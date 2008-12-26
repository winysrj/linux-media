Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBQHQnL1015051
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 12:26:49 -0500
Received: from cp-out9.libero.it (cp-out9.libero.it [212.52.84.109])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBQHQb8o026546
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 12:26:38 -0500
Received: from [192.168.1.102] (151.48.19.203) by cp-out9.libero.it (8.5.016.1)
	id 492C050B045A2B6B for video4linux-list@redhat.com;
	Fri, 26 Dec 2008 18:26:37 +0100
To: video4linux-list@redhat.com
From: Fabio Rossi <rossi.f@inwind.it>
Date: Fri, 26 Dec 2008 18:26:18 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6ORVJEYcScBWqp7"
Message-Id: <200812261826.18796.rossi.f@inwind.it>
Subject: [PATCH] gspca: add support to the Logitech QuickCam E2500
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

--Boundary-00=_6ORVJEYcScBWqp7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Here is a trivial patch for supporting the Logitech QuickCam E2500.

Signed-off-by: Fabio Rossi <rossi.f@inwind.it>
---
diff --git a/Documentation/video4linux/gspca.txt 
b/Documentation/video4linux/gspca.txt
index 004818f..fb7e654 100644
--- a/Documentation/video4linux/gspca.txt
+++ b/Documentation/video4linux/gspca.txt
@@ -53,6 +53,7 @@ zc3xx         0461:0a00       MicroInnovation WebCam320
 spca500                046d:0890       Logitech QuickCam traveler
 vc032x         046d:0892       Logitech Orbicam
 vc032x         046d:0896       Logitech Orbicam
+zc3xx          046d:089d       Logitech QuickCam E2500
 zc3xx          046d:08a0       Logitech QC IM
 zc3xx          046d:08a1       Logitech QC IM 0x08A1 +sound
 zc3xx          046d:08a2       Labtec Webcam Pro
diff --git a/drivers/media/video/gspca/zc3xx.c 
b/drivers/media/video/gspca/zc3xx.c
index 0befacf..3bb9f42 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -7530,6 +7530,7 @@ static const __devinitdata struct usb_device_id 
device_table[] = {
        {USB_DEVICE(0x0458, 0x700c)},
        {USB_DEVICE(0x0458, 0x700f)},
        {USB_DEVICE(0x0461, 0x0a00)},
+       {USB_DEVICE(0x046d, 0x089d), .driver_info = SENSOR_MC501CB},
        {USB_DEVICE(0x046d, 0x08a0)},
        {USB_DEVICE(0x046d, 0x08a1)},
        {USB_DEVICE(0x046d, 0x08a2)},

--Boundary-00=_6ORVJEYcScBWqp7
Content-Type: text/x-diff;
  charset="us-ascii";
  name="qc_e2500.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="qc_e2500.patch"

diff --git a/Documentation/video4linux/gspca.txt b/Documentation/video4linux/gspca.txt
index 004818f..fb7e654 100644
--- a/Documentation/video4linux/gspca.txt
+++ b/Documentation/video4linux/gspca.txt
@@ -53,6 +53,7 @@ zc3xx		0461:0a00	MicroInnovation WebCam320
 spca500		046d:0890	Logitech QuickCam traveler
 vc032x		046d:0892	Logitech Orbicam
 vc032x		046d:0896	Logitech Orbicam
+zc3xx		046d:089d	Logitech QuickCam E2500
 zc3xx		046d:08a0	Logitech QC IM
 zc3xx		046d:08a1	Logitech QC IM 0x08A1 +sound
 zc3xx		046d:08a2	Labtec Webcam Pro
diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index 0befacf..3bb9f42 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -7530,6 +7530,7 @@ static const __devinitdata struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x0458, 0x700c)},
 	{USB_DEVICE(0x0458, 0x700f)},
 	{USB_DEVICE(0x0461, 0x0a00)},
+	{USB_DEVICE(0x046d, 0x089d), .driver_info = SENSOR_MC501CB},
 	{USB_DEVICE(0x046d, 0x08a0)},
 	{USB_DEVICE(0x046d, 0x08a1)},
 	{USB_DEVICE(0x046d, 0x08a2)},

--Boundary-00=_6ORVJEYcScBWqp7
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_6ORVJEYcScBWqp7--
