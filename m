Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f212.google.com ([209.85.218.212]:34764 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0CRG7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 02:59:17 -0400
Received: by bwz4 with SMTP id 4so1848886bwz.39
        for <linux-media@vger.kernel.org>; Wed, 17 Mar 2010 23:59:15 -0700 (PDT)
Date: Thu, 18 Mar 2010 16:00:19 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Add CHIP ID of the uPD61151
Message-ID: <20100318160019.43043c8f@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/sOntcJ/n5..Cj0JyVmWk2BW"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/sOntcJ/n5..Cj0JyVmWk2BW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Add CHIP ID of the NEC MPEG2 encoders uPD61151 and uPD61152.

diff -r b6b82258cf5e linux/include/media/v4l2-chip-ident.h
--- a/linux/include/media/v4l2-chip-ident.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-chip-ident.h	Wed Mar 17 04:53:52 2010 +0900
@@ -278,6 +278,11 @@
 	/* module cs53132a: just ident 53132 */
 	V4L2_IDENT_CS53l32A = 53132,
 
+	/* modules upd61151 MPEG2 encoder: just ident 54000 */
+	V4L2_IDENT_UPD61161 = 54000,
+	/* modules upd61152 MPEG2 encoder with AC3: just ident 54001 */
+	V4L2_IDENT_UPD61162 = 54001,
+
 	/* module upd64031a: just ident 64031 */
 	V4L2_IDENT_UPD64031A = 64031,
 

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.

--MP_/sOntcJ/n5..Cj0JyVmWk2BW
Content-Type: text/x-patch; name=v4l2_upd61151.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=v4l2_upd61151.patch

diff -r b6b82258cf5e linux/include/media/v4l2-chip-ident.h
--- a/linux/include/media/v4l2-chip-ident.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-chip-ident.h	Wed Mar 17 04:53:52 2010 +0900
@@ -278,6 +278,11 @@
 	/* module cs53132a: just ident 53132 */
 	V4L2_IDENT_CS53l32A = 53132,
 
+	/* modules upd61151 MPEG2 encoder: just ident 54000 */
+	V4L2_IDENT_UPD61161 = 54000,
+	/* modules upd61152 MPEG2 encoder with AC3: just ident 54001 */
+	V4L2_IDENT_UPD61162 = 54001,
+
 	/* module upd64031a: just ident 64031 */
 	V4L2_IDENT_UPD64031A = 64031,
 

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/sOntcJ/n5..Cj0JyVmWk2BW--
