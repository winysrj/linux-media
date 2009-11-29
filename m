Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64694 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZK2MHB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 07:07:01 -0500
Date: 29 Nov 2009 13:01:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: jonsmirl@gmail.com
Cc: awalls@radix.net
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: khc@pm.waw.pl
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: lirc@bartelmus.de
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BDodiKlXqgB@lirc>
In-Reply-To: <9e4733910911270949s3e8b5ba9qfe5025d490ad0cfa@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

on 27 Nov 09 at 12:49, Jon Smirl wrote:
[...]
> Christoph, take what you know from all of the years of working on LIRC
> and design the perfect in-kernel system. This is the big chance to
> redesign IR support and get rid of any past mistakes. Incorporate any
> useful chunks of code and knowledge from the existing LIRC into the
> new design. Drop legacy APIs, get rid of daemons, etc. You can do this
> redesign in parallel with existing LIRC. Everyone can continue using
> the existing code while the new scheme is being built. Think of it as
> LIRC 2.0. You can lead this design effort, you're the most experience
> developer in the IR area.

This is a very difficult thing for me to do. I must admit that I'm very  
biased.
Because lircd is the only userspace application that uses the LIRC kernel  
interface, we never had any problems changing the interface when needed.
I can't say there's much legacy stuff inside. I'm quite happy with the  
interface.
The other thing is that I can't really move the decoder from userspace to  
kernel because there are way too many userspace drivers that do require a  
userspace decoder. LIRC also is running on FreeBSD, MacOS and even Cygwin.  
So letting the userspace drivers take advantage of a potential Linux in- 
kernel decoder is not an option for me either.
I'm having my 'LIRC maintainer' hat on mostly during this discussion and I  
do understand that from Linux kernel perspective things look different.

> Take advantage of this window to make a
> design that is fully integrated with Linux - put IR on equal footing
> with the keyboard and mouse as it should be.

That's a question that I have not answered for myself concludingly.
Is a remote control really on exactly the same level as a keyboard or  
mouse?

Christoph
