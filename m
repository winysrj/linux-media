Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:52676 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZAXXxb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2009 18:53:31 -0500
Date: Sat, 24 Jan 2009 15:52:41 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	linux-media@vger.kernel.org,
	Ronald Bultje <rbultje@ronald.bitfreak.net>
Subject: [PATCH] zoran: Update MAINTAINERS entry
In-Reply-To: <Pine.LNX.4.58.0901110346190.1626@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.58.0901241545440.17971@shell2.speakeasy.net>
References: <20090110160854.1d016948@hyperion.delvare>
 <Pine.LNX.4.58.0901110346190.1626@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ronald Bultje hasn't been maintaining the zoran driver for some time.
Re-direct people to the mailing lists and web pages.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
---
I think it's better to keep what info there is here instead of deleting the
entry entirely.  Sure you can find it elsewhere, but isn't the whole point
of MAINTAINERS to gather scattered info into one place and keep it up to
date?  Ronald, would you mind acking this version too?

 MAINTAINERS |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3fe4dc2..755a785 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4908,11 +4908,11 @@ L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
 S:	Maintained

 ZR36067 VIDEO FOR LINUX DRIVER
-P:	Ronald Bultje
-M:	rbultje@ronald.bitfreak.net
 L:	mjpeg-users@lists.sourceforge.net
+L:	linux-media@vger.kernel.org
 W:	http://mjpeg.sourceforge.net/driver-zoran/
-S:	Maintained
+T:	Mercurial http://linuxtv.org/hg/v4l-dvb
+S:	Odd Fixes

 ZS DECSTATION Z85C30 SERIAL DRIVER
 P:	Maciej W. Rozycki
-- 
1.5.4.1

