Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:38212 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbZLFHOs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Dec 2009 02:14:48 -0500
Date: Sat, 5 Dec 2009 23:14:50 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jonsmirl@gmail.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091206071450.GC14651@core.coreip.homeip.net>
References: <BDodf9W1qgB@lirc> <4B14EDE3.5050201@redhat.com> <4B1524DD.3080708@redhat.com> <4B153617.8070608@redhat.com> <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com> <4B17AA6A.9060702@redhat.com> <20091203175531.GB776@core.coreip.homeip.net> <20091203163328.613699e5@pedra> <20091204100642.GD22570@core.coreip.homeip.net> <20091204121234.5144836b@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204121234.5144836b@pedra>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 04, 2009 at 12:12:34PM -0200, Mauro Carvalho Chehab wrote:
> > >
> > 
> > How related lirc-core to the current lirc code? If it is not the same
> > maybe we should not call it lirc to avoid confusion.
> 
> Just for better illustrate what I'm seeing, I broke the IR generic
> code into two components:
> 
> 	lirc core - the module that receives raw pulse/space and creates
> 		    a device to receive raw API pulse/space events;
> 
> 	IR core - the module that receives scancodes, convert them into
> 		  keycodes and send via evdev interface.
> 
> We may change latter the nomenclature, but I'm seeing the core as two different
> modules, since there are cases where lirc core won't be used (those
> devices were there's no way to get pulse/space events).
> 

OK, I think we are close but not exactly close. I believe that what you
call lirc core will be used always - it is the code that create3s class
devices, connectes decorers with the data streams, etc. I believe it
will be utilized even in case of devices using hardware decoders. That
is why we should probably stop calling it "lirc core" just tso we don't
confuse it with original lirc.

Then we have decoders and lirc_dev - which implements original lirc
interface (or maybe its modified version) and allows lircd to continue
working.

Lastly we have what you call IR core which is IR-to-input bridge of
sorts.

Right?

-- 
Dmitry
