Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:52993 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZKPEOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 23:14:04 -0500
Received: by fxm21 with SMTP id 21so2303877fxm.21
        for <linux-media@vger.kernel.org>; Sun, 15 Nov 2009 20:14:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AFFFE3E.8040604@gmail.com>
References: <4A79EC82.4050902@email.it> <4A7B0333.1010901@email.it>
	 <4A81D38A.2050201@email.it>
	 <829197380908111334xf9a89b4gf2da1e4cc765b27b@mail.gmail.com>
	 <4A81E6C3.7010802@email.it> <20090811154232.4ed8a1ba@gmail.com>
	 <4A81F5E1.9070709@email.it> <20090811160806.43a6dfd8@gmail.com>
	 <4A827102.60806@email.it> <4AFFFE3E.8040604@gmail.com>
Date: Sun, 15 Nov 2009 23:14:09 -0500
Message-ID: <829197380911152014h638e0b2av7c93b60e0fbfaeba@mail.gmail.com>
Subject: Re: No analog audio for the Empire Dual Pen: request for help and
	suggestions!!!
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 15, 2009 at 8:12 AM, Andrea.Amorosi76@gmail.com
<Andrea.Amorosi76@gmail.com> wrote:
> I would like to solve this analog audio issue (this device would be useful
> in the future thanks to the 9 pin s-video input which, I think can  take the
> output of an external dvb-t decoder so that to be able to see cripted
> digital tv or from consoles to play and use notebook display as a tv).
> Following the (little) expertise gained with the Dikom DK300, I think that
> the default_analog gpio is not correct for the device.
> Can I try with others gpio or a wrong gpio can phisically break the device?
> Otherwise how can I create a correct gpio for this device?
> Thank you,
> Andrea (Xwang was my nickname)

Hello Andrea,

To determine the correct analog_gpio, I typically do an analog capture
under Windows, and use sniffusb to determine how the GPIO register is
set at the time the analog video is being streamed.

http://www.pcausa.com/Utilities/UsbSnoop/

Generally speaking, you probably do not want to experiment toggling
the GPIOs individually, since you can have conditions such as the
digital demod running at the same time as the analog subsystem (which
would draw too much power).

It's worth noting also that it is entirely possible that a LEDs are
attached to GPIO pins as well (in regards to your other question about
the LED behavior).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
