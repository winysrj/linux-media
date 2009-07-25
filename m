Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6PLXSSw008613
	for <video4linux-list@redhat.com>; Sat, 25 Jul 2009 17:33:28 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n6PLXDFP004266
	for <video4linux-list@redhat.com>; Sat, 25 Jul 2009 17:33:13 -0400
Received: by fg-out-1718.google.com with SMTP id l27so266890fgb.7
	for <video4linux-list@redhat.com>; Sat, 25 Jul 2009 14:33:13 -0700 (PDT)
From: Denis Loginov <dinvlad@gmail.com>
To: amol.debian@gmail.com
Date: Sun, 26 Jul 2009 00:32:56 +0300
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907260032.57292.dinvlad@gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: driver for 041e:4055 Creative Technology, Ltd Live! Cam Video IM
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

Try adding this line:
       {USB_DEVICE(0x041e, 0x4055), .driver_info = SENSOR_TAS5130C_VF0250},
after
       {USB_DEVICE(0x041e, 0x4053), .driver_info = SENSOR_TAS5130C_VF0250},
if file /usr/src/linux/drivers/media/video/gspca/zc3xx.c
then choose in Device Drivers -> Multimedia Devices -> Video Capture Adapters 
-> V4L USB Devices -> GSPCA based webcams -> (M) ZC3XX USB Camera Driver
and reinstall kernel modules.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
