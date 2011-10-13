Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51191 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab1JMPFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 11:05:04 -0400
Received: by gyb13 with SMTP id 13so104001gyb.19
        for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 08:05:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318345735-16778-1-git-send-email-ebutera@users.berlios.de>
References: <1318345735-16778-1-git-send-email-ebutera@users.berlios.de>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Thu, 13 Oct 2011 17:04:44 +0200
Message-ID: <CAAwP0s3of-xrB_xaW8Dn+jqt0GXc3G1OxP7dJbiLeimtxZndaA@mail.gmail.com>
Subject: Re: [RFC 0/3] omap3isp: add BT656 support
To: Enrico Butera <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 11, 2011 at 5:08 PM, Enrico Butera <ebutera@users.berlios.de> wrote:
> This patch series add support for BT656 to omap3isp. It is based
> on patches from Deepthy Ravi and Javier Martinez Canillas.
>
> To be applied on top of omap3isp-omap3isp-yuv branch at:
>
> git.linuxtv.org/pinchartl/media.git
>
> Enrico Butera (2):
>  omap3isp: ispvideo: export isp_video_mbus_to_pix
>  omap3isp: ispccdc: configure CCDC registers and add BT656 support
>
> Javier Martinez Canillas (1):
>  omap3isp: ccdc: Add interlaced field mode to platform data
>
>  drivers/media/video/omap3isp/ispccdc.c  |  143 ++++++++++++++++++++++++++-----
>  drivers/media/video/omap3isp/ispccdc.h  |    1 +
>  drivers/media/video/omap3isp/ispreg.h   |    1 +
>  drivers/media/video/omap3isp/ispvideo.c |    2 +-
>  drivers/media/video/omap3isp/ispvideo.h |    4 +-
>  include/media/omap3isp.h                |    3 +
>  6 files changed, 129 insertions(+), 25 deletions(-)
>
> --
> 1.7.4.1
>

Hello Laurent, Sakari and Deepthy,

Did you take a look at Enrico's patches?

We (Enrico, Gary and me) really want to add support both for
interlaced mode and BT.656 video data format to the ISP driver.

We are putting a lot of effort to this task but need the help of
someone who knows better than use the ISP internals. So, we will be
very happy if you can help us with this. We will address any issue you
find with the patches.

Right know we can get video in YUV format (CCDC BT.656 decoding and
deinterlacing is already working) from the CCDC ouput pad
(/dev/video2) but we have some ghosting effect and don't know what is
causing this nor how to fix.

Thank a lot and best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
