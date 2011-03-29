Return-path: <mchehab@pedra>
Received: from smtp2.sms.unimo.it ([155.185.44.12]:34229 "EHLO
	smtp2.sms.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1C2Xoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 19:44:34 -0400
Received: from mail-fx0-f51.google.com ([209.85.161.51]:37224)
	by smtp2.sms.unimo.it with esmtps (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.69)
	(envelope-from <76466@studenti.unimore.it>)
	id 1Q4iaM-0006Ea-2U
	for linux-media@vger.kernel.org; Wed, 30 Mar 2011 01:44:30 +0200
Received: by fxm5 with SMTP id 5so887907fxm.24
        for <linux-media@vger.kernel.org>; Tue, 29 Mar 2011 16:44:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1103292357270.13285@axis700.grange>
References: <AANLkTinVP6CePBY6g9Dn2aKXM0ovwmpqMd5G4ucz44EH@mail.gmail.com>
	<Pine.LNX.4.64.1103292357270.13285@axis700.grange>
Date: Tue, 29 Mar 2011 18:44:29 -0500
Message-ID: <AANLkTimhP_YoqKRKyPzRbM6gw5jXVNV2D3pveRqqH0W_@mail.gmail.com>
Subject: Re: soc_camera dynamically cropping and scaling
From: Paolo Santinelli <paolo.santinelli@unimore.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

thank you for the quick answer.

Here is what I mean with dynamic: I take "live" one frame at high
resolution, for example a picture at VGA or  QVGA resolution, then a
sequence of frames that depict a cropped area (200x200 or 100x100)
from the original full-resolution frame, and then a new full
resolution image (VGA or QVGA) and again the sequence of frames  that
depict a cropped area from the original full resolution, and so on.
That means takes one frame in 640x480 and  than takes some frames at
100x100 (or 200x200) and so on.

The best would be have two different fixed-output image formats, the
WHOLE IMAGE format ex. 640x480 and the ROI format, 100x100. The ROI
pictures obtained cropping the a region of the whole image. The
cropping area could be even wider  than 100x100 and then scaled down
to the 100x100 ROI format.

Probably it is more simple have a cropping area of the same dimension
of the ROI format, 100x100.

In this way there is a reduction of the computation load of the CPU
(smaller images).

Thank you very much!

Paolo

2011/3/29 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Tue, 29 Mar 2011, Paolo Santinelli wrote:
>
>> Hi all,
>>
>> I am using a PXA270 board running linux 2.6.37 equipped with an ov9655
>> Image sensor. I am able to use the cropping and scaling capabilities
>> V4L2 driver.
>> The question is :
>>
>> Is it possible dynamically change the cropping and scaling values
>> without close and re-open  the camera every time ?
>>
>> Now I am using the streaming I/O memory mapping and to dynamically
>> change the cropping and scaling values I do :
>>
>> 1) stop capturing using VIDIOC_STREAMOFF;
>> 2) unmap all the buffers;
>> 3) close the device;
>> 4) open the device;
>> 5) init the device: VIDIOC_CROPCAP and VIDIOC_S_CROP in order to set
>> the cropping parameters. VIDIOC_G_FMT and VIDIOC_S_FMT in order to set
>> the target image width and height, (scaling).
>> 6) Mapping the buffers: VIDIOC_REQBUFS in order to request buffers and
>> mmap each buffer using VIDIOC_QUERYBUF and mmap():
>>
>> this procedure works but take 400 ms.
>>
>> If I omit steps 3) and 4)  (close and re-open the device) I get this errors:
>>
>> camera 0-0: S_CROP denied: queue initialised and sizes differ
>> camera 0-0: S_FMT denied: queue initialised
>> VIDIOC_S_FMT error 16, Device or resource busy
>> pxa27x-camera pxa27x-camera.0: PXA Camera driver detached from camera 0
>>
>> Do you have some Idea regarding why I have to close and reopen the
>> device and regarding a way to speed up these change?
>
> Yes, by chance I do;-) First of all you have to make it more precise -
> what exactly do you mean - dynamic (I call it "live") scaling or cropping?
> If you want to change output format, that will not be easy ATM, that will
> require the snapshot mode API, which is not yet even in an RFC state. If
> you only want to change the cropping and keep the output format (zoom),
> then I've just implemented that for sh_mobile_ceu_camera. This requires a
> couple of extensions to the soc-camera core, which I can post tomorrow.
> But in fact that is also a hack, because the proper way to implement this
> is to port soc-camera to the Media Controller framework and use the
> pad-level API. So, I am not sure, whether we want this in the mainline,
> but if already two of us need it now - before the transition to pad-level
> operations, maybe it would make sense to mainline this. If, however, you
> do have to change your output window, maybe you could tell us your
> use-case, so that we could consider, what's the best way to support that.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>



-- 
--------------------------------------------------
Paolo Santinelli
ImageLab Computer Vision and Pattern Recognition Lab
Dipartimento di Ingegneria dell'Informazione
Universita' di Modena e Reggio Emilia
via Vignolese 905/B, 41125, Modena, Italy

Cell. +39 3472953357,  Office +39 059 2056270, Fax +39 059 2056129
email:  <mailto:paolo.santinelli@unimore.it> paolo.santinelli@unimore.it
URL:  <http://imagelab.ing.unimo.it/> http://imagelab.ing.unimo.it
--------------------------------------------------
