Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43264 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab1CZBw4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 21:52:56 -0400
Date: Sat, 26 Mar 2011 04:52:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/6] [media] pvrusb2: check for allocation failures
Message-ID: <20110326015221.GH2008@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This function returns NULL on failure so lets do that if kzalloc()
fails.  There is a separate problem that the caller for this function
doesn't check for errors...

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/pvrusb2/pvrusb2-std.c b/drivers/media/video/pvrusb2/pvrusb2-std.c
index 370a9ab..b214f77 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-std.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-std.c
@@ -388,6 +388,9 @@ struct v4l2_standard *pvr2_std_create_enum(unsigned int *countptr,
 
 	stddefs = kzalloc(sizeof(struct v4l2_standard) * std_cnt,
 			  GFP_KERNEL);
+	if (!stddefs)
+		return NULL;
+
 	for (idx = 0; idx < std_cnt; idx++)
 		stddefs[idx].index = idx;
 
