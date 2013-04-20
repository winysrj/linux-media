Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:41247 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3DTTFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Apr 2013 15:05:24 -0400
Received: by mail-bk0-f49.google.com with SMTP id w12so2132305bku.8
        for <linux-media@vger.kernel.org>; Sat, 20 Apr 2013 12:05:22 -0700 (PDT)
Message-ID: <5172E6EF.9000506@googlemail.com>
Date: Sat, 20 Apr 2013 21:05:19 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: =?UTF-8?B?SmVhbi1GcmFuw6dvaXMgTW9pbmU=?= <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: sicco@ddo.nl
Subject: [gspca] Green/garbled/black webcam [0x0ac8 0xc002] output for Sony
 VGN-FE21M laptop
References: <20130420175128.27763.4907.malone@wampee.canonical.com>
In-Reply-To: <20130420175128.27763.4907.malone@wampee.canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I could need some help with this Ubuntu bug report:
https://bugs.launchpad.net/ubuntu/+source/v4l-utils/+bug/1134565

Is there known error in the gspca driver that is causing this kernel log:
[ 2830.890605] gspca_main: ISOC data error: [27] len=0, status=-71

v4l-info reports the following:
     VIDIOC_QUERYCAP
 	driver                  : "vc032x"
 	card                    : "USB2.0 Web Camera"
 	bus_info                : "usb-0000:00:1d.7-8"
 	version                 : 3.2.40
 	capabilities            : 0x5000001 [VIDEO_CAPTURE,READWRITE,STREAMING]

Or is this the result of broken hardware?

Thanks,
Gregor
