Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58645 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab0A2S5M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 13:57:12 -0500
Received: by bwz27 with SMTP id 27so1717113bwz.21
        for <linux-media@vger.kernel.org>; Fri, 29 Jan 2010 10:57:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B632BB8.3000904@redhat.com>
References: <4B60F901.20301@redhat.com>
	 <1264731845.3095.16.camel@palomino.walls.org>
	 <829197381001290922p69a68ce5k3f5192f427f4658a@mail.gmail.com>
	 <4B632BB8.3000904@redhat.com>
Date: Fri, 29 Jan 2010 13:57:10 -0500
Message-ID: <829197381001291057o5b94d1d7k4d5f7f6d7251101f@mail.gmail.com>
Subject: Re: cx18 fix patches
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@radix.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 29, 2010 at 1:40 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> I doubt it would solve. IMO, having it modular is good, since you may not
> need cx18 alsa on all devices.

Modularity is good, but we really need to rethink about the way we are
loading these modules (this applies to dvb as well).  For example, on
em28xx, the dvb module is often getting loaded while at the same that
hald is connecting to the v4l2 device (resulting in i2c errors while
attempting to talk to tvp5150).  A simple initialization lock would
seem like a good idea, except that doesn't really work because the
em28xx submodules get loaded asynchronously.  And the problem isn't
specific to em28xx by any means.  I've hit comparable bugs in cx88.

If we didn't load the modules asynchronously, then at least we would
be able to hold the lock throughout the entire device initialization
(ensuring that nobody can connect to the v4l2 device while the dvb and
alsa drivers are initializing).  Sure, it in theory adds a second or
two to the module load (depending on the device), but we would have a
much simpler model that would be less prone to race conditions.  We
would also lose the ability to modprobe the dvb module after-the-fact
(and expect it to bind to existing devices), but I don't really think
that would be a big deal since everything is auto-detected anyway.  In
fact, it might actually be a good thing given the number of times I've
had to explain to people that you cannot do "modprobe em28xx-dvb" on
an unsupported device and expect it to magically start working.

I didn't mean to hijack the thread, but I'm just trying to point out
that this is a pretty widespread problem, and not specific to cx18.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
