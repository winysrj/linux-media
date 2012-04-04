Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway04.websitewelcome.com ([69.93.179.22]:40793 "EHLO
	gateway04.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932282Ab2DDSif (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Apr 2012 14:38:35 -0400
Received: from gator886.hostgator.com (gator886.hostgator.com [174.120.40.226])
	by gateway04.websitewelcome.com (Postfix) with ESMTP id A865E293ED165
	for <linux-media@vger.kernel.org>; Wed,  4 Apr 2012 13:05:03 -0500 (CDT)
From: "Charlie X. Liu" <charlie@sensoray.com>
To: "'xige'" <evaxige@gmail.com>, <linux-media@vger.kernel.org>
References: <CALnQqNDFMdoxjX+hiLDsK=O0Z=GXKLQGwQaBt5OohAJ+F4gydA@mail.gmail.com>
In-Reply-To: <CALnQqNDFMdoxjX+hiLDsK=O0Z=GXKLQGwQaBt5OohAJ+F4gydA@mail.gmail.com>
Subject: RE: Can't capture fluent video with bt878 card (Osprey 210)
Date: Wed, 4 Apr 2012 11:05:40 -0700
Message-ID: <001d01cd128d$8bdabf70$a3903e50$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Have you tried TVTime and/or XawTV? Also, you may try "streamer -c
/dev/video0 -n pal -s 640x480 -r 2 -t 10 -o image_00.jpeg" to confirm it's
really a field order issue. 

The VLC is tricky. You have to specify the options right to get a good
preview or recording.


-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of xige
Sent: Tuesday, April 03, 2012 7:49 PM
To: linux-media@vger.kernel.org
Subject: Can't capture fluent video with bt878 card (Osprey 210)

Hi, everyone

I found a problem with bt878 card under Linux(2.6 ~ 3.x) by v4l2 interface
when I got a raw frame, but it looks like combined with wrong field order.
In other words, I will received Top Bottom Top Bottom... fields sequences in
theory. But now I got random sequence.

My test hardware blew:
HW:
 Xeon 5606, 4G, Asus Z8ND6C
Core i7 980, 4G, Asus P6T

Capture Card:
Osprey 210

OS:
Ubuntu 10.04
Ubuntu 11.10

SW:
VLC 1.0.6 & 1.1.12

Please give me some advice?

PS.
     In attach, that's a video snapshot.
     English not mine mother tongue, sorry my poor English.

