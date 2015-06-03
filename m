Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40308 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbbFCWAI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 18:00:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Z0Ghf-0002VJ-U6
	for linux-media@vger.kernel.org; Thu, 04 Jun 2015 00:00:05 +0200
Received: from mail.teamtalk.co.nz ([202.8.44.170])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 04 Jun 2015 00:00:03 +0200
Received: from faulkner-ball by mail.teamtalk.co.nz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 04 Jun 2015 00:00:03 +0200
To: linux-media@vger.kernel.org
From: Peter Faulkner-Ball <faulkner-ball@xtra.co.nz>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
Date: Wed, 3 Jun 2015 21:50:44 +0000 (UTC)
Message-ID: <loom.20150603T234551-193@post.gmane.org>
References: <b69d68a858a946c59bb1e292111504ad@IITMAIL.intellectit.local> <556EB2F7.506@iki.fi> <CALzAhNWKPOFe1=jdo6f=FFMtWyNWxm34M1EoJA0CMD3GZfhvWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steven Toth <stoth <at> kernellabs.com> writes:

> 
> >> Many thanks to the developers for all of your hard work.
> >
> >
> > Let me guess they have changed Si2168 chip to latest "C" version. Driver
> > supports only A and B (A20, A30 and B40). I have never seen C version.
> 
> I'll look in detail and report back shortly.
> 

Hi,
I have a working solution (workaround) for the HVR2205/HVR2215 firmware
loading issue.


In the file:

dvb-frontends/si2168.c


change:

#define SI2168_B40 ('B' << 24 | 68 << 16 | '4' << 8 | '0' << 0)


to:

#define SI2168_B40 (68 << 16 | '4' << 8 | '0' << 0)


I do not know why this works, but this is the place where the new chip
is not being detected correctly.

In my case the chip is labelled as: SI2168 40
When the firmware failed to load the error log reported as: si2168-x0040

I hope this is helpful.


I have 2x HVR2215 cards both working for DVB-T on OpenSuse13.2

To get them working, I installed the latest HEAD kernel, downloaded the
media_build tree from LinuxTV, made the change as above, make, make
install, reboot



