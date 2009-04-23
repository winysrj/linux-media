Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3NJYXux022314
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 15:34:33 -0400
Received: from mail-fx0-f166.google.com (mail-fx0-f166.google.com
	[209.85.220.166])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3NJYIX4029404
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 15:34:18 -0400
Received: by fxm10 with SMTP id 10so539322fxm.3
	for <video4linux-list@redhat.com>; Thu, 23 Apr 2009 12:34:18 -0700 (PDT)
From: Behzat Erte <b3hzat@gmail.com>
To: video4linux-list@redhat.com
Date: Thu, 23 Apr 2009 22:34:22 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200904232234.22645.behzaterte@gmail.com>
Content-Transfer-Encoding: 8bit
Subject: About "unknown field specified in initializer" error
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

Hello everyone,

I've some trouble with usb webcam driver. I am newbie for drivers and it's 
really strange. 


static struct video_device usbcam_videodev_template = {
        .name                   = "usbcam-unknown",
        .type                   =  VFL_TYPE_GRABBER,
        .type2                  =  VID_TYPE_CAPTURE,
        .minor                  = -1,
        .release                = usbcam_videodev_release,
};

::: error :::
/home/home/Desktop/sq930-dev/usbcam_dev.c:133: error: unknown field ‘type’ 
specified in initializer
/home/home/Desktop/sq930-dev/usbcam_dev.c:134: error: unknown field ‘type2’ 
specified in initializer

By the way this driver is sq930(i used for creative laptop webcam) and it was 
written for 2.6.17 -2.6.23 but I use 2.6.29.

Than again, I try to change with normal varible that defines, like 
VFL_TYPE_GRABBER is 0 and VID_TYPE_CAPTURE is 1. 

Could you give me any advice about this situation?

Thanks & Regards
Behzat.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
