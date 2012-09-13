Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61724 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2IMHoN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 03:44:13 -0400
Received: by wibhq12 with SMTP id hq12so520477wib.1
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2012 00:44:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347462158-20417-1-git-send-email-p.zabel@pengutronix.de>
References: <1347462158-20417-1-git-send-email-p.zabel@pengutronix.de>
Date: Thu, 13 Sep 2012 09:44:11 +0200
Message-ID: <CACKLOr2XDFUU=_dQ+P=ff9o27+_YZTTiA_nS+tv5t09mwDFPrQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/13] Initial i.MX5/CODA7 support for the CODA driver
From: javier Martin <javier.martin@vista-silicon.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 12 September 2012 17:02, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> These patches contain initial firmware loading and encoding support for the
> CODA7 series VPU contained in i.MX51 and i.MX53 SoCs, and fix some multi-instance
> issues.
>
> Changes since v4:
>  - Added Javier's Tested/Reviewed/Acked-by.
>  - Fixed menu_skip_mask for V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE v4l2_ctrl.
>  - Dropped the ARM patches, those should not go through the media tree.
>  - Dropped the 1080p frame size limit patch for now.

This v5 version it's ok with me. We've tested it with codadx6 and it
works properly.

Good job.


> I'll add support for larger than PAL sized frames properly in the next patch
> series, together with decoder support for i.MX5/CODA7 and i.MX6/CODA960.
>
> regards
> Philipp
>
> ---
>  drivers/media/platform/Kconfig |    3 +-
>  drivers/media/platform/coda.c  |  422 +++++++++++++++++++++++++++++-----------
>  drivers/media/platform/coda.h  |   30 ++-
>  3 files changed, 337 insertions(+), 118 deletions(-)
>



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
