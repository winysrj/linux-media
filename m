Return-path: <linux-media-owner@vger.kernel.org>
Received: from gabe.freedesktop.org ([131.252.210.177]:54384 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbcGIUQl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 16:16:41 -0400
From: Vinson Lee <vlee@freedesktop.org>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kamil Debski <kamil@wypas.org>, k.debski@samsung.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] cec: Fix anonymous union initialization with older toolchains.
Date: Sat,  9 Jul 2016 20:11:08 +0000
Message-Id: <1468095068-7049-1-git-send-email-vlee@freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes this build error on CentOS 6.8 with GCC 4.4.7.

  CC [M]  drivers/staging/media/cec/cec-adap.o
drivers/staging/media/cec/cec-adap.c: In function ‘cec_queue_msg_fh’:
drivers/staging/media/cec/cec-adap.c:141: error: unknown field ‘lost_msgs’ specified in initializer

Fixes: 9881fe0ca187 ("[media] cec: add HDMI CEC framework (adapter)")
Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 drivers/staging/media/cec/cec-adap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 5ffa839..a21c13d 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -137,8 +137,10 @@ static void cec_queue_event(struct cec_adapter *adap,
 static void cec_queue_msg_fh(struct cec_fh *fh, const struct cec_msg *msg)
 {
 	static const struct cec_event ev_lost_msg = {
+		.ts = 0,
 		.event = CEC_EVENT_LOST_MSGS,
-		.lost_msgs.lost_msgs = 1,
+		.flags = 0,
+		{ .lost_msgs = { .lost_msgs = 1 } },
 	};
 	struct cec_msg_entry *entry;
 
-- 
1.7.1

