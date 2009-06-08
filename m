Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55148 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751264AbZFHRww (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2009 13:52:52 -0400
Date: Mon, 8 Jun 2009 19:53:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc-camera: Why are exposure and gain handled via special cases?
In-Reply-To: <4A2D3CFF.9010303@cam.ac.uk>
Message-ID: <Pine.LNX.4.64.0906081946430.4396@axis700.grange>
References: <4A2D3CFF.9010303@cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Jun 2009, Jonathan Cameron wrote:

> Hi All,
> 
> Whilst working on merging the various ov7670 drivers posted
> recently, I came across the following in soc-camera:
> 
> static int soc_camera_g_ctrl(struct file *file, void *priv,
> 			     struct v4l2_control *ctrl)
> {
> 	struct soc_camera_file *icf = file->private_data;
> 	struct soc_camera_device *icd = icf->icd;
> 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> 
> 	WARN_ON(priv != file->private_data);
> 
> 	switch (ctrl->id) {
> 	case V4L2_CID_GAIN:
> 		if (icd->gain == (unsigned short)~0)
> 			return -EINVAL;
> 		ctrl->value = icd->gain;
> 		return 0;
> 	case V4L2_CID_EXPOSURE:
> 		if (icd->exposure == (unsigned short)~0)
> 			return -EINVAL;
> 		ctrl->value = icd->exposure;
> 		return 0;
> 	}
> 
> 	return v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, g_ctrl, ctrl);
> }
> 
> Why are these two cases and only these two handled by soc-camera rather than being passed
> on to the drivers?

In the case of statically configured gain and exposure it is the easiest 
to cache the last configured value and just return it when requested. At 
the time I wrote that code I wasn't sure what to return if autoexposure or 
autogain were configured. In the beginning these two controls actually 
also were implemented individually, but their implementation was 
identical, so, I united them. If this is becomming a problem now, we can 
revert it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
