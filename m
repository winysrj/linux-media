Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44144 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965624AbcIHMEf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 10/47] [media] demux.h: fix a documentation warning
Date: Thu,  8 Sep 2016 09:03:32 -0300
Message-Id: <189605b41bad76f772a0ea00b867faabcb35eb83.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The kernel-doc parser didn't handle well the private:
tag. Rewrite it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/demux.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index 0d9c53518be2..aeda2b64931c 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -582,10 +582,12 @@ struct dmx_demux {
 
 	int (*get_pes_pids)(struct dmx_demux *demux, u16 *pids);
 
+	/* private: */
+
 	/*
-	 * private: Only used at av7110, to read some data from firmware.
-	 *	As this was never documented, we have no clue about what's
-	 *	there, and its usage on other drivers aren't encouraged.
+	 * Only used at av7110, to read some data from firmware.
+	 * As this was never documented, we have no clue about what's
+	 * there, and its usage on other drivers aren't encouraged.
 	 */
 	int (*get_stc)(struct dmx_demux *demux, unsigned int num,
 		       u64 *stc, unsigned int *base);
-- 
2.7.4


