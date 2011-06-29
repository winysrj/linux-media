Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:59209 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab1F2Vyi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 17:54:38 -0400
Message-ID: <4E0B9F18.7060304@infradead.org>
Date: Wed, 29 Jun 2011 18:54:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	trivial@kernel.org
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver
 version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from
 include/
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>	<alpine.LNX.2.00.1106232356530.17688@swampdragon.chaosbits.net>	<4E04732A.3060305@infradead.org>	<201106241326.27593.hverkuil@xs4all.nl> <BANLkTinXymR_2A2Mr+UbhK63s2xjtK=B=g@mail.gmail.com>
In-Reply-To: <BANLkTinXymR_2A2Mr+UbhK63s2xjtK=B=g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 24-06-2011 09:20, Devin Heitmueller escreveu:

> Also, it screws up the ability for users to get fixes through the
> media_build tree (unless you are increasing the revision constantly
> with every merge you do).

Patches merged, and media_build modified in order to use the V4L2 stack
version, instead of the kernel one.

So, while I'm using a 2.6.32 kernel:

$ uname -a
Linux pedra 2.6.32-131.0.15.el6.x86_64 #1 SMP Tue May 10 15:42:40 EDT 2011 x86_64 x86_64 x86_64 GNU/Linux

Driver reports version 3.0.0:

$ v4l2-ctl -D
Driver Info (not using libv4l2):
	Driver name   : vivi
	Card type     : vivi
	Bus info      : vivi-000
	Driver version: 3.0.0
	Capabilities  : 0x05000001
		Video Capture
		Read/Write
		Streaming

It may be a good idea to increment the extraver number to be, for example, 3.0.99 (or to just
decrement 1 number), in order to reflect that this driver is not the vanilla 3.0.0, but, 
instead, a backported one, otherwise, it will report the version from the last git backport
we merge at media_tree.git.

If we just subtract 1, we'll have (right now):

$ v4l2-ctl -D
Driver Info (not using libv4l2):
	Driver name   : vivi
	Card type     : vivi
	Bus info      : vivi-000
	Driver version: 2.255.255
	Capabilities  : 0x05000001
		Video Capture
		Read/Write
		Streaming

Which looks somewhat weird, but, after the 3.1 merge window, it will be
3.0.255, with would be nice. So, if we go this way, the better is to wait
until 3.1-rc1 before applying it.

Comments?

PS.: The media_build is not optimized in the sense that a version increment 
will make it recompile everything. I'll likely fix it if it bothers me enough ;)

Thanks,
Mauro

