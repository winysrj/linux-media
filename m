Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m28I9oK2015774
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 13:09:50 -0500
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m28I98c0032636
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 13:09:08 -0500
Received: by fk-out-0910.google.com with SMTP id b27so1059173fka.3
	for <video4linux-list@redhat.com>; Sat, 08 Mar 2008 10:09:07 -0800 (PST)
From: "Frej Drejhammar" <frej.drejhammar@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <37b97e1d079850e00df8.1204999523@liva.fdsoft.se>
In-Reply-To: <patchbomb.1204999521@liva.fdsoft.se>
Date: Sat, 08 Mar 2008 19:05:23 +0100
To: video4linux-list@redhat.com
Subject: [PATCH 2 of 2] cx88: Add module parameter to control color killer
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

1 file changed, 5 insertions(+), 1 deletion(-)
linux/drivers/media/video/cx88/cx88-core.c |    6 +++++-


# HG changeset patch
# User "Frej Drejhammar <frej.drejhammar@gmail.com>"
# Date 1204990024 -3600
# Node ID 37b97e1d079850e00df8bd8cb540ae7978341489
# Parent  d628824bec6646cc474d13fd47ff03034119d83a
cx88: Add module parameter to control color killer

From: "Frej Drejhammar <frej.drejhammar@gmail.com>"

The cx2388x family has support for a color killer but no way for a
casual user to enable it. This patch adds the module parameter
color_killer which if non-zero enables the killer. By default the
color killer is disabled, as in previous versions of the driver.

Signed-off-by: "Frej Drejhammar <frej.drejhammar@gmail.com>"

diff -r d628824bec66 -r 37b97e1d0798 linux/drivers/media/video/cx88/cx88-core.c
--- a/linux/drivers/media/video/cx88/cx88-core.c	Sat Mar 08 16:25:36 2008 +0100
+++ b/linux/drivers/media/video/cx88/cx88-core.c	Sat Mar 08 16:27:04 2008 +0100
@@ -65,6 +65,10 @@ static unsigned int chroma_agc;
 static unsigned int chroma_agc;
 module_param(chroma_agc, int, 0444);
 MODULE_PARM_DESC(chroma_agc, "enable chroma agc");
+
+static unsigned int color_killer;
+module_param(color_killer, int, 0444);
+MODULE_PARM_DESC(color_killer, "enable color killer");
 
 #define dprintk(level,fmt, arg...)	if (core_debug >= level)	\
 	printk(KERN_DEBUG "%s: " fmt, core->name , ## arg)
@@ -633,7 +637,7 @@ int cx88_reset(struct cx88_core *core)
 				   (1 << 12) |   // agc gain
 				   (1 << 11) |   // adaptibe agc
 				   chroma_agc ? (1 << 10) : 0 |
-				   (0 <<  9) |   // ckillen
+				   color_killer ? (1 <<  9) : 0 |
 				   (7)));
 
 	/* setup image format */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
