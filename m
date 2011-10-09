Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61095 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1JIXAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Oct 2011 19:00:40 -0400
Received: by gyg10 with SMTP id 10so4861383gyg.19
        for <linux-media@vger.kernel.org>; Sun, 09 Oct 2011 16:00:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7vat9iSAuZ4ztDvvo4Od+b4tCOsK6Y+grTE05YUZZEYPQ@mail.gmail.com>
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com>
 <CA+2YH7tv-VVnsoKe+C3es==hmKZw771YvVNL=_wwN=hz7JSKSQ@mail.gmail.com>
 <CAAwP0s0qUvCn+L+tx4NppZknNJ=6aMD5e8E+bLerTnBLLyGL8A@mail.gmail.com>
 <201110081751.38953.laurent.pinchart@ideasonboard.com> <CAAwP0s3K8D7-LyVUmbj1tMjU6UPESJPxWJu43P2THz4fDSF41A@mail.gmail.com>
 <CA+2YH7vat9iSAuZ4ztDvvo4Od+b4tCOsK6Y+grTE05YUZZEYPQ@mail.gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Mon, 10 Oct 2011 01:00:20 +0200
Message-ID: <CAAwP0s3NFvvUYd-0kwKLKXfYB4Zx1nXb0nd9+JM61JWtrVFfRg@mail.gmail.com>
Subject: Re: omap3-isp status
To: Enrico <ebutera@users.berlios.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 10, 2011 at 12:35 AM, Enrico <ebutera@users.berlios.de> wrote:
> On Sat, Oct 8, 2011 at 6:11 PM, Javier Martinez Canillas
> <martinez.javier@gmail.com> wrote:
>> Yes, I'll cook a patch today on top on your omap3isp-yuv and send for
>> review. I won't be able to test neither since I don't have proper
>> hardware at home. But at least you will get an idea of the approach we
>> are using to solve this and can point possible flaws.
>
> I made some tests and unfortunately there are some problems.
>
> Note: i made these tests picking some patches from omap3isp-yuv branch
> and applying to igep 3.1.0rc9 kernel (more or less like mainline +
> some bsp patches) so maybe i made some mistakes (the tvp5150 driver is
> patched too), but due to the nature of the problems i don't think this
> is the case.
>
> Javier patches v1: i can grab frames with yavta but i get only garbage.
>
> Javier patches v2: i cannot grab frames with yavta (it hangs). I see
> only 2 interrupts on the isp, then stops.
>
> I compared Javier-v2 registers setup with Deepthy's patches and there
> are some differences. Moreover i remember that in Deepthy patches vd1
> interrupt was not used (and in fact i had the same yavta-hanging
> problem before, and Deepthy patches solved it).
>
> I think Javier-v1 patches didn't hang the isp because they changed
> vd0/vd1 logic too, so maybe there were only some wrong isp registers
> but the logic was correct.
>
> Now i wonder if it could be easier/better to port Deepthy patches
> first and then add Javier fixes...
>
> Enrico
>

Hi Enrico,

Yes, you are right in interlaced mode the VD1 interrupt handler
doesn't have to be executed. In v1 there is a conditional execution
and that is why the ISP doesn't hang up.

Could you please try changing this on ispccdc.c with v2 patches?

diff --git a/drivers/media/video/omap3isp/ispccdc.c
b/drivers/media/video/omap3isp/ispccdc.c
index 9b40968..bfd3f46 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1658,7 +1658,8 @@ int omap3isp_ccdc_isr(struct isp_ccdc_device
*ccdc, u32 events)
        if (ccdc->state == ISP_PIPELINE_STREAM_STOPPED)
                return 0;

-       if (events & IRQ0STATUS_CCDC_VD1_IRQ)
+       if ((events & IRQ0STATUS_CCDC_VD1_IRQ) &&
+           !ccdc_input_is_fldmode(ccdc))
                ccdc_vd1_isr(ccdc);

        ccdc_lsc_isr(ccdc, events);

With this change the ISP shouldn't hang but I don't know if you will
get the right data.

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
