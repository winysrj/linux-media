Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56531 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab1IRAFZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 20:05:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: hvaibhav@ti.com
Subject: Re: [PATCH] omap_vout: Add poll() support
Date: Sun, 18 Sep 2011 02:05:27 +0200
Cc: linux-media@vger.kernel.org
References: <1314181669-10263-1-git-send-email-laurent.pinchart@ideasonboard.com> <201108311424.53122.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108311424.53122.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109180205.28008.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 31 August 2011 14:24:52 Laurent Pinchart wrote:
> Hi Vaibhav,
> 
> Any opinion on this patch ?

Ping ?

> On Wednesday 24 August 2011 12:27:49 Laurent Pinchart wrote:
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/omap/omap_vout.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap/omap_vout.c
> > b/drivers/media/video/omap/omap_vout.c index a1f3c0f..cfc1705 100644
> > --- a/drivers/media/video/omap/omap_vout.c
> > +++ b/drivers/media/video/omap/omap_vout.c
> > @@ -1184,6 +1184,15 @@ static void omap_vout_buffer_release(struct
> > videobuf_queue *q, /*
> > 
> >   *  File operations
> >   */
> > 
> > +static unsigned int omap_vout_poll(struct file *file,
> > +				   struct poll_table_struct *wait)
> > +{
> > +	struct omap_vout_device *vout = file->private_data;
> > +	struct videobuf_queue *q = &vout->vbq;
> > +
> > +	return videobuf_poll_stream(file, q, wait);
> > +}
> > +
> > 
> >  static void omap_vout_vm_open(struct vm_area_struct *vma)
> >  {
> >  
> >  	struct omap_vout_device *vout = vma->vm_private_data;
> > 
> > @@ -2175,6 +2184,7 @@ static const struct v4l2_ioctl_ops vout_ioctl_ops =
> > {
> > 
> >  static const struct v4l2_file_operations omap_vout_fops = {
> >  
> >  	.owner 		= THIS_MODULE,
> > 
> > +	.poll		= omap_vout_poll,
> > 
> >  	.unlocked_ioctl	= video_ioctl2,
> >  	.mmap 		= omap_vout_mmap,
> >  	.open 		= omap_vout_open,

-- 
Regards,

Laurent Pinchart
