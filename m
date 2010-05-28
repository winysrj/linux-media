Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57870 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0E1G1d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 02:27:33 -0400
Date: Fri, 28 May 2010 08:27:31 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: mt9m111 swap_rgb_red_blue
Message-ID: <20100528062731.GE23664@pengutronix.de>
References: <20100526141848.GU17272@pengutronix.de> <87bpc2za9i.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bpc2za9i.fsf@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Wed, May 26, 2010 at 10:19:21PM +0200, Robert Jarzmik wrote:
> Sascha Hauer <s.hauer@pengutronix.de> writes:
> 
> > Hi,
> >
> > The mt9m111 soc-camera driver has a swap_rgb_red_blue variable which is
> > hardcoded to 1. This results in, well the name says it, red and blue being
> > swapped in my picture.
> > Is this value needed on some boards or is it just a leftover from
> > development?
> 
> Hi Sascha,
> 
> It's not a development leftover, it's something that the sensor and the host
> have to agree upon (ie. agree upon the output the sensor has to deliver to the
> host).
> 
> By now, only the Marvell PXA27x CPU was used as the host of this sensor, and the
> PXA expects the inverted Red/Blue order (ie. have BGR format).

I have digged around in the Datasheet and if I understand it correctly
the PXA swaps red/blue in RGB mode. So if we do not use rgb mode but yuv
(which should be a pass through) we should be able to support rgb on PXA
aswell. Robert, can you confirm that with the following patch applied
you still get an image but with red/blue swapped?

Sascha



>From c7b7d94eca2ed3c17121c558b4cbd31eaadb9dc0 Mon Sep 17 00:00:00 2001
From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Fri, 28 May 2010 08:23:20 +0200
Subject: [PATCH] pxa_camera: Allow real rgb565 format

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/media/video/pxa_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 7fe70e7..f635ad2 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1129,7 +1129,7 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 			CICR1_TBIT | CICR1_COLOR_SP_VAL(1);
 		break;
 	case V4L2_PIX_FMT_RGB565:
-		cicr1 |= CICR1_COLOR_SP_VAL(1) | CICR1_RGB_BPP_VAL(2);
+		cicr1 |= CICR1_COLOR_SP_VAL(2);
 		break;
 	}
 
-- 
1.7.1

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
