Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2892 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaEIMZs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 08:25:48 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id s49CPiHi033556
	for <linux-media@vger.kernel.org>; Fri, 9 May 2014 14:25:46 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 03BB22A19A2
	for <linux-media@vger.kernel.org>; Fri,  9 May 2014 14:25:38 +0200 (CEST)
Message-ID: <536CC941.4050004@xs4all.nl>
Date: Fri, 09 May 2014 14:25:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2-ioctl: drop spurious newline in string
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The message logged by v4l_print_cropcap should be a single line without linebreaks, just
like all the other v4l_print_<ioctl> functions.

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f729bd2..16bffd8 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -562,7 +562,7 @@ static void v4l_print_cropcap(const void *arg, bool write_only)
 	const struct v4l2_cropcap *p = arg;
 
 	pr_cont("type=%s, bounds wxh=%dx%d, x,y=%d,%d, "
-		"defrect wxh=%dx%d, x,y=%d,%d\n, "
+		"defrect wxh=%dx%d, x,y=%d,%d, "
 		"pixelaspect %d/%d\n",
 		prt_names(p->type, v4l2_type_names),
 		p->bounds.width, p->bounds.height,
