Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:58509 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbbJPQCQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 12:02:16 -0400
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
To: <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kozlov Sergey <serjk@netup.ru>, <kbuild-all@01.org>,
	<linux-media@vger.kernel.org>, Abylay Ospan <aospan@netup.ru>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH] Disable -Wframe-larger-than warnings with KASAN=y
Date: Fri, 16 Oct 2015 19:02:10 +0300
Message-ID: <1445011330-22698-1-git-send-email-aryabinin@virtuozzo.com>
In-Reply-To: <20151005110923.GA16831@wfg-t540p.sh.intel.com>
References: <20151005110923.GA16831@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the kernel compiled with KASAN=y, GCC adds redzones
for each variable on stack. This enlarges function's stack
frame and causes:
	'warning: the frame size of X bytes is larger than Y bytes'

The worst case I've seen for now is following:
 ../net/wireless/nl80211.c: In function ‘nl80211_send_wiphy’:
 ../net/wireless/nl80211.c:1731:1: warning: the frame size of 5448 bytes is larger than 2048 bytes [-Wframe-larger-than=]
  }
   ^
That kind of warning becomes useless with KASAN=y. It doesn't necessarily
indicate that there is some problem in the code, thus we should turn it off.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 lib/Kconfig.debug | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ab76b99..1d1521c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -197,6 +197,7 @@ config ENABLE_MUST_CHECK
 config FRAME_WARN
 	int "Warn for stack frames larger than (needs gcc 4.4)"
 	range 0 8192
+	default 0 if KASAN
 	default 1024 if !64BIT
 	default 2048 if 64BIT
 	help
-- 
2.4.9

