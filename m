Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:41392 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753215AbeGBVXc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 17:23:32 -0400
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v7 1/6] ivtv: zero-initialize cx25840 platform data
Date: Mon,  2 Jul 2018 23:23:21 +0200
Message-Id: <6165cab2bc2db2deb2edc9c0b7ab5e3b1623ac7b.1530565770.git.mail@maciej.szmigiero.name>
In-Reply-To: <cover.1530565770.git.mail@maciej.szmigiero.name>
References: <cover.1530565770.git.mail@maciej.szmigiero.name>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to zero-initialize cx25840 platform data structure to make sure
that its future members do not contain random stack garbage.

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
---
 drivers/media/pci/ivtv/ivtv-i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index 522cd111e399..e9ce54dd5e01 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -293,6 +293,7 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
 			.platform_data = &pdata,
 		};
 
+		memset(&pdata, 0, sizeof(pdata));
 		pdata.pvr150_workaround = itv->pvr150_workaround;
 		sd = v4l2_i2c_new_subdev_board(&itv->v4l2_dev, adap,
 				&cx25840_info, NULL);
