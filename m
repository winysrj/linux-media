Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:58011 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2KFNSv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2012 08:18:51 -0500
Date: Tue, 6 Nov 2012 14:18:45 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] OV5642: fix VIDIOC_S_GROP ioctl
Message-ID: <20121106141845.4641954a@wker>
In-Reply-To: <Pine.LNX.4.64.1211061243580.6451@axis700.grange>
References: <1352157290-13201-1-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1211061243580.6451@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 6 Nov 2012 12:45:51 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Tue, 6 Nov 2012, Anatolij Gustschin wrote:
> 
> > VIDIOC_S_GROP ioctl doesn't work, soc-camera driver reports:
> > 
> > soc-camera-pdrv soc-camera-pdrv.0: S_CROP denied: getting current crop failed
> > 
> > The issue is caused by checking for V4L2_BUF_TYPE_VIDEO_CAPTURE type
> > in driver's g_crop callback. This check should be in s_crop instead,
> > g_crop should just set the type field to V4L2_BUF_TYPE_VIDEO_CAPTURE
> > as other drivers do. Move the V4L2_BUF_TYPE_VIDEO_CAPTURE type check
> > to s_crop callback.
> 
> I'm not sure this is correct:
> 
> http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-crop.html
> 
> Or is the .g_crop() subdev operation using a different semantics? Where is 
> that documented?

I do not know if it is documented somewhere. But it seems natural to me
that a sensor driver sets the type field to V4L2_BUF_TYPE_VIDEO_CAPTURE
in its .g_crop(). A sensor is a capture device, not an output or overlay
device. And this ioctl is a query operation.

OTOH I'm fine with this type checking in .g_crop() and it can help
to discover bugs in user space apps. The VIDIOC_G_CROP documentation
states that the type field needs to be set to the respective buffer type
when querying, so the check in .g_crop() is perfectly valid. But then
I need following patch to fix the observed issue:

--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -902,6 +902,8 @@ static int soc_camera_s_crop(struct file *file, void *fh,
        dev_dbg(icd->pdev, "S_CROP(%ux%u@%u:%u)\n",
                rect->width, rect->height, rect->left, rect->top);
 
+       current_crop.type = a->type;
+
        /* If get_crop fails, we'll let host and / or client drivers decide */
        ret = ici->ops->get_crop(icd, &current_crop);
 
What do you think?

And the type field should be checked in .s_crop() anyway, I think.

Thanks,
Anatolij
