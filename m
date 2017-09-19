Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:38805 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751513AbdISMN4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:13:56 -0400
Message-ID: <59C10A00.2070000@googlemail.com>
Date: Tue, 19 Sep 2017 13:13:52 +0100
From: Nigel Kettlewell <nigel.kettlewell@googlemail.com>
MIME-Version: 1.0
To: crope@iki.fi
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix for hanging si2168 in PCTV 292e, making the code match
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[re-sending as plain text]

Fix for hanging si2168 in PCTV 292e USB, making the code match the comment.

Using firmware v4.0.11 the 292e would work once and then hang on 
subsequent attempts to view DVB channels, until physically unplugged and 
plugged back in.

With this patch, the warm state is reset for v4.0.11 and it appears to 
work both on the first attempt and on subsequent attempts.

(Patch basis Linux 4.11.9 f82a53b87594f460f2dd9983eeb851a5840e8df8)

---
  drivers/media/dvb-frontends/si2168.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c 
b/drivers/media/dvb-frontends/si2168.c
index 680ba06..523acd1 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -582,7 +582,7 @@ static int si2168_sleep(struct dvb_frontend *fe)
         dev->active = false;

         /* Firmware B 4.0-11 or later loses warm state during sleep */
-       if (dev->version > ('B' << 24 | 4 << 16 | 0 << 8 | 11 << 0))
+       if (dev->version >= ('B' << 24 | 4 << 16 | 0 << 8 | 11 << 0))
                 dev->warm = false;

         memcpy(cmd.args, "\x13", 1);
--
2.9.4
