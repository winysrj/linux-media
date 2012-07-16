Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway05.websitewelcome.com ([67.18.144.2]:58360 "EHLO
	gateway05.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918Ab2GPR4Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 13:56:25 -0400
Received: from gator886.hostgator.com (gator886.hostgator.com [174.120.40.226])
	by gateway05.websitewelcome.com (Postfix) with ESMTP id 18D5FBB07C839
	for <linux-media@vger.kernel.org>; Mon, 16 Jul 2012 12:50:16 -0500 (CDT)
From: "Charlie X. Liu" <charlie@sensoray.com>
To: <llarevo@gmx.net>, <linux-media@vger.kernel.org>
References: <1342265363.2362.12.camel@tbastian-desktop.localdomain>
In-Reply-To: <1342265363.2362.12.camel@tbastian-desktop.localdomain>
Subject: RE: libv4l2: error dequeuing buf: Resource temporarily unavailable
Date: Mon, 16 Jul 2012 10:50:19 -0700
Message-ID: <000901cd637b$77c9e620$675db260$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Your driver load may not be quite right or got some conflicts. According to: http://www.kernel.org/doc/Documentation/video4linux/CARDLIST.saa7134, the Terratec Cinergy 400 TV should be card=8. Have you tried: restart, "modprobe -r saa7134", "modprobe saa7134 card=8", "dmesg | grep saa7134", and checked if the Terratec Cinergy 400 TV showed up correctly? If right, it should be Ok:

ffmpeg -f video4linux2 -i /dev/video0 out.mpg
ffmpeg -t 30 -f video4linux2 -s vga -r 30 -b 2000k -i /dev/video0 out-vga-2M-30sec.mpg
ffmpeg -t 60 -f video4linux2 -s vga -r 30 -b 2000k -i /dev/video0 out-vga-2M-60sec.avi
..., etc.


-----Original Message-----
From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of llarevo@gmx.net
Sent: Saturday, July 14, 2012 4:29 AM
To: linux-media@vger.kernel.org
Subject: libv4l2: error dequeuing buf: Resource temporarily unavailable

Hi,

I'm not sure, if this is the right list, if I'm wrong here, a hint for a appropriate place for my questions would be very appreciated.

I have a problem with an analog Terratec Cinergy 400 TV. When I try to capture with ffmpeg, 

ffmpeg -f video4linux2 -i /dev/video0 out.mpg

I get the error

libv4l2: error dequeuing buf: Resource temporarily unavailable

I'm using Fedora F17. 

The behavior seems to be pretty strange to me, because xawtv, mencoder, mplayer and tvtime don't have a problem with the hardware at all, ffmpeg has got this problem only with the hardware mentioned above, with a Terratec Cinergy XS, ffmpeg captures without problems.

Why reports libv4l2 "Resource temporarily unavailable"? What are common reasons for that message? What can be a reason that creates the message only on specific hardware (Terratec Cinergy 400 TV)?

Thanks a lot in advance. 

--
Felix


--
To unsubscribe from this list: send the line "unsubscribe linux-media" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

