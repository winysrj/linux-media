Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:42473 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab3GOHcT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 03:32:19 -0400
From: oliver+list@schinagl.nl
To: linux-media@vger.kernel.org
Cc: CrazyCat <crazycat69@narod.ru>,
	Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 2/4] Hotbird Mediaset MIS+PLS transponders.
Date: Mon, 15 Jul 2013 09:28:49 +0200
Message-Id: <1373873331-31829-2-git-send-email-oliver+list@schinagl.nl>
In-Reply-To: <1373873331-31829-1-git-send-email-oliver+list@schinagl.nl>
References: <1373873331-31829-1-git-send-email-oliver+list@schinagl.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: CrazyCat <crazycat69@narod.ru>


Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
---
 dvb-s/Hotbird-13.0E | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/dvb-s/Hotbird-13.0E b/dvb-s/Hotbird-13.0E
index 7c916a8..1724a3d 100644
--- a/dvb-s/Hotbird-13.0E
+++ b/dvb-s/Hotbird-13.0E
@@ -1,6 +1,5 @@
 # EUTELSAT SkyPlex, Hotbird 13E
 # freq pol sr fec
-S 12539000 H 27500000 3/4
 S 10719000 V 27500000 3/4
 S 10723000 H 29900000 3/4
 S 10757000 V 27500000 3/4
@@ -34,7 +33,8 @@ S 11355000 V 27500000 3/4
 S 11373000 H 27500000 2/3
 S 11393000 V 27500000 3/4
 S 11411000 H 27500000 5/6
-S 11432000 V 27500000 2/3
+S2 11432000 V 27500000 2/3 AUTO 8PSK 1 8
+S2 11432000 V 27500000 2/3 AUTO 8PSK 2 8
 S 11470000 V 27500000 5/6
 S 11488000 H 27500000 3/4
 S 11526000 H 27500000 3/4
@@ -84,6 +84,8 @@ S 12418000 V 27500000 3/4
 S 12437000 H 27500000 3/4
 S 12475000 H 27500000 3/4
 S 12519000 V 27500000 3/4
+S2 12539000 H 27500000 2/3 AUTO 8PSK 1 8
+S2 12539000 H 27500000 2/3 AUTO 8PSK 2 8
 S 12558000 V 27500000 3/4
 S 12577000 H 27500000 3/4
 S 12596000 V 27500000 3/4
-- 
1.8.1.5

