Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56212
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2999346AbdDZL0a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 07:26:30 -0400
Date: Wed, 26 Apr 2017 08:26:18 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [patch] propagating controls in libv4l2 was Re: support
 autofocus / autogain in libv4l2
Message-ID: <20170426082608.7dd52fbf@vento.lan>
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

Isn't it a short number?

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

No emacs comments, please.

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

Hardcoding names here is not a good idea. Ideally, it should open
the MC, using the newgen API, and parse the media graph.

The problem is that, even with newgen API, without the properties API
you likely won't be able to write a generic parser. So, we need a
plugin specific for OMAP3 (or at least some database that would teach
a generic plugin about OMAP3 specifics).

I guess that the approach that Jacek was taken were very close to what
a generic plugin would need:
	https://lwn.net/Articles/619449/

The last version of his patch set is here:
	https://patchwork.linuxtv.org/patch/37496/

I didn't review his patchset, but from what I saw, Sakari is the one
that found some issues on v7.1 patchset.

Sakari,

Could you shed us a light about why this patchset was not merged?

Are there anything really bad at the code, or just minor issues that
could be fixed later?

If it is the last case, perhaps we could merge the code, if this
would make easier for Pavel to work on a N9 solution using the
same approach.


Thanks,
Mauro
