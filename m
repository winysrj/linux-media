Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0AIp7tn023403
	for <video4linux-list@redhat.com>; Sat, 10 Jan 2009 13:51:07 -0500
Received: from mail.aknet.ru (mail.aknet.ru [78.158.192.26])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0AIp2KG030781
	for <video4linux-list@redhat.com>; Sat, 10 Jan 2009 13:51:03 -0500
Received: from ppp91-77-123-220.pppoe.mtu-net.ru ([91.77.123.220])
	by mail.aknet.ru with esmtpa (Exim 4.69 (FreeBSD))
	(envelope-from <stsp@aknet.ru>) id 1LLivA-0000Bo-NT
	for video4linux-list@redhat.com; Sat, 10 Jan 2009 21:50:56 +0300
Message-ID: <4968EE9A.5040901@aknet.ru>
Date: Sat, 10 Jan 2009 21:53:14 +0300
From: Stas Sergeev <stsp@aknet.ru>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: multipart/mixed; boundary="------------030202000608070601090801"
Subject: [patch] add video_nr module param to gspca
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

This is a multi-part message in MIME format.
--------------030202000608070601090801
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi.

The attached patch adds the
module_param for video_nr to
the gspca driver.
The patch is completely untested
as I don't use any webcam myself.
Its just that a friend of mine
complained about an inability to
set the device number for gspca
and I hope this patch can solve
that problem.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>

--------------030202000608070601090801
Content-Type: text/x-patch;
 name="gspca_nr.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca_nr.diff"

--- a/drivers/media/video/gspca/gspca.c	2008-12-06 23:39:56.000000000 +0300
+++ b/drivers/media/video/gspca/gspca.c	2009-01-10 19:29:49.000000000 +0300
@@ -48,6 +48,8 @@
 #define DRIVER_VERSION_NUMBER	KERNEL_VERSION(2, 3, 0)
 
 static int video_nr = -1;
+module_param(video_nr, int, 0);
+MODULE_PARM_DESC(video_nr, "video device to register (0=/dev/video0, etc)");
 
 #ifdef GSPCA_DEBUG
 int gspca_debug = D_ERR | D_PROBE;

--------------030202000608070601090801
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------030202000608070601090801--
