Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64228 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1CKX5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 18:57:39 -0500
Received: by iyb26 with SMTP id 26so3156166iyb.19
        for <linux-media@vger.kernel.org>; Fri, 11 Mar 2011 15:57:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=RNXdb6BSLQL74NA9XMrN9mj6CNYvZgycSCQ9n@mail.gmail.com>
References: <AANLkTi=RNXdb6BSLQL74NA9XMrN9mj6CNYvZgycSCQ9n@mail.gmail.com>
Date: Sat, 12 Mar 2011 10:57:38 +1100
Message-ID: <AANLkTinyJOVQEurOUdibvTfTNLRCWEJi_GX8=bodK4c=@mail.gmail.com>
Subject: Problem with saa7134: Asus Tiger revision 1.0, subsys 1043:4857
From: Jason Hecker <jhecker@wireless.org.au>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I just bought a pair of what are a version of the My Cinema 7131 Hybrid cards.

The kernel reports it as saa7134: Asus Tiger revision 1.0, subsys 1043:4857

I did inititially try Mythbuntu 10.04 but the firmware upload seemed
to fail fairly consistently.  Restarting with v10.10 the firmware
loads but I can't seem to scan the channels with Mythbackend - it has
a 0% signal and 100% signal to noise.  I am using MythTV 0.24 with
Avenard's latest patches.

This version of the card has written on the silkscreen Tiger rev 3.02,
a sticker that says Tiger_8M AA.F7.C0.01 (which would appear to be the
latest firmware for this card on Asus's support site) but there is
only one RF connector on CON1.  CON2 is not fitted nor is the IR
receiver.  Now I saw mentioned on a list that to get DVB working on
this card in Linux you need to connect the TV antenna to the FM port,
which I suspect is the one not fitted.  The latest Windows drivers for
this card is circa 2009.

Two questions:
- Is there some sort of SAA7134 module argument I need to use to get
this particular card working on the TV RF input?
- Why does the kernel show the firmware is being reloaded every time
MythTV seems to want to talk to the card?  This slows down access as
it seems to take about 30 seconds for the firmware to install each
time.

I am happy to provide whatever debug dumps or more info if need be.
