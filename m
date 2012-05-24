Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:54250 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab2EXL2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 07:28:00 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:9ce4])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 7521894016F
	for <linux-media@vger.kernel.org>; Thu, 24 May 2012 13:27:53 +0200 (CEST)
Date: Thu, 24 May 2012 13:29:41 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca: Maintainer change
Message-ID: <20120524132941.674603a2@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede accepted to be the new gspca maintainer.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
---
 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f175f44..aaa63da 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3061,8 +3061,7 @@ S:	Maintained
 F:	drivers/media/video/gspca/t613.c
 
 GSPCA USB WEBCAM DRIVER
-M:	Jean-Francois Moine <moinejf@free.fr>
-W:	http://moinejf.free.fr
+M:	Hans de Goede <hdegoede@redhat.com>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
-- 
1.7.10
