Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.1.47]:25219 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab0KTLnY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 06:43:24 -0500
Date: Sat, 20 Nov 2010 13:44:27 +0200
From: David Cohen <david.cohen@nokia.com>
To: ext Sergio Aguirre <saaguirre@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [omap3isp RFC][PATCH 0/4] Improve inter subdev interaction
Message-ID: <20101120114426.GG13186@esdhcp04381.research.nokia.com>
References: <1290209031-12817-1-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290209031-12817-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Sergio,

On Sat, Nov 20, 2010 at 12:23:47AM +0100, ext Sergio Aguirre wrote:
> Hi,
> 
> These are some patches to make these operations more generic:
> - Clock control is being controlled in a very crude manner by
>   subdevices, it should be centralized in isp.c.
> - LSC prefetch wait check is reading a main ISP register, so move
>   it to isp.c
> - Abstract SBL busy check: we don't want a submodule thinkering
>   with main ISP registers. That should be done in the main isp.c
> 
> Also, remove main ISP register dump from CSI2 specific dump. We
> should be using isp_print_status if we'll like to know main ISP
> regdump.
> 
> Comments are welcome. More cleanups for better subdevice isolation
> are on the way.

Your patches are fine for me. I sent you some comments, but they are
opitional and it's up to you to decide what to do. :)
You can copy linux-omap@ as well in future patches.

Regards,

David

> 
> Regards,
> Sergio
> 
> Sergio Aguirre (4):
>   omap3isp: Abstract isp subdevs clock control
>   omap3isp: Move CCDC LSC prefetch wait to main isp code
>   omap3isp: sbl: Abstract SBL busy check
>   omap3isp: csi2: Don't dump ISP main registers
> 
>  drivers/media/video/isp/isp.c        |   95 ++++++++++++++++++++++++++++++++++
>  drivers/media/video/isp/isp.h        |   16 ++++++
>  drivers/media/video/isp/ispccdc.c    |   42 ++-------------
>  drivers/media/video/isp/ispcsi2.c    |    7 ---
>  drivers/media/video/isp/isppreview.c |    6 +--
>  drivers/media/video/isp/ispresizer.c |    6 +--
>  6 files changed, 119 insertions(+), 53 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
