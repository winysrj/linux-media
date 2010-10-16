Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:33026 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab0JPNpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 09:45:04 -0400
Message-ID: <4CB9AC58.5020301@infradead.org>
Date: Sat, 16 Oct 2010 10:44:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>, Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH] viafb camera controller driver
References: <20101010162313.5caa137f@bike.lwn.net>
In-Reply-To: <20101010162313.5caa137f@bike.lwn.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 10-10-2010 19:23, Jonathan Corbet escreveu:
> Howdy, all,
> 
> Well, that took a whole lot longer than I had hoped...but, attached, is a
> new version of the viafb camera driver patch, done against 2.6.36-rc7.
> I've tried to address most of Laurent's comments from back in June; in
> particular, I have:
> 
>  - Gotten rid of the static device structure
>  - Fixed some locking glitches
>  - Fixed a bit of device initialization silliness.
> 
> One thing I have *not* done is to push locking down into the ov7670
> driver.  That would be a good thing to do at some point, but playing with
> that driver was beyond the scope of what I was trying to do here.
> 
> This driver will still need some OLPC bits to work properly, but Daniel is
> working on that.  This version of the driver does work on XO-1.5 systems,
> modulo some 2.6.36 API changes.
> 
> Mauro, any chance of putting this in the queue for 2.6.37?  Yes, I know
> it's really late, my apologies for that.
> 
> Thanks,
> 
> jon
> +static const struct v4l2_file_operations viacam_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= viacam_open,
> +	.release	= viacam_release,
> +	.read		= viacam_read,
> +	.poll		= viacam_poll,
> +	.mmap		= viacam_mmap,
> +	.ioctl		= video_ioctl2,

Hmm... do you need BKL? Otherwise, you should be using, instead, .unlocked_ioctl.

Btw, the driver build is broken:

drivers/media/video/via-camera.c: In function ‘viacam_configure_sensor’:
drivers/media/video/via-camera.c:228: error: ‘const struct v4l2_subdev_video_ops’ has no member named ‘s_fmt’
drivers/media/video/via-camera.c:228: error: ‘const struct v4l2_subdev_video_ops’ has no member named ‘s_fmt’
drivers/media/video/via-camera.c: In function ‘viacam_open’:
drivers/media/video/via-camera.c:651: error: too few arguments to function ‘videobuf_queue_sg_init’
drivers/media/video/via-camera.c: In function ‘viacam_enum_fmt_vid_cap’:
drivers/media/video/via-camera.c:878: error: ‘const struct v4l2_subdev_video_ops’ has no member named ‘enum_fmt’
drivers/media/video/via-camera.c:878: error: ‘const struct v4l2_subdev_video_ops’ has no member named ‘enum_fmt’
drivers/media/video/via-camera.c: In function ‘viacam_try_fmt_vid_cap’:
drivers/media/video/via-camera.c:921: error: ‘const struct v4l2_subdev_video_ops’ has no member named ‘try_fmt’
drivers/media/video/via-camera.c:921: error: ‘const struct v4l2_subdev_video_ops’ has no member named ‘try_fmt’
drivers/media/video/via-camera.c: In function ‘viacam_s_fmt_vid_cap’:
drivers/media/video/via-camera.c:959: error: ‘const struct v4l2_subdev_video_ops’ has no member named ‘try_fmt’
drivers/media/video/via-camera.c:959: error: ‘const struct v4l2_subdev_video_ops’ has no member named ‘try_fmt’

The main responsible for this breakage is this commit: 383e6ad73194814cfc980c302e0173fac11f0ee0
You may take a look on those commits also:
	2e2ae382d956aa221c7b4fd897346c1b39f1699d
	8c26cfe8d5f05ec9f945ea825c7eb28f46d04348

all commits are at staging/v2.6.37 branch on my tree: 
	http://git.linuxtv.org/media_tree.git

They removed s_fmt/enum_fmt/try_fmt in favor of a different approach, as sometimes, the format between the
sensor and the bridge is not exactly the same as seen on userspace.

The fix for this one is trivial:
drivers/media/video/via-camera.c:651: error: too few arguments to function ‘videobuf_queue_sg_init’

Just add an extra NULL parameter to the function.

-

Hans,

You're not playing nice with the others by changing their drivers without their ack, and without even
c/c them. I'm sure that, if Jon was aware on the changes you did on cafe-ccic and ov7670, he would be
submitting this driver with the build issues addressed.

So, please help him to address this issue.

Mauro.

