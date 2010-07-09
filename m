Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54943 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab0GITwf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 15:52:35 -0400
Received: by wyf23 with SMTP id 23so1863484wyf.19
        for <linux-media@vger.kernel.org>; Fri, 09 Jul 2010 12:52:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilCwvUCEWLnurCvwvwRR1xdYU7D7359WBux2_7Q@mail.gmail.com>
References: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com>
	<201006302116.25893.tkrah@fachschaft.imn.htwk-leipzig.de>
	<AANLkTikFtWbXKxnAcfGd2LP4fDjRFwGdNarzDUh3rxt6@mail.gmail.com>
	<201007021547.24917.tkrah@fachschaft.imn.htwk-leipzig.de>
	<AANLkTilCwvUCEWLnurCvwvwRR1xdYU7D7359WBux2_7Q@mail.gmail.com>
Date: Fri, 9 Jul 2010 21:52:33 +0200
Message-ID: <AANLkTilsHoG9gd6QwAV_b17h1eOnOBTr0xYDX-OUBlh_@mail.gmail.com>
Subject: Re: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
From: Thorsten Hirsch <t.hirsch@web.de>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: tkrah@fachschaft.imn.htwk-leipzig.de, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oh, sorry for the long delay.
Yes, I was using my fake-id patch.

@Torsten: just open
linux-2.6/drivers/media/video/em28xx/em28xx-cards.c and search for
"EM2870_BOARD_TERRATEC_XS". Then copy this line and the one above it,
and finally change the usb id in the copied line according to the
output of lsusb.

Thorsten

>> Maybe i need the patch Thorsten did too, to patch the em28xx-cards.c to get
>> the "new" wrong usb id regognized as a em28xx device so that i can reflash the
>> eeprom of the device. I might give this a try later this day.
>
> Please try it, should be the root cause.
