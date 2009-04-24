Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:44975 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437AbZDXNhA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2009 09:37:00 -0400
Received: by bwz7 with SMTP id 7so1097147bwz.37
        for <linux-media@vger.kernel.org>; Fri, 24 Apr 2009 06:36:59 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 24 Apr 2009 16:36:59 +0300
Message-ID: <c83f72c70904240636y320e1fc3u97cd592835410413@mail.gmail.com>
Subject: About "unknown field specified in initializer" error
From: Behzat Erte <b3hzat@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
