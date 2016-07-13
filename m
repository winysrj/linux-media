Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:55127 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbcGMUoG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 16:44:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Jason Baron <jbaron@akamai.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] cxd2841er: avoid misleading gcc warning
Date: Wed, 13 Jul 2016 22:42:33 +0200
Message-Id: <20160713204342.1221511-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The addition of jump label support in dynamic_debug caused an unexpected
warning in exactly one file in the kernel:

drivers/media/dvb-frontends/cxd2841er.c: In function 'cxd2841er_tune_tc':
include/linux/dynamic_debug.h:134:3: error: 'carrier_offset' may be used uninitialized in this function [-Werror=maybe-uninitialized]
   __dynamic_dev_dbg(&descriptor, dev, fmt, \
   ^~~~~~~~~~~~~~~~~
drivers/media/dvb-frontends/cxd2841er.c:3177:11: note: 'carrier_offset' was declared here
  int ret, carrier_offset;
           ^~~~~~~~~~~~~~

The problem seems to be that the compiler gets confused by the extra conditionals
in static_branch_unlikely, to the point where it can no longer keep track of
which branches have already been taken, and it doesn't realize that this variable
is now always initialized when it gets used.

I have done lots of randconfig kernel builds and could not find any other file
with this behavior, so I assume it's a rare enough glitch that we don't need
to change the jump label support but instead just work around the warning in
the driver.

To achieve that, I'm moving the check for the return value into the switch()
statement, which is an obvious transformation, but is enough to un-confuse
the compiler here. The resulting code is not as nice to read, but at
least we retain the behavior of warning if it gets changed to actually
access an uninitialized carrier offset value in the future.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: (in linux-mm) "dynamic_debug: add jump label support"
---
 drivers/media/dvb-frontends/cxd2841er.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 721fb074da7c..0639ca281a2c 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -3223,20 +3223,28 @@ static int cxd2841er_tune_tc(struct dvb_frontend *fe,
 				ret = cxd2841er_get_carrier_offset_i(
 						priv, p->bandwidth_hz,
 						&carrier_offset);
+				if (ret)
+					return ret;
 				break;
 			case SYS_DVBT:
 				ret = cxd2841er_get_carrier_offset_t(
 					priv, p->bandwidth_hz,
 					&carrier_offset);
+				if (ret)
+					return ret;
 				break;
 			case SYS_DVBT2:
 				ret = cxd2841er_get_carrier_offset_t2(
 					priv, p->bandwidth_hz,
 					&carrier_offset);
+				if (ret)
+					return ret;
 				break;
 			case SYS_DVBC_ANNEX_A:
 				ret = cxd2841er_get_carrier_offset_c(
 					priv, &carrier_offset);
+				if (ret)
+					return ret;
 				break;
 			default:
 				dev_dbg(&priv->i2c->dev,
@@ -3244,8 +3252,6 @@ static int cxd2841er_tune_tc(struct dvb_frontend *fe,
 					__func__, priv->system);
 				return -EINVAL;
 			}
-			if (ret)
-				return ret;
 			dev_dbg(&priv->i2c->dev, "%s(): carrier offset %d\n",
 				__func__, carrier_offset);
 			p->frequency += carrier_offset;
-- 
2.9.0

