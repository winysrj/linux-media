Return-path: <linux-media-owner@vger.kernel.org>
Received: from sr101.firestorm.ch ([80.190.193.218]:46638 "EHLO
	sr101.firestorm.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab0BVHgW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 02:36:22 -0500
From: auslands-kv@gmx.de
To: leandro Costantino <lcostantino@gmail.com>
Subject: Re: Possible memory corruption in bttv driver ?
Date: Mon, 22 Feb 2010 08:09:10 +0100
Cc: linux-media@vger.kernel.org
References: <hkcan2$72f$1@ger.gmane.org> <c2fe070d1002211757p7aace520h97bd5c8f03f9d024@mail.gmail.com>
In-Reply-To: <c2fe070d1002211757p7aace520h97bd5c8f03f9d024@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002220809.10981.auslands-kv@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Leandro

There are no crash oops available, as this is a memory corruption that occurs. 
The effects differ strongly each time.

In most cases the system just stops (as the cpu has run over some corrupted 
code). In some rare cases one can see strange program behaviour, e.g. the 
sound library libasound.so responded with a symbol not found error (in this 
case clearing the kernel cache reloaded the uncorrupted libasound code into 
memory).

After a couple of weeks of tests, I found that this memory corruption only 
occurs if:
- data from the bttv device is directly displayed on the video screen using xv 
hardware acceleration on an geode lx system

It does NOT occur if:
- data from the bttv driver is displayed on the video screen using NO hardware 
acceleration (x11)
- data from the bttv driver is transferred first to the hard disk and then (in 
a second) step displayed on the video screen using xv hardware acceleration
- data from the bttv driver is directly displayed on the video screen using xv 
hardware acceleration, but on an intel based system (also faster, more memory)
- data from a NON bttv based video card (em28xx, tw68) is directly displayed 
on the video screen using xv hardware acceleration on the geode lx system

So, that seems to be a strange interaction of the bttv driver with the geode 
lx video driver. I am pretty sure nobody will easily find this one. :-( So, we 
finally switched to a TW6805 based card using the new tw68 driver from William 
Brack.

Thanks for your consideration and best regards

Michael

Am Montag, 22. Februar 2010 schrieb leandro Costantino:
> Hi Michael,
> 
> could you attach any of the crash oops? That would be of help for bttv
> developers here.
> 
> Best Regards
> 
> On Wed, Feb 3, 2010 at 2:10 PM, Michael <auslands-kv@gmx.de> wrote:
> > Hello
> >
> > We use embedded devices running debian lenny (kernel 2.6.31.4 with bttv
> > driver 0.9.18) to monitor an incoming video signal digitized via a video
> > grabber. The /dev/video0 device is opened and closed several hundred
> > times a
> > day.
> >
> > We used to use an em28xx USB based grabber but now switched to an
> > Mini-PCI bttv card (Commel MP-878) due to USB issues.
> >
> > With the bttv card we experience different crashes, usually after a
> > couple of days, while the systems using the em28xx show none even after
> > an extended
> > time frame.
> >
> > The crashes differ strongly. We saw system freezes and also a very
> > interesting problem, where libasound.so.2 couldn't find some symbol. We
> > debugged the latter case, finding that all applications using
> > libasound.so.2
> > no longer worked, giving the same error of a symbol not found. The
> > problem could be remedied by flushing the kernel cashes (echo 1 >
> > /proc/sys/vm/drop_caches).
> >
> > So it might be possible that the systems using the bttv Mini-PCI card
> > corrupt memory after a couple of days, resulting into different failures.
> >
> > To examine the crashes I wrote a small test program, which simply opens
> > and closes the bttv video device repeatedly:
> >
> > #!/bin/bash
> >
> > count=0
> > while [ 1 == 1 ]
> > do
> >        ((count++))
> >        date; echo "COUNT = " $count
> >        mplayer -frames 10 -fs -vo xv tv:// -tv norm=pal:input=1 >
> > /dev/null sleep 0.1
> > done
> >
> > With this program I experienced full hard crashes after 85 counts, 760
> > counts and 3870 counts today, comprising between a couple of minutes and
> > hours. In all cases the hardware watchdog timer resetted the system.
> >
> > The exact same system using an USB ex28xx based grabber instead of the
> > bttv does not crash.
> >
> > 1.) Is there a way to diagnose memory corruption in order to ensure that
> > it is really a corruption problem and to locate the possible bug?
> >
> > 2.) Do newer kernel versions have improved bttv drivers (maybe even with
> > patched memory corruption issues)?
> >
> > 3.) As a last resort: Do you know of other Mini-PCI video grabber cards
> > that
> > are based on other chipsets that are supported by the kernel?
> >
> > Thanks a lot for any help
> >
> > Michael
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

