Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36854 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2FIIYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 04:24:43 -0400
Received: by obbtb18 with SMTP id tb18so3602642obb.19
        for <linux-media@vger.kernel.org>; Sat, 09 Jun 2012 01:24:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1337352032-3165-1-git-send-email-elezegarcia@gmail.com>
References: <1337352032-3165-1-git-send-email-elezegarcia@gmail.com>
Date: Sat, 9 Jun 2012 05:24:42 -0300
Message-ID: <CALF0-+V0vA0CyS1Oj_6vGHTx0=xFptL8uAr2yH9pj+E1Kb+GEw@mail.gmail.com>
Subject: [PATCH] em28xx: Make em28xx_ir_change_protocol a static function
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-input.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-input.c
b/drivers/media/video/em28xx/em28xx-input.c
index 2630b26..53cc36b 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -344,7 +344,7 @@ static void em28xx_ir_stop(struct rc_dev *rc)
       cancel_delayed_work_sync(&ir->work);
 }

-int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 rc_type)
+static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 rc_type)
 {
       int rc = 0;
       struct em28xx_IR *ir = rc_dev->priv;
--
1.7.3.4
