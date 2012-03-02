Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3944 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2CBIUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 03:20:24 -0500
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215] (may be forged))
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id q228KLP4062223
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 2 Mar 2012 09:20:23 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id A8AA235E000C
	for <linux-media@vger.kernel.org>; Fri,  2 Mar 2012 09:20:20 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH] Two small string fixes in v4l2-ctrls.c
Date: Fri, 2 Mar 2012 09:20:19 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203020920.19956.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix one typo and use 'Microseconds' instead of 'useconds' in the pre-emphasis
descriptions.

Regards,

	Hans

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 9091172..8465ee9 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -245,8 +245,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 	};
 	static const char * const tune_preemphasis[] = {
 		"No Preemphasis",
-		"50 useconds",
-		"75 useconds",
+		"50 Microseconds",
+		"75 Microseconds",
 		NULL,
 	};
 	static const char * const header_mode[] = {
@@ -343,7 +343,7 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 	};
 	static const char * const mpeg4_profile[] = {
 		"Simple",
-		"Adcanved Simple",
+		"Advanced Simple",
 		"Core",
 		"Simple Scalable",
 		"Advanced Coding Efficency",
