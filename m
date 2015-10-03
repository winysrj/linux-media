Return-path: <linux-media-owner@vger.kernel.org>
Received: from fed1rmfepo102.cox.net ([68.230.241.144]:50171 "EHLO
	fed1rmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbbJCPTO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2015 11:19:14 -0400
Received: from fed1rmimpo305 ([68.230.241.173]) by fed1rmfepo102.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20151003151913.LOQ19282.fed1rmfepo102.cox.net@fed1rmimpo305>
          for <linux-media@vger.kernel.org>; Sat, 3 Oct 2015 11:19:13 -0400
From: Eric Nelson <eric@nelint.com>
To: linux-media@vger.kernel.org, sean@mess.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mchehab@osg.samsung.com,
	mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
	galak@codeaurora.org, patrice.chotard@st.com, fabf@skynet.be,
	wsa@the-dreams.de, heiko@sntech.de, devicetree@vger.kernel.org,
	otavio@ossystems.com.br, Eric Nelson <eric@nelint.com>
Subject: [PATCH V2 1/2] rc-core: define a default timeout for drivers
Date: Sat,  3 Oct 2015 08:18:50 -0700
Message-Id: <1443885530-4980-1-git-send-email-eric@nelint.com>
In-Reply-To: <20151003112510.54fe2a25@recife.lan>
References: <20151003112510.54fe2a25@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A default timeout value of 125 ms should work for all decoders.

Declare a constant to help standardize its' use.

Signed-off-by: Eric Nelson <eric@nelint.com>
---
V2 increases the default timeout to 125ms as requested by Mauro

 include/media/rc-core.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index ec921f6..f649470 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -239,6 +239,7 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
 	memset(ev, 0, sizeof(*ev));
 }
 
+#define IR_DEFAULT_TIMEOUT	MS_TO_NS(125)
 #define IR_MAX_DURATION         500000000	/* 500 ms */
 #define US_TO_NS(usec)		((usec) * 1000)
 #define MS_TO_US(msec)		((msec) * 1000)
-- 
2.6.0

