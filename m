Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36511 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab0GLLjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 07:39:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [RFC/PATCH v2 7/7] v4l: subdev: Generic ioctl support
Date: Mon, 12 Jul 2010 13:39:06 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278689512-30849-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278689512-30849-8-git-send-email-laurent.pinchart@ideasonboard.com> <001001cb21a5$56f41bb0$04dc5310$%osciak@samsung.com>
In-Reply-To: <001001cb21a5$56f41bb0$04dc5310$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007121339.07652.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

On Monday 12 July 2010 11:33:52 Pawel Osciak wrote:
> > On Friday 9 July 2010 17:32:00 Laurent Pinchart wrote:

[snip]

> >diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-
> >subdev.c
> >index 31bec67..ce47772 100644
> >--- a/drivers/media/video/v4l2-subdev.c
> >+++ b/drivers/media/video/v4l2-subdev.c
> >@@ -120,7 +120,7 @@ static long subdev_do_ioctl(struct file *file,
> >unsigned int cmd, void *arg)
> >
> > 		return v4l2_subdev_call(sd, core, unsubscribe_event, fh, arg);
> > 	
> > 	default:
> >-		return -ENOIOCTLCMD;
> >+		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
> >
> > 	}
> > 	
> > 	return 0;
> 
> Hi,
> one remark about this:
> 
> (@Laurent: this is what've been discussing on Saturday on IRC)
> 
> It looks to me that with this, a subdev will only be able to have either
> kernel or userspace-callable ioctls, not both. Note, that I don't mean one
> ioctl callable from both, but 2 ioctls, where one is kernel-callable and
> the other is userspace-callable. Technically that would work, but would
> become a security risk. Malicious userspace would be able to call the
> kernel-only ioctl.
> 
> So a driver has to be careful not to expose a node to the userspace if
> it has kernel-callable subdev ioctls.
> 
> As long as drivers obey that rule and we do not require both types of
> ioctls in one subdev, there is no problem.

I'll drop this patch for now, as Mauro would like it to go in with a driver 
that uses it. I'll resubmit it with the OMAP3 ISP driver.

-- 
Regards,

Laurent Pinchart
