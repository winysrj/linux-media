Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbeKTUsZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 15:48:25 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jaedon Shin <jaedon.shin@gmail.com>
Subject: [PATCH 2/3] media: dvb_frontend: add debug message for frequency intervals
Date: Tue, 20 Nov 2018 08:19:35 -0200
Message-Id: <dbb518189dfaf5d99d389a94d456b990e8dba65f.1542709160.git.mchehab+samsung@kernel.org>
In-Reply-To: <dc0f3b757454e974eefe7795fbafc7b5cd0f5431.1542709160.git.mchehab+samsung@kernel.org>
References: <dc0f3b757454e974eefe7795fbafc7b5cd0f5431.1542709160.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we did an internal change inside the subsystem to always
represent min/max frequencies in Hz, add a debug message, as this
would help to discover bugs on drivers, if any.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2a26f9210394..27a1d4a98d73 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -917,6 +917,9 @@ static void dvb_frontend_get_frequency_limits(struct dvb_frontend *fe,
 			 "DVB: adapter %i frontend %u frequency limits undefined - fix the driver\n",
 			 fe->dvb->num, fe->id);
 
+	dprintk("frequency interval: tuner: %u...%u, frontend: %u...%u",
+		tuner_min, tuner_max, frontend_min, frontend_max);
+
 	/* If the standard is for satellite, convert frequencies to kHz */
 	switch (c->delivery_system) {
 	case SYS_DVBS:
-- 
2.19.1
