Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44384 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab1FGTfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 15:35:00 -0400
Received: by wya21 with SMTP id 21so3819855wya.19
        for <linux-media@vger.kernel.org>; Tue, 07 Jun 2011 12:34:59 -0700 (PDT)
Subject: Re: DM04 USB DVB-S TUNER
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mehmet Altan Pire <baybesteci@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1307424701.2117.13.camel@localhost>
References: <4DEACF3F.9090305@gmail.com>
	 <1307283393.22968.12.camel@localhost> <4DEBB00D.4040202@gmail.com>
	 <1307306576.2064.13.camel@localhost> <1307310455.2547.9.camel@localhost>
	 <4DED628E.9070502@gmail.com>  <1307424701.2117.13.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 20:34:50 +0100
Message-ID: <1307475290.3453.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-06-07 at 06:31 +0100, Malcolm Priestley wrote:
> On Tue, 2011-06-07 at 02:28 +0300, Mehmet Altan Pire wrote:
> > 06-06-2011 00:47, Malcolm Priestley yazmış:
> > > On Sun, 2011-06-05 at 21:42 +0100, Malcolm Priestley wrote:
> > >> On Sun, 2011-06-05 at 19:34 +0300, Mehmet Altan Pire wrote:
> > >>> 05-06-2011 17:16, Malcolm Priestley yazmış:
> > >>>> On Sun, 2011-06-05 at 03:35 +0300, Mehmet Altan Pire wrote:
> > >>>>> Hi,
> > >>>>> I have "DM04 USB DVBS TUNER", using ubuntu with v4l media-build
> > >>>>> drivers/modules but device  doesn't working (unknown device).
> > >>>>>
> > >>>>> lsusb message:
> > >>>>> ID 3344:22f0
> > >>>>>
> > >>>>> under of the box:
> > >>>>> DM04P2011050176
> > >>> Yes, i have windows xp driver, name is "US2B0D.sys" I sending it,
> > >>> attached in this mail. Thanks. 
> > >> Here is a modified lmedm04.c and lme2510b_fw.sh using the US2B0D.sys
> > >>
> > to modify the interrupt return.
> > >
> 
> > >
> > Ok, i tested it. Device recognized on WinXP with original driver, but tv
> > application says "no lock".
> > I'm not sure it worked on WinXP but driver cd is original and
> > succesfully loaded and recognized.
> > Again tested on ubuntu with new lmedm04.c and lme2510b_fw.sh than make,
> > make install, and restart.
> > 
> > lsusb says:
> > Bus 001 Device 008: ID 3344:1120  (changes 22f0 to 1120)
> > dmesg says:
> Yes this should happen. The firmware will reboot with the correct id.

> 
> > My device different or chip is damaged? Label, box and driver cd title
> > writes "DM04P". DM04 and DM04P different devices?
> 
> I think the id of the chip is faulty or default.
> 
> I will test the firmware with LG tuner later.

It is not the LG, s7395 or S0194 tuner.

So the id is intentional. 

How does it identify itself in windows?


tvboxspy

