Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m64Eeppe016178
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 10:40:51 -0400
Received: from aragorn.vidconference.de (dns.vs-node3.de [87.106.12.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m64EedHS028945
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 10:40:39 -0400
Date: Fri, 4 Jul 2008 16:40:37 +0200
To: thierry.merle@free.fr
Message-ID: <20080704144036.GJ18818@vidsoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
From: Gregor Jasny <jasny@vidsoft.de>
Cc: video4linux-list@redhat.com, v4l2-library@linuxtv.org
Subject: PATCH: libv4l-fix-idct-inline-assembly.diff
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

Hi,

This patch fixes the input constraint for the sar instruction. It allows only an
immediate or cl as shift width.

Thanks,
Gregor

Signed-off-by: Gregor Jasny <jasny@vidsoft.de>

diff -r 61deeffda900 v4l2-apps/lib/libv4l/libv4lconvert/jidctflt.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/jidctflt.c	Fri Jul 04 07:21:55 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/jidctflt.c	Fri Jul 04 16:24:33 2008 +0200
@@ -92,7 +92,7 @@ static inline unsigned char descale_and_
       "\tcmpl %4,%1\n"
       "\tcmovg %4,%1\n"
       : "=r"(x)
-      : "0"(x), "Ir"(shift), "ir"(1UL<<(shift-1)), "r" (0xff), "r" (0)
+      : "0"(x), "Ic"((unsigned char)shift), "ir"(1UL<<(shift-1)), "r" (0xff), "r" (0)
       );
   return x;
 }

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
