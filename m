Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33118
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751960AbdI0Vkr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v2 22/37] media: dvb_demux: mark a boolean field as such
Date: Wed, 27 Sep 2017 18:40:23 -0300
Message-Id: <66b3c151da1ec6e51a7576c0633e455df013f588.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct dvb_demux_filter.doneq is a boolean.

Mark it as such, as it helps to understand what it does.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.c | 4 ++--
 drivers/media/dvb-core/dvb_demux.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 6628f80d184f..68e93362c081 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -898,14 +898,14 @@ static void prepare_secfilters(struct dvb_demux_feed *dvbdmxfeed)
 		return;
 	do {
 		sf = &f->filter;
-		doneq = 0;
+		doneq = false;
 		for (i = 0; i < DVB_DEMUX_MASK_MAX; i++) {
 			mode = sf->filter_mode[i];
 			mask = sf->filter_mask[i];
 			f->maskandmode[i] = mask & mode;
 			doneq |= f->maskandnotmode[i] = mask & ~mode;
 		}
-		f->doneq = doneq ? 1 : 0;
+		f->doneq = doneq ? true : false;
 	} while ((f = f->next));
 }
 
diff --git a/drivers/media/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
index 045f7fd1a8b1..700887938145 100644
--- a/drivers/media/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb-core/dvb_demux.h
@@ -64,7 +64,7 @@ struct dvb_demux_filter {
 	struct dmx_section_filter filter;
 	u8 maskandmode[DMX_MAX_FILTER_SIZE];
 	u8 maskandnotmode[DMX_MAX_FILTER_SIZE];
-	int doneq;
+	bool doneq;
 
 	struct dvb_demux_filter *next;
 	struct dvb_demux_feed *feed;
-- 
2.13.5
