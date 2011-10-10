Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38295 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1JJIyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Oct 2011 04:54:46 -0400
Received: by ywb5 with SMTP id 5so5136304ywb.19
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2011 01:54:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAwP0s3NFvvUYd-0kwKLKXfYB4Zx1nXb0nd9+JM61JWtrVFfRg@mail.gmail.com>
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com>
	<CA+2YH7tv-VVnsoKe+C3es==hmKZw771YvVNL=_wwN=hz7JSKSQ@mail.gmail.com>
	<CAAwP0s0qUvCn+L+tx4NppZknNJ=6aMD5e8E+bLerTnBLLyGL8A@mail.gmail.com>
	<201110081751.38953.laurent.pinchart@ideasonboard.com>
	<CAAwP0s3K8D7-LyVUmbj1tMjU6UPESJPxWJu43P2THz4fDSF41A@mail.gmail.com>
	<CA+2YH7vat9iSAuZ4ztDvvo4Od+b4tCOsK6Y+grTE05YUZZEYPQ@mail.gmail.com>
	<CAAwP0s3NFvvUYd-0kwKLKXfYB4Zx1nXb0nd9+JM61JWtrVFfRg@mail.gmail.com>
Date: Mon, 10 Oct 2011 10:54:46 +0200
Message-ID: <CA+2YH7uFeHAmEpVqbd94qtCajb45pkr9YzeW+RDa5sf2bUG_wQ@mail.gmail.com>
Subject: Re: omap3-isp status
From: Enrico <ebutera@users.berlios.de>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 10, 2011 at 1:00 AM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
> On Mon, Oct 10, 2011 at 12:35 AM, Enrico <ebutera@users.berlios.de> wrote:
>> I made some tests and unfortunately there are some problems.
>>
>> Note: i made these tests picking some patches from omap3isp-yuv branch
>> and applying to igep 3.1.0rc9 kernel (more or less like mainline +
>> some bsp patches) so maybe i made some mistakes (the tvp5150 driver is
>> patched too), but due to the nature of the problems i don't think this
>> is the case.
>>
>> Javier patches v1: i can grab frames with yavta but i get only garbage.
>>
>> Javier patches v2: i cannot grab frames with yavta (it hangs). I see
>> only 2 interrupts on the isp, then stops.
>>
>> I compared Javier-v2 registers setup with Deepthy's patches and there
>> are some differences. Moreover i remember that in Deepthy patches vd1
>> interrupt was not used (and in fact i had the same yavta-hanging
>> problem before, and Deepthy patches solved it).
>>
>> I think Javier-v1 patches didn't hang the isp because they changed
>> vd0/vd1 logic too, so maybe there were only some wrong isp registers
>> but the logic was correct.
>>
>> Now i wonder if it could be easier/better to port Deepthy patches
>> first and then add Javier fixes...
>>
>> Enrico
>>
>
> Hi Enrico,
>
> Yes, you are right in interlaced mode the VD1 interrupt handler
> doesn't have to be executed. In v1 there is a conditional execution
> and that is why the ISP doesn't hang up.
>
> Could you please try changing this on ispccdc.c with v2 patches?
>
> diff --git a/drivers/media/video/omap3isp/ispccdc.c
> b/drivers/media/video/omap3isp/ispccdc.c
> index 9b40968..bfd3f46 100644
> --- a/drivers/media/video/omap3isp/ispccdc.c
> +++ b/drivers/media/video/omap3isp/ispccdc.c
> @@ -1658,7 +1658,8 @@ int omap3isp_ccdc_isr(struct isp_ccdc_device
> *ccdc, u32 events)
>        if (ccdc->state == ISP_PIPELINE_STREAM_STOPPED)
>                return 0;
>
> -       if (events & IRQ0STATUS_CCDC_VD1_IRQ)
> +       if ((events & IRQ0STATUS_CCDC_VD1_IRQ) &&
> +           !ccdc_input_is_fldmode(ccdc))
>                ccdc_vd1_isr(ccdc);
>
>        ccdc_lsc_isr(ccdc, events);
>
> With this change the ISP shouldn't hang but I don't know if you will
> get the right data.

I tried that but i only get this:

root@igep0020:~# yavta -c4 -f UYVY -s 720x625 -n 4 /dev/video2
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
Video format set: UYVY (59565955) 720x625 buffer size 900000
Video format: UYVY (59565955) 720x625 buffer size 900000
4 buffers requested.
length: 900000 offset: 0
Buffer 0 mapped at address 0x4027a000.
length: 900000 offset: 901120
Buffer 1 mapped at address 0x403de000.
length: 900000 offset: 1802240
Buffer 2 mapped at address 0x4059b000.
length: 900000 offset: 2703360
Buffer 3 mapped at address 0x40748000.
[  952.675170] omap3isp omap3isp: CCDC won't become idle!
[  952.695159] omap3isp omap3isp: CCDC won't become idle!
[  952.715179] omap3isp omap3isp: CCDC won't become idle!
[  952.735137] omap3isp omap3isp: CCDC won't become idle!

and it continues forever saying that.

I'm going to try to apply Deepthy patches on omap3isp-yuv and hope it will work.

Enrico
