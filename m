Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:56139 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab1C2WEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 18:04:05 -0400
Date: Wed, 30 Mar 2011 00:04:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paolo Santinelli <paolo.santinelli@unimore.it>
cc: linux-media@vger.kernel.org
Subject: Re: soc_camera dynamically cropping and scaling
In-Reply-To: <AANLkTinVP6CePBY6g9Dn2aKXM0ovwmpqMd5G4ucz44EH@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1103292357270.13285@axis700.grange>
References: <AANLkTinVP6CePBY6g9Dn2aKXM0ovwmpqMd5G4ucz44EH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 29 Mar 2011, Paolo Santinelli wrote:

> Hi all,
> 
> I am using a PXA270 board running linux 2.6.37 equipped with an ov9655
> Image sensor. I am able to use the cropping and scaling capabilities
> V4L2 driver.
> The question is :
> 
> Is it possible dynamically change the cropping and scaling values
> without close and re-open  the camera every time ?
> 
> Now I am using the streaming I/O memory mapping and to dynamically
> change the cropping and scaling values I do :
> 
> 1) stop capturing using VIDIOC_STREAMOFF;
> 2) unmap all the buffers;
> 3) close the device;
> 4) open the device;
> 5) init the device: VIDIOC_CROPCAP and VIDIOC_S_CROP in order to set
> the cropping parameters. VIDIOC_G_FMT and VIDIOC_S_FMT in order to set
> the target image width and height, (scaling).
> 6) Mapping the buffers: VIDIOC_REQBUFS in order to request buffers and
> mmap each buffer using VIDIOC_QUERYBUF and mmap():
> 
> this procedure works but take 400 ms.
> 
> If I omit steps 3) and 4)  (close and re-open the device) I get this errors:
> 
> camera 0-0: S_CROP denied: queue initialised and sizes differ
> camera 0-0: S_FMT denied: queue initialised
> VIDIOC_S_FMT error 16, Device or resource busy
> pxa27x-camera pxa27x-camera.0: PXA Camera driver detached from camera 0
> 
> Do you have some Idea regarding why I have to close and reopen the
> device and regarding a way to speed up these change?

Yes, by chance I do;-) First of all you have to make it more precise - 
what exactly do you mean - dynamic (I call it "live") scaling or cropping? 
If you want to change output format, that will not be easy ATM, that will 
require the snapshot mode API, which is not yet even in an RFC state. If 
you only want to change the cropping and keep the output format (zoom), 
then I've just implemented that for sh_mobile_ceu_camera. This requires a 
couple of extensions to the soc-camera core, which I can post tomorrow. 
But in fact that is also a hack, because the proper way to implement this 
is to port soc-camera to the Media Controller framework and use the 
pad-level API. So, I am not sure, whether we want this in the mainline, 
but if already two of us need it now - before the transition to pad-level 
operations, maybe it would make sense to mainline this. If, however, you 
do have to change your output window, maybe you could tell us your 
use-case, so that we could consider, what's the best way to support that.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
