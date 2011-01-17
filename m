Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:62401 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab1AQRnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 12:43:10 -0500
Date: Mon, 17 Jan 2011 18:43:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Qing Xu <qingx@marvell.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: soc-camera s_fmt question?
In-Reply-To: <7BAC95F5A7E67643AAFB2C31BEE662D014040BF23F@SC-VEXCH2.marvell.com>
Message-ID: <Pine.LNX.4.64.1101171840360.16051@axis700.grange>
References: <AANLkTimucMmO8Vb_y4xnhehQt+mamNMmXyY_qfrVOSo7@mail.gmail.com>
 <AANLkTinv64SL4HavFRK-s2Tr4CTGPH4iQ9bz7=40v1Hc@mail.gmail.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF23F@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 17 Jan 2011, Qing Xu wrote:

> Hi,
> 
> We are now nearly complete porting our camera driver to align with 
> soc-camera framework, however, we encounter a problem when it works with 
> our application during switch format from preview to still capture, 
> application's main calling sequence is as follow:
> 1) s_fmt /* preview @ YUV, VGA */
> 2) request buffer (buffer count = 6)
> 2) queue buffer
> 3) stream on
> 4) q-buf, dq-buf...
> 5) stream off
> 
> 6) s_fmt /* still capture @ jpeg, 2592x1944*/
> 7) request buffer (buffer count = 3)
> 8) same as 3)->5)...
> 
> The point is in soc_camera_s_fmt_vid_cap() {
>         if (icd->vb_vidq.bufs[0]) {
>                 dev_err(&icd->dev, "S_FMT denied: queue initialised\n");
>                 ret = -EBUSY;
>                 goto unlock;
>         }
> }
> We didn't find vb_vidq.bufs[0] be free, (it is freed in 
> videobuf_mmap_free(), and in __videobuf_mmap_setup, but no one calls 
> videobuf_mmap_free(), and in __videobuf_mmap_setup it is freed at first 
> and then allocated sequentially), so we always fail at calling s_fmt.
> My idea is to implement soc_camera_reqbufs(buffer count = 0), to provide 
> application opportunity to free this buffer node, refer to v4l2 spec, 
> http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-reqbufs.html
> "A count value of zero frees all buffers, after aborting or finishing 
> any DMA in progress, an implicit VIDIOC_STREAMOFF."

Currently buffers are freed in soc-camera upon close(). Yes, I know about 
that clause in the API spec, and I know, that it is unimplemented in 
soc-camera. Do you have a reason to prefer that over close()ing and 
re-open()ing the device?

Thanks
Guennadi

> 
> What do you think?
> 
> Any ideas will be appreciated!
> Thanks!
> Qing Xu
> 
> Email: qingx@marvell.com
> Application Processor Systems Engineering,
> Marvell Technology Group Ltd.
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
