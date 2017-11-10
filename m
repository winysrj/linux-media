Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:52642 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753141AbdKJQqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 11:46:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] pulse8-cec: print time using time64_t.
Date: Fri, 10 Nov 2017 17:45:54 +0100
Message-Id: <20171110164559.3737072-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The firmware timestamp is an unsigned 32-bit value, but we copy it into
a signed 32-bit variable, so we can theoretically get an overflow in
the calculation when the timestamp is between 2038 and 2106.

This changes the temporary variable to time64_t and changes the deprecated
time_to_tm() over to time64_to_tm() accordingly.

There is still an overflow in y2106, but that is a limitation of the
firmware interface, not a kernel problem.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/pulse8-cec/pulse8-cec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
index 50146f263d90..350635826aae 100644
--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -329,7 +329,7 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio,
 	u8 cmd[2];
 	int err;
 	struct tm tm;
-	time_t date;
+	time64_t date;
 
 	pulse8->vers = 0;
 
@@ -349,7 +349,7 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio,
 	if (err)
 		return err;
 	date = (data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3];
-	time_to_tm(date, 0, &tm);
+	time64_to_tm(date, 0, &tm);
 	dev_info(pulse8->dev, "Firmware build date %04ld.%02d.%02d %02d:%02d:%02d\n",
 		 tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
 		 tm.tm_hour, tm.tm_min, tm.tm_sec);
-- 
2.9.0
