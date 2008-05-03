Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m43CD6Y8011805
	for <video4linux-list@redhat.com>; Sat, 3 May 2008 08:13:06 -0400
Received: from omta0102.mta.everyone.net (imta-38.everyone.net
	[216.200.145.38])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m43CCrnI013185
	for <video4linux-list@redhat.com>; Sat, 3 May 2008 08:12:53 -0400
Received: from sj1-dm04.mta.everyone.net (sj1-slb03-gw2 [172.16.1.96])
	by omta0102.mta.everyone.net (Postfix) with ESMTP id 8BE5B6BB613
	for <video4linux-list@redhat.com>; Sat,  3 May 2008 05:11:49 -0700 (PDT)
Received: by sj1-dm04.mta.everyone.net (EON-AUTHRELAY2 - c198dd4f) id
	sj1-dm04.4819fc67.35e37
	for <video4linux-list@redhat.com>; Sat, 3 May 2008 05:11:36 -0700
From: "John Ortega" <jortega@listpropertiesnow.com>
To: <video4linux-list@redhat.com>
Date: Sat, 3 May 2008 08:11:35 -0400
Message-ID: <EEEHJJMABEBDCNKAINKCMEBMCHAA.jortega@listpropertiesnow.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Subject: Pinnacle PCTV usb2 PAL EUROPE
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

Hello all (Markus if you're there),

I've successfully installed my device with the v4l libraries (stable) but I
can not get the remote to work. I've attempted various different options
such as:

1) recompile the v4l library changing the em28xx-input.c code to 0xFE
instead of 0x00
2) install lirc using the ic option
3) modprobing ir_kbd_i2 and later bttv
4) irrecord, irw, xev

None of the above work.

I've received errors such as major number 81 or 13 incorrect.
I've also seen the device in /proc/bus/input/devices as /class/input/input6
then tried to cat the /dev/input/...6 part and nothing.

Please someone help me!

Thanks,
John Ortega
www.listpropertiesnow.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
