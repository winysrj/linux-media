Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34926 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914Ab2FUTx5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 15:53:57 -0400
Received: by mail-gh0-f174.google.com with SMTP id r11so883954ghr.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 12:53:57 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ben Collins <bcollins@bluecherry.net>,
	<linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 08/10] staging: solo6x10: Declare static const array properly
Date: Thu, 21 Jun 2012 16:52:10 -0300
Message-Id: <1340308332-1118-8-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/solo6x10/v4l2.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index 90e1379..1f896b9 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -588,12 +588,12 @@ static int solo_querycap(struct file *file, void  *priv,
 static int solo_enum_ext_input(struct solo_dev *solo_dev,
 			       struct v4l2_input *input)
 {
-	static const char *dispnames_1[] = { "4UP" };
-	static const char *dispnames_2[] = { "4UP-1", "4UP-2" };
-	static const char *dispnames_5[] = {
+	static const char * const dispnames_1[] = { "4UP" };
+	static const char * const dispnames_2[] = { "4UP-1", "4UP-2" };
+	static const char * const dispnames_5[] = {
 		"4UP-1", "4UP-2", "4UP-3", "4UP-4", "16UP"
 	};
-	const char **dispnames;
+	const char * const *dispnames;
 
 	if (input->index >= (solo_dev->nr_chans + solo_dev->nr_ext))
 		return -EINVAL;
-- 
1.7.4.4

