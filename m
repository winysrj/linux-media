Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:61279 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbbESVfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 17:35:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] [media] coda: remove extraneous TRACE_SYSTEM_STRING
Date: Tue, 19 May 2015 23:34:33 +0200
Message-ID: <4790110.OLqddgPxAn@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The coda tracing code causes lots of warnings like

In file included from /git/arm-soc/include/trace/define_trace.h:90:0,
                 from /git/arm-soc/drivers/media/platform/coda/trace.h:203,
                 from /git/arm-soc/drivers/media/platform/coda/coda-bit.c:34:
/git/arm-soc/include/trace/ftrace.h:28:0: warning: "TRACE_SYSTEM_STRING" redefined
 #define TRACE_SYSTEM_STRING __app(TRACE_SYSTEM_VAR,__trace_system_name)
 ^
In file included from /git/arm-soc/include/trace/define_trace.h:83:0,
                 from /git/arm-soc/drivers/media/platform/coda/trace.h:203,
                 from /git/arm-soc/drivers/media/platform/coda/coda-bit.c:34:
/git/arm-soc/drivers/media/platform/coda/./trace.h:12:0: note: this is the location of the previous definition
 #define TRACE_SYSTEM_STRING __stringify(TRACE_SYSTEM)

>From what I can tell, this is just the result of a bogus TRACE_SYSTEM_STRING
definition, and removing that one makes the warnings go away.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 9a1a8f9953f ("[media] coda: Add tracing support")

diff --git a/drivers/media/platform/coda/trace.h b/drivers/media/platform/coda/trace.h
index d1d06cbd1f6a..781bf7286d53 100644
--- a/drivers/media/platform/coda/trace.h
+++ b/drivers/media/platform/coda/trace.h
@@ -9,8 +9,6 @@
 
 #include "coda.h"
 
-#define TRACE_SYSTEM_STRING __stringify(TRACE_SYSTEM)
-
 TRACE_EVENT(coda_bit_run,
 	TP_PROTO(struct coda_ctx *ctx, int cmd),
 

