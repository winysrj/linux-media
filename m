Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:36012 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZHFMxZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 08:53:25 -0400
Received: by ey-out-2122.google.com with SMTP id 9so337986eyd.37
        for <linux-media@vger.kernel.org>; Thu, 06 Aug 2009 05:53:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7AC430.4070505@netscape.net>
References: <4A7AC430.4070505@netscape.net>
Date: Thu, 6 Aug 2009 08:53:25 -0400
Message-ID: <37219a840908060553g452266fdq5ea3814b4ce725bc@mail.gmail.com>
Subject: Re: Hauppauge WinTV HVR-900HD support?
From: Michael Krufky <mkrufky@kernellabs.com>
To: Kaya Saman <SamanKaya@netscape.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kaya,

On Thu, Aug 6, 2009 at 7:53 AM, Kaya Saman<SamanKaya@netscape.net> wrote:
> Hi,
>
> in an earlier post I was responded to that my old WinTV USB 1 Tuner would
> never work under Linux due to bad and complicated coding which (since no one
> uses that tuner anymore) will never be looked at.

I don't think that's true -- I didn't see your earlier post, but I can
only assume that your WinTV USB 1 Tuner uses the NT003 / NT004
chipsets, supported by the usbvision driver -- did you try that?

> So I am in need of a new tuner!

Better off getting a new one anyway, since analog TV will disappear
eventually and DTV is all that will be around.

> This is a dilemma as I need analog TV.... since I will be using it for
> watching stuff through a satellite receiver but also analog terrestrial TV
> too as where I will be taking it to doesn't have digital TV at best the have
> cable.
>
> I was considering going for the Hauppauge WinTV HVR-900HD. I am not sure if
> it will be compatible though with the global regions I will use it in which
> is UK that I know it has support for as I will buy from here which is PAL I
> but then also Turkey which I think is PAL Beta if I'm not mistaken??
>
> More importantly though is it supported under Linux?? I use KUbuntu 9.04
> which is pretty up to date. I am just a bit worried about this part since
> the site says that as of June 2008 there is no support... of course we are
> in August 2009 so maybe in a year it might have been integrated into the
> later kernels??
> Taken from here:
> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-900H
>
> What's everyone's verdict? Any suggestions would be great!

The HVR-900H is currently *not* supported under Linux, and it does not
seem that it will get such support anytime in the near future,
unfortunately.  Please note, I am only speaking for the HVR-900H ...
other flavors of the HVR900 are fully functional and supported, just
not the "H" version.

If you're looking for a well-supported USB hybrid device, I would
recommend one of the standard "HVR-900" sticks, or even better, the
HVR-1900 .  The HVR1900 is a usb device that does Digital DVB-T and
analog (PAL / NTSC) both.  The analog side has a hardware mpeg encoder
-- this is perfect if you intend to use the device for recordings.
HVR1900 is fully supported under Linux.

I hope this helps.

Regards,

Mike
