Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761818AbZJNObw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 10:31:52 -0400
Date: Wed, 14 Oct 2009 11:30:35 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Giuseppe Borzi <gborzi@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx DVB modeswitching change: call for testers
Message-ID: <20091014113035.5f8a2681@pedra.chehab.org>
In-Reply-To: <829197380910140711l7624c0c8va474156f712580a4@mail.gmail.com>
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
	<20091014122550.7c84bba5@ieee.org>
	<829197380910140612t726251d6y7cff3873587101b4@mail.gmail.com>
	<20091014160626.70db928b@ieee.org>
	<829197380910140711l7624c0c8va474156f712580a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 14 Oct 2009 10:11:48 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Wed, Oct 14, 2009 at 10:06 AM, Giuseppe Borzi <gborzi@gmail.com> wrote:
> > Hello Devin,
> > I did as you suggested. Unplugged the stick reboot and plug it again.
> > And just to be sure I did it two times. Now the device works, but it is
> > unable to change channel. That is to say, when I use the command "vlc
> > channels.conf" it tunes to the first station in the channel file and
> > can't change it. Other apps (xine, kaffeine) that seems to change to
> > the latest channel don't work at all. The dmesg output after plugging
> > the driver is in attach. In dmesg I noticed lines like this
> >
> > [drm] TV-14: set mode NTSC 480i 0
> >
> > I suppose this hasn't anything to do with the analog audio problem, but
> > just to be sure I ask you. Also, using arecord/aplay for analog audio I
> > get an "underrun" error message
> >
> > arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE | aplay -
> > Recording WAVE 'stdin' : Signed 16 bit Little Endian, Rate 32000 Hz,
> > Stereo Playing WAVE 'stdin' : Signed 16 bit Little Endian, Rate 32000
> > Hz, Stereo underrun!!! (at least -1255527098942.108 ms long)
> >
> > Cheers.
> 
> Ok, let me look at the code and see what I can figure out.

Devin,

You can't simply remove the DVB gpio setup there. It is used when you change
from analog/digital, when you restore from hibernation and to turn on the demod
on hybrid devices, and to turn it off after stopping DVB. If you're having troubles
there, then probably the DVB demod poweron/reset gpio sequence is wrong or
incomplete.
> 
> Devin
> 




Cheers,
Mauro
