Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1539 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3LPLfC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 06:35:02 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id rBGBYwqs074650
	for <linux-media@vger.kernel.org>; Mon, 16 Dec 2013 12:35:00 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 280F02A2226
	for <linux-media@vger.kernel.org>; Mon, 16 Dec 2013 12:34:45 +0100 (CET)
Message-ID: <52AEE554.3080000@xs4all.nl>
Date: Mon, 16 Dec 2013 12:34:44 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFCv2: Properties, Configuration Storage, Selections and Matrices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updated the RFC to match my proof-of-concept code available here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/propapi

The main changes are in the configuration store setup: stores always exist
and are no longer created by S_EXT_CTRLS. In addition stores can now easily
map to hardware shadow registers if needed.

Properties, Configuration Storage, Selections and Matrices
==========================================================

This proposal is an attempt to solve multiple issues with one single solution.

There have been various discussions in the past regarding a property-based
API. Basically similar to the way controls are handled but without having
to deal with the GUI-related aspects of controls and with more flexibility
with regards to supported types.

Another discussion is about how to atomically set certain pipeline configurations,
selections in particular. And for Android's camera3 library we also need to
switch configuration on a per-buffer or per-frame basis, so we need some
sort of configuration store.

Finally, a recent API extension was proposed for matrices:

http://www.spinics.net/lists/linux-media/msg67326.html

This would fit better in a property-based extension.

It is quite easy to extend the control framework to support pretty much all
of the requirements stated above. It already satisfies the atomicity requirements
(by far the hardest to implement), and extending it to support compound,
array and matrix types isn't hard either. Neither is implementing a configuration
store.

One important observation regarding configuration stores: the information it
can contain should at the very least be information that can change while
streaming. Looking at all the ioctls we have there are really only a few
types of ioctls for which this requirement is true: controls and selections
being the primary ones.

S_PARM for setting the timeperframe is another. S_INPUT/OUTPUT might be
useful as well for surveillance apps to switch input/output between frames.

That's not many and it wouldn't be hard to implement that functionality as
properties.


Property API Proposal
=====================

Step 1: Property IDs

All properties have bit 26 (0x04000000) set. This gives properties the
range 0x04000000 - 0x3fffffff. For controls that range is 0x00980000 -
0x03ff0000. It starts at 0x00980000 due to historical reasons.

The existing V4L2_CTRL_FLAG_NEXT_CTRL flag will only enumerate controls.
A new flag V4L2_CTRL_FLAG_NEXT_PROP (0x40000000) is added to enumerate
properties. If you want to enumerate both, then both flags need to be set.

Control and properties share the same classes.


Step 2: Property Types

The enum v4l2_ctrl_type can be extended with new property types. The matrix
proposal referred to above requires u8 and u16 matrix types in order to
implement the motion detection API:

struct v4l2_prop_type_matrix_u8 {
	struct v4l2_rect r;
	__u8 data[];
};

struct v4l2_prop_type_matrix_u16 {
	struct v4l2_rect r;
	__u16 data[];
};

	/* Properties are > 0x0100 */
	V4L2_PROP_TYPES	             = 0x0100,
	V4L2_PROP_TYPE_U8	     = 0x0101,
	V4L2_PROP_TYPE_U16	     = 0x0102,

	/* Matrix property types will have bit 15 set */
	V4L2_PROP_TYPE_MATRIX        = 0x8000,
	V4L2_PROP_TYPE_MATRIX_U8     = V4L2_PROP_TYPE_MATRIX | V4L2_PROP_TYPE_U8,
	V4L2_PROP_TYPE_MATRIX_U16    = V4L2_PROP_TYPE_MATRIX | V4L2_PROP_TYPE_U16,

All property types start at 0x100, 0x01-0xff is reserved for control types.

The v4l2_rect in the matrix type allows you to set only a subset of a matrix.
Note an array is a one-dimensional matrix, so I do not see any need to add
specific array support. Yes, higher-dimensions are possible but I have never
seen it in any hardware related to video capture. Should we ever see that,
then we can add a new property type for that.

In order to support compound or matrix types the v4l2_ext_control struct
has to be extended:

struct v4l2_ext_control {
	__u32 id;
	__u32 size;
	__u32 reserved2[1];
	union {
		__s32 value;
		__s64 value64;
		char *string;
		void *prop;
	};
} __attribute__ ((packed));

Any types > V4L2_PROP_TYPES are assumed to use the prop field and the 'size' field
contains the total size of the data prop points to. If a property fits one of the
existing control types, then those should be used of course.


Step 3: Querying Properties

You need to be able to query the properties as well. v4l2_queryctrl is no
longer sufficient, so we add a struct v4l2_query_ext_ctrl and VIDIOC_QUERY_EXT_CTRL
instead.

I thought about naming it v4l2_queryprop, but it can be used with extended
controls as well, and since all the existing naming is centered around _ext_ctrl
I think this is more consistent.

struct v4l2_query_ext_ctrl {
	__u32                config_store;
	__u32		     id;
	__u32		     type;
	char		     name[32];
	char		     unit[32];
	union {
		__s64 val;
		__u32 reserved[8];
	} min;
	union {
		__s64 val;
		__u32 reserved[8];
	} max;
	union {
		__u64 val;
		__u32 reserved[8];
	} step;
	union {
		__s64 val;
		__u32 reserved[8];
	} def;
	__u32                flags;
	__u32                cols, rows;
	__u32                elem_size;
	__u32		     reserved[16];
};

This increases min/max/def/step sizes to 64 bit. It allows for future more complex
data types as well.

It also adds cols and rows to report the size of a matrices, and elem_size to
report the size of a single cell in the matrix. For non-matrix types cols and
rows are set to 1 and elem_size is the size of the control type.

Since we have a new struct anyway I am also adding a unit string: this can be used
by drivers to provide the unit of a control/property so it can be shown in a GUI for
controls.

If we want applications to be able to understand the units, then we either need to add
a unit enum as well and add it to the query_ext_ctrl struct, or we make #defines of the
units that are used in drivers and do a strcmp instead. E.g.:

#define V4L2_CTRL_UNIT_DB	"dB"
#define V4L2_CTRL_UNIT_0_001_DB	"0.001 dB"

Sakari, I could use your input for this.

I'll describe the meaning of the config_store in the next section.


Step 4: Configuration Stores

A configuration store is a set of controls and their values. It can be referred to by
a configuration store ID. It can be stored either in the file handle, or per device
node or per device instance. Per-filehandle stores will be deleted when the filehandle
is closed. The others will stay around until the device nodes are unregistered or the
device is released.

The driver that creates the controls/properties has to define the number of
configuration stores that are needed for that control/property. The control framework
will allocate the memory needed to store the additional values.

There are two types of configuration stores: the first type is a direct mapping
between shadow registers and a configuration store. So if the hardware provides
2 registers for a control, and only one of the two is active at any one time, then
you can create two configuration stores which map to each register, and you tell
the framework which store (register) is active initially. Switching stores is
then just a matter of telling the hardware which of the two registers to use.
And changing a value in a store will just update the corresponding shadow register.
In this particular situation the 'current value' of a control is that of the currently
active store.

If there are no shadow registers and you just want to update controls/properties
at a specific time, then whenever a configuration store is applied it is identical
to setting the current control value to that of the value in the specified store.
In this situration the 'current value' of a control is separate of the value of
the control in a specific store.

In order to set a configuration store you call S_EXT_CTRLS. This requires a change to
struct v4l2_ext_controls:

struct v4l2_ext_controls {
	union {
		__u32 ctrl_class;
		__u32 config_store;
	};
	__u32 count;
	__u32 error_idx;
	__u32 reserved[2];
	struct v4l2_ext_control *controls;
};

The ctrl_class field is today either 0 or a control class ID. If it is the latter,
then all controls in the 'controls' array must be of the given control class.
This is a left-over from before the control framework was created. Few drivers
still require a non-zero ctrl_class and such drivers won't support configuration
stores anyway.

So rather than taking a reserved field it makes more sense to turn this into a
configuration store ID. As long as it is in the range 1-0xffff it will not
clash with the old control class meaning.

If a driver does not support config stores, then calling S_EXT_CTRLS with a config
store ID of 1 will fail. This is true for all drivers today, so this method is
nicely backwards compatible.

So to set a config store you call S_EXT_CTRLS to update controls/properties
of the specified config store.

G_EXT_CTRLS will get what is in the store. Using the config_store field
added to v4l2_query_ext_ctrl you can enumerate which controls are stored in
a particular config store.

Note that read-only controls/properties can also be part of a store. A driver
can update such read-only values after e.g. a frame has been captured. When
the buffer has been dequeued the application can query the configuration
store for such read-only values using the store associated with the buffer.

This is functionality that is required by libcamera3 in Android.

Controls/properties that have a store will set the new V4L2_CTRL_FLAG_CAN_STORE
flag.


Step 5: Using Config Stores

To associate a store with a buffer we take the reserved2 field of struct
v4l2_buffer and rename it config_store. When QBUF is called that field
will contain the config store ID (or 0 if there is nothing to set).
If config_store != 0, then a priority check is done as well to be certain
that the filehandle is allowed to change settings.

The driver needs a way to prepare for changing the configuration. There
are a number of places where that can be done: when setting the store
(in particular when stores are mapped to shadow registers), when queuing
a buffer (QBUF) or internally when a buffer with an associated store is
queued up for the DMA. How this is done is entirely driver dependent.
The control framework places no restrictions on this.

In my current proof-of-concept implementation the control framework provides
a function that applies a configuration store. For controls/properties mapped
to shadow registers it will just update the control's concept of the 'current
value' to that of the new store. For others it will update the current value
with the new value from the store. This will trigger the usual v4l2_ctrl_ops.

Note that the ctrl_ops are also called when you read/set a control or property
for a store. You can check the ctrl->store value inside the op implementation
to see if it gets/sets the value for a specific store (ctrl->store > 0) or
for the current value (ctrl->store == 0).

We can also consider adding a new ioctl to set a config store when a
particular frame is processed. I am however not certain how to do that.
One option is to specify a config store for an already queued buffer or
(using a magic value) for the first possible buffer. Or perhaps by
specifying a frame number of some sort. I really don't want to implement
anything for this until we have a realistic use-case. The idea of associating
a config store to a buffer when you queue it is needed anyway for Android,
so that's a good place to start.

Another complication is how to handle different subdevs, each with controls
that might have different number of stores. The control framework is pretty
fine-grained: the only limitation is that all controls in a cluster must
have the same number of configuration stores. But when you queue a buffer
you specify just a single configuration store, you can't be more specific
than that.

In the completely generic case you want to pass mappings to subdevs and video
nodes: e.g. 'if configuration store A is selected, then apply store 1 of
controls X, Y and Z and apply store 3 of controls K, L and M.'

Then when store A needs to be applied the bridge driver can notify all subdevs
which store they should use and each will apply the mapping to determine which
control-specific stores should be applied.

While it is technically possible to go down to that level of detail, in
practice I think that it is much more likely that the bridge driver is the
one that decides things like this. So the bridge driver will just provide
N stores for all controls/properties that can be updated per buffer, and
it will just do the correct mapping to the underlying hardware. So if the
subdev doesn't supply stores for e.g. a brightness control, then the bridge
driver has to provide an overriding brightness control with N stores. The
s_ctrl implementation will then set the subdev's control when a store is
applied.

For now we should just keep this simple and see what is needed when this
is actually implemented.


Step 6: Selections as Properties

Since the control framework already provides all you need to atomically
set properties it would be very helpful if cropping and composing
rectangles could be specified as properties as well.

The selection struct looks like this:

struct v4l2_selection {
	__u32			type;
	__u32			target;
	__u32                   flags;
	struct v4l2_rect        r;
	__u32                   reserved[9];
};

The contents of a crop/compose property would be flags + r. Target + type
would together form the property ID. The only targets for which a
property makes sense are CROP and COMPOSE. The others are (or should be)
read-only. The type field is used to tell whether the selection is for
the capture or the output stream. So we have to define four properties:
CAPTURE_CROP, CAPTURE_COMPOSE, OUTPUT_CROP, OUTPUT_COMPOSE.

struct v4l2_prop_selection {
	__u32 flags;
	struct v4l2_rect r;
	__u32 reserved[9];
};

S_SELECTION(CAPTURE, CROP) will now just set the corresponding property.
The control framework allows you to set both atomically (by clustering
the crop and compose properties), so that problem is solved as well.
You also get a TRY_SELECTION for free through TRY_EXT_CTRLS.

One addition that we need is to add a V4L2_SEL_FLAG_PRIO flag to tell
the driver which of the crop and compose selections should be prioritized.
I.e. which of the two should remain closest to the requested rectangle.

If you set one at a time, then that always gets the flag, but if you
set both atomically, then you need to know.

Finally I think this is also a good way of allowing multi-selection:
multi-selection would be an array (1-dimensional matrix) of selections.

query_ext_ctrls will even tell you the maximum number of selections.
S_SELECTION will not change, so it can't be used for multi-selection.


Conclusion

I think that this approach would solve a host of different issues without
having to change too much.

My proof-of-concept implementation works well with almost all changes isolated
to v4l2-ctrls.c. The API modifications are remarkably minor.
