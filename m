Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46727 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbbLHRRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2015 12:17:21 -0500
Date: Tue, 8 Dec 2015 15:17:17 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH v8 35/55] [media] s5k5baf: fix subdev type
Message-ID: <20151208151717.73cf79e2@recife.lan>
In-Reply-To: <2154292.e5cNedqy2f@avalon>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<7ed3721139e459f5dd4cdd05bd1e58f248fc0781.1440902901.git.mchehab@osg.samsung.com>
	<2154292.e5cNedqy2f@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 06 Dec 2015 03:55:32 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Sunday 30 August 2015 00:06:46 Mauro Carvalho Chehab wrote:
> > X-Patchwork-Delegate: m.chehab@samsung.com
> > This sensor driver is abusing MEDIA_ENT_T_V4L2_SUBDEV, creating
> > some subdevs with a non-existing type.
> > 
> > As this is a sensor driver, the proper type is likely
> > MEDIA_ENT_T_V4L2_SUBDEV_SENSOR.
> 
> That's actually not correct. The driver creates two subdevs, one for the image 
> sensor pixel array (and the related readout logic) and one for an ISP. The 
> first subdev already uses the MEDIA_ENT_T_V4L2_SUBDEV_SENSOR type, but the 
> second subdev isn't a sensor pixel array.

OK.

Patch replaced by the one below.

Thanks,
Mauro

>From b1acc860aa845e9ea84fa597d540ad34047fe0cc Mon Sep 17 00:00:00 2001
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date: Thu, 7 May 2015 22:12:35 -0300
Subject: [media] s5k5baf: fix subdev type
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
    Mauro Carvalho Chehab <mchehab@infradead.org>

The driver creates two subdevs, one for the image sensor pixel array
(and the related readout logic) and one for an ISP.

The first subdev already uses the MEDIA_ENT_T_V4L2_SUBDEV_SENSOR type,
but the second subdev isn't a sensor pixel array.

So, rename the second subdev as MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/i2c/s5k5baf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index d3bff30bcb6f..0513196bd48c 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1919,7 +1919,7 @@ static int s5k5baf_configure_subdevs(struct s5k5baf *state,
 
 	state->pads[PAD_CIS].flags = MEDIA_PAD_FL_SINK;
 	state->pads[PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN;
 	ret = media_entity_init(&sd->entity, NUM_ISP_PADS, state->pads);
 
 	if (!ret)
-- 
2.5.0



