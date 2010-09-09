Return-path: <mchehab@pedra>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:36724 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab0IIVw2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 17:52:28 -0400
Received: from metzlerbros.de
	(ip-62-143-72-211.unitymediagroup.de [62.143.72.211])
	by post.strato.de (mrclete mo20) (RZmta 23.5)
	with ESMTP id z02a25m89JO8Os for <linux-media@vger.kernel.org>;
	Thu, 9 Sep 2010 23:52:25 +0200 (MEST)
Received: from rjkm by valen.metzler with local (Exim 4.69 #1 (Debian))
	id 1Otp2f-0003NP-L4
	for <linux-media@vger.kernel.org>; Thu, 09 Sep 2010 23:52:25 +0200
From: rjkm <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19593.22297.612764.560375@valen.metzler>
Date: Thu, 9 Sep 2010 23:52:25 +0200
To: linux-media@vger.kernel.org
Subject: How to handle independent CA devices
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

cards like the Digital Devices DuoFlex S2, cineS2 and upcoming 
hardware (octuple, network, etc.) have independent CA devices.
This means that instead of having the stream routed from the frontend 
through the CI and only then into memory a stream can be sent from
memory through the CI and back. So, the current device model does not
fit this hardware.

One could hide this fact inside the driver and send the stream from
the frontend through the CI transparently to the API but this would
prevent people from implementing new features like decoding a stream from 
a different DVB card, decoding streams from hard disk or even decoding
several sub-streams from different transponders.
The latter works with the current Windows driver but I have not
implemented it in Linux yet. It also has to be supported by the CI
modules. Some can decode 12 streams (6 times video/audio) at once.

But decoding single streams already works fine. Currently, I am 
registering a different adapter for the CI.
On a CineS2 with CI attached at the IO port I then have

/dev/dvb/adapter[01] for the two DVB-S2 frontends and
/dev/dvb/adapter2 just for the ca0 device.

I am abusing the unused sec0 to write/read data to/from the CI module.
For testing I hacked zap from dvb-apps to tune on adapter0 but 
use adapter2/ca0 to talk to the CI module.
I then write the encrypted stream from adapter0/dvr0 into 
adapter2/sec0 and read the decoded stream back from adapter2/sec0.
The encrypted stream of course has to contain all the PIDs of the
ca_pmt. 

So, I would like to hear your opinions about how to handle such CA devices 
regarding device names/types, the DVB API and user libraries.


-Ralph


