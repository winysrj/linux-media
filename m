Return-path: <mchehab@pedra>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:44905 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335Ab1CTCgm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2011 22:36:42 -0400
Date: Sun, 20 Mar 2011 03:36:37 +0100 (CET)
From: hermann-pitton@arcor.de
To: jwhecker@gmail.com, hermann-pitton@arcor.de
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Message-ID: <1749854967.238689.1300588597796.JavaMail.ngmail@webmail08.arcor-online.net>
In-Reply-To: <AANLkTi=vi-1Y7kjwF1d9K1VBO38jYcO2ynT0UgCvdKNn@mail.gmail.com>
References: <AANLkTi=vi-1Y7kjwF1d9K1VBO38jYcO2ynT0UgCvdKNn@mail.gmail.com> <AANLkTikV3LW5JZdUMjctretv8_ZWN6YFhhfwzDo8NzbW@mail.gmail.com>
	<1300412946.9136.18.camel@pc07.localdom.local>
Subject: Re: [linux-dvb] Problem with saa7134: Asus Tiger revision 1.0,
 subsys 1043:4857
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 
Hi Jason,

> Hi Hermann,
> 
> > Hopefully it does help in that other case.

that one really counts now.

> I have it working now.  I had to add a delay of 120 seconds in the
> mythtv backend script to allow the driver enough time to scan both
> cards and install the firmware properly.  Previously the mythtv
> backend at startup was trying to talk to the cards before the firmware
> was loaded and so they'd fail to work.
> 
> It's not a big hassle but it would seem in spite of a test in the
> startup script to ensure udev configuration was complete before
> mythbackend was loaded it would seem that udev device configuration

Sorry, no time yet to dig into it further, but I seem to hear some faint noise.

How sure you are to have original eeprom content on your card ?

Some bill, original packing material or similar?

On some first impression, l doubt we deal with something it claims to be.

Cheers,
Hermann










> was completing before the firmware was loaded.
> 
> Is there the possibility of adding some feature into the driver to
> make sure it fails on opening if the firmware isn't properly loaded?
> 
> Another general question, does V4L sequentially initialise hardware or
> does it run in parallel?  It would seem to be a good time saver to
> have all DVB cards initialised in parallel to speed up booting of a
> system.
> 
> I have reverted back to Mythbuntu 10.04 and kernel 2.6.32 and the
> cards work fine now (though with the latest v29 of the firmware for
> these cards).
> 
> Cheers
> Jason
> 
