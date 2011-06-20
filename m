Return-path: <mchehab@pedra>
Received: from yop.chewa.net ([91.121.105.214]:48400 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab1FTTk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 15:40:57 -0400
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] vtunerc - virtual DVB device driver
Date: Mon, 20 Jun 2011 22:40:49 +0300
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com> <201106202037.19535.remi@remlab.net> <BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
In-Reply-To: <BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106202240.50029.remi@remlab.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

	Hello again,

Le lundi 20 juin 2011 20:41:44 Devin Heitmueller, vous avez écrit :
> > Some might argue that CUSE can already do this. Then again, CUSE would
> > not be able to reuse the kernel DVB core infrastructure: everything
> > would need to be reinvented in userspace.
> 
> Generally speaking, this is the key reason that "virtual dvb" drivers
> have been rejected in the past for upstream inclusion - it makes it
> easier for evil tuner manufacturers to leverage all the hard work done

Err? My point is exactly the opposite: without a dedicated virtual DVB device, 
(open-source) developers are stuck with CUSE, which if it would work at all, 
would be a major waste of effort. And then, it won't work for unprivileged 
processes due to CUSE ioctl's restrictions.

In other words, my point was technical, not political.

> by the LinuxTV developers while providing a closed-source solution.

This does not enable much that evil closed-source device vendors couldn't 
already do. Virtually any Linux-DVB-capable tool will also accept MPEG-TS feed 
piped from standard input. Tuning would have to use a dedicated interface; 
that's pretty much the only inconvenience.

DVB_NET can be implemented with the TUNTAP driver easily if it comes to that. 
And remote control can be mulated with the uinput driver all the same. There 
is even a mem2mem V4L2 device nowadays, is there not? And while uinput and 
tuntap allow proprietary userspace drivers, they come with major limitations 
inherent to userspace which limit their usefulness for proprietary device 
drivers.

FWIW, virtual device driver enables (open-source) innovation. There are 
countless useful IP tunnels or emulators using TUN or TAP for instance.

> It was an explicit goal to *not* allow third parties to reuse the
> Linux DVB core unless they were providing in-kernel drivers which
> conform to the GPL.

I am afraid I don't understand how is Linux-DVB different from other Linux 
subsystems, such as the (much larger in terms of non-driver-specific code) 
networking one.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
