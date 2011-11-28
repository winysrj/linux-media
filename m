Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56511 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab1K1HdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 02:33:05 -0500
Date: Mon, 28 Nov 2011 08:31:37 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] [media] convert drivers/media/* to use
 module_platform_driver()
In-reply-to: <1322290135.20464.1.camel@phoenix>
To: 'Axel Lin' <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: 'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>,
	=?utf-8?Q?'Richard_R=C3=B6jfors'?= <richard.rojfors@pelagicore.com>,
	"'Matti J. Aaltonen'" <matti.j.aaltonen@nokia.com>,
	'Lucas De Marchi' <lucas.demarchi@profusion.mobi>,
	'Manjunath Hadli' <manjunath.hadli@ti.com>,
	'Muralidharan Karicheri' <m-karicheri2@ti.com>,
	'Anatolij Gustschin' <agust@denx.de>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	'Robert Jarzmik' <robert.jarzmik@free.fr>,
	'Jonathan Corbet' <corbet@lwn.net>,
	'Daniel Drake' <dsd@laptop.org>, linux-media@vger.kernel.org
Message-id: <000001ccad9f$c371c440$4a554cc0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 8BIT
References: <1322290135.20464.1.camel@phoenix>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Saturday, November 26, 2011 7:49 AM Axel Lin wrote:

> This patch converts the drivers in drivers/media/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: "Richard Röjfors" <richard.rojfors@pelagicore.com>
> Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
> Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> Cc: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Muralidharan Karicheri <m-karicheri2@ti.com>
> Cc: Anatolij Gustschin <agust@denx.de>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Robert Jarzmik <robert.jarzmik@free.fr>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Daniel Drake <dsd@laptop.org>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/media/radio/radio-si4713.c         |   15 +----------
>  drivers/media/radio/radio-timb.c           |   15 +----------
>  drivers/media/radio/radio-wl1273.c         |   17 +-----------
>  drivers/media/video/davinci/dm355_ccdc.c   |   13 +---------
>  drivers/media/video/davinci/dm644x_ccdc.c  |   13 +---------
>  drivers/media/video/davinci/isif.c         |   13 +---------
>  drivers/media/video/davinci/vpbe.c         |   24 +-----------------
>  drivers/media/video/davinci/vpbe_display.c |   38 +---------------------------
>  drivers/media/video/davinci/vpbe_osd.c     |   18 +------------
>  drivers/media/video/davinci/vpbe_venc.c    |   18 +------------
>  drivers/media/video/davinci/vpfe_capture.c |   18 +------------
>  drivers/media/video/fsl-viu.c              |   13 +---------
>  drivers/media/video/mx3_camera.c           |   14 +---------
>  drivers/media/video/omap1_camera.c         |   12 +--------
>  drivers/media/video/omap24xxcam.c          |   19 +-------------
>  drivers/media/video/omap3isp/isp.c         |   19 +-------------
>  drivers/media/video/pxa_camera.c           |   14 +---------
>  drivers/media/video/s5p-g2d/g2d.c          |   16 +-----------
>  drivers/media/video/s5p-mfc/s5p_mfc.c      |   22 +---------------
>  drivers/media/video/s5p-tv/hdmi_drv.c      |   26 +------------------
>  drivers/media/video/s5p-tv/sdo_drv.c       |   22 +---------------

For Samsung drivers in drivers/media/video/s5p-*

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

>  drivers/media/video/sh_mobile_csi2.c       |   13 +---------
>  drivers/media/video/soc_camera_platform.c  |   13 +---------
>  drivers/media/video/timblogiw.c            |   15 +----------
>  drivers/media/video/via-camera.c           |   12 +--------
>  25 files changed, 26 insertions(+), 406 deletions(-)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


