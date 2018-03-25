Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:41268 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752237AbeCYV1W (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 17:27:22 -0400
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: [PATCH v6 1/6] ivtv: zero-initialize cx25840 platform data
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <cover.1522012430.git.mail@maciej.szmigiero.name>
Message-ID: <254514e8-17a6-1e22-8095-9a7a6b992369@maciej.szmigiero.name>
Date: Sun, 25 Mar 2018 23:27:20 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1522012430.git.mail@maciej.szmigiero.name>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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
