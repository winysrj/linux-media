Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbZK3KmL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 05:42:11 -0500
Message-ID: <4B13A161.7050405@redhat.com>
Date: Mon, 30 Nov 2009 08:41:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: jonsmirl@gmail.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BDodiKlXqgB@lirc>
In-Reply-To: <BDodiKlXqgB@lirc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christoph Bartelmus wrote:
> Hi Jon,
> 
> on 27 Nov 09 at 12:49, Jon Smirl wrote:
> [...]
>> Christoph, take what you know from all of the years of working on LIRC
>> and design the perfect in-kernel system. This is the big chance to
>> redesign IR support and get rid of any past mistakes. Incorporate any
>> useful chunks of code and knowledge from the existing LIRC into the
>> new design. Drop legacy APIs, get rid of daemons, etc. You can do this
>> redesign in parallel with existing LIRC. Everyone can continue using
>> the existing code while the new scheme is being built. Think of it as
>> LIRC 2.0. You can lead this design effort, you're the most experience
>> developer in the IR area.
> 
> This is a very difficult thing for me to do. I must admit that I'm very  
> biased.
> Because lircd is the only userspace application that uses the LIRC kernel  
> interface, we never had any problems changing the interface when needed.
> I can't say there's much legacy stuff inside. I'm quite happy with the  
> interface.

It makes sense currently, but, once added at kernel, you won't be able
to change it again, without huge efforts. So, if the interface has any 
trouble, we need to correct it before adding at the kernel. You should
remember that a kernel driver shouldn't be bound to an specific userspace
application. So, the same kernel interface should work with all lircd's
starting from the version where the interface was added. In other words,
it should be possible to use let's say a 5 year-old lirc with a brand 
new kernel.

Also, some non lirc applications may arise, using the same kernel interface.
So, the API stability needs to be kept.

> The other thing is that I can't really move the decoder from userspace to  
> kernel because there are way too many userspace drivers that do require a  
> userspace decoder. LIRC also is running on FreeBSD, MacOS and even Cygwin.  
> So letting the userspace drivers take advantage of a potential Linux in- 
> kernel decoder is not an option for me either.

You can take advantage of a in-kernel decoder. Instead of receiving raw
pulse/space, you'll be receiving keystrokes (or scancodes).

Probably, it doesn't make sense to port every single IR protocol decoder
to kernel. We need there support for the protocols that come with the IR shipped
with the devices (I think that currently we have RC5, RC4, NEC and pulse-distance), 
and the most used procolos at the universal IR's (RC5 may be enough?).

>> Take advantage of this window to make a
>> design that is fully integrated with Linux - put IR on equal footing
>> with the keyboard and mouse as it should be.
> 
> That's a question that I have not answered for myself concludingly.
> Is a remote control really on exactly the same level as a keyboard or  
> mouse?

On some devices like STB and TV sets (most of modern LCD/Plasma TV's run Linux),
they are at the same level. I'd say that the same applies to PC's that
the user has dedicated to work as an MCE.

Cheers,
Mauro.
