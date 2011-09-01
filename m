Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57640 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420Ab1IAOMq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 10:12:46 -0400
Received: by gya6 with SMTP id 6so1381683gya.19
        for <linux-media@vger.kernel.org>; Thu, 01 Sep 2011 07:12:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7ttb-dUVHqKVA-Bazo0of0vJR7gdhPmz3VLE=TebS0oPQ@mail.gmail.com>
References: <4E56734A.3080001@mlbassoc.com>
	<201108311833.24394.laurent.pinchart@ideasonboard.com>
	<CA+2YH7t9K6PFW-4YvLUx-BfteJ8ORujHppM+iesn4u2qP-Of=w@mail.gmail.com>
	<201109011155.44516.laurent.pinchart@ideasonboard.com>
	<CA+2YH7ttb-dUVHqKVA-Bazo0of0vJR7gdhPmz3VLE=TebS0oPQ@mail.gmail.com>
Date: Thu, 1 Sep 2011 16:12:42 +0200
Message-ID: <CA+2YH7voYvf9LK50rtWG39zGnMGiLQhK6qUcZ63TRWVBphmEhg@mail.gmail.com>
Subject: Re: Getting started with OMAP3 ISP
From: Enrico <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Gary Thomas <gary@mlbassoc.com>,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 1, 2011 at 12:24 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Thu, Sep 1, 2011 at 11:55 AM, Laurent Pinchart
>> Does your tvp5150 generate progressive or interlaced images ?
>
> In the driver it is setup to decode by default in bt656 mode, so interlaced.
>
> I've read on the omap trm that the isp can deinterlace it setting
> properly SDOFST, i just noticed in the register dump this:
>
> omap3isp omap3isp: ###CCDC SDOFST=0x00000000
>
> and maybe this is related too:
>
> omap3isp omap3isp: ###CCDC REC656IF=0x00000000
>
> Moreover i just found this [1] old thread about the same problem, i'm
> reading it now.
>
> Enrico
>
> [1]: http://www.spinics.net/lists/linux-media/msg28079.html

Still not working, and much more doubts :D

1) In board code isp_parallel_platform_data i added the bt656 = 1
setting and i see it gets applied, but reading code and omap trm i've
found that you must set ISPCCDC_REC656IF_ECCFVH flag too.

2) ispccdc.c:ccdc_config_outlineoffset(..) seems broken to me.

It is used only once in ccdc_configure:
ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);

so the last two parameters are always set to 0, while they should be
(conditionally) set with for ex. EVENODD, 1

Moreover the implementation has this (hope it will keep formatting...):

switch (oddeven) {
        case EVENEVEN:
                isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
                            (numlines & 0x7) << ISPCCDC_SDOFST_LOFST0_SHIFT);
                break;
        case ODDEVEN:
                isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
                            (numlines & 0x7) << ISPCCDC_SDOFST_LOFST1_SHIFT);
                break;
        case EVENODD:
                isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
                            (numlines & 0x7) << ISPCCDC_SDOFST_LOFST2_SHIFT);
                break;
        case ODDODD:
                isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
                            (numlines & 0x7) << ISPCCDC_SDOFST_LOFST3_SHIFT);
                break;
        default:
                break;
        }

But reading the omap trm (Figure 12-77) it seems to me that all the
LOFSTX should be set.

3) Last but not least, i'm using V4L2_MBUS_FMT_UYVY8_1X16 format in
tvp5150, but i'm not sure it is correct. What is the proper format for
bt656? Maybe V4L2_MBUS_FMT_UYVY8_2X8?

Thanks,

Enrico
