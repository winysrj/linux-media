Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2464 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab2HPHMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 03:12:41 -0400
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "crope@iki.fi" <crope@iki.fi>
CC: "htl10@users.sourceforge.net" <htl10@users.sourceforge.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"joe@perches.com" <joe@perches.com>
Date: Thu, 16 Aug 2012 09:12:28 +0200
Subject: Re: noisy dev_dbg_ratelimited()
Message-ID: <20120816.101228.1829061240257077271.hdoyu@nvidia.com>
References: <1344991485.62541.YahooMailClassic@web29404.mail.ird.yahoo.com><502AF5E3.7080405@iki.fi><502C48DC.9090303@iki.fi>
In-Reply-To: <502C48DC.9090303@iki.fi>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

Antti Palosaari <crope@iki.fi> wrote @ Thu, 16 Aug 2012 03:11:56 +0200:

> Hello Hiroshi,
> 
> I see you have added dev_dbg_ratelimited() recently, commit 
> 6ca045930338485a8cdef117e74372aa1678009d .
> 
> However it seems to be noisy as expected similar behavior than normal 
> dev_dbg() without a ratelimit.
> 
> I looked ratelimit.c and there is:
> printk(KERN_WARNING "%s: %d callbacks suppressed\n", func, rs->missed);
> 
> What it looks my eyes it will print those "callbacks suppressed" always 
> because KERN_WARNING.

Right. Can the following fix the problem?

>From 905b1dedb6c64bc46a70f6d203ef98c23fccb107 Mon Sep 17 00:00:00 2001
From: Hiroshi Doyu <hdoyu@nvidia.com>
Date: Thu, 16 Aug 2012 10:02:11 +0300
Subject: [PATCH 1/1] driver-core: Shut up dev_dbg_reatelimited() without
 DEBUG

dev_dbg_reatelimited() without DEBUG printed "217078 callbacks
suppressed". This shouldn't print anything without DEBUG.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Reported-by: Antti Palosaari <crope@iki.fi>
---
 include/linux/device.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index eb945e1..d4dc26e 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -962,9 +962,13 @@ do {									\
 	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
 #define dev_info_ratelimited(dev, fmt, ...)				\
 	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
+#if defined(DEBUG)
 #define dev_dbg_ratelimited(dev, fmt, ...)				\
 	dev_level_ratelimited(dev_dbg, dev, fmt, ##__VA_ARGS__)
-
+#else
+#define dev_dbg_ratelimited(dev, fmt, ...)			\
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#endif
 /*
  * Stupid hackaround for existing uses of non-printk uses dev_info
  *
-- 
1.7.5.4

