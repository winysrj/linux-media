Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1822 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab2HAUSt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 16:18:49 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id q71KIk9K099140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Wed, 1 Aug 2012 22:18:47 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.186])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 093A046A011C
	for <linux-media@vger.kernel.org>; Wed,  1 Aug 2012 22:18:41 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH for v3.6] Add missing logging for rangelow/high of hwseek
Date: Wed, 1 Aug 2012 22:18:41 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208012218.41213.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct v4l2_hw_freq_seek has two new fields that weren't printed in the
logging function. Added.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index c3b7b5f..6bc47fc 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -402,8 +402,10 @@ static void v4l_print_hw_freq_seek(const void *arg, bool write_only)
 {
 	const struct v4l2_hw_freq_seek *p = arg;
 
-	pr_cont("tuner=%u, type=%u, seek_upward=%u, wrap_around=%u, spacing=%u\n",
-		p->tuner, p->type, p->seek_upward, p->wrap_around, p->spacing);
+	pr_cont("tuner=%u, type=%u, seek_upward=%u, wrap_around=%u, spacing=%u, "
+		"rangelow=%u, rangehigh=%u\n",
+		p->tuner, p->type, p->seek_upward, p->wrap_around, p->spacing,
+		p->rangelow, p->rangehigh);
 }
 
 static void v4l_print_requestbuffers(const void *arg, bool write_only)
