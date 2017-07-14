Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:53470 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdGNJ2i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:28:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org
Subject: [PATCH 05/14] isdn: isdnloop: suppress a gcc-7 warning
Date: Fri, 14 Jul 2017 11:25:17 +0200
Message-Id: <20170714092540.1217397-6-arnd@arndb.de>
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We test whether a bit is set in a mask here, which is correct
but gcc warns about it as it thinks it might be confusing:

drivers/isdn/isdnloop/isdnloop.c:412:37: error: ?: using integer constants in boolean context, the expression will always evaluate to 'true' [-Werror=int-in-bool-context]

This replaces the negation of an integer with an equivalent
comparison to zero, which gets rid of the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/isdn/isdnloop/isdnloop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index 6ffd13466b8c..5792928b944d 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -409,7 +409,7 @@ isdnloop_sendbuf(int channel, struct sk_buff *skb, isdnloop_card *card)
 		return -EINVAL;
 	}
 	if (len) {
-		if (!(card->flags & (channel) ? ISDNLOOP_FLAGS_B2ACTIVE : ISDNLOOP_FLAGS_B1ACTIVE))
+		if ((card->flags & (channel) ? ISDNLOOP_FLAGS_B2ACTIVE : ISDNLOOP_FLAGS_B1ACTIVE) == 0)
 			return 0;
 		if (card->sndcount[channel] > ISDNLOOP_MAX_SQUEUE)
 			return 0;
-- 
2.9.0
