Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62050 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753893AbdBGS5d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 13:57:33 -0500
Received: from localhost ([37.120.85.196]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MJBn4-1cYQs74AfK-002sHJ for
 <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 19:40:58 +0100
Date: Tue, 7 Feb 2017 19:40:55 +0100
From: Matthias Lay <loomy@gmx.li>
To: linux-media@vger.kernel.org
Subject: dvb-s usb problems
Message-ID: <20170207194055.18d31a83@gmx.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi all,

I am having some problems getting some channels to work on usb dvb-s
devices.
tried 2 so far a skystar and teviis660 both have the same problem.

I am about to switch from an PCI-e card to a usb hosted solution. My
PCI-e setup (skystar too) never had any problems.

both systems on a 4.9 Kernel. Astra 19,2

Problem on the USB system

using dvb-utils scan, It doesnt find any HD channels. the only one is
WDR HD which seems to be the only one using QPSK. the other are 8PSK I
think. 

using mythbackend, I am able to scan and find the channels, but when
its recording, the quality is poor with a lot of errors in the picture.

nothing in dmesg, but if I do a "scan -c" using dvb-utils after
mythbackend locked one of the channels I get

***************************************
open("/dev/dvb/adapter0/demux0", O_RDWR|O_NONBLOCK) = 4
ioctl(4, 0x403c6f2b, 0xbeac6f48)        = -1 EINVAL (Invalid argument)
write(2, "start_filter:1752: ERROR: ioctl "..., 75start_filter:1752:
ERROR: ioctl DMX_SET_FILTER failed: 22 Invalid argument ) = 75
ioctl(4, 0x6f2a, 0x1)                   = 0
close(4)                                = 0
open("/dev/dvb/adapter0/demux0", O_RDWR|O_NONBLOCK) = 4
ioctl(4, 0x403c6f2b, 0xbeac6f48)        = -1 EINVAL (Invalid argument)
write(2, "start_filter:1752: ERROR: ioctl "..., 75start_filter:1752:
ERROR: ioctl DMX_SET_FILTER failed: 22 Invalid argument ) = 75
ioctl(4, 0x6f2a, 0x1)                   = 0
close(4)                                = 0
*********************************************************


is this a known problem? you have any hint for me, where to check for
the problem?

Greetz loomy
