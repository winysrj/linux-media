Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.243])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <filippo.argiolas@gmail.com>) id 1JRlGB-0001w5-1i
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 10:29:03 +0100
Received: by an-out-0708.google.com with SMTP id d18so1071829and.125
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 01:28:58 -0800 (PST)
From: Filippo Argiolas <filippo.argiolas@gmail.com>
To: Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
References: <1203434275.6870.25.camel@tux>
	<Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
Date: Wed, 20 Feb 2008 10:27:45 +0100
Message-Id: <1203499665.7026.66.camel@tux>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700
	ir	receiver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Il giorno mar, 19/02/2008 alle 22.14 +0100, Patrick Boettcher ha
scritto:
> That indeed looks OK to my eyes. I have to admit that I never took a look 
> into the IR-code from DiBcom...
> 
> In any case, especially to that problem with "unknown key code" I think it 
> is time to change the IR-behavior of the DVB-USB.
> 
> My problem is, I don't know how.
> 
> My naive idea would be, that the IR-code is reporting each key (as raw as 
> possible) without mapping it to an event to the event interface and then 
> someone, somewhere is interpreting it. Also forward any repeat-attribute.
> 
> Those endless tables in a lot of dvb-usb drivers are annoying me, firstly 
> because they are endless and huge, and secondly, they are never complete. 
> If there is an adequate replacement from userspace (somehow loading 
> key-lists to the event-layer or in the worst case, to the 
> dvb-usb-framework) would be a good solution.
> 
> Filippo, it seems you understand quite some thing around that. Do you know 
> if what I'm saying is somehow possible?

Patrick, your doubts are the same that I've felt when, a few days ago, I
started looking at the dib0700 code.
I thinked why the driver decode events and binds them to a keymap
instead of passing them raw to a user space tool (lirc?)? This prevents
me to easily add a custom keymap for commercial remotes or even add a
keymap for the remotes I have. So my device can decode most of my
remote controllers but I cannot use them without editing the kernel code from
development branch.
Later I understood the idea behind all this:
as Nicolas said binding keypress to an event interface turns the remote
into a common input interface that works everywhere without additional
user space tools and without difficult per-app configurations. So I
think that current behavior is somewhat sane even if it lacks of a
simple system (from a user point of view) to add more keymaps or edit
current ones.
Please note that this behavior does not conflict with having different
settings for different application, since this is achievable configuring
lirc. 

Another problem (as far as I understood with a quick look at the code)
is that each different driver, being written by different people, faces
the whole thing in different ways. As you said almost each driver has
its own keymaps and its own methods to present events to the input
interface.
For example I've seen some effort towards a unified system in
dvb-usb-remote.c but dib0700 seems not to use it.

Regarding ir-common (as Darren suggested), after a quick look it seems
more a framework for decoding remote events but it cannot be extended to
all the devices since many of them do the decoding stuff on their own
outputting directly decoded data that only has to be binded to a keymap
and to an event device.
I think that all the drivers should output keypress decoded data in a
common format to be passed to a common framework that binds it to common
keymaps (better if user customizable in some way) and generates input
events.

I don't know yet how this could be done and maybe it involves some work
rewriting the ir stuff. So I think in the meanwhile my patch could be
merged (if you think it's good) waiting for this work to be done.
I'll take a deeper look at the code but I don't know if I'm able to do
this thing, I've read kernel code a few days ago for the very first time
and I've written the patch just because a I needed the repeat feature :)

Regards,

Filippo





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
