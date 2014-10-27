Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0072.hostedemail.com ([216.40.44.72]:51285 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750761AbaJ0Fl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 01:41:59 -0400
Message-ID: <1414388515.15751.32.camel@perches.com>
Subject: [PATCH] MAINTAINERS: Update ivtv mailing lists as subscriber-only
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media <linux-media@vger.kernel.org>
Date: Sun, 26 Oct 2014 22:41:55 -0700
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mark these as subscriber-only mailing lists.

Signed-off-by: Joe Perches <joe@perches.com>
---
I got rejects not moderation emails for patches to these lists...

 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1b063fc..2e353c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2684,7 +2684,7 @@ F:	drivers/net/wireless/cw1200/
 
 CX18 VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
-L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
+L:	ivtv-devel@ivtvdriver.org (subscribers-only)
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
@@ -5152,7 +5152,7 @@ F:	drivers/media/tuners/it913x*
 
 IVTV VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
-L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
+L:	ivtv-devel@ivtvdriver.org (subscribers-only)
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://www.ivtvdriver.org


