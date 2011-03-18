Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46745 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab1CRJeD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2011 05:34:03 -0400
Received: by iwn34 with SMTP id 34so3773809iwn.19
        for <linux-media@vger.kernel.org>; Fri, 18 Mar 2011 02:34:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300412946.9136.18.camel@pc07.localdom.local>
References: <AANLkTikV3LW5JZdUMjctretv8_ZWN6YFhhfwzDo8NzbW@mail.gmail.com>
	<1300412946.9136.18.camel@pc07.localdom.local>
Date: Fri, 18 Mar 2011 20:34:03 +1100
Message-ID: <AANLkTi=vi-1Y7kjwF1d9K1VBO38jYcO2ynT0UgCvdKNn@mail.gmail.com>
Subject: Re: [linux-dvb] Problem with saa7134: Asus Tiger revision 1.0, subsys 1043:4857
From: Jason Hecker <jwhecker@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hermann,

> Hopefully it does help in that other case.

I have it working now.  I had to add a delay of 120 seconds in the
mythtv backend script to allow the driver enough time to scan both
cards and install the firmware properly.  Previously the mythtv
backend at startup was trying to talk to the cards before the firmware
was loaded and so they'd fail to work.

It's not a big hassle but it would seem in spite of a test in the
startup script to ensure udev configuration was complete before
mythbackend was loaded it would seem that udev device configuration
was completing before the firmware was loaded.

Is there the possibility of adding some feature into the driver to
make sure it fails on opening if the firmware isn't properly loaded?

Another general question, does V4L sequentially initialise hardware or
does it run in parallel?  It would seem to be a good time saver to
have all DVB cards initialised in parallel to speed up booting of a
system.

I have reverted back to Mythbuntu 10.04 and kernel 2.6.32 and the
cards work fine now (though with the latest v29 of the firmware for
these cards).

Cheers
Jason
