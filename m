Return-path: <mchehab@pedra>
Received: from 200-232-120-2.rf.com.br ([200.232.120.2]:33046 "EHLO rf.com.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab0KKSpy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 13:45:54 -0500
Received: from rf.com.br (yankee.rf.com.br [127.0.0.1])
	by rf.com.br (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id oABIYh0B015792
	for <linux-media@vger.kernel.org>; Thu, 11 Nov 2010 16:34:43 -0200
From: "Joao S Veiga" <jsveiga@rf.com.br>
To: linux-media@vger.kernel.org
Subject: DVB-S/S2 Card for a linux-based dish pointer
Date: Thu, 11 Nov 2010 16:34:43 -0200
Message-Id: <20101111175421.M41484@rf.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello guys,

We're developing an automatic satellite dish pointer controller (for Satellite News Gathering vehicles and other
applications), and it will be based on a mini-itx Atom motherboard running debian.

I'm looking for options for measuring the received signal strength and quality for the auto-track and signal lock
confirmation, and would like to use an off-the-shelf dvb-s card, supported by a vanilla kernel if possible.

I've looked at this list's archive, and found good recommendations for the Technotrend TT-S3200 and TT-S1600.

Remote control and hardware mpeg2 decoding are not needed; the 2Ux19" dish pointer controller will have no display
(other than a 480x220 touchscreen which cannot show video, and a web user interface). Eventually we'll allow the
connection of a monitor if the 1.6GHz fanless single-core Atom can handle the decoding, but that would be just a
interesting feature, not a must.

The card can be PCI or USB2 (the mini-itx board also has a very useful mini-pcie).

I've never used a DVB card, so I'd like to please ask you guys if the dvb-s support under linux can be used in this
situation:

- no X running
- send tuning/cps/etc configuration/commands via command line
- get signal strength (dBm?) and quality (BER?), signal lock, and other sat info via command line or api or somewhere in
/proc/ for example

Considering that this is all I need (and users-do-not-need-to-know-this-is-a-computer stability), are the Technotrend
TT-S3200 and TT-S1600 still good bets? Any less featured but still good quality cheaper option?

Thank you!

Joao S Veiga

