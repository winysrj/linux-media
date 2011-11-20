Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58062 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab1KTXyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 18:54:04 -0500
Received: by ghbz2 with SMTP id z2so2219835ghb.19
        for <linux-media@vger.kernel.org>; Sun, 20 Nov 2011 15:54:04 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 20 Nov 2011 16:54:04 -0700
Message-ID: <CAAN7ACQFzNhswnDfsprHDk5C71GCXnbvnpkX+AsoQ9ejCFn6wQ@mail.gmail.com>
Subject: Re: mt9p031 based sensor and ack lockups. Ie CCDC won't become idle.
From: Andrew Tubbiolo <andrew.tubbiolo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All:

   I'm having fun with my new camera project that uses the mt9p031
camera. I'm getting nice raw stills, and that's great, but every 16 or
so images I take I get a troublesome error.

CCDC won't become idle!

The message is coming from...


static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)

in ...

linux-2.6.39.1/drivers/media/video/omap3isp/ispccdc.c

I printed out the return of the status of the registers on the CCDC
and found that the only bit set was the CCDC_BUSY register.

static int ccdc_sbl_busy(struct isp_ccdc_device *ccdc)
{
        struct isp_device *isp = to_isp_device(ccdc);

        return omap3isp_ccdc_busy(ccdc)
                | (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_0) &
                   ISPSBL_CCDC_WR_0_DATA_READY)
                | (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_1) &
                   ISPSBL_CCDC_WR_0_DATA_READY)
                | (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_2) &
                   ISPSBL_CCDC_WR_0_DATA_READY)
                | (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_3) &
                   ISPSBL_CCDC_WR_0_DATA_READY);
}


 I THINK I'm suffering from a data underflow, where the previous batch
of images did not complete, or something. Which is funny because I
almost always get a full data set if everything starts up with no
hiccup. I should add that I get this error when I start a exposure and
data ack. The error is immediate, not in the middle of an ack. In fact
the error is thrown during the yavta init sequence. During a
ioctl(STREAM_ON).

I tried to issue a isp flush to the flush bit as described on (fig
Table 12-88 ISP_CTRL) pg 1512 of the TI-OMAP manual. This froze the
whole system. I'm wondering if anyone else is running into a similar
or even the same problem and if they know of a solution, a fix, or a
workaround?

Thanks.
Andrew
