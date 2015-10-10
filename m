Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39228 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbbJJNgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:19 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 14/26] [media] DocBook: finish documenting struct dmx_demux
Date: Sat, 10 Oct 2015 10:35:57 -0300
Message-Id: <4bc645df7d46253836062ecb1e2969034d5ebd11.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two callbacks still not documented:
	.//drivers/media/dvb-core/demux.h:422: warning: No description found for parameter 'get_pes_pids'
	.//drivers/media/dvb-core/demux.h:422: warning: No description found for parameter 'get_stc'

The purpose of first one is clear. The second one is used only
on the obsolete av7110 driver, and its purpose is not clear,
as it just returns a 64-bit word from the firmware to userspace.

Let's document get_pes_pids and mark get_stc as private, adding
a comment to not use it, while this is not documented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index 53c82514ede5..b045a598fb2d 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -381,6 +381,16 @@ struct dmx_frontend {
  *	It returns
  *		0 on success;
  *		-EINVAL on bad parameter.
+ *
+ * @get_pes_pids: Get the PIDs for DMX_PES_AUDIO0, DMX_PES_VIDEO0,
+ *	DMX_PES_TELETEXT0, DMX_PES_SUBTITLE0 and DMX_PES_PCR0.
+ *	The @demux function parameter contains a pointer to the demux API and
+ *	instance data.
+ *	The @pids function parameter contains an array with five u16 elements
+ *	where the PIDs will be stored.
+ *	It returns
+ *		0 on success;
+ *		-EINVAL on bad parameter.
  */
 
 struct dmx_demux {
@@ -416,7 +426,11 @@ struct dmx_demux {
 	int (*get_caps) (struct dmx_demux* demux, struct dmx_caps *caps);
 	int (*set_source) (struct dmx_demux* demux, const dmx_source_t *src);
 #endif
-	/* public: */
+	/*
+	 * private: Only used at av7110, to read some data from firmware.
+	 *	As this was never documented, we have no clue about what's
+	 * 	there, and its usage on other drivers aren't encouraged.
+	 */
 	int (*get_stc) (struct dmx_demux* demux, unsigned int num,
 			u64 *stc, unsigned int *base);
 };
-- 
2.4.3


