Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35343 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab1FEVrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jun 2011 17:47:42 -0400
Received: by wya21 with SMTP id 21so2396246wya.19
        for <linux-media@vger.kernel.org>; Sun, 05 Jun 2011 14:47:41 -0700 (PDT)
Subject: Re: DM04 USB DVB-S TUNER
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mehmet Altan Pire <baybesteci@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1307306576.2064.13.camel@localhost>
References: <4DEACF3F.9090305@gmail.com>
	 <1307283393.22968.12.camel@localhost> <4DEBB00D.4040202@gmail.com>
	 <1307306576.2064.13.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Jun 2011 22:47:35 +0100
Message-ID: <1307310455.2547.9.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-06-05 at 21:42 +0100, Malcolm Priestley wrote:
> On Sun, 2011-06-05 at 19:34 +0300, Mehmet Altan Pire wrote:
> > 05-06-2011 17:16, Malcolm Priestley yazmış:
> > > On Sun, 2011-06-05 at 03:35 +0300, Mehmet Altan Pire wrote:
> > >> Hi,
> > >> I have "DM04 USB DVBS TUNER", using ubuntu with v4l media-build
> > >> drivers/modules but device  doesn't working (unknown device).
> > >>
> > >> lsusb message:
> > >> ID 3344:22f0
> > >>
> > >> under of the box:
> > >> DM04P2011050176
> > >
> > Yes, i have windows xp driver, name is "US2B0D.sys" I sending it,
> > attached in this mail. Thanks. 
> 
> Here is a modified lmedm04.c and lme2510b_fw.sh using the US2B0D.sys
> 
> Tested here, it appears to work with the sharp7395 tuner.
> 
> Are you sure it works under Windows?  I can't find your ID in the
> US2B0D.sys file. It may be a blank lme2510c chip.
> 
> I assume you are using the lastest media_build to update driver then
> over write lmedm04.c 
> 
> found in;
> media_build/linux/drivers/media/dvb/dvb-usb
> 
> If already build, just a make and sudo make install is required.
I have done some further tests with this firmware and it does not return
the correct signal lock data. By default the signal lock returns the
last good lock and updated by interrupt. This just means when lock is
lost the driver still returns lock.

I will need to modify the interrupt return.

However, it may be a different tuner.

tvboxspy




