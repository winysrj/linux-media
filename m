Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm26-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.160]:32020 "HELO
	nm26-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757501Ab2BJQln (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 11:41:43 -0500
Message-ID: <1328891689.25568.YahooMailClassic@web39302.mail.mud.yahoo.com>
Date: Fri, 10 Feb 2012 08:34:49 -0800 (PST)
From: Jan Panteltje <panteltje@yahoo.com>
Subject: General question about IR remote signals  from USB DVB tuner
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently bought a Terratec cinergy S2 USB  HD receiver.
I got everything working just fine in Linux and get excellent
reception.
This thing came with a small remote controller, and I notice
that the  output of this remote appears as ASCII characters on stdin,
on any terminal that I open...
Wrote a small GUI application that sets the input focus to a hidden
input field, and can process the numbers from this remote that way,
but of course this only works if the mouse has selected that application.

Thinking about this I think that the driver dumps the received remote
control characters simply to stdout.
If this is so, does there perhaps exists a /dev/dvb/adapterX/remoteX
interface in the specs so I could modify that driver to send the codes
there?
If not how about adding such a thing?
The application can then in a separate thread for example open
this device and use those codes.
This little remote has it all:
 numbers 0 to 9, ENTER, channel up /down, power, mute, EPG,
volume, what not.
Sorry I a am bit rusty, been many years since I did any programming
for DVB, so may be this already exists?
So much seems to have changed.
 
Any suggestions would be appreciated

