Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HMw6VM013608
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 18:58:06 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7HMvuvb022397
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 18:57:56 -0400
Received: by ug-out-1314.google.com with SMTP id m2so110945uge.13
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 15:57:56 -0700 (PDT)
Message-ID: <48A8ACFB.4070506@gmail.com>
Date: Sun, 17 Aug 2008 18:58:03 -0400
From: rob <susegebr@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: troubles with my webcam and kernel 2.6.27.rc3  Msi StarCam  0xc45
 0x60fc   sn9c105  hv7131r   with mic
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

Hello all

This is my first post to this list


i have troubles with my webcam and kernel 2.6.27.rc3  (Opensuse)
there are modules loaded gspca  sonic sn9s102 
but no program sees the webcam
The webcam is   Msi StarCam  0xc45 0x60fc   sn9c105  hv7131r   with mic


With the gspcav1 drivers compiled on kernel 2.6.25.11-0.1 (opensuse)
the webcam is seen as a v4L1 webcam see  log below

his is the outcome from the gspca compiled  by me:  om kernel 2.6.25.11
/home/rob/gspcav1-20071224/gspca_core.c: USB GSPCA camera found. SONIX
JPEG (sn9c1xx)
/home/rob/gspcav1-20071224/gspca_core.c: [spca5xx_probe:4275] Camera
type JPEG
/home/rob/gspcav1-20071224/gspca_core.c: [spca5xx_getcapability:1249]
maxw 640 maxh 480 minw 160 minh 120
usbcore: registered new interface driver gspca
/home/rob/gspcav1-20071224/gspca_core.c: gspca driver 01.00.20 registered
/home/rob/gspcav1-20071224/gspca_core.c: [spca5xx_set_light_freq:1932]
Sensor currently not support light frequency banding filters.
/home/rob/gspcav1-20071224/gspca_core.c: [gspca_set_isoc_ep:945] ISO
EndPoint found 0x81 AlternateSet 8



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
