Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33886 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752995AbaDEQIF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Apr 2014 12:08:05 -0400
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id AF66E20F69
	for <linux-media@vger.kernel.org>; Sat,  5 Apr 2014 12:08:03 -0400 (EDT)
Message-ID: <53402A51.9020301@fastmail.fm>
Date: Sun, 06 Apr 2014 00:07:45 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
MIME-Version: 1.0
To: m.chehab@samsung.com, gregkh@linuxfoundation.org
CC: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dt3155v4l: Fixed global symbol
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Made q_ops static, as suggested by sparse.

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index e729e52..97e7a9b 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -299,7 +299,7 @@ dt3155_buf_queue(struct vb2_buffer *vb)
  *	end driver-specific callbacks
  */
 
-const struct vb2_ops q_ops = {
+static const struct vb2_ops q_ops = {
 	.queue_setup = dt3155_queue_setup,
 	.wait_prepare = dt3155_wait_prepare,
 	.wait_finish = dt3155_wait_finish,
-- 
1.7.12.1

