Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m28I9i9i015735
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 13:09:44 -0500
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m28I942x032609
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 13:09:05 -0500
Received: by fk-out-0910.google.com with SMTP id b27so1059146fka.3
	for <video4linux-list@redhat.com>; Sat, 08 Mar 2008 10:09:04 -0800 (PST)
From: "Frej Drejhammar" <frej.drejhammar@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <d628824bec6646cc474d.1204999522@liva.fdsoft.se>
In-Reply-To: <patchbomb.1204999521@liva.fdsoft.se>
Date: Sat, 08 Mar 2008 19:05:22 +0100
To: video4linux-list@redhat.com
Subject: [PATCH 1 of 2] cx88: Add module parameter to control chroma AGC
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
# Date 1204989936 -3600
# Node ID d628824bec6646cc474d13fd47ff03034119d83a
# Parent  ad0b1f882ad988ae2f80ebbbe914092a4a963f04
cx88: Add module parameter to control chroma AGC

From: "Frej Drejhammar <frej.drejhammar@gmail.com>"

The cx2388x family has support for chroma AGC but no way for a casual
user to enable it. This patch adds the module parameter chroma_agc
which if non-zero enables the AGC. By default chroma AGC is disabled,
as in previous versions of the driver.


Signed-off-by: "Frej Drejhammar <frej.drejhammar@gmail.com>"

diff -r ad0b1f882ad9 -r d628824bec66 linux/drivers/media/video/cx88/cx88-core.c
--- a/linux/drivers/media/video/cx88/cx88-core.c	Wed Mar 05 20:24:43 2008 +0000
+++ b/linux/drivers/media/video/cx88/cx88-core.c	Sat Mar 08 16:25:36 2008 +0100
@@ -61,6 +61,10 @@ static unsigned int nocomb;
 static unsigned int nocomb;
 module_param(nocomb,int,0644);
 MODULE_PARM_DESC(nocomb,"disable comb filter");
+
+static unsigned int chroma_agc;
+module_param(chroma_agc, int, 0444);
+MODULE_PARM_DESC(chroma_agc, "enable chroma agc");
 
 #define dprintk(level,fmt, arg...)	if (core_debug >= level)	\
 	printk(KERN_DEBUG "%s: " fmt, core->name , ## arg)
@@ -628,7 +632,7 @@ int cx88_reset(struct cx88_core *core)
 	cx_write(MO_INPUT_FORMAT, ((1 << 13) |   // agc enable
 				   (1 << 12) |   // agc gain
 				   (1 << 11) |   // adaptibe agc
-				   (0 << 10) |   // chroma agc
+				   chroma_agc ? (1 << 10) : 0 |
 				   (0 <<  9) |   // ckillen
 				   (7)));
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
