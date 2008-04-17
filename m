Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3HAj1We004829
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 06:45:01 -0400
Received: from scin52.mxsweep.com (mail.station1.mxsweep.com [212.147.136.149])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3HAiYK2020142
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 06:44:37 -0400
Message-ID: <480729F3.8090606@draigBrady.com>
Date: Thu, 17 Apr 2008 11:44:03 +0100
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Hauppauge 950Q
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

Hi,

I just got 2 USB TV devices here that I would like to get just
analog TV support working for a start:

2040:7200 = Hauppauge WINTV HVR 950Q
0CCD:0072 = Terratec Cinergy hybrid T USB XS FM

I plugged both into a fedora 9 (2.6.25) box and neither were recognized.

Now in the just released 2.6.25 official kernel I notice only
support for the Hauppauge WINTV HVR 950 (2040:6513),
and 0CCD:0042 & 0CCD:0047 Terratec devices.

Note the difference between 950 and 950Q is that the 950 Q is QAM enabled
allowing the detection of digital channels over US cable systems while the
950 allows only terrestrial digital channel detection.

So do I just add the new device IDs and hope for the best?
Also I need to back port support to the fedora core 5 kernel (2.6.17),
so any gotchas you can think of doing that would be appreciated.

thanks,
Pádraig.

p.s. I noticed the HVR 950 specific tree also didn't have support for these IDs:
http://linuxtv.org/hg/~mkrufky/hvr950/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
