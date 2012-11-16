Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62670 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2KPG5B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 01:57:01 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so1660177pad.19
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2012 22:57:01 -0800 (PST)
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Subject: [PATCH 01/14] [media] ivtv: Remove redundant check on unsigned variable
Date: Fri, 16 Nov 2012 12:20:33 +0530
Message-Id: <1353048646-10935-2-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need to check whether unsigned variable is less than 0.

CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: ivtv-devel@ivtvdriver.org
CC: linux-media@vger.kernel.org
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/media/pci/ivtv/ivtv-ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 949ae23..4b47b5c 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -993,7 +993,7 @@ int ivtv_s_input(struct file *file, void *fh, unsigned int inp)
 	v4l2_std_id std;
 	int i;
 
-	if (inp < 0 || inp >= itv->nof_inputs)
+	if (inp >= itv->nof_inputs)
 		return -EINVAL;
 
 	if (inp == itv->active_input) {
-- 
1.7.4.1

