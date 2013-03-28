Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:62654 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3C1Tvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 15:51:52 -0400
Received: by mail-ea0-f178.google.com with SMTP id o10so1006806eaj.23
        for <linux-media@vger.kernel.org>; Thu, 28 Mar 2013 12:51:51 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 28 Mar 2013 19:51:50 +0000
Message-ID: <CAOS+5GGFDjUbTFf6ZV46ZGVLPg6C_ipOjGBH77z=wVzzY=pUXg@mail.gmail.com>
Subject: Problems with Hauppauge Nova TD Dual Tuner USB Stick and Mythtv, no
 problems in Windows!
From: Another Sillyname <anothersname@googlemail.com>
To: Development of mythtv <mythtv-dev@mythtv.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm posting this on both the Mythtv dev and Linux Media lists as I'm
not sure where the problem sits, my inclination is it's probably in
myth's tuning and I'll explaing why shortly.

I recently built a system for a friend of mine, using Fedora 18 x64.

Clean build on a DFI Mini ITX P55-T36 system with a decent sized hard
disk and 4GB of memory......plenty to run a mythTV backend.

The tuners were Hauppauge Nova TD Dual Tuner USB Sticks, USB reference
2040:9580 IIRC.

His place has a masthead antenna and no matter what I did I could not
get these things to tune properly.....

LNA On, LNA Off, Rooftop Antenna, Mini Antenna supplied with Stick,
Attenuators in and out, I've messed around with every variation for
about 3 weeks now and been unable to get a proper signal on all the
muxes no matter what I do.  He's in East London on the border of the
City near Aldgate.  His internal antenna feed to the TV is perfect but
I cannot get it behave using Linux no matter what configuration I try.

In desperation I finally tried something different today, took in
another hard disk and did a clean build of Windows 7 Ultimate x64,
didn't touch anything else, installed the latest Hauppauge drivers
from their website and used Win7Ult own Media for TV
software.....every channel tuned in straight away no problem, except
some borderline signal issues with the Film4 mux.

Now this got me thinking back to when I first plugged the USB stick in
to a Mint Live CD, I tested it using either VLC or Kaffeine (I honest
can't rmember which) and I could get tuning on pretty much all the
channels straight away.

As the device isn't supported properly in Myth/Linux I had to compile
the V4L drivers, I'm running Fedora 18 x64 Kernel 3.8.4-202 and V4L
compiled last night, using Mythtv from the RPMFusion repos so
26.0.7--18.

If anyone can suggest anything I'm receptive to try it but honestly I
think something is broken in either the mythtv tuning code or the
interaction between the tuners and the V4L drivers.

If anyone wants specific info let me know what you need.

Tony
