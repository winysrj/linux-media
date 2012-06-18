Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4021 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2FRMtA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 08:49:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv1 PATCH 29/32] v4l2-dev.c: also add debug support for the fops.
Date: Mon, 18 Jun 2012 14:48:53 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <201206181340.24860.hverkuil@xs4all.nl> <2461283.FaTdpDH5hz@avalon>
In-Reply-To: <2461283.FaTdpDH5hz@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206181448.53989.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 18 2012 14:19:51 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 18 June 2012 13:40:24 Hans Verkuil wrote:
> > On Mon June 18 2012 12:01:47 Laurent Pinchart wrote:
> > > On Sunday 10 June 2012 12:25:51 Hans Verkuil wrote:
> > > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > > 
> > > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > > ---
> > > > 
> > > >  drivers/media/video/v4l2-dev.c |   41 ++++++++++++++++++++++-----------
> > > >  1 file changed, 29 insertions(+), 12 deletions(-)
> > > > 
> > > > diff --git a/drivers/media/video/v4l2-dev.c
> > > > b/drivers/media/video/v4l2-dev.c index 5c0bb18..54f387d 100644
> > > > --- a/drivers/media/video/v4l2-dev.c
> > > > +++ b/drivers/media/video/v4l2-dev.c
> > > > @@ -305,6 +305,9 @@ static ssize_t v4l2_read(struct file *filp, char
> > > > __user
> > > > *buf, ret = vdev->fops->read(filp, buf, sz, off);
> > > > 
> > > >  	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
> > > >  	
> > > >  		mutex_unlock(vdev->lock);
> > > > 
> > > > +	if (vdev->debug)
> > > 
> > > As vdev->debug is a bitmask, shouldn't we add an fops debug bit ?
> > 
> > I actually want to move away from the bitmask idea. I've never really liked
> > it here.
> 
> Would using dev_dbg with dynamic printk instead of creating our own logging 
> system be an option ?

I don't think so. There are lots of printk message you'd all have to enable.
You just want to have a standard method of debugging which ioctls are called
that anyone can use and that's consistent for all v4l drivers.

This does just that.

> 
> > > > +		pr_info("%s: read: %zd (%d)\n",
> > > > +			video_device_node_name(vdev), sz, ret);
> > > 
> > > Shouldn't we use KERN_DEBUG instead of KERN_INFO ? BTW, what about
> > > replacing the pr_* calls with dev_* calls ?
> > 
> > KERN_DEBUG vs KERN_INFO is actually a good question. My reasoning is that
> > you explicitly enable logging, and so you really want to see it in the log,
> > so we use KERN_INFO. With KERN_DEBUG you might have the situation where the
> > debug level of the logging is disabled, so the messages are ignored.
> > 
> > However, if people disagree with this, then I'm happy to move it back to
> > KERN_DEBUG.
> 
> On embedded systems KERN_INFO will be printed to the serial console. 
> Interleaving kernel messages with application output during capture result in 
> a mess.
> 
> If someone enables debugging I expect him/her to know enough to get the kernel 
> log debug messages.

OK, I'll change this back to KERN_DEBUG. Good argument.

Regards,

	Hans
