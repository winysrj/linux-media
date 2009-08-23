Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280AbZHWR7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 13:59:41 -0400
Date: Sun, 23 Aug 2009 14:59:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Fau <dalamenona@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Kernel oops with em28xx device
Message-ID: <20090823145938.3e64aa4d@pedra.chehab.org>
In-Reply-To: <4fab9a6f0908230858n24a5df5obab807a53fac94d4@mail.gmail.com>
References: <4fab9a6f0908221729n5410920fmd38bace3070105a3@mail.gmail.com>
	<4fab9a6f0908221732g8e061f3t8fc871c3a0b36337@mail.gmail.com>
	<829197380908221737h46f028ffu9b7a3b1e260f8c22@mail.gmail.com>
	<4fab9a6f0908221806k408047e6s83aa5c3902255eaa@mail.gmail.com>
	<829197380908230642q55879fc5lcc61589b1a1b775a@mail.gmail.com>
	<4fab9a6f0908230858n24a5df5obab807a53fac94d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 23 Aug 2009 17:58:44 +0200
Fau <dalamenona@gmail.com> escreveu:

> 2009/8/23 Devin Heitmueller <dheitmueller@kernellabs.com>:
> > On Sat, Aug 22, 2009 at 9:06 PM, Fau<dalamenona@gmail.com> wrote:
> >> Hi Devin,
> >> in primis thank you for your help, it's a strange thing that the DVB
> >> is not working,
> >> in the past i used the em28xx-new and it worked very well, even for the DVB-T
> >> but now the mercurial repository is empty and the mailing list is
> >> dead, don't know what happened,
> >> anyway if you need some testing just ask,
> >> thank you again,
> >
> > Markus decided to discontinue distributing his sources.
> >
> > I've got some code that will make the DVB for this device work, I just
> > need to get the work finished (in particular, a firmware extract
> > script still needs to be written).
> >
> > Devin
> >
> > --
> > Devin J. Heitmueller - Kernel Labs
> > http://www.kernellabs.com
> 
> Hi Devin,
> I've read your post on www.kernellabs.com
> so the firware extracted with the perl scritp extract_xc3028.pl in
> v4l-dvb is not in a valid form?
> I fear I'm of little help whit that, my progamming skills are very low
> and became near 0 with PERL,
> anyway I can do some tests if you need,
> thank you again,

This device requires two different firmwares: xc3028 and drx-d firmwares. The
first one can be get via the extract_xc3028.pl script. The second one needs to
be extracted from some existing driver, since Micronas (the original
manufacturer) or Trident (the actual one) never allowed the firmware
distribution for Linux.

I'm working with Devin to teach get_dvb_firmware how to copy it from some driver.

Cheers,
Mauro
