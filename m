Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53404 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab1IAOYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 10:24:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.berlios.de>
Subject: Re: Getting started with OMAP3 ISP
Date: Thu, 1 Sep 2011 16:24:55 +0200
Cc: linux-media@vger.kernel.org, Gary Thomas <gary@mlbassoc.com>,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
References: <4E56734A.3080001@mlbassoc.com> <CA+2YH7ttb-dUVHqKVA-Bazo0of0vJR7gdhPmz3VLE=TebS0oPQ@mail.gmail.com> <CA+2YH7voYvf9LK50rtWG39zGnMGiLQhK6qUcZ63TRWVBphmEhg@mail.gmail.com>
In-Reply-To: <CA+2YH7voYvf9LK50rtWG39zGnMGiLQhK6qUcZ63TRWVBphmEhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109011624.56512.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Thursday 01 September 2011 16:12:42 Enrico wrote:
> On Thu, Sep 1, 2011 at 12:24 PM, Enrico <ebutera@users.berlios.de> wrote:
> > On Thu, Sep 1, 2011 at 11:55 AM, Laurent Pinchart
> > 
> >> Does your tvp5150 generate progressive or interlaced images ?
> > 
> > In the driver it is setup to decode by default in bt656 mode, so
> > interlaced.
> > 
> > I've read on the omap trm that the isp can deinterlace it setting
> > properly SDOFST, i just noticed in the register dump this:
> > 
> > omap3isp omap3isp: ###CCDC SDOFST=0x00000000
> > 
> > and maybe this is related too:
> > 
> > omap3isp omap3isp: ###CCDC REC656IF=0x00000000
> > 
> > Moreover i just found this [1] old thread about the same problem, i'm
> > reading it now.
> > 
> > Enrico
> > 
> > [1]: http://www.spinics.net/lists/linux-media/msg28079.html
> 
> Still not working, and much more doubts :D
> 
> 1) In board code isp_parallel_platform_data i added the bt656 = 1
> setting and i see it gets applied, but reading code and omap trm i've
> found that you must set ISPCCDC_REC656IF_ECCFVH flag too.

That's not mandatory, but I suppose it wouldn't hurt.

> 2) ispccdc.c:ccdc_config_outlineoffset(..) seems broken to me.
> 
> It is used only once in ccdc_configure:
> ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
> 
> so the last two parameters are always set to 0, while they should be
> (conditionally) set with for ex. EVENODD, 1
> 
> Moreover the implementation has this (hope it will keep formatting...):
> 
> switch (oddeven) {
>         case EVENEVEN:
>                 isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
>                             (numlines & 0x7) <<
> ISPCCDC_SDOFST_LOFST0_SHIFT); break;
>         case ODDEVEN:
>                 isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
>                             (numlines & 0x7) <<
> ISPCCDC_SDOFST_LOFST1_SHIFT); break;
>         case EVENODD:
>                 isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
>                             (numlines & 0x7) <<
> ISPCCDC_SDOFST_LOFST2_SHIFT); break;
>         case ODDODD:
>                 isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
>                             (numlines & 0x7) <<
> ISPCCDC_SDOFST_LOFST3_SHIFT); break;
>         default:
>                 break;
>         }
> 
> But reading the omap trm (Figure 12-77) it seems to me that all the
> LOFSTX should be set.

The driver currently has no support for interlaced video. This code has never 
been properly tested.

> 3) Last but not least, i'm using V4L2_MBUS_FMT_UYVY8_1X16 format in
> tvp5150, but i'm not sure it is correct. What is the proper format for
> bt656? Maybe V4L2_MBUS_FMT_UYVY8_2X8?

You should use V4L2_MBUS_FMT_UYVY8_2X8, as video data is transmitted on a 8-
bit bus with two samples per pixel.

-- 
Regards,

Laurent Pinchart
