Return-path: <mchehab@pedra>
Received: from bar.sig21.net ([80.81.252.164]:59484 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab0INOnr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 10:43:47 -0400
Date: Tue, 14 Sep 2010 16:43:39 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: rjkm <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org
Subject: Re: How to handle independent CA devices
Message-ID: <20100914144339.GA9525@linuxtv.org>
References: <19593.22297.612764.560375@valen.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19593.22297.612764.560375@valen.metzler>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Ralph,

On Thu, Sep 09, 2010 at 11:52:25PM +0200, rjkm wrote:
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

it looks like there isn't much interest from DVB developers
in that topic...  I'll try...


IMHO there are three sub topics:

1. be compatible with existing applications
   (I guess this means: feed stream from frontend through CI transparently)
2. create an API which would also work for CI-only
   devices like this Hauppauge WinTV-CI USB thingy
3. how to switch between these modes?

This sec0 device is history (unused and deprecated for years), right?
How about the following:
Rename it to ci0.  When ci0 is closed the stream is routed
transparently from frontend through CI, if it's opened one needs to
read/write the stream from userspace.


If you can't get responses here I guess you could talk to
vdr or other application developers.  After all they'll have
to use the API.


Cheers,
Johannes
