Return-path: <linux-media-owner@vger.kernel.org>
Received: from jack.hrz.tu-chemnitz.de ([134.109.132.46]:52680 "EHLO
	jack.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZHaQXh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 12:23:37 -0400
From: Jens Reimann <jens.reimann@s2003.tu-chemnitz.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Hauppauge WinTV-HVR 900 R2 (DRX 3973D)
Date: Mon, 31 Aug 2009 18:23:36 +0200
Cc: linux-media@vger.kernel.org
References: <200908301726.52296.jens.reimann@s2003.tu-chemnitz.de> <829197380908300944i4872d26r3429844a0741efc@mail.gmail.com>
In-Reply-To: <829197380908300944i4872d26r3429844a0741efc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908311823.36402.jens.reimann@s2003.tu-chemnitz.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sonntag, 30. August 2009 18:44:39 schrieb Devin Heitmueller:
> On Sun, Aug 30, 2009 at 11:26 AM, Jens
>
> Reimann<jens.reimann@s2003.tu-chemnitz.de> wrote:
> > Hi,
> > it's again about the second revision of  WinTV-HVR 900. I'm know about
> > the problems and conflicts with this device and the developers of the
> > driver. I'm still using the driver from Markus Rechberger
> > (www.mcentral.de) but he stopped development and there is only support up
> > to Linux kernel 2.6.28. I would like to see support for DVB-T for this
> > device in the linuxtv tree. As much as I understood, the problem is
> > initializing the drx3973d chip with proper data, but there are no specs
> > available. I own one of these devices and willing to help debugging. I
> > even have the programming skills to do investigations. But, are there any
> > hints where to start? For example there are parameters for this device in
> > the tree of Markus. May be these parameters can be used (even if not
> > understood) to get the device working.
> >
> > Thanks
> > Jens
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Hello Jens,
>
> As is the case with the PCTV 330e, I've got the device working here
> and I have a tree setup (fully tested and debugged).  All I need to do
> is get the firmware extraction script finished.  Mauro took a crack at
> it last week but it still needs some work.
>
> I'm hoping to get back to it in the next couple of weeks, so keep an
> eye on the KernelLabs blog for an announcement
> (http://kernellabs.com/blog).
>
> Cheers,
>
> Devin

Hi Devin,
thanks a lot for the information. I didn't knew about these efforts until now. 
I'm really looking forward to this driver.

Jens
