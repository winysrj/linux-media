Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:40085 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806Ab1BJAvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Feb 2011 19:51:10 -0500
Subject: Re: [PATCH/RFC 0/5] HDMI driver for Samsung S5PV310 platform
From: Andy Walls <awalls@md.metrocast.net>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	Maling list - DRI developers
	<dri-devel@lists.freedesktop.org>
In-Reply-To: <AANLkTimeYp=aJi40jH2Nwu25C_e1dJYxLXXXu-7zwZEp@mail.gmail.com>
References: <1297157427-14560-1-git-send-email-t.stanislaws@samsung.com>
	 <201102081047.17840.hansverk@cisco.com>
	 <AANLkTi=A=HiAvHojWP8HcFXpjXbZpq6UdHjOnWq-8jww@mail.gmail.com>
	 <1297205267.2423.24.camel@localhost>
	 <AANLkTimeYp=aJi40jH2Nwu25C_e1dJYxLXXXu-7zwZEp@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 19:51:05 -0500
Message-ID: <1297299065.2428.125.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-02-09 at 02:12 -0500, Alex Deucher wrote:
> On Tue, Feb 8, 2011 at 5:47 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > On Tue, 2011-02-08 at 10:28 -0500, Alex Deucher wrote:
> >> On Tue, Feb 8, 2011 at 4:47 AM, Hans Verkuil <hansverk@cisco.com> wrote:
> >> > Just two quick notes. I'll try to do a full review this weekend.
> >> >
> >> > On Tuesday, February 08, 2011 10:30:22 Tomasz Stanislawski wrote:
> >> >> ==============
> >> >>  Introduction
> >> >> ==============
> >> >>
> >> >> The purpose of this RFC is to discuss the driver for a TV output interface
> >> >> available in upcoming Samsung SoC. The HW is able to generate digital and
> >> >> analog signals. Current version of the driver supports only digital output.
> >> >>
> >> >> Internally the driver uses videobuf2 framework, and CMA memory allocator.
> >> > Not
> >> >> all of them are merged by now, but I decided to post the sources to start
> >> >> discussion driver's design.
> >
> >> >
> >> > Cisco (i.e. a few colleagues and myself) are working on this. We hope to post
> >> > an RFC by the end of this month. We also have a proposal for CEC support in
> >> > the pipeline.
> >>
> >> Any reason to not use the drm kms APIs for modesetting, display
> >> configuration, and hotplug support?  We already have the
> >> infrastructure in place for complex display configurations and
> >> generating events for hotplug interrupts.  It would seem to make more
> >> sense to me to fix any deficiencies in the KMS APIs than to spin a new
> >> API.  Things like CEC would be a natural fit since a lot of desktop
> >> GPUs support hdmi audio/3d/etc. and are already using kms.
> >>
> >> Alex
> >
> > I'll toss one out: lack of API documentation for driver or application
> > developers to use.
> >
> >
> > When I last looked at converting ivtvfb to use DRM, KMS, TTM, etc. (to
> > possibly get rid of reliance on the ivtv X video driver
> > http://dl.ivtvdriver.org/xf86-video-ivtv/ ), I found the documentation
> > was really sparse.
> >
> > DRM had the most documentation under Documentation/DocBook/drm.tmpl, but
> > the userland API wasn't fleshed out.  GEM was talked about a bit in
> > there as well, IIRC.
> >
> > TTM documentation was essentially non-existant.
> >
> > I can't find any KMS documentation either.
> >
> > I recall having to read much of the drm code, and having to look at the
> > radeon driver, just to tease out what the DRM ioctls needed to do.
> >
> > Am I missing a Documentation source for the APIs?
> >
> 
> Documentation is somewhat sparse compared to some other APIs.  Mostly
> inline kerneldoc comments in the core functions.  It would be nice to
> improve things.   The modesetting API is very similar to the xrandr
> API in the xserver.
> 
> At the moment a device specific surface manager (Xorg ddx, or some
> other userspace lib) is required to use kms due to device specific
> requirements with respect to memory management and alignment for
> acceleration.  The kms modesetting ioctls are common across all kms
> drm drivers, but the memory management ioctls are device specific.
> GEM itself is an Intel-specific memory manager, although radeon uses
> similar ioctls.  TTM is used internally by radeon, nouveau, and svga
> for managing memory gpu accessible memory pools.  Drivers are free to
> use whatever memory manager they want; an existing one shared with a
> v4l or platform driver, TTM, or something new.
>   There is no generic
> userspace kms driver/lib although Dave and others have done some work
> to support that, but it's really hard to make a generic interface
> flexible enough to handle all the strange acceleration requirements of
> GPUs.

All of the above unfortunately says to me that the KMS API has a fairly
tightly coupled set of userspace components, because userspace
applications need have details about the specific underlying hardware
embeeded in the application to effectively use the API.

If so, that's not really conducive to getting application developers to
write applications to the API, since applications will get tied to
specific sets of hardware.

Lack of documentation on the API for userpace application writers to use
exacerbates that issue, as there are no clearly stated guarantees on

	device node conventions
	ioctl's
		arguments and bounds on the arguments
		expected error return values
		behavior on error return and meaning of error return
		which are mandatory, which are optional
		how to perform "atomic" transactions
	Behavior of other fops:
		Are multiple opens allowed or not?
		Is llseek() meaningful?
		Is poll() meaningful?
		Does final close() deallocate all memory objects?
	sysfs nodes
		location
		expected names
		data formats
	how compliant or not any one driver is with the KMS APIcontrol
	where drivers are permitted to behave differently and where they are not
	What include files do user space applications need to include


What device nodes should be opened?
$ ls -al /dev/dri/*
crw-rw----+ 1 root video 226,  0 2011-02-09 17:27 /dev/dri/card0
crw-rw-rw-. 1 root video 226, 64 2011-02-09 17:26 /dev/dri/controlD64

What's the difference between them?
What's the renderDnn node that can show up?

Which of the below are mandatory for a KMS driver to support?
Which are optional?
Which were bad ideas and are deprecated?

#define DRM_IOCTL_MODE_GETRESOURCES     DRM_IOWR(0xA0, struct drm_mode_card_res)
#define DRM_IOCTL_MODE_GETCRTC          DRM_IOWR(0xA1, struct drm_mode_crtc)
#define DRM_IOCTL_MODE_SETCRTC          DRM_IOWR(0xA2, struct drm_mode_crtc)
#define DRM_IOCTL_MODE_CURSOR           DRM_IOWR(0xA3, struct drm_mode_cursor)
#define DRM_IOCTL_MODE_GETGAMMA         DRM_IOWR(0xA4, struct drm_mode_crtc_lut)
#define DRM_IOCTL_MODE_SETGAMMA         DRM_IOWR(0xA5, struct drm_mode_crtc_lut)
#define DRM_IOCTL_MODE_GETENCODER       DRM_IOWR(0xA6, struct drm_mode_get_encoder)
#define DRM_IOCTL_MODE_GETCONNECTOR     DRM_IOWR(0xA7, struct drm_mode_get_connector)
#define DRM_IOCTL_MODE_ATTACHMODE       DRM_IOWR(0xA8, struct drm_mode_mode_cmd)
#define DRM_IOCTL_MODE_DETACHMODE       DRM_IOWR(0xA9, struct drm_mode_mode_cmd)

#define DRM_IOCTL_MODE_GETPROPERTY      DRM_IOWR(0xAA, struct drm_mode_get_property)

	How does one iterate through multiple properties or all they all returned at once?
	The amount of data returned by drm_mode_get_property seems unbounded
		as the caller provides some pointers cast to __u64.
	How is the caller supposed to know how much space to reserve?
	Is the method consistent across all drivers?
	What is a property?  Any random (name-tag, value) pair the driver wants to provide?
	Are there any required properties consistent across all drivers?

#define DRM_IOCTL_MODE_SETPROPERTY      DRM_IOWR(0xAB, struct drm_mode_connector_set_property)
#define DRM_IOCTL_MODE_GETPROPBLOB      DRM_IOWR(0xAC, struct drm_mode_get_blob)
#define DRM_IOCTL_MODE_GETFB            DRM_IOWR(0xAD, struct drm_mode_fb_cmd)
#define DRM_IOCTL_MODE_ADDFB            DRM_IOWR(0xAE, struct drm_mode_fb_cmd)
#define DRM_IOCTL_MODE_RMFB             DRM_IOWR(0xAF, unsigned int)
#define DRM_IOCTL_MODE_PAGE_FLIP        DRM_IOWR(0xB0, struct drm_mode_crtc_page_flip)
#define DRM_IOCTL_MODE_DIRTYFB          DRM_IOWR(0xB1, struct drm_mode_fb_dirty_cmd)


If we ask application developers to "read the kernel source and figure
it out", who is really going to write any userland code to that API?  X
and Wayland developers.

What userspace application developer is going to crosswalk all the
drivers and figure out what is universally supported by all the kernel
drivers, versus what is intel, radeon, or nouveau driver specific?

What are the userspace applications currently using KMS: the Xserver,
Plymouth, and Wayland?  Any others on the horizon?



>   kms does however provide a legacy kernel fb interface.

That's another reason I had initally looked into it for replacing the
ivtv X-driver.  I figured moving ivtvfb over to the DRM/KMS FB
implementation interface could be a first easy step.


> While the documentation is not great, the modesetting API is solid and
> it would be nice to get more people involved and working on it (or at
> least looking at it)

Does solid mean it is not going to change?


>  rather than starting something equivalent from
> scratch or implementing a device specific modesetting API.

It is too difficult for me to say if it would be equivalent.

The one issue that often springs to mind is the security policy.  Video
capture and presentation devices may require different user permissions
than the Desktop, and console VTs.

If using a common API means both Console and Video devices now have to
have the same security policy; requires someone to get new, elevated
privileges; or now means joe-user can DoS the graphics memory system,
then it is not worth it just for that.

>   If you
> have any questions about it, please ask on dri-devel (CCed).

I've posed some of them both rhetorical and genuine.

Regards,
Andy

