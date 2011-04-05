Return-path: <mchehab@pedra>
Received: from smtp2.sms.unimo.it ([155.185.44.12]:40627 "EHLO
	smtp2.sms.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1DEBEo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 21:04:44 -0400
Received: from mail-fx0-f51.google.com ([209.85.161.51]:40705)
	by smtp2.sms.unimo.it with esmtps (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.69)
	(envelope-from <76466@studenti.unimore.it>)
	id 1Q6uhC-0000L6-To
	for linux-media@vger.kernel.org; Tue, 05 Apr 2011 03:04:40 +0200
Received: by fxm5 with SMTP id 5so6078680fxm.24
        for <linux-media@vger.kernel.org>; Mon, 04 Apr 2011 18:04:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTin51MZy8gUFJLf5cSXTPDQNJDxiAJkC=jX=f8T0@mail.gmail.com>
References: <AANLkTinVP6CePBY6g9Dn2aKXM0ovwmpqMd5G4ucz44EH@mail.gmail.com>
	<Pine.LNX.4.64.1103292357270.13285@axis700.grange>
	<AANLkTimhP_YoqKRKyPzRbM6gw5jXVNV2D3pveRqqH0W_@mail.gmail.com>
	<Pine.LNX.4.64.1103300947580.4695@axis700.grange>
	<AANLkTimN_LgfXYgH9jejakS38v-FdRQUnQ6qJJJCb1oe@mail.gmail.com>
	<AANLkTikx84JovevQ1YHrU79Hj1=jjSZ7FM9BtogiWOcc@mail.gmail.com>
	<Pine.LNX.4.64.1103310027490.15210@axis700.grange>
	<AANLkTin51MZy8gUFJLf5cSXTPDQNJDxiAJkC=jX=f8T0@mail.gmail.com>
Date: Mon, 4 Apr 2011 20:04:38 -0500
Message-ID: <BANLkTik7jm=zbifmdi3G3huG_Uw4fHWpGA@mail.gmail.com>
Subject: Re: soc_camera dynamically cropping and scaling
From: Paolo Santinelli <paolo.santinelli@unimore.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

I have tried to implement the changes you suggested me in order to get
the new live cropping capabilities. I am able to successfully compile
the patched driver even though I still have problems  when an
application program tries to do live cropping (calling run time the
same ."ioctl VIDIOC_S_CROP" but with different cropping parameters).

This is the run time error I get when  I call the "ioctl
VIDIOC_S_CROP" in order to change live the  cropping area:

ov9655 0-0030: Scaled for 320x240 (320x240) : 0x0
ov9655 0-0030: Adjusted for 320x240 : hstart 240, hstop 560 = 320,
vstart 11, vstop 252 = 241
pxa27x-camera pxa27x-camera.0: Output after crop: 320x240

pxa27x-camera pxa27x-camera.0: DMA Bus Error IRQ!
pxa27x-camera pxa27x-camera.0: DMA Bus Error IRQ!
pxa27x-camera pxa27x-camera.0: DMA Bus Error IRQ!
select timeout



Here is what I have done:

1) I have used the kernel  linux-2.6.39-rc1;
2) I have carefully  added the patch at the  soc_camera.c and
soc_camera.h files as you indicated in your mail "[PATCH 1/2] V4L:
soc-camera: add a livecrop host operation";
4) I have changed pxa_camera.c file trying to put the patch as you
have indicated for the sh_mobile_ceu_camera.c, that is:

-I have changed the "pxa_camera_dev" struct  instead of
"sh_mobile_ceu_dev" adding the elements "struct completion complete"
and "unsigned int frozen:1;"

-I have added the .set_livecrop() method. Inside this method I  have
replaced the  prefix "sh_mobile_ceu_"  with "pxa_camera_". This method
calls the function "sh_mobile_ceu_capture()" but doesn't exist an
equivalent function named "pxa_camera_capture()", instead there are
the two functions "pxa_camera_start_capture()" and
"pxa_camera_stop_capture()". So I call "pxa_camera_start_capture()"
instead of "sh_mobile_ceu_capture()", but I am not sure this is the
right solution;

-I have changed the  "pxa_camera_start_capture()" function instead of
"sh_mobile_ceu_capture()" adding at the end "if (pcdev->frozen)
complete(&pcdev->complete);" even if I'm afraid that is not good.

-Of course I have  added the line ".set_livecrop	=
sh_mobile_ceu_set_livecrop," at the structure  "static struct
soc_camera_host_ops pxa_soc_camera_host_ops" instead of  "static
struct soc_camera_host_ops sh_mobile_ceu_host_ops".

-I didn't change anything else.

How to do the live cropping from the application program ? Do I have
to invoke the usual "ioctl VIDIOC_S_CROP" or I have to invoke the
".livecrop()" method adding a new "ioctl VIDIOC_S_LIVECROP" ?


Thank you very much.

Paolo



2011/3/30 Paolo Santinelli <paolo.santinelli@unimore.it>:
> OK!
>
> Thanks
>
> Paolo
>
> 2011/3/30 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>> On Wed, 30 Mar 2011, Paolo Santinelli wrote:
>>
>>> Hi Guennadi,
>>>
>>> Am I wrong or do  I have to add some functions ?
>>>
>>> I have hand applied the changes at the soc_camera.c and soc_camera.h
>>> files. At a fist glance to these files seems that I have to add the
>>> function:
>>>
>>>  .set_livecrop()
>>
>> Yes, I think, I mentioned this in my last mail, that's what my sh-ceu
>> example should have illustrated.
>>
>>>
>>> and probably even something more:
>>>
>>>   CC      drivers/media/video/soc_camera.o
>>> drivers/media/video/soc_camera.c: In function 'soc_camera_s_fmt_vid_cap':
>>> drivers/media/video/soc_camera.c:545: error: implicit declaration of
>>> function 'vb2_is_streaming'
>>> drivers/media/video/soc_camera.c:545: error: 'struct
>>> soc_camera_device' has no member named 'vb2_vidq'
>>> drivers/media/video/soc_camera.c: In function 'soc_camera_s_crop':
>>> drivers/media/video/soc_camera.c:799: error: 'struct
>>> soc_camera_device' has no member named 'vb2_vidq'
>>> make[3]: *** [drivers/media/video/soc_camera.o] Error 1
>>
>> You have to use current sources. 2.6.39-rc1 should be ok.
>>
>> Thanks
>> Guennadi
>>
>>>
>>> What about vb2_is_streaming and vb2_vidq ?
>>>
>>> Any tips regarding these functions ?
>>>
>>> Thanks
>>>
>>> Paolo
>>> 2011/3/30 Paolo Santinelli <paolo.santinelli@unimore.it>:
>>> > Hi Guennadi,
>>> >
>>> > thank you very much for the patch. I am going to apply it in order to
>>> > start toying with the new capability. I think it is a  useful
>>> > capability.
>>> >
>>> > I'll let you know.
>>> >
>>> > Again thank you.
>>> >
>>> > Paolo
>>> >
>>> > 2011/3/30 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>>> >> On Tue, 29 Mar 2011, Paolo Santinelli wrote:
>>> >>
>>> >>> Hi Guennadi,
>>> >>>
>>> >>> thank you for the quick answer.
>>> >>>
>>> >>> Here is what I mean with dynamic: I take "live" one frame at high
>>> >>> resolution, for example a picture at VGA or  QVGA resolution, then a
>>> >>> sequence of frames that depict a cropped area (200x200 or 100x100)
>>> >>> from the original full-resolution frame, and then a new full
>>> >>> resolution image (VGA or QVGA) and again the sequence of frames  that
>>> >>> depict a cropped area from the original full resolution, and so on.
>>> >>> That means takes one frame in 640x480 and  than takes some frames at
>>> >>> 100x100 (or 200x200) and so on.
>>> >>
>>> >> Ic, so, if you can live with a fixed output format and only change the
>>> >> input cropping rectangle, the patch set, that I've just sent could give
>>> >> you a hint, how this can be done. This would work if you're ok with first
>>> >> obtaining VGA images scaled down to, say, 160x120, and then take 160x120
>>> >> cropped frames unscaled. But I'm not sure, this is something, that would
>>> >> work for you. Otherwise, unless your sensor can upscale cropped images to
>>> >> VGA output size, you'll also want fast switching between different output
>>> >> sizes, which you'd have to wait for (or implement yourself;-))
>>> >>
>>> >> Thanks
>>> >> Guennadi
>>> >>
>>> >>>
>>> >>> The best would be have two different fixed-output image formats, the
>>> >>> WHOLE IMAGE format ex. 640x480 and the ROI format, 100x100. The ROI
>>> >>> pictures obtained cropping the a region of the whole image. The
>>> >>> cropping area could be even wider  than 100x100 and then scaled down
>>> >>> to the 100x100 ROI format.
>>> >>>
>>> >>> Probably it is more simple have a cropping area of the same dimension
>>> >>> of the ROI format, 100x100.
>>> >>>
>>> >>> In this way there is a reduction of the computation load of the CPU
>>> >>> (smaller images).
>>> >>>
>>> >>> Thank you very much!
>>> >>>
>>> >>> Paolo
>>> >>>
>>> >>> 2011/3/29 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>>> >>> > On Tue, 29 Mar 2011, Paolo Santinelli wrote:
>>> >>> >
>>> >>> >> Hi all,
>>> >>> >>
>>> >>> >> I am using a PXA270 board running linux 2.6.37 equipped with an ov9655
>>> >>> >> Image sensor. I am able to use the cropping and scaling capabilities
>>> >>> >> V4L2 driver.
>>> >>> >> The question is :
>>> >>> >>
>>> >>> >> Is it possible dynamically change the cropping and scaling values
>>> >>> >> without close and re-open  the camera every time ?
>>> >>> >>
>>> >>> >> Now I am using the streaming I/O memory mapping and to dynamically
>>> >>> >> change the cropping and scaling values I do :
>>> >>> >>
>>> >>> >> 1) stop capturing using VIDIOC_STREAMOFF;
>>> >>> >> 2) unmap all the buffers;
>>> >>> >> 3) close the device;
>>> >>> >> 4) open the device;
>>> >>> >> 5) init the device: VIDIOC_CROPCAP and VIDIOC_S_CROP in order to set
>>> >>> >> the cropping parameters. VIDIOC_G_FMT and VIDIOC_S_FMT in order to set
>>> >>> >> the target image width and height, (scaling).
>>> >>> >> 6) Mapping the buffers: VIDIOC_REQBUFS in order to request buffers and
>>> >>> >> mmap each buffer using VIDIOC_QUERYBUF and mmap():
>>> >>> >>
>>> >>> >> this procedure works but take 400 ms.
>>> >>> >>
>>> >>> >> If I omit steps 3) and 4)  (close and re-open the device) I get this errors:
>>> >>> >>
>>> >>> >> camera 0-0: S_CROP denied: queue initialised and sizes differ
>>> >>> >> camera 0-0: S_FMT denied: queue initialised
>>> >>> >> VIDIOC_S_FMT error 16, Device or resource busy
>>> >>> >> pxa27x-camera pxa27x-camera.0: PXA Camera driver detached from camera 0
>>> >>> >>
>>> >>> >> Do you have some Idea regarding why I have to close and reopen the
>>> >>> >> device and regarding a way to speed up these change?
>>> >>> >
>>> >>> > Yes, by chance I do;-) First of all you have to make it more precise -
>>> >>> > what exactly do you mean - dynamic (I call it "live") scaling or cropping?
>>> >>> > If you want to change output format, that will not be easy ATM, that will
>>> >>> > require the snapshot mode API, which is not yet even in an RFC state. If
>>> >>> > you only want to change the cropping and keep the output format (zoom),
>>> >>> > then I've just implemented that for sh_mobile_ceu_camera. This requires a
>>> >>> > couple of extensions to the soc-camera core, which I can post tomorrow.
>>> >>> > But in fact that is also a hack, because the proper way to implement this
>>> >>> > is to port soc-camera to the Media Controller framework and use the
>>> >>> > pad-level API. So, I am not sure, whether we want this in the mainline,
>>> >>> > but if already two of us need it now - before the transition to pad-level
>>> >>> > operations, maybe it would make sense to mainline this. If, however, you
>>> >>> > do have to change your output window, maybe you could tell us your
>>> >>> > use-case, so that we could consider, what's the best way to support that.
>>> >>> >
>>> >>> > Thanks
>>> >>> > Guennadi
>>> >>> > ---
>>> >>> > Guennadi Liakhovetski, Ph.D.
>>> >>> > Freelance Open-Source Software Developer
>>> >>> > http://www.open-technology.de/
>>> >>> >
>>> >>>
>>> >>>
>>> >>>
>>> >>> --
>>> >>> --------------------------------------------------
>>> >>> Paolo Santinelli
>>> >>> ImageLab Computer Vision and Pattern Recognition Lab
>>> >>> Dipartimento di Ingegneria dell'Informazione
>>> >>> Universita' di Modena e Reggio Emilia
>>> >>> via Vignolese 905/B, 41125, Modena, Italy
>>> >>>
>>> >>> Cell. +39 3472953357,  Office +39 059 2056270, Fax +39 059 2056129
>>> >>> email:  <mailto:paolo.santinelli@unimore.it> paolo.santinelli@unimore.it
>>> >>> URL:  <http://imagelab.ing.unimo.it/> http://imagelab.ing.unimo.it
>>> >>> --------------------------------------------------
>>> >>>
>>> >>
>>> >> ---
>>> >> Guennadi Liakhovetski, Ph.D.
>>> >> Freelance Open-Source Software Developer
>>> >> http://www.open-technology.de/
>>> >>
>>> >
>>> >
>>> >
>>> > --
>>> > --------------------------------------------------
>>> > Paolo Santinelli
>>> > ImageLab Computer Vision and Pattern Recognition Lab
>>> > Dipartimento di Ingegneria dell'Informazione
>>> > Universita' di Modena e Reggio Emilia
>>> > via Vignolese 905/B, 41125, Modena, Italy
>>> >
>>> > Cell. +39 3472953357,  Office +39 059 2056270, Fax +39 059 2056129
>>> > email:  <mailto:paolo.santinelli@unimore.it> paolo.santinelli@unimore.it
>>> > URL:  <http://imagelab.ing.unimo.it/> http://imagelab.ing.unimo.it
>>> > --------------------------------------------------
>>> >
>>>
>>>
>>>
>>> --
>>> --------------------------------------------------
>>> Paolo Santinelli
>>> ImageLab Computer Vision and Pattern Recognition Lab
>>> Dipartimento di Ingegneria dell'Informazione
>>> Universita' di Modena e Reggio Emilia
>>> via Vignolese 905/B, 41125, Modena, Italy
>>>
>>> Cell. +39 3472953357,  Office +39 059 2056270, Fax +39 059 2056129
>>> email:  <mailto:paolo.santinelli@unimore.it> paolo.santinelli@unimore.it
>>> URL:  <http://imagelab.ing.unimo.it/> http://imagelab.ing.unimo.it
>>> --------------------------------------------------
>>>
>>
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
>>
>
>
>
> --
> --------------------------------------------------
> Paolo Santinelli
> ImageLab Computer Vision and Pattern Recognition Lab
> Dipartimento di Ingegneria dell'Informazione
> Universita' di Modena e Reggio Emilia
> via Vignolese 905/B, 41125, Modena, Italy
>
> Cell. +39 3472953357,  Office +39 059 2056270, Fax +39 059 2056129
> email:  <mailto:paolo.santinelli@unimore.it> paolo.santinelli@unimore.it
> URL:  <http://imagelab.ing.unimo.it/> http://imagelab.ing.unimo.it
> --------------------------------------------------
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
