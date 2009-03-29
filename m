Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-6.mail.uk.tiscali.com ([212.74.114.14]:55321
	"EHLO mk-outboundfilter-6.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbZC2WWP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 18:22:15 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 2/4] Specify SHELL in documentation Makefile
Date: Sun, 29 Mar 2009 23:22:08 +0100
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu, Hans Verkuil <hverkuil@xs4all.nl>
References: <200903292309.31267.linux@baker-net.org.uk> <200903292317.10249.linux@baker-net.org.uk>
In-Reply-To: <200903292317.10249.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903292322.08660.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Makefile for the V4L2 spec uses bash extensions but
was using the default system shell, change it to explicitly
request bash.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>

---
diff -r d8d701594f71 v4l2-spec/Makefile
--- a/v4l2-spec/Makefile	Sun Mar 29 08:45:36 2009 +0200
+++ b/v4l2-spec/Makefile	Sun Mar 29 22:59:16 2009 +0100
@@ -1,5 +1,6 @@
 # Also update in v4l2.sgml!
 VERSION = 0.25
+SHELL=/bin/bash
 
 SGMLS = \
 	biblio.sgml \

