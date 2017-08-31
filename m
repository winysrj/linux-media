Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:59620 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751398AbdHaIM7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 04:12:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Mats Randgaard <matrandg@cisco.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/3] cec.h: initialize *parent and *port in cec_phys_addr_validate
Date: Thu, 31 Aug 2017 10:12:53 +0200
Message-Id: <20170831081255.23608-2-hverkuil@xs4all.nl>
In-Reply-To: <20170831081255.23608-1-hverkuil@xs4all.nl>
References: <20170831081255.23608-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make sure these values are set to avoid 'uninitialized variable'
warnings. Hasn't happened yet, but better safe than sorry.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/cec.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/media/cec.h b/include/media/cec.h
index df6b3bd31284..b96423d7058a 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -417,6 +417,10 @@ static inline u16 cec_phys_addr_for_input(u16 phys_addr, u8 input)
 
 static inline int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port)
 {
+	if (parent)
+		*parent = phys_addr;
+	if (port)
+		*port = 0;
 	return 0;
 }
 
-- 
2.14.1
