Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6PKC8wa007333
	for <video4linux-list@redhat.com>; Sat, 25 Jul 2009 16:12:08 -0400
Received: from mail-fx0-f223.google.com (mail-fx0-f223.google.com
	[209.85.220.223])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n6PKBrbb001678
	for <video4linux-list@redhat.com>; Sat, 25 Jul 2009 16:11:54 -0400
Received: by fxm23 with SMTP id 23so258634fxm.3
	for <video4linux-list@redhat.com>; Sat, 25 Jul 2009 13:11:53 -0700 (PDT)
From: Denis Loginov <dinvlad@gmail.com>
To: video4linux-list@redhat.com
Date: Sat, 25 Jul 2009 23:11:37 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907252311.37511.dinvlad@gmail.com>
Subject: Patch for drivers/media/video/gspca/sonixj.c (new device added)
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

Hello. Included is a patch allowing to use DIGITUS DA-70811 webcam, also known 
as ZSMC USB PC Camera ZS211 (with idVendor name = Microdia in lsusb).

In file drivers/media/video/gspca/sonixj.c :
--- sonixj.c        2009-07-25 16:57:45.293263122 +0300
+++ sonixj.c    2009-07-25 22:58:11.952516010 +0300
@@ -1752,6 +1752,7 @@
 /*     {USB_DEVICE(0x0c45, 0x6122), BSI(SN9C110, ICM105C, 0x??)}, */
 /*     {USB_DEVICE(0x0c45, 0x6123), BSI(SN9C110, SanyoCCD, 0x??)}, */
        {USB_DEVICE(0x0c45, 0x6128), BSI(SN9C110, OM6802, 0x21)}, /*sn9c325?*/
+       {USB_DEVICE(0x0c45, 0x6148), BSI(SN9C325, OM6802, 0x21)}, /*sn9c110?*/
 /*bw600.inf:*/
        {USB_DEVICE(0x0c45, 0x612a), BSI(SN9C120, OV7648, 0x21)}, /*sn9c110?*/
        {USB_DEVICE(0x0c45, 0x612c), BSI(SN9C110, MO4000, 0x21)},

Accordingly, 
In file Documentation/video4linux/gspca.txt :
--- gspca.txt       2009-07-25 23:01:05.589518320 +0300
+++ gspca.txt   2009-07-25 23:04:57.880516995 +0300
@@ -271,6 +271,7 @@
 sonixj         0c45:613b       Surfer SN-206
 sonixj         0c45:613c       Sonix Pccam168
 sonixj         0c45:6143       Sonix Pccam168
+sonixj         0c45:6148       Digitus DA-70811/ZSMC USB PC Camera 
ZS211/Microdia
 sunplus                0d64:0303       Sunplus FashionCam DXG
 etoms          102c:6151       Qcam Sangha CIF
 etoms          102c:6251       Qcam xxxxxx VGA

Tested on kernel 2.6.29, works fine for a cheap model.
The only open question is what value for the bridge should be used: SN9C110, 
SN9C120, or SN9C325 (camera works well with any of them).

Thank you for attention.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
