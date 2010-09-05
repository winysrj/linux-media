Return-path: <mchehab@localhost>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55682 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab0IEIE3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Sep 2010 04:04:29 -0400
Received: by wwj40 with SMTP id 40so4956139wwj.1
        for <linux-media@vger.kernel.org>; Sun, 05 Sep 2010 01:04:28 -0700 (PDT)
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: [PATCH] LED control
References: <20100904131048.6ca207d1@tele> <4C834D46.5030801@redhat.com>
Date: Sun, 05 Sep 2010 10:04:25 +0200
In-Reply-To: <4C834D46.5030801@redhat.com> (Hans de Goede's message of "Sun,
	05 Sep 2010 09:56:54 +0200")
Message-ID: <87sk1oty46.fsf@macbook.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

>>>>> "Hans" == Hans de Goede <hdegoede@redhat.com> writes:

Hi,

 >> +	<entry><constant>V4L2_CID_LEDS</constant></entry>
 >> +	<entry>integer</entry>
 >> +	<entry>Switch on or off the LED(s) or illuminator(s) of the device.
 >> +	    The control type and values depend on the driver and may be either
 >> +	    a single boolean (0: off, 1:on) or the index in a menu type.</entry>
 >> +	</row>

 Hans> I think that using one control for both status leds (which is
 Hans> what we are usually talking about) and illuminator(s) is a bad
 Hans> idea. I'm fine with standardizing these, but can we please have 2
 Hans> CID's one for status lights and one for the led. Esp, as I can
 Hans> easily see us supporting a microscope in the future where the
 Hans> microscope itself or other devices with the same bridge will have
 Hans> a status led, so then we will need 2 separate controls anyways.

Why does this need to go through the v4l2 api and not just use the
standard LED (sysfs) api in the first place?

-- 
Bye, Peter Korsgaard
