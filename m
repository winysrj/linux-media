Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4096 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab0EGJV7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 05:21:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 03/15] [RFC] Documentation: add v4l2-controls.txt documenting the new controls API.
Date: Fri, 7 May 2010 11:23:16 +0200
Cc: linux-media@vger.kernel.org
References: <cover.1272267136.git.hverkuil@xs4all.nl> <201005030021.46500.hverkuil@xs4all.nl> <201005062336.49288.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201005062336.49288.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005071123.16551.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 06 May 2010 23:36:48 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 03 May 2010 00:21:46 Hans Verkuil wrote:
> > On Sunday 02 May 2010 22:39:11 Laurent Pinchart wrote:
> > > On Monday 26 April 2010 09:33:38 Hans Verkuil wrote:
> 
> [snip]
> 
> > > > +Objects in the framework
> > > > +========================
> > > > +
> > > > +There are two main objects:
> > > > +
> > > > +The v4l2_ctrl object describes the control properties and keeps track
> > > > of the
> > > > +control's value (both the current value and the proposed new value).
> > > 
> > > I'm not sure v4l2_ctrl is a good name. We already have a v4l2_control
> > > structure, and using the abbreviated name for the in-kernel version is
> > > going to be confusing.
> > 
> > Originally it was called v4l2_ctrl_info but that became very cumbersome.
> > It's not really an info object anyway, it really describes a control. When
> > using this framework the driver no longer sees the v4l2_control anymore, so
> > from the point of view of the driver there is only v4l2_ctrl.
> 
> Sure, but it's still misleading. Using an both the abbreviated and non-
> abbreviated names to refer to two different things has been done too often in 
> V4L2, and it's starting to bother me. It makes the API look inconsistent. We 
> need to define a naming policy and stick to it for the future. That can be a 
> topic for the V4L2 summit in June.

I can go back to v4l2_ctrl_info, unless you have a better name?

> > > It's obviously too late to change v4l2_control to something else.
> > > v4l2_control_info and v4l2_control_value are two names that come to my
> > > mind. Actually, it might be a good idea to split the v4l2_ctrl structure
> > > into a static driver-wide structure (v4l2_control_info) and an
> > > instance-specific structure (v4l2_control_value). There's no point in
> > > storing the same static data (function pointers, names, ...) for
> > > identical controls in different devices.
> > 
> > Other than the name there isn't anything that is static. And the name is
> > already static.
> 
> The following fields are static (they're identical across all v4l2_ctrl 
> instances for the same control):
> 
> - ops
> - id
> - name
> - type
> - menu (not too sure about this one)

It's honestly not worth it. The fields name, menu and ops already point to
static const datastructs, so that leaves only the pointers themselves that
you can save. And most of these fields are used very frequently as well, so
having do an extra dereference will reduce the performance.

I tried something like this in the beginning and it simply isn't worth the
pain it introduces.

> 
> [snip]
> 
> > > > +
> > > > +  How to hook the handler into a bridge driver:
> > > > +
> > > > +	foo->v4l2_dev.ctrl_handler = &foo->hdl;
> 
> [snip]
> 
> > > > +
> > > > +  And whenever you call video_register_device() you must set the
> > > > +  ctrl_handler field of struct video_device as well:
> > > > +
> > > > +	vdev->ctrl_handler = &foo->hdl;
> 
> [snip]
> 
> > > Why can't the framework find the ctrl_handler instance from the
> > > video_device's v4l2_device parent ?
> > 
> > Sometimes you want to provide different control handlers to different
> > video devices. E.g. /dev/radio0 may have only a small subset of the
> > controls of /dev/video0 (bttv does that, for example).
> > 
> > One option is to automatically let video_register_device copy ctrl_handler
> > from the v4l2_dev struct, but I think it is clearer if it is explicitly
> > set.
> 
> I was thinking about copying it implicitly if it's not set, yes. That way only 
> the v4l2_device instance would need an explicit handler, video devices would 
> inherit it from their v4l2_device parent. The driver would still have the 
> ability to set it if it wants to override the default behaviour.
> 
> It might be clearer to always set it explicitly, I have no strong opinion on 
> this one.

In that case I will leave it as is.
 
> > > > +  Finally, remove all control functions from your v4l2_ioctl_ops:
> > > > +  vidioc_queryctrl, vidioc_querymenu, vidioc_g_ctrl, vidioc_s_ctrl,
> > > > +  vidioc_g_ext_ctrls, vidioc_try_ext_ctrls and vidioc_s_ext_ctrls.
> > > > +  Those are now no longer needed.
> > > > +
> > > > +  How to hook the control handler into a subdev driver:
> > > > +
> > > > +	foo->sd.ctrl_handler = &foo->hdl;
> > > > +
> > > > +  And set all core control ops in your struct v4l2_subdev_core_ops to
> > > > these
> > > > +  helpers:
> > > > +
> > > > +	.queryctrl = v4l2_sd_queryctrl,
> > > > +	.querymenu = v4l2_sd_querymenu,
> > > > +	.g_ctrl = v4l2_sd_g_ctrl,
> > > > +	.s_ctrl = v4l2_sd_s_ctrl,
> > > > +	.g_ext_ctrls = v4l2_sd_g_ext_ctrls,
> > > > +	.try_ext_ctrls = v4l2_sd_try_ext_ctrls,
> > > > +	.s_ext_ctrls = v4l2_sd_s_ext_ctrls,
> > > 
> > > s/sd/subdev/ ?
> > 
> > I have to sleep on that... :-)
> 
> You've slept on it for a week now :-)
> 
> We really have too many abbreviations in V4L2, or at least no consistent usage 
> of them.

I'll change it to subdev. There helpers are temporarily anyway.
 
> [snip]
> 
> > > What about hardware for which the boundaries are only known at runtime,
> > > or could depend on the values of other controls ? I'm thinking about UVC
> > > devices for instance, the boundaries, step and default values need to be
> > > retrieved from the hardware. I currently do that at runtime when the
> > > control is queried for the first time and cache the values, as doing it
> > > during initialization (probe function) crashes a few webcams. That
> > > doesn't seem to be possible with the control framework.
> > 
> > It is possible to add controls to an existing control handler at runtime.
> > It is also possible to change boundaries at runtime: you just change the
> > relevant values in v4l2_ctrl. There is no function for that, it's enough
> > to call v4l2_ctrl_lock(), change the values and call unlock().
> > 
> > I could make a function that does this, but UVC is the only driver that I
> > know of that might need this.
> 
> My issue is that the UVC driver would need to set the boundaries the first 
> time the control is queried. There's no callback for that at the moment.

Ah! Now I understand your problem. What you need is an .init op that is called
the first time the control is used. That shouldn't be hard to add.
 
> > > > +	...
> > > > +	if (foo->hdl.error) {
> > > > +		int err = foo->hdl.error;
> > > > +
> > > > +		v4l2_ctrl_handler_free(&foo->hdl);
> > > > +		return err;
> > > > +	}
> > > > +
> > > > +The v4l2_ctrl_new_std function returns the v4l2_ctrl pointer to the new
> > > > +control, but if you do not need to access the pointer outside the
> > > > control ops,
> > > > +then there is no need to store it.
> > > > +
> > > > +Note that if something fails, the function will return NULL or an error
> > > > and
> > > > +set hdl->error to the error code. If hdl->error was already set, then
> > > > it
> > > > +will just return and do nothing. This is also true for
> > > > v4l2_ctrl_handler_init
> > > > +if it cannot allocate the internal data structure.
> > > > +
> > > > +This makes it easy to init the handler and just add all controls and
> > > > only check
> > > > +the error code at the end. Saves a lot of repetitive error checking.
> > > 
> > > I would still check the v4l2_ctrl_handler_init return value explicitly,
> > > but that may be just me.
> > 
> > Feel free to do that :-)
> 
> You know what I meant :-) I agree this is a good way to handle errors for 
> v4l2_ctrl_new_*, but v4l2_ctrl_handler_init feels... different.

I know what you mean, but it is just so useful to do it like this. Remember
that many drivers have just 1-4 controls, so having to introduce yet another
error path to handle the failure of v4l2_ctrl_handler_init is getting really
frustrating. I definitely like to keep this functionality, it saves unnecessary
repetitive code in a lot of drivers.

> 
> [snip]
> 
> > > > +3) Optionally force initial control setup:
> > > > +
> > > > +	v4l2_ctrl_handler_setup(&foo->hdl);
> > > > +
> > > > +This will call s_ctrl for all controls unconditionally. Effectively
> > > > this
> > > > +initializes the hardware to the default control values. It is
> > > > recommended +that you do this.
> > > 
> > > What about the other way around, if I want to initialize the framework
> > > with the current values retrieved from the hardware ?
> > 
> > In that case you would set the default value of the control based on the
> > value reported by the hardware.
> 
> The default value can still be different than the current value. Don't you 
> mean I should initialize the current value, not the default one ?
> 
> What should be recommended, calling v4l2_ctrl_handler_setup, or initializing 
> the framework with the current value ?

OK, you want to initialize the current value to something that isn't the
default value. I didn't catch that nuance.

There are two ways of doing this that I can think of up front:

The first is to use the proposed .init op. In the case of UVC that might be a
good choice actually. The second approach is to create the control and call
v4l2_ctrl_s to set it explicitly. Actually, I would favor using init for this.
Note that I suspect that in uvc you will not use v4l2_ctrl_handler_setup at all.
 
> Thinking some more about this, it can be a problem for UVC devices, much like 
> querying the min/max/step/default values is. Some devices just crash if you 
> send too many requests too fast. I would like to get a g_ctrl call the first 
> time the current value needs to be read, and then have the framework cache 
> that value.
> 
> By the way (still more thinking :-)), does the framework handle a value cache 
> that can be configured per control ? Some controls are volatile and need to be 
> read from the driver every time, some others can be cached. How is that 
> handled ?

It is already cached. Based on your misunderstanding I realized that I should
rename the g_ctrl op to g_volatile_ctrl. Because g_ctrl is only meant for
volatile controls. As you can see from my patches that convert existing drivers
to the control framework, the majority doesn't implement g_ctrl.

In the case of uvc (and if the .init op is added), the .init can take care of
the initial setup, querying the hardware for the current value, and if the
control isn't volatile, then the control's current value will be cached.
 
> Last thought: does the framework query the driver for the current control 
> values when setting a control in a cluster ? If two clustered controls are 
> stored in a single hardware "register", and one of them needs to be modified, 
> a read-update-write operation needs to be performed. The update part will be 
> done by the framework, the write part by the driver, but what about the read 
> part ?

No, it does not read the current control value before calling s_ctrl. I don't
think it is useful: if you need to do a read-update-write cycle, then you want
to do that in one operation. Having the read done well before the write is not
useful. If you need to, then you can call g_ctrl directly from within s_ctrl.
I have yet to see a driver that needs this, though.
 
> [snip]
> 
> > > > +Accessing Control Values
> > > > +========================
> > > > +
> > > > +The v4l2_ctrl struct contains these two unions:
> > > > +
> > > > +	/* The current control value. */
> > > > +	union {
> > > > +		s32 val;
> > > > +		s64 val64;
> > > > +		char *string;
> > > > +	} cur;
> > > > +
> > > > +	/* The new control value. */
> > > > +	union {
> > > > +		s32 val;
> > > > +		s64 val64;
> > > > +		char *string;
> > > > +	};
> > > > +
> > > > +Within the control ops you can freely use these. The val and val64
> > > > speak for
> > > > +themselves. The string pointers point to character buffers of length
> > > > +ctrl->maximum + 1, and are always 0-terminated.
> > > > +
> > > > +For g_ctrl you have to update the current control values like this:
> > > > +
> > > > +	ctrl->cur.val = read_reg(0x123);
> > > > +
> > > > +The 'new value' union is not relevant in g_ctrl.
> > > 
> > > When is g_ctrl called ? When the userspace applications issues a
> > > VIDIOC_G_CTRL or VIDIOC_G_EXT_CTRLS ioctl ?
> > 
> > Yes.
> 
> OK. Can you make that explicit ?

I clearly need to clarify this. It is called when someone (usually userspace
through these ioctls) needs to get the control's value. But normally drivers
do not implement and so the cached current value is returned. Only if this is
a volatile control do the drivers implement this op.

One other thing that needs to be clarified: when you create a new control the
initial current value will be set to the default value.

Calling v4l2_ctrl_handler_setup will set all controls with that initial current
value. In other words it syncs the hardware with the internal control state.
 
> > > I suppose the operation only needs to be implemented if the device needs
> > > to be queried because it modified the control value on its own (possibly
> > > as a result of setting another control). What if some controls need to be
> > > handled that way, while the others are not self-modifying ?
> > 
> > g_ctrl only has to take care of self-modifying controls and can ignore the
> > others. saa7115 has a use case like that.
> 
> Instead of calling g_ctrl for all drivers, have it go through a big switch and 
> do nothing, wouldn't it be better to add a volatile flag to the v4l2_ctrl 
> structure ? g_ctrl calls would be skipped for non-volatile controls (except on 
> the first read of course).

I thought about this, but you can also create two op structs: one for volatile
controls containing a g_ctrl, and one for non-volatile controls which doesn't
have that. That way you don't need to set a flag afterwards.

What op struct you provide will give you the flexibility that you need.
I didn't think it was necessary to add yet another flag.

> > > > +For try/s_ctrl the new values (i.e. as passed by the user) are filled
> > > > in and
> > > > +you can modify them in try_ctrl or set them in s_ctrl. The 'cur' union
> > > > +contains the current value, which you can use (but not change!) as
> > > > well. +
> > > > +If s_ctrl returns 0 (OK), then the control framework will copy the new
> > > > final
> > > > +values to the 'cur' union.
> > > > +
> > > > +While in g/s/try_ctrl you can access the value of all controls owned
> > > > by the
> > > > +same handler since the handler's lock is held. Do not attempt to
> > > > access +the value of controls owned by other handlers, though.
> > > > +
> > > > +Elsewhere in the driver you have to be more careful. You cannot just
> > > > refer +to the current control values without locking.
> > > > +
> > > > +There are two simple helper functions defined that will get or set a
> > > > single
> > > > +control value safely:
> > > > +
> > > > +	s32 v4l2_ctrl_g(struct v4l2_ctrl *ctrl);
> > > > +	int v4l2_ctrl_s(struct v4l2_ctrl *ctrl, s32 val);
> > > 
> > > I suppose that v4l2_ctrl_s can be used if the device notifies the driver
> > > that a control has changed. Is that correct ?
> > > 
> > > I don't really like the names of those two functions. For instance,
> > > v4l2_ctrl_s looks like it will call the driver to set a control.
> > 
> > I think there is a misunderstanding here: v4l2_ctrl_s() will indeed change
> > the control's value.
> 
> Do you mean that it will call the driver's s_ctrl operation or that it will 
> modify the current value in the v4l2_ctrl structure ? The misunderstanding 
> probably calls for a function name change :-)

It will call the driver's s_ctrl operation. And a better name is indeed needed.
Suggestions?

> 
> [snip]
> 
> > > > +Menu Controls
> > > > +=============
> > > > +
> > > > +Menu controls use the 'step' value differently compared to other
> > > > control +types. The v4l2_ctrl struct contains this union:
> > > > +
> > > > +	union {
> > > > +		u32 step;
> > > > +		u32 menu_skip_mask;
> > > > +	};
> > > > +
> > > > +For menu controls menu_skip_mask is used. What it does is that it
> > > > allows you
> > > > +to easily exclude certain menu items. This is used in the
> > > > VIDIOC_QUERYMENU +implementation where you can return -EINVAL if a
> > > > certain menu item is not +present. Note that VIDIOC_QUERYCTRL always
> > > > returns a step value of 1 for +menu controls.
> > > > +
> > > > +A good example is the MPEG Audio Layer II Bitrate menu control where
> > > > the +menu is a list of standardized possible bitrates. But in practice
> > > > hardware +implementations will only support a subset of those. By
> > > > setting the skip +mask you can tell the framework which menu items
> > > > should be skipped. Setting
> > > > +it to 0 means that all menu items are supported.
> > > > +
> > > > +So when using v4l2_ctrl_new_std or v4l2_ctrl_new_custom you need to
> > > > remember
> > > > +that 'step' means 'skip mask' for menu controls. If you put in '1' by
> > > > mistake,
> > > > +then the first menu item will be skipped.
> > > 
> > > What about adding a v4l2_ctrl_new_menu then ? That will avoid such a
> > > mistake.
> > > 
> > > > +The v4l2_ctrl_new_std_menu can be used to add menu controls more
> > > > easily: it
> > > > +will calculate the min and max values automatically based on the size
> > > > of the
> > > > +menu, and it has a proper 'mask' argument instead of 'step'.
> > > 
> > > OK :-) Shouldn't v4l2_ctrl_new_custom be restricted to non-menu controls
> > > then ? Looking at the code, it should probably become an internal
> > > function, with another function added for custom controls without menu
> > > support.
> > 
> > I might add that in the future. I want to avoid creating a long series of
> > different functions, all alike :-)
> 
> Then drivers will use the function that will later become internal. You'll 
> have to change a bunch of drivers later, and you will tell me that it would be 
> too much work and wouldn't be worth it ;-)

It's more that I don't want to add functions unless there is at least one driver
that uses it.
 
> > > > +Active and Grabbed Controls
> > > > +===========================
> > > > +
> > > > +If you get more complex relationships between controls, then you may
> > > > have to
> > > > +activate and deactivate controls. For example, if the Chroma AGC
> > > > control is +on, then the Chroma Gain control is inactive. That is, you
> > > > may set it, but +the value will not be used by the hardware as long as
> > > > the automatic gain +control is on. Typically user interfaces can
> > > > disable such input fields. +
> > > > +You can set the 'active' status using v4l2_ctrl_activate(). By default
> > > > all +controls are active. Note that the framework does not check for
> > > > this flag. +It is meant purely for GUIs. The function is typically
> > > > called from within +s_ctrl.
> > > 
> > > What you refer to as active/inactive is usually referred to as
> > > enabled/disabled in the GUI world. Might be worth using the same
> > > convention.
> > 
> > Strictly speaking it is not quite the same. An inactive control can still
> > be written, the new value will simply not be used until the control
> > becomes active again. In a GUI that would be confusing, so the control is
> > disabled instead. It's a subtle difference that may or may not be
> > important.
> 
> What does the framework do when the userspace application attempts to write to 
> a disabled control ?

It returns -EINVAL as per spec.

> 
> [snip]
> 
> > > > +Control Clusters
> > > > +================
> > > > +
> > > > +By default all controls are independent from the others. But in more
> > > > +complex scenarios you can get dependencies from one control to
> > > > another. +In that case you need to 'cluster' them:
> > > > +
> > > > +	struct foo {
> > > > +		struct v4l2_ctrl_handler hdl;
> > > > +		struct v4l2_ctrl *volume;
> > > > +		struct v4l2_ctrl *mute;
> > > > +		...
> > > > +	};
> > > > +
> > > > +	state->volume = v4l2_ctrl_new_std(&state->hdl, ...);
> > > > +	state->mute = v4l2_ctrl_new_std(&state->hdl, ...);
> > > > +	v4l2_ctrl_cluster(2, &state->volume);
> > > 
> > > What's the first argument to v4l2_ctrl_cluster ? The number of controls
> > > in the cluster ?
> > 
> > Yes.
> > 
> > > Does that imply that they need to be added in a sequence, right
> > > before v4l2_ctrl_cluster is called ? That seems a bit awkward. Wouldn't
> > > it be better to specify the relationships between controls explicitly,
> > > maybe by passing a pointer to the master control when creating the
> > > 'slave' controls in the cluster ?
> > 
> > OK, I clearly need to explain this better.
> > 
> > What you pass is an array of v4l2_ctrl pointers, e.g.:
> > 
> > 	struct foo {
> > 		struct v4l2_ctrl *cluster[2];
> > 		...
> > 	};
> > 
> > 	foo->cluster[CTRL_VOLUME] = v4l2_ctrl_new_std();
> > 	foo->cluster[CTRL_MUTE] = v4l2_ctrl_new_std();
> > 	v4l2_ctrl_cluster(2, foo->cluster);
> > 
> > cluster[0] is always the master.
> > 
> > Now, using arrays here becomes quickly very annoying, so instead you can
> > just say:
> > 	struct foo {
> > 		/* volume/mute cluster */
> > 		struct v4l2_ctrl *volume;
> > 		struct v4l2_ctrl *mute;
> > 		...
> > 	};
> > 
> > 	foo->volume = v4l2_ctrl_new_std();
> > 	foo->mute = v4l2_ctrl_new_std();
> > 	v4l2_ctrl_cluster(2, &foo->volume);
> > 
> > Same thing, but without the cumbersome array indices.
> 
> That looks *very* dangerous. People will not get it (I haven't) and all kind 
> of bad things will happen, like adding a field between two struct v4l2_ctrl 
> pointers. This part of the API needs to be reworked, if you require an array 
> then an array must be passed to the function.

I realized the same: I need to write this as an array. It's annoying since it
requires a lot of macros for the array indices.

An alternative might be to move the pointers into a struct:

	struct foo {
		/* volume/mute cluster */
		struct cluster {
			struct v4l2_ctrl *volume;
			struct v4l2_ctrl *mute;
		};
		...
 	};

Better, but I fear that it is not enough. I hate having to do

	struct foo {
		/* volume/mute cluster */
		#define FOO_VOL 0
		#define FOO_MUTE 1
		struct v4l2_ctrl *vol_mute[2];
		...
 	};

And have to refer to controls using foo->vol_mute[FOO_MUTE]. It's a mouthful.

Hmm. Perhaps some static inline helpers like

static inline struct v4l2_ctrl *foo_volume(struct foo *foo)
{
	return foo->vol_mute[FOO_VOL];
}

> 
> [snip]
> 
> > > > +VIDIOC_LOG_STATUS Support
> > > > +=========================
> > > > +
> > > > +This ioctl allow you to dump the current status of a driver to the
> > > > kernel log.
> > > 
> > > This has nothing to do with the controls framework, but shouldn't that
> > > ioctl be restricted to root only ? It can potentially dump a lot of
> > > information to the kernel log, and thus system logs.
> > 
> > Personally I see no reason to change this.
> 
> You don't think it opens a door for unprivileged applications to flood the 
> kernel and system logs ?

There is a printk variant that prevents against flooding. The name escapes
me at the moment. But it is probably a good idea to use that instead of the
normal printk.

> 
> [snip]
> 
> > > > +Different Handlers for Different Video Nodes
> > > > +============================================
> > > > +
> > > > +Usually the bridge driver has just one control handler that is global
> > > > for +all video nodes. But you can also specify different control
> > > > handlers for +different video nodes. It's no problem if there are no
> > > > subdevs involved. +But if there are, then you need to block the
> > > > automatic merging of subdev +controls to the global control handler.
> > > > You do that by simply setting the +ctrl_handler field in struct
> > > > v4l2_device to NULL.
> > > > +
> > > > +After each subdev was added, you will then have to call
> > > > v4l2_ctrl_add_handler
> > > > +manually to add the subdev's control handler (sd->ctrl_handler) to the
> > > > desired
> > > > +bridge control handler.
> > > 
> > > Do you mean video device instead of bridge here ?
> > 
> > struct v4l2_device.
> 
> I don't get it then. If you want to use different handlers for different video 
> nodes, you need to add the subdev handler to the video node (video_device) 
> handler, not the subdev handler to the v4l2_device handle.

I'm sorry, you are completely right. I didn't read this carefully enough. It is
indeed video device instead of v4l2_device.

BTW: I'd love to do a search-and-replace for video_device to something like
v4l2_devnode. It's very confusing at the moment.
 
> > > I wouldn't mention "bridge" in here. I assume that by bridge you mean
> > > v4l2_device. Please use that name directly. The term "bridge" is only
> > > applicable to a subset of the v4l2_device use cases.
> > 
> > Good point.
> > 
> > > Can controls for a specific subdev be reported through more than one
> > > video device node, but not all of them ?
> > 
> > Yes. It will be a bit fiddly to set up, but that's to be expected if you
> > want to do things like that.
> 
> I was just wondering if it was possible, I have no use case in mind. I wonder 
> if we should even allow that...
> 
> [snip]
> 
> > > > +Inheriting Controls
> > > > +===================
> > > > +
> > > > +When one control handler is added to another using
> > > > v4l2_ctrl_add_handler, then
> > > > +by default all controls from one are merged to the other. But a subdev
> > > > might
> > > > +have low-level controls that make sense for some advanced embedded
> > > > system, but
> > > > +not when it is used in consumer-level hardware. In that case you want
> > > > to keep
> > > > +those low-level controls local to the subdev. You can do this by
> > > > simply +setting the 'is_private' flag of the control to 1:
> > > > +
> > > > +	ctrl = v4l2_ctrl_new_custom(&sd->hdl, &sd_ctrl_ops, ...);
> > > > +	if (ctrl)
> > > > +		ctrl->is_private = 1;
> > > 
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

It's an internal API, not a public one. And I think it is important not to
implement something unless it is actually used.

> 
> > > I'm actually wondering if it wouldn't be better to pass a pointer to a
> > > structure with the required information (maybe the v4l2_control_info
> > > structure I mentioned earlier ?) to v4l2_ctrl_new_custom.
> > 
> > I thought about that, but 1) that means yet another structure and 2) I
> > dislike code like that because the definition is usually quite far from
> > the place were it is actually used.
> 
> Yes, it means yet another structure. On the other hand all those structures 
> can be nicely grouped in an array, and controls can then be added using a loop 
> instead of a bunch of function calls. I think it would be much cleaner, code 
> would be more readable and error handling would be easier.
> 
> > > > +These controls will now be skipped when v4l2_ctrl_add_handler is
> > > > called. +
> > > > +
> > > > +Strict Control Validation
> > > > +=========================
> > > > +
> > > > +By default when the application wants to change an integer control the
> > > > value
> > > > +passed to the framework will automatically be modified to map to the
> > > > provided
> > > > +minimum, maximum and step values of the control. If instead you just
> > > > want to
> > > > +validate the value and not modify it, then set the 'strict_validation'
> > > > flag of
> > > > +the control:
> > > > +
> > > > +	ctrl->strict_validation = 1;
> > > > +
> > > > +Now -ERANGE will be returned if the new value does not match the
> > > > control's +requirements.
> > > 
> > > Why do we need the two behaviours ? Wouldn't it be better to standardize
> > > on one of them ?
> > 
> > I may have fallen in the pitfall of featurism here. Just because it is easy
> > to implement, that doesn't mean that you should actually do it.
> > 
> > I think I'll remove strict_validation.
> 
> Thanks.
> 
> [snip]
> 
> > > > +Proposals for Extensions
> > > > +========================
> > > > +
> > > > +Some ideas for future extensions to the spec:
> > > > +
> > > > +1) Add a V4L2_CTRL_FLAG_HEX to have values shown as hexadecimal
> > > > instead of +decimal. Useful for e.g. video_mute_yuv.
> > > > +
> > > > +2) It is possible to mark in the controls array which controls have
> > > > been +successfully written and which failed by for example adding a
> > > > bit to the +control ID. Not sure if it is worth the effort, though.
> > > 
> > > I still feel a bit awkward about the interface. One particular point that
> > > might require attention is the split of the v4l2_ctrl structure into
> > > v4l2_control_info and v4l2_control_value structures (the names are not
> > > set into stone). I would also like to see if we can't pass pointers to
> > > v4l2_control_info (or similar) to the control creation functions instead
> > > of a plethora of arguments.
> > 
> > One of my original attempts was indeed to have two structs. But that made
> > the code only more complex. Having two structs only makes sense if the
> > 'static' part can be, well, static.
> 
> Indeed :-) Like I pointed out above there's some static information, but maybe 
> not enough of them to split them into another structure. On the other hand, 
> like I also pointed above, I think passing a structure, even if it's not big, 
> to the control creation functions would make driver code cleaner.
> 
> > But then you have UVC where that isn't static. So the code then has to
> > differentiate between these two cases and it quickly becomes a big mess.
> 
> There's static information in UVC. Look at uvc_ctrl.c, it starts with two big 
> arrays.
> 
> > Regarding the plethora of arguments: remember that 99% of all controls will
> > just use v4l2_ctrl_new_std(). And that ain't too bad. new_custom is indeed
> > a big one, but currently only used by cx2341x where it is wrapped inside a
> > much easier to digest function. I've tried to make the 90% of easy cases
> > easy, and for the remaining 10% you will indeed have to do more work.
> 
> If we pass structures to the functions, drivers could only fill the fields 
> they need and skip the other ones. For instance, a name field would be left 
> untouched by drivers that call v4l2_ctrl_new_std(). The ones that call 
> v4l2_ctrl_new_custom() would just need to fill the field in the 
> v4l2_ctrl_whatever array. Clean and easy :-)
> 
> This (whether we should use a structure to create new controls) is something 
> on which I'd like to hear other people's opinions (Sakari, I asked you to 
> review this RFC, so please answer :-)).

I have thought about this a bit more. I think it makes sense to have
v4l2_ctrl_new_custom use a struct as input. But for v4l2_ctrl_new_std it makes
no sense IMHO. This function is already very simple and straightforward.

I will make a more detailed proposal for this later.

Regards,

	Hans

> 
> > > I'll now have a look at the code. As there are already quite a few
> > > comments on the documentation I won't perform a very in-depth code
> > > review though, I'll save that for later after we agree on the spec :-)
> > 
> > Thanks for the review!
> > 
> > This was very useful.
> 
> You're welcome. I might bother you with other issues later if I catch new one 
> :-)
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
