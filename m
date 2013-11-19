Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2926 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3KSIKa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 03:10:30 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id rAJ8AP4Z001578
	for <linux-media@vger.kernel.org>; Tue, 19 Nov 2013 09:10:28 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B433C2A221E
	for <linux-media@vger.kernel.org>; Tue, 19 Nov 2013 09:10:20 +0100 (CET)
Message-ID: <528B1CEC.5060308@xs4all.nl>
Date: Tue, 19 Nov 2013 09:10:20 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: Properties, Configuration Storage, Selections and Matrices
References: <52862D55.8010406@xs4all.nl>
In-Reply-To: <52862D55.8010406@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a quick update:

I've been working on this for the past four days and I am now in the process
of testing this. Adding matrix support to the control framework was actually
the hardest part, particularly since I wanted it to be efficient. The code is
still a bit too complex for my liking, but once testing verifies that everything
is working I plan to clean things up some more.

I hope to be able to post a first version during or just after the weekend.

Please review this RFC: other than some small changes this is pretty much how
it will turn out.

Some of the changes are:

- The property bit is 26, not 27. Bit 27 clashes with the PRIVATE_BASE define so
it can't be used.

- Any control/property type can be changed into a matrix by setting bit 15 in
the type. E.g. V4l2_PROP_TYPE_MATRIX | V4L2_CTRL_TYPE_INTEGER. When passing the
data of a matrix the data is always preceded by a struct v4l2_rect which tells
the driver which subset of the matrix the application wants to set/get.

- We definitely need a V4L2_CTRL_FLAG_CAN_STORE flag. Stores take memory and you
only want to allocate that for those controls that actually need to be stored.

- Regarding implementing stores for matrices: I store it in the internal format,
but with additional information regarding the parts of the matrix that need to
be updated. Basically the best of both worlds. With some careful tweaking of
data structure this turned out to be fairly easy to do. This systems allows
you to update only parts of a matrix in a config store efficiently without
having to convert from one format to another.

Regards,

	Hans

On 11/15/2013 03:19 PM, Hans Verkuil wrote:
> Properties, Configuration Storage, Selections and Matrices
> ==========================================================
> 
> This proposal is an attempt to solve multiple issues with one single solution.
> 
> There have been various discussions in the past regarding a property-based
> API. Basically similar to the way controls are handled but without having
> to deal with the GUI-related aspects of controls and with more flexibility
> with regards to supported types.
> 
> Another discussion is about how to atomically set certain pipeline configurations,
> selections in particular. And for Android's camera3 library we also need to
> switch configuration on a per-buffer or per-frame basis, so we need some
> sort of configuration store.
> 
> Also, I proposed an API extension for matrices:
> 
> http://www.spinics.net/lists/linux-media/msg67326.html
> 
> This would fit better in a property-based API.
> 
> Recent discussions regarding multi-selection also ran into the same atomicity
> problems and unhappiness about the impact of the API changes necessary to
> support multi-selection.
> 
> It is quite easy to extend the control framework to support pretty much all
> of the requirements stated above. It already satisfies the atomicity requirements
> (by far the hardest to implement), and extending it to support compound,
> array and matrix types isn't hard either. Neither is implementing a configuration
> store.
> 
> One important observation regarding configuration stores: the information it
> can contain should be information that can change while streaming. If it
> can't be changed while streaming, then there is no reason to put it in a
> config store. Looking at all the ioctls we have there are really only a few
> types of ioctls for which this requirement is true: controls and selections
> being the primary ones.
> 
> S_PARM for setting the timeperframe is another. S_INPUT/OUTPUT might be
> useful as well for surveillance apps to switch input/output between frames.
> 
> That's not many and it wouldn't be hard to implement that functionality as
> properties.
> 
> 
> Property API Proposal
> =====================
> 
> Step 1: Property IDs
> 
> All properties have bit 27 (0x08000000) set. So V4L2_CTRL_ID2CLASS(propid)
> will always return a value between 0x08000000 and 0x0fff0000.
> 
> For controls that range is 0x00980000 - 0x07ff0000. It starts at 0x00980000
> due to historical reasons.
> 
> The existing V4L2_CTRL_FLAG_NEXT_CTRL flag will only enumerate controls.
> A new flag V4L2_CTRL_FLAG_NEXT_PROP (0x40000000) is added to enumerate
> properties. If you want to enumerate both, then both flags need to be set.
> 
> Question: should we still use classes to group properties as we do with
> controls? Personally I like classes as it enforces a system on what
> otherwise will be a big pile of random IDs.
> 
> If we keep using classes, then we can decide on making a 1-to-1 mapping
> between the classes used for controls and the classes used for properties:
> e.g. you have V4L2_CTRL_CLASS_MPEG (0x00990000) and V4L2_PROP_CLASS_MPEG
> (0x08990000).
> 
> Properties have a V4L2_PID_ prefix instead of _CID_.
> 
> 
> Step 2: Property Types
> 
> The enum v4l2_ctrl_type can be extended with new property types. The matrix
> proposal referred to above requires u8 and u16 matrix types in order to
> implement the motion detection API:
> 
> struct v4l2_prop_type_matrix_u8 {
> 	struct v4l2_rect r;
> 	__u8 data[];
> };
> 
> struct v4l2_prop_type_matrix_u16 {
> 	struct v4l2_rect r;
> 	__u16 data[];
> };
> 
> 	V4l2_PROP_TYPE_MATRIX_U8  = 0x100,
> 	V4l2_PROP_TYPE_MATRIX_U16,
> 
> All property types start at 0x100, 0x01-0xff is reserved for control types.
> 
> The v4l2_rect in the matrix type allows you to set only a subset of a matrix.
> Note that an array is a one-dimensional matrix, so I do not see any need to
> add specific array support. Yes, higher-dimensions are possible but I have
> never seen it in any hardware related to video capture. Should we ever see
> that, then we can add a new property type for that.
> 
> In order to support compound or matrix types the v4l2_ext_control struct
> has to be extended:
> 
> struct v4l2_ext_control {
> 	__u32 id;
> 	__u32 size;
> 	__u32 reserved2[1];
> 	union {
> 		__s32 value;
> 		__s64 value64;
> 		char *string;
> 		void *prop;
> 	};
> } __attribute__ ((packed));
> 
> All types >= 0x100 are assumed to use the prop field and the 'size' field contains
> the total size of the data prop points to. If a property fits one of the existing
> control types, then those should be used of course.
> 
> 
> Step 3: Querying Properties
> 
> You need to be able to query the properties as well. v4l2_queryctrl is no
> longer sufficient, so we add a struct v4l2_query_ext_ctrl and VIDIOC_QUERY_EXT_CTRL
> instead.
> 
> I thought about naming it v4l2_queryprop, but it can be used with extended
> controls as well, and since all the existing naming is centered around _ext_ctrl
> I think this is more consistent.
> 
> struct v4l2_query_ext_ctrl {
> 	__u32                config_store;
> 	__u32		     id;
> 	__u32		     type;
> 	__u8		     name[32];
> 	__u8		     unit[32];
> 	union {
> 		__s64 val;
> 		__u32 reserved[8];
> 	} min;
> 	union {
> 		__s64 val;
> 		__u32 reserved[8];
> 	} max;
> 	union {
> 		__s64 val;
> 		__u32 reserved[8];
> 	} step;
> 	union {
> 		__s64 val;
> 		__u32 reserved[8];
> 	} def;
> 	__u32                flags;
> 	__u32                width, height;
> 	__u32		     reserved[16];
> };
> 
> This increases min/max/def/step sizes to 64 bit. It allows for future more complex
> data types as well.
> 
> It also adds width and height to report the max number of elements in matrices. They
> will always be set to 1 for controls, only properties support matrices.
> 
> An alternative is to do something like this: '__u32 dimensions[4]' to allow for up to
> 4D matrices. But I would rather add a 'depth' field should we need 3D data structs
> and a 'spissitude' field when we go 4D (yes, that's what it is called according to
> http://en.wikipedia.org/wiki/Four-dimensional_space).
> 
> Since we have a new struct anyway I am also adding a unit string: this can be used
> by drivers to provide the unit of a control/property so it can be shown in a GUI for
> controls. This feature has been requested in the past.
> 
> If we want applications to be able to understand the units, then we either need to add
> a unit enum type and add it to the query_ext_ctrl struct, or we make #defines of the
> units that are used in drivers and do a strcmp instead. E.g.:
> 
> #define V4L2_CTRL_UNIT_DB	"dB"
> #define V4L2_CTRL_UNIT_0_001_DB	"0.001 dB"
> 
> Sakari, I could use your input for this.
> 
> I'll describe the meaning of the config_store field in the next section.
> 
> 
> Step 4: Configuration Stores
> 
> A configuration store is a set of properties and their values. It can be referred to by
> a configuration store ID. It can be stored either in the file handle, or per device
> node or per device instance. Per-filehandle stores will be deleted when the filehandle
> is closed. The others will stay around until the device nodes are unregistered or the
> device is released.
> 
> In order to set a configuration store you call S_EXT_CTRLS. This requires a change to
> struct v4l2_ext_controls:
> 
> struct v4l2_ext_controls {
> 	union {
> 		__u32 ctrl_class;
> 		__u32 config_store;
> 	};
> 	__u32 count;
> 	__u32 error_idx;
> 	__u32 reserved[2];
> 	struct v4l2_ext_control *controls;
> };
> 
> The ctrl_class field is today either 0 or a control class ID. If it is the latter,
> then all controls in the 'controls' array must be of the given control class.
> This is a left-over from before the control framework was created. Few drivers
> still require a non-zero ctrl_class and such drivers won't support configuration
> stores anyway.
> 
> So rather than taking a reserved field it makes more sense to turn this into a
> configuration store ID. As long as it is in the range 1-0xffff it will not
> clash with the old control class meaning.
> 
> If a driver does not support config stores, then calling S_EXT_CTRLS with a config
> store ID in that range will fail. This is true for all drivers today, so this
> method is nicely backwards compatible.
> 
> Question: how should an application find the maximum number of available stores?
> I can think of two ways: either set config_store to 1 and call TRY_EXT_CTRLS
> with count = 0 to see if it exists, and increase config_store by one until
> TRY_EXT_CTRLS fails (effectively enumerating the available stores).
> 
> Or set config_store to e.g. 0xffff (or any invalid store ID for that matter),
> then call G/S/TRY_EXT_CTRLS with count = 0 and it will return an error but set
> config_store to the last valid configuration store ID. It's quicker, but a
> bit magic.
> 
> To set a config store you call S_EXT_CTRLS to fill the specified config
> store. It will overwrite whatever was there before. So calling S_EXT_CTRLS
> with a count of 0 will clear any existing config store.
> 
> G_EXT_CTRLS will get what is in the store. Using the config_store field
> added to v4l2_query_ext_ctrl you can enumerate which controls are stored in
> a particular config store.
> 
> Not all controls/properties are suitable for a configuration store: read-only
> controls make no sense, and some controls cannot be set while streaming.
> 
> Should a control flag be introduced to tell userspace about this? E.g.
> V4L2_CTRL_FLAG_CAN_STORE? Or should such invalid controls just be ignored?
> The advantage of a flag is that the control framework can do sanity checks.
> That will simplify the driver implementation, which is a big advantage.
> 
> 
> Step 5: Using Config Stores
> 
> To associate a store with a buffer we take the reserved2 field of struct
> v4l2_buffer and rename it config_store. When QBUF is called that field
> will contain the config store ID (or 0 if there is nothing to set).
> If config_store != 0, then a priority check is done as well to be certain
> that the filehandle is allowed to change settings.
> 
> The driver needs a way to prepare for changing the configuration. There
> are a number of places where that can be done: when setting the store
> (S_EXT_CTRLS), when queuing a buffer (QBUF) or internally when a buffer
> with an associated store is queued up for the DMA.
> 
> I think that the control framework should provide a function that
> replays the configuration store (thus calling the v4l2_ctrl_ops try_ctrl
> and s_ctrl) but you can check in those ops whether it is for a store
> or not. If s_ctrl is called for a store, then you can fill in the internal
> config state instead of updating the hardware so it is ready for whenever
> it is needed.
> 
> When and how the hardware has to be programmed is entirely hardware/driver
> specific. But this approach can certainly be used to set up shadow registers,
> for example. It is another reason why I think a V4L2_CTRL_FLAG_CAN_STORE
> flag is useful: that way a driver can reduce the complexity by only supporting
> stores for a limited set of functionality. Perhaps starting with just a
> few controls/properties and extending it as more advanced functionality is
> implemented.
> 
> We can also consider adding a new ioctl to set a config store when a
> particular frame is processed. I am however not certain how to do that.
> One option is to specify a config store for an already queued buffer or
> (using a magic value) for the first possible buffer. Or perhaps by
> specifying a frame number of some sort.
> 
> How to do this for a number of different subdevs synchronously is another
> problem. This proposal for configuration stores extends to subdevs as well
> as long as they use the control framework, but you still need a way to
> synchronize changes over all subdevs involved.
> 
> One way of doing this is if the bridge driver counts the frames and notifies
> all subdevs when they should be ready to switch config for an upcoming frame.
> Each subdev can then map the frame counter it received to a config store and
> set that store. This clearly requires an ioctl to set a store for a frame
> number. Such an ioctl could even specify a line number in addition to a
> frame number if you want to e.g. strobe the flash at a specific time for
> a specific frame.
> 
> Another question is how to handle matrices in a store. It is not a problem
> if the full matrix is defined when the store is set up, but what if only
> a subset of a matrix (e.g. just one cell) is set?
> 
> It depends in part on the implementation: a store can either contain
> the control array as was specified by S_EXT_CTRLS, or it can be post
> processed and implemented as an array of internal v4l2_ctrl structs.
> 
> The disadvantage of storing the control array is that when you want
> to set the store more processing needs to be done, but that submatrices
> are retained. Implementing it as an array of internal structs is faster,
> but you always have to set the full matrix. In addition, the values for
> cells not explicitly set by S_EXT_CTRLS will be taken from what they
> were when S_EXT_CTRLS was called for the store, not what they were when
> the store was applied. I have to investigate further, but I am leaning
> towards storing the control array, not the internal structures.
> 
> 
> Step 6: Selections as Properties
> 
> Since the control framework already provides all you need to atomically
> set properties it would be very helpful if cropping and composing
> rectangles could be specified as properties as well.
> 
> The selection struct looks like this:
> 
> struct v4l2_selection {
> 	__u32			type;
> 	__u32			target;
> 	__u32                   flags;
> 	struct v4l2_rect        r;
> 	__u32                   reserved[9];
> };
> 
> The contents of a crop/compose property would be flags + r. Target + type
> would together form the property ID. The only targets for which a
> property makes sense are CROP and COMPOSE. The others are (or should be)
> read-only. The type field is used to tell whether the selection is for
> the capture or the output stream. So we have to define four properties:
> CAPTURE_CROP, CAPTURE_COMPOSE, OUTPUT_CROP, OUTPUT_COMPOSE.
> 
> S_SELECTION(CAPTURE, CROP) will now just set the corresponding property.
> The control framework allows you to set crop and compose atomically (by
> clustering the properties), so that problem is solved as well. You also
> get a TRY_SELECTION for free through TRY_EXT_CTRLS.
> 
> Finally I think this is also a good way of implementing multi-selection:
> multi-selection would be an array (1-dimensional matrix) of selections.
> 
> query_ext_ctrls will even tell you the maximum number of selections.
> The G/S_SELECTION API will not change, so for multi-selection you need
> to use the property API instead.
> 
> Note that the other selection targets can be implemented as properties
> as well, I'm just not sure if that is a good or a bad idea.
> 
> 
> Conclusion
> 
> I think that this approach would solve a host of different issues without
> having to change too much.
> 
> I'll post a patch as well that adds property support to the API (just header
> changes for now) which gives an overview of the API changes described in
> this document.
> 
> I'll also start work on the changes needed in the control framework in order
> to support properties. I think it is all fairly trivial, but I might have
> missed something.
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

