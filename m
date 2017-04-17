Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48409
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932404AbdDQBzk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 21:55:40 -0400
Date: Sun, 16 Apr 2017 22:55:33 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Anders Eriksson <aeriksson2@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: em28xx i2c writing error
Message-ID: <20170416225533.6d83fc6c@vento.lan>
In-Reply-To: <CAGncdOYtM3PkJWDcBdSdONY8VbP5gDccBO777=j+ARQFXQMJBw@mail.gmail.com>
References: <CAGncdOYtM3PkJWDcBdSdONY8VbP5gDccBO777=j+ARQFXQMJBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Apr 2017 20:28:20 +0200
Anders Eriksson <aeriksson2@gmail.com> escreveu:

> Hi Mauro,
> 
> I've two devices using this driver, and whenever I have them both in
> use I eventually (between 10K and 100K secs uptime) i2c write errors
> such as in the log below. If only have one of the devices in use, the
> machine is stable.
> 
> The machine never recovers from the error.
> 
> All help apreciated.
> -Anders
> 
> 
> 
> [    0.000000] Booting Linux on physical CPU 0xf00
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 4.4.15-v7+ (dc4@dc4-XPS13-9333) (gcc
> version 4.9.3 (crosstool-NG crosstool-ng-1.22.0-88-g8460611) ) #897
> SMP Tue Jul 12 18:42:55 BST 2016
> [    0.000000] CPU: ARMv7 Processor [410fc075] revision 5 (ARMv7), cr=10c5387d
> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing
> instruction cache
> [    0.000000] Machine model: Raspberry Pi 2 Model B Rev 1.1

Hmm.. RPi2... that explains a lot ;)

I've seen similar behaviors on some arm devices with just one device.

That's likely due to some problem with isochronous transfers at the
USB host driver.

The thing is that ISOC transfers are heavily used by USB cameras:
they require that the USB chip would provide a steady throughput
that can eat up to 60% of the USB maximum bitrate, with just one
video stream.

My experience says that several USB drivers can't sustain such
bit rates for a long time.

The RPi tree uses an out-of-tree driver for the USB host driver
(otgdwc - I guess). Upstream uses a different driver (dwc2).
My recent experiences with upstream(dwc2) and USB cameras
is even worse: it doesn't work, if the camera supports only
ISOC frames.

I'll eventually try to fix the upstream driver if I find
spare time for it, but I won't touch at the proprietary
driver that is shipped with the downstream Kernel.

Thanks,
Mauro
