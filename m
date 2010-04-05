Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3837 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0DESLO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Apr 2010 14:11:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: RFC: new V4L control framework
Date: Mon, 5 Apr 2010 20:11:13 +0200
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <201004041741.51869.hverkuil@xs4all.nl> <201004051125.20672.hverkuil@xs4all.nl> <4BBA04BB.5030600@redhat.com>
In-Reply-To: <4BBA04BB.5030600@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201004052011.13162.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 05 April 2010 17:41:47 Mauro Carvalho Chehab wrote:
> Hans Verkuil wrote:
> > On Monday 05 April 2010 04:58:02 Andy Walls wrote:
> >> On Sun, 2010-04-04 at 17:41 +0200, Hans Verkuil wrote:
> >>> Hi all,
> >>>
> >>> The support in drivers for the V4L2 control API is currently very chaotic.
> >>> Few if any drivers support the API correctly. Especially the support for the
> >>> new extended controls is very much hit and miss.
> >>>
> >>> Combine that with the requirements for the upcoming embedded devices that
> >>> will want to use controls much more actively and you end up with a big mess.
> >>>
> >>> I've wanted to fix this for a long time and last week I finally had the time.
> >>>
> >>> The new framework works like a charm and massively reduces the complexity in
> >>> drivers when it comes to control handling. And just as importantly, any driver
> >>> that uses it is fully compliant to the V4L spec. Something that application
> >>> writers will appreciate.
> >>>
> >>> I have converted the cx2341x.c module and tested it with ivtv since that is
> >>> by far the most complex example of control handling. The new code is much,
> >>> much cleaner.
> >>>
> >>> The documentation is available here:
> >>>
> >>> http://linuxtv.org/hg/~hverkuil/v4l-dvb-fw/raw-file/9b6708e8293c/linux/Documentation/video4linux/v4l2-controls.txt
> >> >From reading the Documentation.  Things look very much improved.
> >>
> >> However:
> >>
> >> "When a subdevice is registered with a bridge driver and the ctrl_handler
> >> fields of both v4l2_subdev and v4l2_device are set, then the controls of the
> >> subdev will become automatically available in the bridge driver as well. If
> >> the subdev driver contains controls that already exist in the bridge driver,
> >> then those will be skipped (so a bridge driver can always override a subdev
> >> control)."
> >>
> >> I think I have 2 cases where that is undesriable:
> >>
> >> 1. cx18 volume control: av_core subdev has a volume control (which the
> >> bridge driver currently reports as it's volume control) and the cs5435
> >> subdev has a volume control.
> >>
> >> I'd really need them *both* to be controllable by the user.  I'd also
> >> like them to appear as a single (bridge driver) volume control to the
> >> user - as that is what a user would expect.
> > 
> > So the bridge driver implements the volume control, but the bridge's s_ctrl
> > operation will in turn control the subdev's volume implementation, right?
> > That's no problem. I do need to add a few utility functions to make this
> > easy, though. I realized that I need that anyway when I worked on converting
> > bttv yesterday.
> 
> I think this is a common case for some audio controls: in general, bridge drivers
> have a set of volume adjustments, but, depending on how the audio is connected
> (I2S, analog input, analog directly wired to an output pin or to an  AC97 chip), 
> the bridge volume may or may not work, and you may need to map the sub-device
> volume control.
> 
> Em28xx is probably an interesting case, since it is designed to work with an
> AC97 audio chip, but it also supports I2S. Older designs were shipped with a
> msp34xx audio chip, while newer designs come with an Empia202 or with other
> AC97 chips. Depending on the specific hardware, the volume should be controlled
> into either one of the devices.

There are a few possibilities:

1) The bridge controls the volume. Easy, just make a bridge volume control and
that will hide any subdev volume controls you might have.

2) The subdev handles the volume. Easy again, just don't make a bridge volume
control. I am not sure whether I should make some code to remove a control.
Right now you can only add, not remove, which makes the framework a lot easier.
Some sort of removal scheme could be made, but it would be more like hiding
controls than actually removing it (as that would make pointer management so
much harder).

3) The bridge controls the volume, but needs to cooperate with the subdev's
volume control. Fairly easy: make a bridge volume control, get a pointer to
the subdev's volume control and let the volume control code of the bridge
use that pointer to manipulate the volume of the subdev. Note that the bridge
has to know how that control works. The min/max/step values for such a control
may not match those of the bridge.

4) The user needs to see both volume controls. While this is possible once
subdevs have their own device nodes, this is really meant for embedded systems
and not for use with consumer hardware. 

One option is to make a new set of control IDs to control the secondary audio
controls. Then all I need to do in the control framework is to make something
like:

v4l2_ctrl_add_ctrl_remap(struct v4l2_ctrl_handler *hdl,
			 struct v4l2_ctrl_info *cinfo,
			 u32 new_id);

However, that requires new control IDs (and who knows for what other controls
we need to do this as well in the future) and a lot of manual work in the
driver. Also, they won't be visible in applications unless those applications
are recompiled with the new V4L2_CID_LASTP1 value (or unless they use the new
FLAG_NEXT_CTRL).

Another option would be to set aside a range of IDs at the end of each control
class that could be used as a 'remap' area.

For example: the IDs for user class controls go from 0x980000-0x98ffff. Of
which anything >= 0x981000 is a private control (i.e. specific to a driver).
We could set aside 0x98f000-0x98ffff for remapped controls.

So if you want to make a subdev's volume control available as a secondary
control you can do something like this:

v4l2_ctrl_add_ctrl_remap(struct v4l2_ctrl_handler *hdl,
			 struct v4l2_ctrl_info *cinfo,
			 const char *fmt);

The framework will pick a new ID from the remap range and add this control
with the name created using snprintf(fmt, sz, cinfo->name). Since this control
is remapped as a private control it will be seen by old applications as well
since they just iterate from V4L2_CID_PRIVATE_BASE, and the framework handles
that transparently.

It is even possible to do this for all controls from a subdev, e.g.:

v4l2_ctrl_add_handler_remap(struct v4l2_ctrl_handler *hdl,
			    struct v4l2_ctrl_handler *add,
			    const char *fmt);

Every control in 'add' that already exists in 'hdl' would then be remapped
and a new name is generated.

> > Of course, once we can create device nodes for sub-devices, then the controls
> > of the cs5435 will show up there as well so the user can have direct access
> > to that volume control. But that's not really for applications, though.
> 
> I don't think  that a "technical" volume control  per subdevice would make sense,
>  except on a very few cases, where you might need to deal with more than one volume
> control, to avoid distortions. On most cases, you need to use just one of
> the controls.

I agree.

> >> 2. ivtv volume control for an AverTV M113 card.  The CX2584x chip is
> >> normally the volume control.  However, due to some poor baseband audio
> >> noise performance on this card, it is advantagous to adjust the volume
> >> control on the WM8739 subdev that feeds I2S audio into the CX2584x chip.
> >> Here, I would like a secondary volume control, not an override of the
> >> primary.
> >>
> >> (Here's my old hack:
> >> 	http://linuxtv.org/hg/~awalls/ivtv-avertv-m113/rev/c8f2378a3119 )
> >>
> >>
> >> Maybe there's a way to use the control clusters to handle some of this.
> >> I'm a bit too tired to figure it all out at the moment.
> > 
> > Interesting use case. I have several ideas, but I need some time to think
> > about it a bit more. Basically you want to be able to merge-and-remap
> > controls. Or perhaps even allow some sort of control hierarchy.
> 
> I'd say that the bridge driver should be able to disable the visibility of
> a control from userspace, while keeping being able of accessing it for its
> own control implementations.

Sure, that's already possible since that is true for 95% of all use cases.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
