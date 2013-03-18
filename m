Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2776 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3CRNxb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 09:53:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [REVIEW PATCH 5/5] v4l2-ioctl: simplify debug code.
Date: Mon, 18 Mar 2013 14:52:49 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1363343245-23531-1-git-send-email-hverkuil@xs4all.nl> <dfd667be0e2aa9ba06ab3193c0594de960788d7f.1363342714.git.hans.verkuil@cisco.com> <2675687.DN9O0xj4an@avalon>
In-Reply-To: <2675687.DN9O0xj4an@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303181452.49551.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri March 15 2013 13:25:21 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Friday 15 March 2013 11:27:25 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > The core debug code can now be simplified since all the write-only ioctls
> > are now const and will not modify the data they pass to the drivers.
> > 
> > So instead of logging write-only ioctls before the driver is called this can
> > now be done afterwards, which is cleaner when it comes to error reporting
> > as well.
> > 
> > This also fixes a logic error in the debugging code where there was one
> > 'else' too many.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-ioctl.c |   15 ++-------------
> >  1 file changed, 2 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> > b/drivers/media/v4l2-core/v4l2-ioctl.c index 2abd13a..b3fe148 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -2147,11 +2147,6 @@ static long __video_do_ioctl(struct file *file,
> >  	}
> > 
> >  	write_only = _IOC_DIR(cmd) == _IOC_WRITE;
> > -	if (write_only && debug > V4L2_DEBUG_IOCTL) {
> > -		v4l_printk_ioctl(video_device_node_name(vfd), cmd);
> > -		pr_cont(": ");
> > -		info->debug(arg, write_only);
> > -	}
> >  	if (info->flags & INFO_FL_STD) {
> >  		typedef int (*vidioc_op)(struct file *file, void *fh, void *p);
> >  		const void *p = vfd->ioctl_ops;
> > @@ -2170,16 +2165,10 @@ static long __video_do_ioctl(struct file *file,
> > 
> >  done:
> >  	if (debug) {
> > -		if (write_only && debug > V4L2_DEBUG_IOCTL) {
> > -			if (ret < 0)
> > -				printk(KERN_DEBUG "%s: error %ld\n",
> > -					video_device_node_name(vfd), ret);
> > -			return ret;
> > -		}
> >  		v4l_printk_ioctl(video_device_node_name(vfd), cmd);
> >  		if (ret < 0)
> > -			pr_cont(": error %ld\n", ret);
> > -		else if (debug == V4L2_DEBUG_IOCTL)
> > +			pr_cont(": error %ld", ret);
> > +		if (debug == V4L2_DEBUG_IOCTL)
> 
> Shouldn't this be >= V4L2_DEBUG_IOCTL ?

No. V4L2_DEBUG_IOCTL is the lowest debug level and should just print the ioctl
and return code. So the else parts are for higher debug levels where all args
are also printed.

Regards,

	Hans

> 
> >  			pr_cont("\n");
> >  		else if (_IOC_DIR(cmd) == _IOC_NONE)
> >  			info->debug(arg, write_only);
> 
> 
