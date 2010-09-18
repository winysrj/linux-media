Return-path: <mchehab@pedra>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:29624 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0IRBC4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 21:02:56 -0400
From: rjkm <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19604.4030.730179.891359@valen.metzler>
Date: Sat, 18 Sep 2010 03:02:54 +0200
To: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [linux-media] How to handle independent CA devices
In-Reply-To: <4C928170.7060808@tvdr.de>
References: <19593.22297.612764.560375@valen.metzler>
	<4C928170.7060808@tvdr.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Klaus Schmidinger writes:
 > VDR already has mechanisms that allow independent handling of CAMs
 > and receiving devices. Out of the box this currently only works for
 > DVB devices that actually have a frontend and where the 'ca' device
 > is under the same 'adapter' as the frontend.
 > I could easily make it skip adapters that have no actual
 > 'frontend' and set up separate cDvbCiAdapter objects for adapters that
 > only have a 'ca' device and no frontend.
 > 
 > However, VDR always assumes that the data to be recorded comes out of
 > the 'dvr' device that's under the same adapter as the 'frontend'.
 > So requiring that VDR would read from the frontend's 'dvr' device,
 > write to the ca-adapter's 'sec' (or whatever) device, and finally read
 > from that same 'sec' device again would be something I'd rather avoid.
 > Besides, what if some PIDs are encrypted, while others are not? Should
 > the unencrypted ones be read directly from 'dvr' and only the encrypted
 > ones from 'sec'? That might mess with the proper sequence of the packets.
 > 
 > As for decrypting data from several frontends through one CAM: I don't
 > see this happening in VDR. Pay tv channels repeat their stuff
 > often enough to find a slot where everything can be recorded. Others may,
 > of course, welcome this ability, but I'd like to keep things simple in VDR.
 > So I'm not against this, I just won't use it in VDR.
 > 
 > As for recording encrypted and decrypting later: that's also something
 > I don't see being used in VDR (again, mainly for KISS reasons).
 > 
 > So, the bottom line is: I would appreciate an implementation where,
 > given the configuration you described above, I could, e.g., tune using
 > /dev/dvb/adapter0/frontend0, read the data stream from /dev/dvb/adapter0/dvr0
 > as usual, communicate with the CAM through /dev/dvb/adapter2/ca0 and
 > (which is the tricky part, I guess) "tell" the driver or some library
 > function to "assign the CAM in /dev/dvb/adapter2/ca0 to the frontend|dvr
 > in /dev/dvb/adapter0/frontend0|dvr0).



Sorry, no plans here to support it like this right now.


-Ralph
