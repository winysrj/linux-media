Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2687 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbaBUJQi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Feb 2014 04:16:38 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id s1L9GZ7t046602
	for <linux-media@vger.kernel.org>; Fri, 21 Feb 2014 10:16:37 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E03FF2A01A7
	for <linux-media@vger.kernel.org>; Fri, 21 Feb 2014 10:16:32 +0100 (CET)
Message-ID: <53071970.3030408@xs4all.nl>
Date: Fri, 21 Feb 2014 10:16:32 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2-ctrls: replace BUG_ON by WARN_ON
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

BUG_ON is unnecessarily strict.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 6ff002b..35d551d 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1921,7 +1921,8 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 	int i;
 
 	/* The first control is the master control and it must not be NULL */
-	BUG_ON(ncontrols == 0 || controls[0] == NULL);
+	if (WARN_ON(ncontrols == 0 || controls[0] == NULL))
+		return;
 
 	for (i = 0; i < ncontrols; i++) {
 		if (controls[i]) {
-- 
1.9.0

