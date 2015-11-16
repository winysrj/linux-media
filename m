Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:34528 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbbKPTyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 14:54:06 -0500
Received: by wmvv187 with SMTP id v187so194593079wmv.1
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2015 11:54:05 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 3/8] media: rc: constify struct proto_names
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>
Message-ID: <564A33F1.2000504@gmail.com>
Date: Mon, 16 Nov 2015 20:52:17 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare struct proto_names and its member name as const.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index cede8bc..f2d5c50 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -777,9 +777,9 @@ static struct class rc_class = {
  * used by the sysfs protocols file. Note that the order
  * of the entries is relevant.
  */
-static struct {
+static const struct {
 	u64	type;
-	char	*name;
+	const char	*name;
 	const char	*module_name;
 } proto_names[] = {
 	{ RC_BIT_NONE,		"none",		NULL			},
-- 
2.6.2

