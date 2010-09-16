Return-path: <mchehab@pedra>
Received: from racoon.tvdr.de ([188.40.50.18]:47767 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab0IPVAN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 17:00:13 -0400
Received: from whale.tvdr.de (whale.tvdr.de [192.168.100.6])
	by racoon.tvdr.de (8.14.3/8.14.3) with ESMTP id o8GKhYLZ005306
	for <linux-media@vger.kernel.org>; Thu, 16 Sep 2010 22:43:34 +0200
Received: from [192.168.100.10] (hawk.tvdr.de [192.168.100.10])
	by whale.tvdr.de (8.14.3/8.14.3) with ESMTP id o8GKhSg2009012
	for <linux-media@vger.kernel.org>; Thu, 16 Sep 2010 22:43:28 +0200
Message-ID: <4C928170.7060808@tvdr.de>
Date: Thu, 16 Sep 2010 22:43:28 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] How to handle independent CA devices
References: <19593.22297.612764.560375@valen.metzler>
In-Reply-To: <19593.22297.612764.560375@valen.metzler>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 09.09.2010 23:52, rjkm wrote:
> Hi,
> 
> cards like the Digital Devices DuoFlex S2, cineS2 and upcoming 
> hardware (octuple, network, etc.) have independent CA devices.
> This means that instead of having the stream routed from the frontend 
> through the CI and only then into memory a stream can be sent from
> memory through the CI and back. So, the current device model does not
> fit this hardware.
> 
> One could hide this fact inside the driver and send the stream from
> the frontend through the CI transparently to the API but this would
> prevent people from implementing new features like decoding a stream from 
> a different DVB card, decoding streams from hard disk or even decoding
> several sub-streams from different transponders.
> The latter works with the current Windows driver but I have not
> implemented it in Linux yet. It also has to be supported by the CI
> modules. Some can decode 12 streams (6 times video/audio) at once.
> 
> But decoding single streams already works fine. Currently, I am 
> registering a different adapter for the CI.
> On a CineS2 with CI attached at the IO port I then have
> 
> /dev/dvb/adapter[01] for the two DVB-S2 frontends and
> /dev/dvb/adapter2 just for the ca0 device.
> 
> I am abusing the unused sec0 to write/read data to/from the CI module.
> For testing I hacked zap from dvb-apps to tune on adapter0 but 
> use adapter2/ca0 to talk to the CI module.
> I then write the encrypted stream from adapter0/dvr0 into 
> adapter2/sec0 and read the decoded stream back from adapter2/sec0.
> The encrypted stream of course has to contain all the PIDs of the
> ca_pmt. 
> 
> So, I would like to hear your opinions about how to handle such CA devices 
> regarding device names/types, the DVB API and user libraries.

Here's my 2ct as viewed from VDR:

VDR already has mechanisms that allow independent handling of CAMs
and receiving devices. Out of the box this currently only works for
DVB devices that actually have a frontend and where the 'ca' device
is under the same 'adapter' as the frontend.
I could easily make it skip adapters that have no actual
'frontend' and set up separate cDvbCiAdapter objects for adapters that
only have a 'ca' device and no frontend.

However, VDR always assumes that the data to be recorded comes out of
the 'dvr' device that's under the same adapter as the 'frontend'.
So requiring that VDR would read from the frontend's 'dvr' device,
write to the ca-adapter's 'sec' (or whatever) device, and finally read
from that same 'sec' device again would be something I'd rather avoid.
Besides, what if some PIDs are encrypted, while others are not? Should
the unencrypted ones be read directly from 'dvr' and only the encrypted
ones from 'sec'? That might mess with the proper sequence of the packets.

As for decrypting data from several frontends through one CAM: I don't
see this happening in VDR. Pay tv channels repeat their stuff
often enough to find a slot where everything can be recorded. Others may,
of course, welcome this ability, but I'd like to keep things simple in VDR.
So I'm not against this, I just won't use it in VDR.

As for recording encrypted and decrypting later: that's also something
I don't see being used in VDR (again, mainly for KISS reasons).

So, the bottom line is: I would appreciate an implementation where,
given the configuration you described above, I could, e.g., tune using
/dev/dvb/adapter0/frontend0, read the data stream from /dev/dvb/adapter0/dvr0
as usual, communicate with the CAM through /dev/dvb/adapter2/ca0 and
(which is the tricky part, I guess) "tell" the driver or some library
function to "assign the CAM in /dev/dvb/adapter2/ca0 to the frontend|dvr
in /dev/dvb/adapter0/frontend0|dvr0).

Please forgive me if this sounds like a crazy request - I'm not a driver
developer ;-)

Klaus
