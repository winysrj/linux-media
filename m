Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61460 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750747AbdBKPWM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Feb 2017 10:22:12 -0500
Received: from localhost ([37.120.85.196]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LxxNo-1cOSST1ZUi-015MHU for
 <linux-media@vger.kernel.org>; Sat, 11 Feb 2017 16:22:09 +0100
Date: Sat, 11 Feb 2017 16:22:07 +0100
From: Matthias Lay <loomy@gmx.li>
To: linux-media@vger.kernel.org
Subject: Re: dvb-s usb problems
Message-ID: <20170211162207.179b116e@gmx.li>
In-Reply-To: <20170207194055.18d31a83@gmx.li>
References: <20170207194055.18d31a83@gmx.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


tracked down the problem.

If somebody else is googling to this thread having similar problems I
wanna share my experniences.

I tested the usb devices on a simliar kernel on x86 device and it
worked well. After a lot of testing, I tracked down the problem to the
cpufreq scheduler.
needed some time to find that, as the cpu was not very busy during
recordings. it was nearly idling around 10-30%. the problem seem to be
related to the switches of the scheduler.

I am using a bananapipro with armbian, which sets the schedutil as a
default cpu scheduler. turning off the scheduler, and set it to
performance, solved my problem.

even setting the min-frequency to nearly maximum produces the problem.
not related to schedutil, same behaviour for ondemand.

so if you are reading this having similar problems on an arm soc,
switch to performance!


Greetz

Am Tue, 7 Feb 2017 19:40:55 +0100
schrieb Matthias Lay <loomy@gmx.li>:

> Hi all,
> 
> I am having some problems getting some channels to work on usb dvb-s
> devices.
> tried 2 so far a skystar and teviis660 both have the same problem.
> 
> I am about to switch from an PCI-e card to a usb hosted solution. My
> PCI-e setup (skystar too) never had any problems.
> 
> both systems on a 4.9 Kernel. Astra 19,2
> 
> Problem on the USB system
> 
> using dvb-utils scan, It doesnt find any HD channels. the only one is
> WDR HD which seems to be the only one using QPSK. the other are 8PSK I
> think. 
> 
> using mythbackend, I am able to scan and find the channels, but when
> its recording, the quality is poor with a lot of errors in the
> picture.
> 
> nothing in dmesg, but if I do a "scan -c" using dvb-utils after
> mythbackend locked one of the channels I get
> 
> ***************************************
> open("/dev/dvb/adapter0/demux0", O_RDWR|O_NONBLOCK) = 4
> ioctl(4, 0x403c6f2b, 0xbeac6f48)        = -1 EINVAL (Invalid argument)
> write(2, "start_filter:1752: ERROR: ioctl "..., 75start_filter:1752:
> ERROR: ioctl DMX_SET_FILTER failed: 22 Invalid argument ) = 75
> ioctl(4, 0x6f2a, 0x1)                   = 0
> close(4)                                = 0
> open("/dev/dvb/adapter0/demux0", O_RDWR|O_NONBLOCK) = 4
> ioctl(4, 0x403c6f2b, 0xbeac6f48)        = -1 EINVAL (Invalid argument)
> write(2, "start_filter:1752: ERROR: ioctl "..., 75start_filter:1752:
> ERROR: ioctl DMX_SET_FILTER failed: 22 Invalid argument ) = 75
> ioctl(4, 0x6f2a, 0x1)                   = 0
> close(4)                                = 0
> *********************************************************
> 
> 
> is this a known problem? you have any hint for me, where to check for
> the problem?
> 
> Greetz loomy
