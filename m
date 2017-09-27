Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33171
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752131AbdI0Vkt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:49 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH v2 23/37] media: dvb_demux: dvb_demux_feed.pusi_seen is boolean
Date: Wed, 27 Sep 2017 18:40:24 -0300
Message-Id: <e9cc0692d55e91e389c9ed4445a99a71f33d697c.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using an integer to represent it, use boolean,
as this better describes what this field really means.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.c    | 12 ++++++------
 drivers/media/dvb-core/dvb_demux.h    |  2 +-
 drivers/media/pci/ttpci/av7110.c      |  2 +-
 drivers/media/pci/ttpci/budget-core.c |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 68e93362c081..b9360cbc3519 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -223,10 +223,10 @@ static void dvb_dmx_swfilter_section_new(struct dvb_demux_feed *feed)
  *  when the second packet arrives.
  *
  * Fix:
- * when demux is started, let feed->pusi_seen = 0 to
+ * when demux is started, let feed->pusi_seen = false to
  * prevent initial feeding of garbage from the end of
  * previous section. When you for the first time see PUSI=1
- * then set feed->pusi_seen = 1
+ * then set feed->pusi_seen = true
  */
 static int dvb_dmx_swfilter_section_copy_dump(struct dvb_demux_feed *feed,
 					      const u8 *buf, u8 len)
@@ -318,10 +318,10 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 		 */
 #endif
 		/*
-		 * Discontinuity detected. Reset pusi_seen = 0 to
+		 * Discontinuity detected. Reset pusi_seen to
 		 * stop feeding of suspicious data until next PUSI=1 arrives
 		 */
-		feed->pusi_seen = 0;
+		feed->pusi_seen = false;
 		dvb_dmx_swfilter_section_new(feed);
 	}
 
@@ -335,8 +335,8 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 
 			dvb_dmx_swfilter_section_copy_dump(feed, before,
 							   before_len);
-			/* before start of new section, set pusi_seen = 1 */
-			feed->pusi_seen = 1;
+			/* before start of new section, set pusi_seen */
+			feed->pusi_seen = true;
 			dvb_dmx_swfilter_section_new(feed);
 			dvb_dmx_swfilter_section_copy_dump(feed, after,
 							   after_len);
diff --git a/drivers/media/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
index 700887938145..9db3c2b7c64e 100644
--- a/drivers/media/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb-core/dvb_demux.h
@@ -101,7 +101,7 @@ struct dvb_demux_feed {
 	enum dmx_ts_pes pes_type;
 
 	int cc;
-	int pusi_seen;		/* prevents feeding of garbage from previous section */
+	bool pusi_seen;		/* prevents feeding of garbage from previous section */
 
 	u16 peslen;
 
diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index f46947d8adf8..f89fb23f6c57 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -1224,7 +1224,7 @@ static int budget_start_feed(struct dvb_demux_feed *feed)
 	dprintk(2, "av7110: %p\n", budget);
 
 	spin_lock(&budget->feedlock1);
-	feed->pusi_seen = 0; /* have a clean section start */
+	feed->pusi_seen = false; /* have a clean section start */
 	status = start_ts_capture(budget);
 	spin_unlock(&budget->feedlock1);
 	return status;
diff --git a/drivers/media/pci/ttpci/budget-core.c b/drivers/media/pci/ttpci/budget-core.c
index 97499b2af714..b3dc45b91101 100644
--- a/drivers/media/pci/ttpci/budget-core.c
+++ b/drivers/media/pci/ttpci/budget-core.c
@@ -330,7 +330,7 @@ static int budget_start_feed(struct dvb_demux_feed *feed)
 		return -EINVAL;
 
 	spin_lock(&budget->feedlock);
-	feed->pusi_seen = 0; /* have a clean section start */
+	feed->pusi_seen = false; /* have a clean section start */
 	if (budget->feeding++ == 0)
 		status = start_ts_capture(budget);
 	spin_unlock(&budget->feedlock);
-- 
2.13.5
