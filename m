Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56180
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S970713AbdDZLNs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 07:13:48 -0400
Date: Wed, 26 Apr 2017 08:13:38 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [patch] propagating controls in libv4l2 was Re: support
 autofocus / autogain in libv4l2
Message-ID: <20170426081330.6ca10e42@vento.lan>
In-Reply-To: <20170426105300.GA857@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
        <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
        <20170414232332.63850d7b@vento.lan>
        <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
        <20170419105118.72b8e284@vento.lan>
        <20170424093059.GA20427@amd>
        <20170424103802.00d3b554@vento.lan>
        <20170424212914.GA20780@amd>
        <20170424224724.5bb52382@vento.lan>
        <20170426105300.GA857@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Em Wed, 26 Apr 2017 12:53:00 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
> 
> > > > IMO, the best place for autofocus is at libv4l2. Putting it on a
> > > > separate "video server" application looks really weird for me.    
> > > 
> > > Well... let me see. libraries are quite limited -- it is hard to open
> > > files, or use threads/have custom main loop. It may be useful to
> > > switch resolutions -- do autofocus/autogain at lower resolution, then
> > > switch to high one for taking picture. It would be good to have that
> > > in "system" code, but I'm not at all sure libv4l2 design will allow
> > > that.  
> > 
> > I don't see why it would be hard to open files or have threads inside
> > a library. There are several libraries that do that already, specially
> > the ones designed to be used on multimidia apps.  
> 
> Well, This is what the libv4l2 says:
> 
>    This file implements libv4l2, which offers v4l2_ prefixed versions
>    of
>       open/close/etc. The API is 100% the same as directly opening
>    /dev/videoX
>       using regular open/close/etc, the big difference is that format
>    conversion
>    
> but if I open additional files in v4l2_open(), API is no longer the
> same, as unix open() is defined to open just one file descriptor.
> 
> Now. There is autogain support in libv4lconvert, but it expects to use
> same fd for camera and for the gain... which does not work with
> subdevs.
> 
> Of course, opening subdevs by name like this is not really
> acceptable. But can you suggest a method that is?

There are two separate things here:

1) Autofoucs for a device that doesn't use subdev API
2) libv4l2 support for devices that require MC and subdev API

for (1), it should use the /dev/videoX device that was opened with
v4l2_open().

For (2), libv4l2 should be aware of MC and subdev APIs. Sakari
once tried to write a libv4l2 plugin for OMAP3, but never finished it.
A more recent trial were to add a libv4l2 plugin for Exynos.
Unfortunately, none of those code got merged. Last time I checked,
the Exynos plugin was almost ready to be merged, but Sakari asked
some changes on it. The developer that was working on it got job on
some other company. Last time I heard from him, he was still interested
on finishing his work, but in the need to setup a test environment
using his own devices.

So, currently, there's no code at all adding MC/subdev API
support merged at libv4l2.

-

IMHO, the right thing to do with regards to autofocus is to
implement it via a processing module, assuming that just one
video device is opened.

Then, add a N900 plugin to make libv4l2 aware of OMAP3 specifics.

After that, rework at the processing module to let it use a 
different file descriptor if such plugin is in usage.

-

The hole idea is that a libv4l2 client, running on a N900 device
would just open a fake /dev/video0. Internally, libv4l2 will
open whatever video nodes it needs to control the device, exporting
all hardware capabilities (video formats, controls, resolutions,
etc) as if it was a normal V4L2 camera, hiding all dirty details
about MC and subdev APIs from userspace application.

This way, a normal application, like xawtv, tvtime, camorama,
zbar, mplayer, vlc, ... will work without any changes.


> 
> Thanks,
> 								Pavel
> 
> commit 4cf9d10ead014c0db25452e4bb9cd144632407c3
> Author: Pavel <pavel@ucw.cz>
> Date:   Wed Apr 26 11:38:04 2017 +0200
> 
>     Add subdevices.
> 
> diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
> index 343db5e..a6bc48e 100644
> --- a/lib/libv4l2/libv4l2-priv.h
> +++ b/lib/libv4l2/libv4l2-priv.h
> @@ -26,6 +26,7 @@
>  #include "../libv4lconvert/libv4lsyscall-priv.h"
>  
>  #define V4L2_MAX_DEVICES 16
> +#define V4L2_MAX_SUBDEVS 8
>  /* Warning when making this larger the frame_queued and frame_mapped members of
>     the v4l2_dev_info struct can no longer be a bitfield, so the code needs to
>     be adjusted! */
> @@ -104,6 +105,7 @@ struct v4l2_dev_info {
>  	void *plugin_library;
>  	void *dev_ops_priv;
>  	const struct libv4l_dev_ops *dev_ops;
> +        int subdev_fds[V4L2_MAX_SUBDEVS];
>  };
>  
>  /* From v4l2-plugin.c */
> diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
> index 0ba0a88..edc9642 100644
> --- a/lib/libv4l2/libv4l2.c
> +++ b/lib/libv4l2/libv4l2.c
> @@ -1,3 +1,4 @@
> +/* -*- c-file-style: "linux" -*- */
>  /*
>  #             (C) 2008 Hans de Goede <hdegoede@redhat.com>
>  
> @@ -789,18 +790,25 @@ no_capture:
>  
>  	/* Note we always tell v4lconvert to optimize src fmt selection for
>  	   our default fps, the only exception is the app explicitly selecting
> -	   a fram erate using the S_PARM ioctl after a S_FMT */
> +	   a frame rate using the S_PARM ioctl after a S_FMT */
>  	if (devices[index].convert)
>  		v4lconvert_set_fps(devices[index].convert, V4L2_DEFAULT_FPS);
>  	v4l2_update_fps(index, &parm);
>  
> +	devices[index].subdev_fds[0] = SYS_OPEN("/dev/video_sensor", O_RDWR, 0);
> +	devices[index].subdev_fds[1] = SYS_OPEN("/dev/video_focus", O_RDWR, 0);
> +	devices[index].subdev_fds[2] = -1;
> +
> +	printf("Sensor: %d, focus: %d\n", devices[index].subdev_fds[0], 
> +	       devices[index].subdev_fds[1]);
> +
>  	V4L2_LOG("open: %d\n", fd);
>  
>  	return fd;
>  }
>  
>  /* Is this an fd for which we are emulating v4l1 ? */
> -static int v4l2_get_index(int fd)
> +int v4l2_get_index(int fd)
>  {
>  	int index;
>  
> 
> commit 1d6a9ce121f53e8f2e38549eed597a3c3dea5233
> Author: Pavel <pavel@ucw.cz>
> Date:   Wed Apr 26 12:34:04 2017 +0200
> 
>     Enable ioctl propagation.
> 
> diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
> index edc9642..6dab661 100644
> --- a/lib/libv4l2/libv4l2.c
> +++ b/lib/libv4l2/libv4l2.c
> @@ -1064,6 +1064,23 @@ static int v4l2_s_fmt(int index, struct v4l2_format *dest_fmt)
>  	return 0;
>  }
>  
> +static int v4l2_propagate_ioctl(int index, unsigned long request, void *arg)
> +{
> +	int i = 0;
> +	int result;
> +	while (1) {
> +		if (devices[index].subdev_fds[i] == -1)
> +			return -1;
> +		printf("g_ctrl failed, trying...\n");
> +		result = SYS_IOCTL(devices[index].subdev_fds[i], request, arg);
> +		printf("subdev %d result %d\n", i, result);
> +		if (result == 0)
> +			return 0;
> +		i++;
> +	}
> +	return -1;
> +}
> +
>  int v4l2_ioctl(int fd, unsigned long int request, ...)
>  {
>  	void *arg;
> @@ -1193,14 +1210,20 @@ no_capture_request:
>  	switch (request) {
>  	case VIDIOC_QUERYCTRL:
>  		result = v4lconvert_vidioc_queryctrl(devices[index].convert, arg);
> +		if (result == -1)
> +			result = v4l2_propagate_ioctl(index, request, arg);
>  		break;
>  
>  	case VIDIOC_G_CTRL:
>  		result = v4lconvert_vidioc_g_ctrl(devices[index].convert, arg);
> +		if (result == -1)
> +			result = v4l2_propagate_ioctl(index, request, arg);
>  		break;
>  
>  	case VIDIOC_S_CTRL:
>  		result = v4lconvert_vidioc_s_ctrl(devices[index].convert, arg);
> +		if (result == -1)
> +			result = v4l2_propagate_ioctl(index, request, arg);
>  		break;
>  
>  	case VIDIOC_G_EXT_CTRLS:
> 
> 



Thanks,
Mauro
