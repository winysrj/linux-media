Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72B2EYA021558
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 07:02:14 -0400
Received: from n8a.bullet.tw1.yahoo.com (n8a.bullet.tw1.yahoo.com
	[119.160.244.195])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m72B1wPo027482
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 07:01:59 -0400
From: Lars Oliver Hansen <lolh@ymail.com>
To: video4linux-list@redhat.com
Date: Sat, 02 Aug 2008 13:01:21 +0200
Message-Id: <1217674881.7839.2.camel@lars-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: no video device with saa7134 driver
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

Hello,

I have problems getting a video device under Ubuntu 8.04. I compiled and
installed the experimental saa7134 driver according to
http://mcentral.de/wiki/index.php5/AverMedia_Cardbus_Hybrid_TV_FM_E506R
and it shows up like this:

﻿Module                  Size  Used by
saa7134               150484  0 
video_buf              30212  1 saa7134
compat_ioctl32         11136  1 saa7134
ir_kbd_i2c             11664  1 saa7134
ir_common              43908  2 saa7134,ir_kbd_i2c
videodev               31360  1 saa7134
v4l2_common            21888  3 saa7134,compat_ioctl32,videodev
v4l1_compat            15492  2 saa7134,videodev


Yet there is no video device video0 listed under dev/. Any advice? I'm
using that AVer E506R Hybrid Cardbus card. And thanks people for your
development efforts!! Without this there would be no TV card support!

Lars
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
