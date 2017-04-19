Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59644
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934533AbdDSNvc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 09:51:32 -0400
Date: Wed, 19 Apr 2017 10:51:18 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH v3 1/2] v4l: Add camera voice coil lens control class,
 current control
Message-ID: <20170419105118.72b8e284@vento.lan>
In-Reply-To: <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
        <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
        <20170414232332.63850d7b@vento.lan>
        <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 16 Apr 2017 12:12:10 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Fri, Apr 14, 2017 at 11:23:32PM -0300, Mauro Carvalho Chehab wrote:
> > Hi Sakari,
> > 
> > Em Tue, 14 Feb 2017 14:20:22 +0200
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >   
> > > Add a V4L2 control class for voice coil lens driver devices. These are
> > > simple devices that are used to move a camera lens from its resting
> > > position.  
> > 
> > From some past threads with this patch, you mentioned that:
> > 
> > "The FOCUS_ABSOLUTE control really is not a best control ID to
> >  control a voice coil driver's current."
> > 
> > However, I'm not seeing any explanation there at the thread, at
> > the patch description or at the documentation explaining why, and,
> > more important, when someone should use the focus control or the
> > camera voice coil control.  
> 
> It should be available in the thread.

The email thread is not registered at git logs nor at the API spec.

> Nevertheless, V4L2_CID_FOCUS_ABSOLUTE
> is documented as follows (emphasis mine):
> 
> 	This control sets the *focal point* of the camera to the specified
> 	position. The unit is undefined. Positive values set the focus
> 	closer to the camera, negative values towards infinity.
> 
> What you control in voice coil devices is current (in Ampères) and the
> current only has a relatively loose relation to the focal point.

The real problem I'm seeing here is that this control is already
used by voice coil motor (VCM). Several UVC-based Logitech cameras
come with VCM, like their QuickCam Pro-series webcams:

	https://secure.logitech.com/en-hk/articles/3231

The voice coil can be seen on this picture:
	https://photo.stackexchange.com/questions/48678/can-i-modify-a-logitech-c615-webcam-for-infinity-focus

> Additionally, increasing the current brings the focus closer, not farther.

That's just a hardware/software implementation detail. One could use
a voice coil to do just the reverse: without any current, it would
be getting a minimal focus distance; with max current it would
go to infinite, or may have some firmware inside the hardware that
would be inverting the signal.

I have here a C920 camera. This model has V4L2_CID_FOCUS_ABSOLUTE:

ioctl(3, VIDIOC_G_EXT_CTRLS, {ctrl_class=V4L2_CTRL_CLASS_CAMERA, count=1, controls=[{id=V4L2_CID_FOCUS_ABSOLUTE, size=0, value=0, value64=0}]}) = 0
write(1, "                 focus_absolute "..., 97                 focus_absolute (int)    : min=0 max=250 step=5 default=0 value=0 flags=inactive

On this model, V4L2_CID_FOCUS_ABSOLUTE == infinite.

On a quick check at uvc driver, it seems that the driver itself
doesn't invert the value before sending to the device. So, 
I guess that, either the camera firmware do something like:
	current = 250 - control_value
Or the VCM here is mounted, in hardware, to use less current
when focusing on a close object.

Looking on it on another side, this control was added on this changeset:

    commit f9bd5843658e18a7097fc7258c60fb840109eaa8
    Author: Brandon Philips <bphilips@suse.de>
    Date:   Tue Apr 22 14:42:02 2008 -0300

    V4L/DVB (7167): [v4l] Add camera class control definitions

Meant to be used on USB cameras. Until this changeset:

	commit bee3d51156113363e952674504833b4bc92cf15e
	Author: Pavel Machek <pavel@ucw.cz>
	Date:   Fri Aug 5 07:26:11 2016 -0300

	[media] ad5820: Add driver for auto-focus coil

The only driver that were using it were uvcvideo.

As far as I remember, Brandon was working together with a Logitech
developer, in order to add support for those Quickcam Pro cameras.
So, what this control actually sets is the VCM.

That's why I don't see any need to add another control to do the same
thing.

> I anticipate adding controls for ringing compensation in the future.
> Virtually all other devices except this one do ringing compensation and
> there's some control to be done for that.

Hmm... if the idea is to have a control that doesn't do ringing
compensation, then it should be clear at the control's descriptions
that:

- V4L2_CID_FOCUS_ABSOLUTE should be used if the VCM has ringing
  compensation;
- V4L2_CID_VOICE_COIL_CURRENT and V4L2_CID_VOICE_COIL_RING_COMPENSATION
  should be used otherwise.

Btw, if the rationale for this patch is to support devices without
ring compensation, so, both controls and their descriptions should
be added at the same time, together with a patchset that would be
using both.

> How about adding such an explanation added to the commit message?

It is not enough. Documentation should be clear that VCM devices
with ring compensation should use V4L2_CID_FOCUS_ABSOLUTE.

> 
> > 
> > Worse than that, patch 2/2 gives the false sensation that both
> > controls are equal.
> > 
> > Ok, I understand that they need to be identical on the existing
> > driver, in order to keep backward compatibility, but I'm afraid
> > that, without a clear distinction between them at the documentation,
> > people may just clone the existing code on other drivers.  
> 
> Indeed. The only reason that I'm not just replacing FOCUS_ABSOLUTE with the
> new contorol is backwards compatibility. But as Pavel pointed out, he's
> likely the sole user of this device that can only be found (as far as we
> commonly are aware) in the Nokia N900.
> 
> I'm happy to just switch the control, and Pavel mentioned he's happy with
> that. It would avoid copying the code in new drivers --- which I would most
> certainly point out anyway.
> 
> > 
> > So, please add more details to patch 1/2.  
> 
> Let me know if you're happy with the above.
> 



Thanks,
Mauro
