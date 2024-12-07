const Snowflake = @import("snowflake.zig").Snowflake;
const User = @import("user.zig").User;
const Member = @import("member.zig").Member;
const Attachment = @import("attachment.zig").Attachment;
const Application = @import("application.zig").Application;
const Embed = @import("embed.zig").Embed;
const AllowedMentionTypes = @import("shared.zig").AllowedMentionsTypes;
const PremiumTypes = @import("shared.zig").PremiumTypes;
const InteractionTypes = @import("shared.zig").InteractionTypes;
const StickerTypes = @import("shared.zig").StickerTypes;
const StickerFormatTypes = @import("shared.zig").StickerFormatTypes;
const MessageTypes = @import("shared.zig").MessageTypes;
const MessageFlags = @import("shared.zig").MessageFlags;
const Emoji = @import("emoji.zig").Emoji;
const Poll = @import("poll.zig").Poll;
const AvatarDecorationData = @import("user.zig").AvatarDecorationData;
const MessageActivityTypes = @import("shared.zig").MessageActivityTypes;
const Partial = @import("partial.zig").Partial;

/// TODO: fix this
pub const MessageComponent = isize;

/// https://discord.com/developers/docs/resources/channel#message-object
pub const Message = struct {
    /// id of the message
    id: Snowflake,
    /// id of the channel the message was sent in
    channel_id: Snowflake,
    ///
    /// id of the guild the message was sent in
    /// Note: For MESSAGE_CREATE and MESSAGE_UPDATE events, the message object may not contain a guild_id or member field since the events are sent directly to the receiving user and the bot who sent the message, rather than being sent through the guild like non-ephemeral messages.,
    ///
    guild_id: ?Snowflake,
    ///
    /// The author of this message (not guaranteed to be a valid user)
    /// Note: The author object follows the structure of the user object, but is only a valid user in the case where the message is generated by a user or bot user. If the message is generated by a webhook, the author object corresponds to the webhook's id, username, and avatar. You can tell if a message is generated by a webhook by checking for the webhook_id on the message object.,
    ///
    author: User,
    ///
    /// Member properties for this message's author
    /// Note: The member object exists in `MESSAGE_CREATE` and `MESSAGE_UPDATE` events from text-based guild channels. This allows bots to obtain real-time member data without requiring bots to store member state in memory.,
    ///
    member: ?Member,
    /// Contents of the message
    content: ?[]const u8,
    /// When this message was sent
    timestamp: []const u8,
    /// When this message was edited (or null if never)
    edited_timestamp: ?[]const u8,
    /// Whether this was a TTS message
    tts: bool,
    /// Whether this message mentions everyone
    mention_everyone: bool,
    ///
    /// Users specifically mentioned in the message
    /// Note: The user objects in the mentions array will only have the partial member field present in `MESSAGE_CREATE` and `MESSAGE_UPDATE` events from text-based guild channels.,
    ///
    mentions: []User,
    /// Roles specifically mentioned in this message
    mention_roles: ?[][]const u8,
    ///
    /// Channels specifically mentioned in this message
    /// Note: Not all channel mentions in a message will appear in `mention_channels`. Only textual channels that are visible to everyone in a discoverable guild will ever be included. Only crossposted messages (via Channel Following) currently include `mention_channels` at all. If no mentions in the message meet these requirements, this field will not be sent.,
    ///
    mention_channels: ?[]ChannelMention,
    /// Any attached files
    attachments: []Attachment,
    /// Any embedded content
    embeds: []Embed,
    /// Reactions to the message
    reactions: ?[]Reaction,
    // Used for validating a message was sent
    //nonce: ?union(enum) {int: isize,string: []const u8,},
    /// Whether this message is pinned
    pinned: bool,
    /// If the message is generated by a webhook, this is the webhook's id
    webhook_id: ?Snowflake,
    /// Type of message
    type: MessageTypes,
    /// Sent with Rich Presence-related chat embeds
    activity: ?MessageActivity,
    /// Sent with Rich Presence-related chat embeds
    application: ?Partial(Application),
    /// if the message is an Interaction or application-owned webhook, this is the id of the application
    application_id: ?Snowflake,
    // Data showing the source of a crosspost, channel follow add, pin, or reply message
    // message_reference: ?Omit(MessageReference, .{"failIfNotExists"}),
    /// Message flags combined as a bitfield
    flags: ?MessageFlags,
    ///
    /// The stickers sent with the message (bots currently can only receive messages with stickers, not send)
    /// @deprecated
    ///
    stickers: ?[]Sticker,
    ///
    /// The message associated with the `message_reference`
    /// Note: This field is only returned for messages with a `type` of `19` (REPLY). If the message is a reply but the `referenced_message` field is not present, the backend did not attempt to fetch the message that was being replied to, so its state is unknown. If the field exists but is null, the referenced message was deleted.,
    /// TAKES A POINTER
    referenced_message: ?*Message,
    /// The message associated with the `message_reference`. This is a minimal subset of fields in a message (e.g. `author` is excluded.)
    message_snapshots: ?[]MessageSnapshot,
    /// sent if the message is sent as a result of an interaction
    interaction_metadata: ?MessageInteractionMetadata,
    ///
    /// Sent if the message is a response to an Interaction
    ///
    /// @deprecated Deprecated in favor of {@link interaction_metadata};
    ///
    interaction: ?MessageInteraction,
    // The thread that was started from this message, includes thread member object
    // thread: ?Omit(Channel, .{"member"}), //& { member: ThreadMember };,
    /// The components related to this message
    components: ?[]MessageComponent,
    /// Sent if the message contains stickers
    sticker_items: ?[]StickerItem,
    /// A generally increasing integer (there may be gaps or duplicates) that represents the approximate position of the message in a thread, it can be used to estimate the relative position of the message in a thread in company with `total_message_sent` on parent thread
    position: ?isize,
    /// The poll object
    poll: ?Poll,
    /// The call associated with the message
    call: ?MessageCall,
};

/// https://discord.com/developers/docs/resources/channel#message-call-object
pub const MessageCall = struct {
    /// Array of user object ids that participated in the call
    participants: [][]const u8,
    /// Time when call ended
    ended_timestamp: []const u8,
};

/// https://discord.com/developers/docs/resources/channel#channel-mention-object
pub const ChannelMention = struct {
    /// id of the channel
    id: Snowflake,
    /// id of the guild containing the channel
    guild_id: Snowflake,
    /// The type of channel
    type: isize,
    /// The name of the channel
    name: []const u8,
};

/// https://discord.com/developers/docs/resources/channel#reaction-object
pub const Reaction = struct {
    /// Total isize of times this emoji has been used to react (including super reacts)
    count: isize,
    ///
    count_details: ReactionCountDetails,
    /// Whether the current user reacted using this emoji
    me: bool,
    ///
    me_burst: bool,
    /// Emoji information
    emoji: Partial(Emoji),
    /// HEX colors used for super reaction
    burst_colors: [][]const u8,
};

/// https://discord.com/developers/docs/resources/channel#get-reactions-reaction-types
pub const ReactionType = enum {
    Normal,
    Burst,
};

/// https://discord.com/developers/docs/resources/channel#reaction-count-details-object
pub const ReactionCountDetails = struct {
    /// Count of super reactions
    burst: isize,
    ///
    normal: isize,
};

/// https://discord.com/developers/docs/resources/channel#message-object-message-activity-structure
pub const MessageActivity = struct {
    /// Type of message activity
    type: MessageActivityTypes,
    /// `party_id` from a Rich Presence event
    party_id: ?Snowflake,
};

/// https://discord.com/developers/docs/resources/channel#message-object-message-reference-structure
pub const MessageReference = struct {
    /// Type of reference
    type: ?MessageReferenceType,
    /// id of the originating message
    message_id: ?Snowflake,
    ///
    /// id of the originating message's channel
    /// Note: `channel_id` is optional when creating a reply, but will always be present when receiving an event/response that includes this data model.,
    ///
    channel_id: ?Snowflake,
    /// id of the originating message's guild
    guild_id: ?Snowflake,
    /// When sending, whether to error if the referenced message doesn't exist instead of sending as a normal (non-reply) message, default true
    fail_if_not_exists: bool,
};

/// https://discord.com/developers/docs/resources/channel#message-reference-object-message-reference-types
pub const MessageReferenceType = enum {
    ///
    /// A standard reference used by replies.
    ///
    /// @remarks
    /// When the type is set to this value, the field referenced_message on the message will be present
    ///
    Default,
    ///
    /// Reference used to point to a message at a point in time.
    ///
    /// @remarks
    /// When the type is set to this value, the field message_snapshot on the message will be present
    ///
    /// This value can only be used for basic messages;
    /// i.e. messages which do not have strong bindings to a non global entity.
    /// Thus we support only messages with `DEFAULT` or `REPLY` types, but disallowed if there are any polls, calls, or components.
    ///
    Forward,
};

/// https://discord.com/developers/docs/resources/channel#message-snapshot-object-message-snapshot-structure
pub const MessageSnapshot = struct {
    /// https://discord.com/developers/docs/resources/channel#message-object
    /// Minimal subset of fields in the forwarded message
    message: struct {
        content: ?[]const u8,
        timestamp: []const u8,
        edited_timestamp: ?[]const u8,
        mentions: []struct {
            username: []const u8,
            global_name: ?[]const u8,
            locale: ?[]const u8,
            flags: ?isize,
            premium_type: ?PremiumTypes,
            public_flags: ?isize,
            accent_color: ?isize,
            id: Snowflake,
            discriminator: []const u8,
            avatar: ?[]const u8,
            bot: ?bool,
            system: ?bool,
            mfa_enabled: ?bool,
            verified: ?bool,
            email: ?[]const u8,
            banner: ?[]const u8,
            avatar_decoration_data: ?AvatarDecorationData,
            member: ?Partial(Member),
        },
        mention_roles: ?[][]const u8,
        type: MessageTypes,
        flags: ?MessageFlags,
        stickers: ?[]Sticker,
        components: ?[]MessageComponent,
        sticker_items: ?[]StickerItem,
        attachments: []Attachment,
        embeds: []Embed,
    },
};

/// https://discord.com/developers/docs/resources/sticker#sticker-object-sticker-structure
pub const Sticker = struct {
    /// [Id of the sticker](https://discord.com/developers/docs/reference#image-formatting)
    id: Snowflake,
    /// Id of the pack the sticker is from
    pack_id: ?Snowflake,
    /// Name of the sticker
    name: []const u8,
    /// Description of the sticker
    description: []const u8,
    /// a unicode emoji representing the sticker's expression
    tags: []const u8,
    /// [type of sticker](https://discord.com/developers/docs/resources/sticker#sticker-object-sticker-types)
    type: StickerTypes,
    /// [Type of sticker format](https://discord.com/developers/docs/resources/sticker#sticker-object-sticker-format-types)
    format_type: StickerFormatTypes,
    ///  Whether or not the sticker is available
    available: ?bool,
    /// Id of the guild that owns this sticker
    guild_id: ?Snowflake,
    /// The user that uploaded the sticker
    user: ?User,
    /// A sticker's sort order within a pack
    sort_value: ?isize,
};

/// https://discord.com/developers/docs/interactions/receiving-and-responding#message-interaction-object-message-interaction-structure
pub const MessageInteraction = struct {
    /// Id of the interaction
    id: Snowflake,
    /// The type of interaction
    type: InteractionTypes,
    /// The name of the ApplicationCommand including the name of the subcommand/subcommand group
    name: []const u8,
    /// The user who invoked the interaction
    user: User,
    /// The member who invoked the interaction in the guild
    member: ?Partial(Member),
};

/// https://discord.com/developers/docs/resources/channel#message-interaction-metadata-object-message-interaction-metadata-structure
pub const MessageInteractionMetadata = struct {
    /// Id of the interaction
    id: Snowflake,
    /// The type of interaction
    type: InteractionTypes,
    /// User who triggered the interaction
    user: User,
    // IDs for installation context(s) related to an interaction
    // authorizing_integration_owners: Partial(AutoArrayHashMap(ApplicationIntegrationType, []const u8)),
    /// ID of the original response message, present only on follow-up messages
    original_response_message_id: ?Snowflake,
    /// ID of the message that contained interactive component, present only on messages created from component interactions
    interacted_message_id: ?Snowflake,
    /// Metadata for the interaction that was used to open the modal, present only on modal submit interactions
    /// TAKES A POINTER
    triggering_interaction_metadata: ?*MessageInteractionMetadata,
};

/// https://discord.com/developers/docs/resources/sticker#sticker-item-object-sticker-item-structure
pub const StickerItem = struct {
    /// Id of the sticker
    id: Snowflake,
    /// Name of the sticker
    name: []const u8,
    /// [Type of sticker format](https://discord.com/developers/docs/resources/sticker#sticker-object-sticker-format-types)
    format_type: StickerFormatTypes,
};

/// https://discord.com/developers/docs/resources/sticker#sticker-pack-object-sticker-pack-structure
pub const StickerPack = struct {
    /// id of the sticker pack
    id: Snowflake,
    /// the stickers in the pack
    stickers: []Sticker,
    /// name of the sticker pack
    name: []const u8,
    /// id of the pack's SKU
    sku_id: Snowflake,
    /// id of a sticker in the pack which is shown as the pack's icon
    cover_sticker_id: ?Snowflake,
    /// description of the sticker pack
    description: []const u8,
    /// id of the sticker pack's [banner image](https://discord.com/developers/docs/reference#image-formatting)
    banner_asset_id: ?Snowflake,
};

pub const AllowedMentions = struct {
    /// An array of allowed mention types to parse from the content.
    parse: []AllowedMentionTypes,
    /// Array of role_ids to mention (Max size of 100)
    roles: []Snowflake,
    /// Array of user_ids to mention (Max size of 100)
    users: []Snowflake,
    /// For replies, whether to mention the author of the message being replied to (default false)
    replied_user: ?bool,
};
