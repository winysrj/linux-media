Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1446 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab0EXJme (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 05:42:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 03/15] [RFCv2] Documentation: add v4l2-controls.txt documenting the new controls API.
Date: Mon, 24 May 2010 11:44:16 +0200
Cc: linux-media@vger.kernel.org
References: <cover.1274015084.git.hverkuil@xs4all.nl> <c4116a8d705331ab8086902841bea31d4aa50a1f.1274015085.git.hverkuil@xs4all.nl> <201005240117.35431.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201005240117.35431.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005241144.16825.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your review! As always, it was very useful.

On Monday 24 May 2010 01:17:34 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the second RFC version. I've finally had time to review it. Many 
> issues from the first version have been fixed, but there are some left (or at 
> least topics that are still open for discussion). Here are my comments.
> 
> On Sunday 16 May 2010 15:20:57 Hans Verkuil wrote:
> > Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  Documentation/video4linux/v4l2-controls.txt |  600
> > +++++++++++++++++++++++++++ 1 files changed, 600 insertions(+), 0
> > deletions(-)
> >  create mode 100644 Documentation/video4linux/v4l2-controls.txt
> > 
> > diff --git a/Documentation/video4linux/v4l2-controls.txt
> > b/Documentation/video4linux/v4l2-controls.txt new file mode 100644
> > index 0000000..44246b2
> > --- /dev/null
> > +++ b/Documentation/video4linux/v4l2-controls.txt
> > @@ -0,0 +1,600 @@
> > +Introduction
> > +============
> > +
> > +The V4L2 control API seems simple enough, but quickly becomes very hard to
> > +implement correctly in drivers. But much of the code needed to handle
> > controls
> > +is actually not driver specific and can be moved to the V4L core framework.
> > +
> > +After all, the only part that a driver developer is interested in is:
> > +
> > +1) How do I add a control?
> > +2) How do I set the control's value? (i.e. s_ctrl)
> > +
> > +And occasionally:
> > +
> > +3) How do I get the control's value? (i.e. g_volatile_ctrl)
> > +4) How do I validate the user's proposed control value? (i.e. try_ctrl)
> > +
> > +All the rest is something that can be done centrally.
> > +
> > +The control framework was created in order to implement all the rules of
> > the
> > +V4L2 specification with respect to controls in a central place. And to make
> > +life as easy as possible for the driver developer.
> > +
> > +Note that the control framework relies on the presence of a struct
> > v4l2_device
> > +for bridge drivers and struct v4l2_subdev for sub-device drivers.
> 
> Didn't we agree on replacing the name bridge by something else ? "bridges" are 
> a subset of the V4L2 devices.

What is a good name for such drivers? V4L2 drivers?

> > +Objects in the framework
> > +========================
> > +
> > +There are two main objects:
> > +
> > +The v4l2_ctrl object describes the control properties and keeps track of
> > the
> > +control's value (both the current value and the proposed new value).
> > +
> > +v4l2_ctrl_handler is the object that keeps track of controls. It maintains
> > a
> > +list of v4l2_ctrl objects that it owns and another list of references to
> > +controls, possibly to controls owned by other handlers.
> > +
> > +
> > +Basic usage for bridge and sub-device drivers
> > +=============================================
> > +
> > +1) Prepare the driver:
> > +
> > +1.1) Add the handler to your driver's top-level struct:
> > +
> > +	struct foo_dev {
> > +		...
> > +		struct v4l2_ctrl_handler ctrl_handler;
> > +		...
> > +	};
> > +
> > +	struct foo_dev *foo;
> > +
> > +1.2) Initialize the handler:
> > +
> > +	v4l2_ctrl_handler_init(&foo->ctrl_handler, nr_of_controls);
> > +
> > +  The second argument is a hint telling the function how many controls
> > this
> > +  handler is expected to handle. It will allocate a hashtable based on this
> > +  information. It is a hint only.
> > +
> > +1.3) Hook the control handler into the driver:
> > +
> > +1.3.1) For bridge drivers do this:
> > +
> > +	foo->v4l2_dev.ctrl_handler = &foo->ctrl_handler;
> > +
> > +  Where foo->v4l2_dev is of type struct v4l2_device.
> 
> Please add struct v4l2_device v4l2_dev in the foo_dev structure above.

Will do.

> 
> > +  Finally, remove all control functions from your v4l2_ioctl_ops:
> > +  vidioc_queryctrl, vidioc_querymenu, vidioc_g_ctrl, vidioc_s_ctrl,
> > +  vidioc_g_ext_ctrls, vidioc_try_ext_ctrls and vidioc_s_ext_ctrls.
> > +  Those are now no longer needed.
> > +
> > +1.3.2) For sub-device drivers do this:
> > +
> > +	foo->sd.ctrl_handler = &foo->ctrl_handler;
> > +
> > +  Where foo->sd is of type struct v4l2_subdev.
> > +
> > +  And set all core control ops in your struct v4l2_subdev_core_ops to
> > these
> > +  helpers:
> > +
> > +	.queryctrl = v4l2_subdev_queryctrl,
> > +	.querymenu = v4l2_subdev_querymenu,
> > +	.g_ctrl = v4l2_subdev_g_ctrl,
> > +	.s_ctrl = v4l2_subdev_s_ctrl,
> > +	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
> > +	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
> > +	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
> > +
> > +  Note: this is a temporary solution only. Once everything is converted to
> > +  the control framework these helpers will no longer be needed.
> 
> If I understand things properly, those operations are still needed to allow 
> "legacy" V4L2 device drivers to use converted subdevices. I would then phrase 
> it a bit differently:
> 
> "Note: this is a temporary solution only. Once all devices using the subdev 
> are converted to the control framework these helpers will no longer be 
> needed."
> 
> This will make it clear that subdev drivers can be cleaned up of those 
> backward-compatibility helpers as soon all device drivers using the subdevs 
> are converted, and not when all device drivers are converted.

I'll change the phrasing.
 
> 1.3.1 is for bridge drivers. 1.3.2 is for subdev drivers. What about drivers 
> with no subdevs and bridge (just a "simple" device such as a webcam) ?

Wherever I wrote 'bridge driver' replace that with 'V4L2 driver'. So 1.3.1 is
for any V4L2 driver.
 
> > +1.4) Clean up the handler at the end:
> > +
> > +	v4l2_ctrl_handler_free(&foo->ctrl_handler);
> > +
> > +
> > +2) Add controls:
> > +
> > +Typically done right after the v4l2_ctrl_handler_init:
> > +
> > +	v4l2_ctrl_handler_init(&foo->ctrl_handler, nr_of_controls);
> > +	v4l2_ctrl_new_std(&foo->ctrl_handler, &foo_ctrl_ops,
> > +			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
> 
> Adding the function prototype to the documentation is still a good idea :-)

Will do.
 
> > +	v4l2_ctrl_new_std(&foo->ctrl_handler, &foo_ctrl_ops,
> > +			V4L2_CID_CONTRAST, 0, 255, 1, 128);
> > +	...
> > +	if (foo->ctrl_handler.error) {
> > +		int err = foo->ctrl_handler.error;
> > +
> > +		v4l2_ctrl_handler_free(&foo->ctrl_handler);
> > +		return err;
> > +	}
> > +
> > +The v4l2_ctrl_new_std function returns the v4l2_ctrl pointer to the new
> > +control, but if you do not need to access the pointer outside the control
> > ops,
> > +then there is no need to store it.
> > +
> > +The v4l2_ctrl_new_std function will fill in most fields based on the
> > control
> > +ID except for the min, max, step and default values. These are passed in
> > the
> > +last four arguments. These values are driver specific while control
> > attributes
> > +like type, name, flags are all global. The control's current value will be
> > set
> > +to the default value.
> > +
> > +Note that if something fails, the function will return NULL or an error
> > and
> > +set ctrl_handler->error to the error code. If ctrl_handler->error was
> > already
> > +set, then it will just return and do nothing. This is also true for
> > +v4l2_ctrl_handler_init if it cannot allocate the internal data structure.
> > +
> > +This makes it easy to init the handler and just add all controls and only
> > check
> > +the error code at the end. Saves a lot of repetitive error checking.
> > +
> > +It is recommended to add controls in ascending control ID order: it will
> > be
> > +a bit faster that way.
> 
> You will find me a bit annoying, but if standard controls could be initialized 
> using structures, we could pass a pointer to an array to a single control add 
> function :-) There would be less code in drivers, and they would be easier to 
> read.

It's not at all annoying :-)

I hadn't thought of creating a function to initialize multiple controls
from one array. That's actually a nice idea. I'll look into this.

The same idea can be used for custom controls as well.
 
> > +3) Optionally force initial control setup:
> > +
> > +	v4l2_ctrl_handler_setup(&foo->ctrl_handler);
> > +
> > +This will call s_ctrl for all controls unconditionally. Effectively this
> > +initializes the hardware to the default control values. It is recommended
> > +that you do this.
> 
> Copying my comments from the previous review, I think they got lost somewhere 
> (or I have lost your answer to them).
> 
> What should be recommended, calling v4l2_ctrl_handler_setup, or initializing 
> the framework with the current value ?

Calling v4l2_ctrl_handler_setup is recommended. It's easy and guarantees that
the controls and the hardware are in sync. I think that is what I do for all
drivers I have converted until now. UVC will be one of the drivers where this
is not a suitable call, though.

For UVC you will probably want to use the init callback and/or initialize the
framework with the current value.
 
> Thinking some more about this, it can be a problem for UVC devices, much like 
> querying the min/max/step/default values is. Some devices just crash if you 
> send too many requests too fast. I would like to get a g_ctrl call the first 
> time the current value needs to be read, and then have the framework cache 
> that value.

Use the init callback for that. There you can fill in both the boundaries and
the initial current value. It's called only once when the control is referenced
for the first time by the application.

> By the way (still more thinking :-)), does the framework handle a value cache 
> that can be configured per control ? Some controls are volatile and need to be 
> read from the driver every time, some others can be cached. How is that 
> handled ?

Currently it depends on whether the g_volatile_ctrl op is set. If set, then
that is called, otherwise it will use the cached value. But see my notes on
g_ctrl below.
 
> Last thought: does the framework query the driver for the current control 
> values when setting a control in a cluster ? If two clustered controls are 
> stored in a single hardware "register", and one of them needs to be modified, 
> a read-update-write operation needs to be performed. The update part will be 
> done by the framework, the write part by the driver, but what about the read 
> part ?

The framework will not do a read of the control. The reason is that that is
pointless. There are two situations:

1) The control values are cached (i.e. none of the controls are volatile). In
that case you can just use the cached values since it will be up to date.

2) The control values are volatile. In that (very unlikely) case you need to
do some sort of atomic read-update-write operation and that needs to be done
when you set the control. Having the framework do a g_ctrl first before calling
s_ctrl is hardly atomic so that won't work anyway.

> > +4) Finally: implement the v4l2_ctrl_ops
> > +
> > +	static const struct v4l2_ctrl_ops foo_ctrl_ops = {
> > +		.s_ctrl = foo_s_ctrl,
> > +	};
> > +
> > +Usually all you need is s_ctrl:
> > +
> > +	static int foo_s_ctrl(struct v4l2_ctrl *ctrl)
> > +	{
> > +		struct foo *state = container_of(ctrl->handler, struct foo,
> > ctrl_handler); +
> > +		switch (ctrl->id) {
> > +		case V4L2_CID_BRIGHTNESS:
> > +			write_reg(0x123, ctrl->val);
> > +			break;
> > +		case V4L2_CID_CONTRAST:
> > +			write_reg(0x456, ctrl->val);
> > +			break;
> > +		}
> > +		return 0;
> > +	}
> > +
> > +The control ops are called with the v4l2_ctrl pointer as argument.
> > +The new control value has already been validated, so all you need to do is
> > +to actually update the hardware registers.
> > +
> > +You're done! And this is sufficient for most of the drivers we have. No
> > need
> > +to do any validation of control values, or implement QUERYCTRL/QUERYMENU.
> > And
> > +G/S_CTRL as well as G/TRY/S_EXT_CTRLS are automatically supported.
> > +
> > +
> > +==========================================================================
> > ====
> > +
> > +The remainder of this document deals with more advanced topics and
> > scenarios.
> > +In practice the basic usage as described above is sufficient for most
> > drivers.
> > +
> > +==========================================================================
> > =====
> > +
> > +
> > +Inheriting Controls
> > +===================
> > +
> > +When a sub-device is registered with a bridge driver by calling
> > +v4l2_device_register_subdev() and the ctrl_handler fields of both
> > v4l2_subdev
> > +and v4l2_device are set, then the controls of the subdev will become
> > +automatically available in the bridge driver as well. If the subdev driver
> > +contains controls that already exist in the bridge driver, then those will
> > be
> > +skipped (so a bridge driver can always override a subdev control).
> > +
> > +What happens here is that v4l2_device_register_subdev() calls
> > +v4l2_ctrl_add_handler() adding the controls of the subdev to the controls
> > +of v4l2_device.
> > +
> > +
> > +Accessing Control Values
> > +========================
> > +
> > +The v4l2_ctrl struct contains these two unions:
> > +
> > +	/* The current control value. */
> > +	union {
> > +		s32 val;
> > +		s64 val64;
> > +		char *string;
> > +	} cur;
> > +
> > +	/* The new control value. */
> > +	union {
> > +		s32 val;
> > +		s64 val64;
> > +		char *string;
> > +	};
> > +
> > +Within the control ops you can freely use these. The val and val64 speak
> > for
> > +themselves. The string pointers point to character buffers of length
> > +ctrl->maximum + 1, and are always 0-terminated.
> 
> Does the string controls spec require the maximum length to be fixed, or can 
> it vary ?

No, that maximum length is fixed.
 
> > +In most cases 'cur' contains the current cached control value. When you
> > create
> > +a new control this value is made identical to the default value. After
> > calling
> > +v4l2_ctrl_handler_setup() this value is passed to the hardware. It is
> > generally
> > +a good idea to call this function.
> > +
> > +Whenever a new value is set that new value is automatically cached. This
> > means
> > +that most drivers do not need to implement the g_volatile_ctrl() op. The
> > +exception is for controls that return a volatile register such as a signal
> > +strength read-out that changes continuously. In that case you will need to
> > +implement g_volatile_ctrl like this:
> > +
> > +	ctrl->cur.val = read_reg(0x123);
> 
> Do we really need to call the operation g_volatile_ctrl ? I was OK with 
> g_ctrl.
> 
> If some controls are volatile and others are not, you said that the operation 
> can ignore non-volatile controls. How does it do so ? By just returning 
> success ? It might be worth mentioning it in the doc.

Correct.
 
> Another comment from my previous review for which I haven't seen an answer:
> 
> Instead of calling g_ctrl for all drivers, have it go through a big switch and 
> do nothing, wouldn't it be better to add a volatile flag to the v4l2_ctrl 
> structure ? g_ctrl calls would be skipped for non-volatile controls (except on 
> the first read of course).

First I want to clarify something: the only time g_volatile_ctrl is needed
is to get the value of a volatile control. There is no 'first time g_ctrl'.
If you need that, then use the init op. This is why I renamed it to
g_volatile_ctrl to make that use explicit.

The majority of the drivers can just create the controls with a good default
value and call the setup function. No need to implement a g_ctrl. That makes
life very easy for driver developers.

Now, if you do have volatile controls, then I envisaged that you make two
v4l2_ctrl_ops structs: one with and one without g_volatile_ctrl. The first ops
struct is passed to volatile controls, and the second to non-volatile controls.

The presence of the g_volatile_ctrl op would decide whether or not the
framework would call that function.

However, both from your comments and my own experience I am beginning to realize
that that is probably too confusing and an is_volatile bit controlling whether or
not the g_volatile_ctrl op is called is better. So I will change that. I will
also introduce a needs_init flag which controls whether the .init needs to be
called on first use.

I prefer to keep the g_volatile_ctrl name, since this is really only for
volatile controls. And the name is even more appropriate when the is_volatile
bit is introduced.

But this makes another change possible and I'd like your feedback on this.
At the moment the ops struct is set per-control. The idea is that this makes
it possible if desired to have per-control s/g/try functions. With these flags
I can move the ops struct to the control handler instead. But that means that
the control ops always consist of a big switch and that it is no longer possible
to write small ops functions for specific controls, so you are less flexible.

I am not sure about this, but it will be interesting to hear your opinion.

> > +The 'new value' union is not relevant in g_volatile_ctrl. In general
> > controls
> > +that need to implement g_volatile_ctrl are read-only controls.
> > +
> > +For try/s_ctrl the new values (i.e. as passed by the user) are filled in
> > and
> > +you can modify them in try_ctrl or set them in s_ctrl. The 'cur' union
> > +contains the current value, which you can use (but not change!) as well.
> > +
> > +If s_ctrl returns 0 (OK), then the control framework will copy the new
> > final
> > +values to the 'cur' union.
> 
> Instead of playing with cur and new, wouldn't it be less confusing to pass a 
> pointer to the new value as an argument to s_ctrl (and a pointer to the 
> current value as an argument to g_ctrl) ?

Nice idea, but that doesn't work for clustered controls.
 
> > +While in g_volatile/s/try_ctrl you can access the value of all controls
> > owned
> > +by the same handler since the handler's lock is held. Do not attempt to
> > access 
> > +the value of controls owned by other handlers, though.
> 
> Can we access all fields of other controls in s_ctrl, or just the value ? More 
> specifically, can s_ctrl on an auto control modify the enabled flag on the 
> associated manual control ?

All fields are accessible.

> > +Elsewhere in the driver you have to be more careful. You cannot just refer
> > +to the current control values without locking. There are two simple helper
> > +functions defined that will get or set a single control value safely from
> > +within the driver:
> > +
> > +	s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
> > +	int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
> > +
> > +These functions go through the control framework just as VIDIOC_G/S_CTRL
> > ioctls
> > +do. Don't use these inside the control ops g_volatile/s/try_ctrl, though,
> > that
> > +will fail since these helpers lock the handler.
> 
> This sounds a bit confusing. Would it be possible to avoid taking the lock in 
> v4l2_ctrl_g/s_ctrl if the control belongs to the same handler as the one being 
> accessed in g/s/try_ctrl ? Just throwing an idea, not sure if it's a good one, 
> but I'm pretty sure it will be confusing to have to access controls directly 
> and use the helper functions in drivers depending on which control you access 
> and in which context.

One small problem: how do I know that v4l2_ctrl_s_ctrl is called from within
a control op?

> 
> > +You can also take the handler lock yourself:
> > +
> > +	mutex_lock(&state->ctrl_handler.lock);
> > +	printk(KERN_INFO "String value is '%s'\n", ctrl1->cur.string);
> > +	printk(KERN_INFO "Integer value is '%s'\n", ctrl2->cur.val);
> > +	mutex_unlock(&state->ctrl_handler.lock);
> > +
> > +
> > +Menu Controls
> > +=============
> > +
> > +Menu controls use the 'step' value differently compared to other control
> > +types. The v4l2_ctrl struct contains this union:
> > +
> > +	union {
> > +		u32 step;
> > +		u32 menu_skip_mask;
> > +	};
> > +
> > +For menu controls menu_skip_mask is used. What it does is that it allows
> > you
> > +to easily exclude certain menu items. This is used in the VIDIOC_QUERYMENU
> > +implementation where you can return -EINVAL if a certain menu item is not
> > +present. Note that VIDIOC_QUERYCTRL always returns a step value of 1 for
> > +menu controls.
> > +
> > +A good example is the MPEG Audio Layer II Bitrate menu control where the
> > +menu is a list of standardized possible bitrates. But in practice hardware
> > +implementations will only support a subset of those. By setting the skip
> > +mask you can tell the framework which menu items should be skipped.
> > Setting
> > +it to 0 means that all menu items are supported.
> > +
> > +So when using v4l2_ctrl_new_std or v4l2_ctrl_new_custom (see below) you
> > need
> > +to remember that 'step' means 'skip mask' for menu controls. If you put in
> > '1'
> > +by mistake, then the first menu item will be skipped.
> 
> What about renaming the argument to step_or_skip_mask then ? Or make it two 
> arguments ?
> 
> The comment doesn't seem to apply to v4l2_ctrl_new_custom anymore, as you have 
> two different fields there.

I'm going to experiment a bit with these calls. I agree that it needs more work.
Another thing that is currently wrong is that v4l2_ctrl_new_std_menu() doesn't
have a 'max' argument. Instead I calculate it based on the size of the qmenu
array. The problem with that is that if the menu is extended with new values,
then you don't want to have those new values automatically appear in any driver
that uses that menu. The max value must be passed in when the control is created.

> > +The v4l2_ctrl_new_std_menu function can be used to add menu controls more
> > +easily: it will calculate the min and max values automatically based on
> > the
> > +size of the menu, and it has a proper 'mask' argument instead of 'step'.
> > +
> > +
> > +Custom Controls
> > +===============
> > +
> > +Driver specific controls can be created using v4l2_ctrl_new_custom():
> > +
> > +	static const struct v4l2_ctrl_config ctrl_filter = {
> > +		.ops = &ctrl_custom_ops,
> > +		.id = V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER,
> > +		.name = "Spatial Filter",
> > +		.type = V4L2_CTRL_TYPE_INTEGER,
> > +		.flags = V4L2_CTRL_FLAG_SLIDER,
> > +		.max = 15,
> > +		.step = 1,
> > +	};
> > +
> > +	ctrl = v4l2_ctrl_new_custom(&foo->ctrl_handler, &ctrl_filter, NULL);
> > +
> > +The last argument is the priv pointer which can be set to driver-specific
> > +private data.
> 
> If I add a standard control using v4l2_ctrl_new_custom, will it fill the name, 
> type, ... fields for me ?

No. That's why it is called 'custom'. That said, it would be easy to add
something like that. E.g. if the name is NULL, then assume it is a std control
and fill in the field accordingly.

But is that sensible or featurism?
 
> > +Active and Grabbed Controls
> > +===========================
> > +
> > +If you get more complex relationships between controls, then you may have
> > to
> > +activate and deactivate controls. For example, if the Chroma AGC control is
> > +on, then the Chroma Gain control is inactive. That is, you may set it, but
> > +the value will not be used by the hardware as long as the automatic gain
> > +control is on. Typically user interfaces can disable such input fields.
> > +
> > +You can set the 'active' status using v4l2_ctrl_activate(). By default all
> > +controls are active. Note that the framework does not check for this flag.
> > +It is meant purely for GUIs. The function is typically called from within
> > +s_ctrl.
> 
> Shouldn't you mention that the driver needs to take the handler lock if it 
> wants to (de)activate a control belonging to another handler, or if it wants 
> to do it outside the s_ctrl callback ?

I just realized I have a much better idea: if I make the v4l2_ctrl flags field
an unsigned long, then I can use the atomic bit ops, thus avoiding the whole
problem of locking.
 
> > +The other flag is the grabbed flag. A grabbed control means that you
> > cannot
> > +change it because it is in use by some resource. Typical examples are MPEG
> > +bitrate controls that cannot be changed while capturing is in progress.
> > +
> > +If a control is set to 'grabbed' using v4l2_ctrl_grab(), then the
> > framework
> > +will return -EBUSY if an attempt is made to set this control.
> > +
> > +Since this flag is used by the framework the v4l2_ctrl_grab function will
> > +take the control handler's lock. So it cannot be called from within the
> > +control ops. Instead this is typically called from the driver when it
> > +starts streaming.
> 
> This makes v4l2_ctrl_activate and v4l2_ctrl_grab behave differently. It might 
> be confusing.

Should be fixed when I use the atomic bit ops.
 
> > +Control Clusters
> > +================
> > +
> > +By default all controls are independent from the others. But in more
> > +complex scenarios you can get dependencies from one control to another.
> > +In that case you need to 'cluster' them:
> > +
> > +	struct foo {
> > +		struct v4l2_ctrl_handler ctrl_handler;
> > +#define AUDIO_CL_VOLUME (0)
> > +#define AUDIO_CL_MUTE   (1)
> > +		struct v4l2_ctrl *audio_cluster[2];
> > +		...
> > +	};
> > +
> > +	state->audio_cluster[AUDIO_CL_VOLUME] =
> > +		v4l2_ctrl_new_std(&state->ctrl_handler, ...);
> > +	state->audio_cluster[AUDIO_CL_MUTE] =
> > +		v4l2_ctrl_new_std(&state->ctrl_handler, ...);
> > +	v4l2_ctrl_cluster(ARRAY_SIZE(state->audio_cluster), state->audio_cluster);
> > +
> > +From now on whenever one or more of the controls belonging to the same
> > +cluster is set (or 'gotten', or 'tried'), only the control ops of the
> > first
> > +control ('volume' in this example) is called. You effectively create a new
> > +composite control. Similar to how a 'struct' works in C.
> > +
> > +So when s_ctrl is called with V4L2_CID_AUDIO_VOLUME as argument, you should
> > set
> > +all two controls belonging to the audio_cluster:
> > +
> > +	static int foo_s_ctrl(struct v4l2_ctrl *ctrl)
> > +	{
> > +		struct foo *state = container_of(ctrl->handler, struct foo,
> > ctrl_handler); +
> > +		switch (ctrl->id) {
> > +		case V4L2_CID_AUDIO_VOLUME: {
> > +			struct v4l2_ctrl *mute = ctrl->cluster[AUDIO_CL_MUTE];
> > +
> > +			write_reg(0x123, mute->val ? 0 : ctrl->val);
> > +			break;
> > +		}
> > +		case V4L2_CID_CONTRAST:
> > +			write_reg(0x456, ctrl->val);
> > +			break;
> > +		}
> > +		return 0;
> > +	}
> > +
> > +In the example above the following are equivalent for the VOLUME case:
> > +
> > +	ctrl == ctrl->cluster[AUDIO_CL_VOLUME] ==
> > state->audio_cluster[AUDIO_CL_VOLUME]
> > +	ctrl->cluster[AUDIO_CL_MUTE] == state->audio_cluster[AUDIO_CL_MUTE]
> > +
> > +Note that controls in a cluster may be NULL. For example, if for some
> > +reason mute was never added (because the hardware doesn't support that
> > +particular feature), then mute will be NULL.
> 
> The driver needs to set state->audio_cluster[AUDIO_CL_MUTE] to NULL 
> explicitly, right ? In that case I think you should mention it.

Good point.
 
> > So in that case we have a
> > +cluster of 2 controls, of which only 1 is actually instantiated. The
> > +only restriction is that the first control of the cluster must always be
> > +present, since that is the 'master' control of the cluster. The master
> > +control is the one that identifies the cluster and that provides the
> > +pointer to the v4l2_ctrl_ops struct that is used for that cluster.
> > +
> > +
> > +VIDIOC_LOG_STATUS Support
> > +=========================
> > +
> > +This ioctl allow you to dump the current status of a driver to the kernel
> > log.
> > +The v4l2_ctrl_handler_log_status(ctrl_handler, prefix) can be used to dump
> > the
> > +value of the controls owned by the given handler to the log. You can supply
> > a
> > +prefix as well. If the prefix didn't end with a space, then ': ' will be
> > added
> > +for you.
> > +
> > +
> > +Different Handlers for Different Video Nodes
> > +============================================
> > +
> > +Usually the bridge driver has just one control handler that is global for
> > +all video nodes. But you can also specify different control handlers for
> > +different video nodes. You can do that by manually setting the ctrl_handler
> > +field of struct video_device.
> > +
> > +That is no problem if there are no subdevs involved but if there are, then
> > +you need to block the automatic merging of subdev controls to the global
> > +control handler. You do that by simply setting the ctrl_handler field in
> > +struct v4l2_device to NULL. Now v4l2_device_register_subdev() will no
> > longer
> > +merge subdev controls.
> > +
> > +After each subdev was added, you will then have to call
> > v4l2_ctrl_add_handler
> > +manually to add the subdev's control handler (sd->ctrl_handler) to the
> > desired
> > +control handler. This control handler may be specific to the video_device
> > or
> > +for a subset of video_device's. For example: the radio device nodes only
> > have
> > +audio controls, while the video and vbi device nodes share the same control
> > +handler for the audio and video controls.
> > +
> > +If you want to have one handler (e.g. for a radio device node) have a
> > subset
> > +of another handler (e.g. for a video device node), then you should first
> > add
> > +the controls to the first handler, add the other controls to the second
> > +handler and finally add the first handler to the second. For example:
> > +
> > +	v4l2_ctrl_new_std(&radio_ctrl_handler, &radio_ops, V4L2_CID_AUDIO_VOLUME,
> > ...);
> > +	v4l2_ctrl_new_std(&radio_ctrl_handler, &radio_ops, V4L2_CID_AUDIO_MUTE,
> > ...);
> > +	v4l2_ctrl_new_std(&video_ctrl_handler, &video_ops, V4L2_CID_BRIGHTNESS,
> > ...);
> > +	v4l2_ctrl_new_std(&video_ctrl_handler, &video_ops, V4L2_CID_CONTRAST,
> > ...);
> > +	v4l2_ctrl_add_handler(&video_ctrl_handler, &radio_ctrl_handler);
> > +
> > +Or you can add specific controls to a handler:
> > +
> > +	volume = v4l2_ctrl_new_std(&video_ctrl_handler, &ops,
> > V4L2_CID_AUDIO_VOLUME, ...);
> > +	v4l2_ctrl_new_std(&video_ctrl_handler, &ops, V4L2_CID_BRIGHTNESS, ...);
> > +	v4l2_ctrl_new_std(&video_ctrl_handler, &ops, V4L2_CID_CONTRAST, ...);
> > +	v4l2_ctrl_add_ctrl(&radio_ctrl_handler, volume);
> > +
> > +What you should not do is make two identical controls for two handlers.
> > +For example:
> > +
> > +	v4l2_ctrl_new_std(&radio_ctrl_handler, &radio_ops, V4L2_CID_AUDIO_MUTE,
> > ...);
> > +	v4l2_ctrl_new_std(&video_ctrl_handler, &video_ops, V4L2_CID_AUDIO_MUTE,
> > ...); +
> > +This would be bad since muting the radio would not change the video mute
> > +control. The rule is to have one control for each hardware 'knob' that you
> > +can twiddle.
> > +
> > +
> > +Finding Controls
> > +================
> > +
> > +Normally you have created the controls yourself and you can store the
> > struct
> > +v4l2_ctrl pointer into your own struct.
> > +
> > +But sometimes you need to find a control from another handler that you do
> > +not own. For example, if you have to find a volume control from a subdev.
> > +
> > +You can do that by calling v4l2_ctrl_find:
> > +
> > +	struct v4l2_ctrl *volume;
> > +
> > +	volume = v4l2_ctrl_find(sd->ctrl_handler, V4L2_CID_AUDIO_VOLUME);
> > +
> > +Since v4l2_ctrl_find will lock the handler you have to be careful where
> > you
> > +use it. For example, this is not a good idea:
> > +
> > +	struct v4l2_ctrl_handler ctrl_handler;
> > +
> > +	v4l2_ctrl_new_std(&ctrl_handler, &video_ops, V4L2_CID_BRIGHTNESS, ...);
> > +	v4l2_ctrl_new_std(&ctrl_handler, &video_ops, V4L2_CID_CONTRAST, ...);
> > +
> > +...and in video_ops.s_ctrl:
> > +
> > +	case V4L2_CID_BRIGHTNESS:
> > +		contrast = v4l2_find_ctrl(&ctrl_handler, V4L2_CID_CONTRAST);
> > +		...
> > +
> > +When s_ctrl is called by the framework the ctrl_handler.lock is already
> > taken, so
> > +attempting to find another control from the same handler will deadlock.
> > +
> > +It is recommended not to use this function from inside the control ops.
> 
> Doesn't that call for an unlocked version of the find function ?

Normally you will store the pointer to the control directly in the driver's
state struct. Why try to find it when you have direct access to the control
through the pointer?

But should there be a need for this, then an unlocked version can be added.
It actually exists already internally.
 
> > +Inheriting Controls
> > +===================
> > +
> > +When one control handler is added to another using v4l2_ctrl_add_handler,
> > then
> > +by default all controls from one are merged to the other. But a subdev
> > might
> > +have low-level controls that make sense for some advanced embedded system,
> > but
> > +not when it is used in consumer-level hardware. In that case you want to
> > keep
> > +those low-level controls local to the subdev. You can do this by simply
> > +setting the 'is_private' flag of the control to 1:
> > +
> > +	ctrl = v4l2_ctrl_new_custom(&sd->ctrl_handler, ...);
> > +	if (ctrl)
> > +		ctrl->is_private = 1;
> > +
> > +These controls will now be skipped when v4l2_ctrl_add_handler is called.
> 
> One more unresolved comment from the previous review:
> 
> > > Wouldn't it make more sense to pass that as an argument to
> > > v4l2_ctrl_new_custom ?
> > 
> > As I said earlier, I tried to avoid creating zillions of very similar
> > functions, or functions with very long arg lists. For now at least private
> > controls are not used at all.
> > 
> > It is usually easier for the driver to write a few special static inlines
> > that do exactly what the driver needs. Of course, if many drivers need to
> > do the same thing, then such inlines should be moved to the core header.
> 
> "Maybe this feature won't be used" sounds more like a reason to remove it than 
> to implement it badly and leave it to be fixed later :-)
> 
> The control framework is a big change to the V4L2 framework, we should take 
> great care to get it as good as possible on the first try.

I will look at this. I will definitely add this to struct v4l2_ctrl_config.

> > +V4L2_CTRL_TYPE_CTRL_CLASS Controls
> > +==================================
> > +
> > +Controls of this type can be used by GUIs to get the name of the control
> > class.
> > +A fully featured GUI can make a dialog with multiple tabs with each tab
> > +containing the controls belonging to a particular control class. The name
> > of
> > +each tab can be found by querying a special control with ID <control class
> > | 1>.
> > +
> > +Drivers do not have to care about this. The framework will automatically
> > add 
> > +a control of this type whenever the first control belonging to a new
> > control
> > +class is added.
> > +
> > +
> > +Initializing Controls
> > +=====================
> > +
> > +Usually controls are initialized when you call one of the
> > v4l2_ctrl_new_*()
> > +functions. But sometimes you do not know all the details of the control's
> > +boundaries and possibly even type at this stage. Or obtaining those details
> > +may require expensive hardware accesses.
> > +
> > +In that case you can specify a .init op in struct v4l2_ctrl_ops. This op
> > +returns a void, so it may not fail. Should the init run into problems,
> > then
> > +it should disable the control by setting V4L2_CTRL_FLAG_DISABLED.
> 
> If it can fail, why does it return void ? The operation will fail from times 
> to times with buggy UVC devices. It's better to return an error to userspace 
> rather than silently disabling the control. I can already see support e-mails 
> asking why a control suddenly becomes disabled.

What is userspace supposed to do when this fails? That was the reason for
making this a void initially: I have no idea what to do with it when it fails.

But I'll see if I can change this.
 
> > +The init op can be used to setup the type and boundaries of the control on
> > +first use. Any controls with a .init op will be skipped by
> > +v4l2_ctrl_handler_setup().
> > +
> > +
> > +Differences from the Spec
> > +=========================
> > +
> > +There are a few places where the framework acts slightly differently from
> > the
> > +V4L2 Specification. Those differences are described in this section. We
> > will
> > +have to see whether we need to adjust the spec or not.
> > +
> > +1) It is no longer required to have all controls contained in a
> > +v4l2_ext_control array be from the same control class. The framework will
> > be
> > +able to handle any type of control in the array. You need to set ctrl_class
> > +to 0 in order to enable this. If ctrl_class is non-zero, then it will still
> > +check that all controls belong to that control class.
> > +
> > +If you set ctrl_class to 0 and count to 0, then it will only return an
> > error
> > +if there are no controls at all.
> > +
> > +2) Clarified the way error_idx works. For get and set it will be equal to
> > +count if nothing was done yet. If it is less than count then only the
> > controls
> > +up to error_idx-1 were successfully applied.
> > +
> > +3) When attempting to read a button control the framework will return
> > -EACCES
> > +instead of -EINVAL as stated in the spec. It seems to make more sense since
> > +button controls are write-only controls.
> 
> What about non-button write-only controls, are they handled the same way ?

According to the spec they should already return -EACCES when an attempt is
made to read them.
 
> > +4) Attempting to write to a read-only control will return -EACCES instead
> > of
> > +-EINVAL as the spec says.
> > +
> > +5) The spec does not mention what should happen when you try to set/get a
> > +control class controls. ivtv currently returns -EINVAL (indicating that the
> > +control ID does not exist) while the framework will return -EACCES, which
> > +makes more sense.
> > +
> > +
> > +Proposals for Extensions
> > +========================
> > +
> > +Some ideas for future extensions to the spec:
> > +
> > +1) Add a V4L2_CTRL_FLAG_HEX to have values shown as hexadecimal instead of
> > +decimal. Useful for e.g. video_mute_yuv.
> 
> Shown where ?

In v4l2-ctl, qv4l2 and any other GUI.
 
> > +2) It is possible to mark in the controls array which controls have been
> > +successfully written and which failed by for example adding a bit to the
> > +control ID. Not sure if it is worth the effort, though.
> 
> 

Again, thank you very much for this review. It gave me several good ideas.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
