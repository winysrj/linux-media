Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37885 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbaIZOZR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 10:25:17 -0400
Message-ID: <54257743.6050509@osg.samsung.com>
Date: Fri, 26 Sep 2014 08:25:07 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: em28xx breaks after hibernate
References: <20140925181747.GA21522@linuxtv.org> <542462C4.7020907@osg.samsung.com> <20140926080030.GB31491@linuxtv.org> <20140926080824.GA8382@linuxtv.org> <20140926071411.61a011bd@recife.lan> <20140926110727.GA880@linuxtv.org> <20140926084215.772adce9@recife.lan> <20140926090316.5ae56d93@recife.lan> <20140926122721.GA11597@linuxtv.org> <20140926101222.778ebcaf@recife.lan> <20140926132513.GA30084@linuxtv.org>
In-Reply-To: <20140926132513.GA30084@linuxtv.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/26/2014 07:25 AM, Johannes Stezenbach wrote:
> On Fri, Sep 26, 2014 at 10:12:22AM -0300, Mauro Carvalho Chehab wrote:
>> Try to add a WARN_ON or printk at em28xx_usb_resume().
> 
> It is called two times, once during hibernate and once during resume:
> 

> root@debian:~# echo disk >/sys/power/state

On the upside this does look similar to what I have seen when
I was debugging suspend/resume on pctv stick that uses em28xx
and drx39xyj

One thing that helped me debug the problem is testing
hibernate in platform mode (which is default) and then
Hibernate in reboot mode.

I enabled usb debug and device debug to see what is happening
at the usb-core and ran the following cases:
I enable pm trace:
echo 1 > /sys/power/pm_trace

Hibernate in platform mode (default and recommended hibernation mode)
echo platform > /sys/power/disk
echo disk > /sys/power/state

Hibernate in reboot mode: (usb bus could go through loss of power as
platform might not maintain power to the buses). reset_resume should
recover from loss of power or have the force disconnect path handle the
case. i.e don't install reset_resume

echo reboot > /sys/power/disk
echo disk > /sys/power/state

I also simply selected suspend from the GUI, this seems to
take the usb-bus through a different path.

These behave differently when reset_resume is installed vs.
not installed. In our case, reset_resume simply points to
resume which can't handle the power loss case. It would be
good to get data on these different scenarios. I wish I have
the WinTV 930, but I don't.

If we have full debug for the above three scenarios, it would
help debug it further. I also do the following to see resume
works in a simple case: no disk involved suspend to ram

echo mem > /sys/power/state

I am looking at drxk to see if I can figure out anything.
Also I dumped em28xx eprom to see if looks ok during these
tests.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
