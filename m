Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33858 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754057AbdGKR5H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 13:57:07 -0400
Date: Tue, 11 Jul 2017 19:57:05 +0200
From: Yves =?iso-8859-1?Q?Lem=E9e?= <yves.lemee.kernel@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Clean up lirc zilog error codes
Message-ID: <20170711175704.p2ssblkm7lkincfx@yves>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According the coding style guidelines, the ENOSYS error code must be returned
in case of a non existent system call. This code has been replaced with
the ENOTTY error code indicating, a missing functionality.

Signed-off-by: Yves Lemée <yves.lemee.kernel@gmail.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 015e41bd036e..26dd32d5b5b2 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1249,7 +1249,7 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		break;
 	case LIRC_GET_REC_MODE:
 		if (!(features & LIRC_CAN_REC_MASK))
-			return -ENOSYS;
+			return -ENOTTY;
 
 		result = put_user(LIRC_REC2MODE
 				  (features & LIRC_CAN_REC_MASK),
@@ -1257,21 +1257,21 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		break;
 	case LIRC_SET_REC_MODE:
 		if (!(features & LIRC_CAN_REC_MASK))
-			return -ENOSYS;
+			return -ENOTTY;
 
 		result = get_user(mode, uptr);
 		if (!result && !(LIRC_MODE2REC(mode) & features))
-			result = -EINVAL;
+			result = -ENOTTY;
 		break;
 	case LIRC_GET_SEND_MODE:
 		if (!(features & LIRC_CAN_SEND_MASK))
-			return -ENOSYS;
+			return -ENOTTY;
 
 		result = put_user(LIRC_MODE_PULSE, uptr);
 		break;
 	case LIRC_SET_SEND_MODE:
 		if (!(features & LIRC_CAN_SEND_MASK))
-			return -ENOSYS;
+			return -ENOTTY;
 
 		result = get_user(mode, uptr);
 		if (!result && mode != LIRC_MODE_PULSE)
-- 
2.13.2
