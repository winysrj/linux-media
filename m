Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:50599 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421AbZICLoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 07:44:23 -0400
Message-ID: <4A9FAC15.9000002@onelan.com>
Date: Thu, 03 Sep 2009 12:44:21 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not	working	well
 together
References: <4A9E9E08.7090104@onelan.com>  <4A9EAF07.3040303@hhs.nl>	 <1251975978.22279.8.camel@morgan.walls.org>  <4A9FA729.3010207@onelan.com> <1251977347.22279.21.camel@morgan.walls.org>
In-Reply-To: <1251977347.22279.21.camel@morgan.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Thu, 2009-09-03 at 12:23 +0100, Simon Farnsworth wrote:
>> Andy Walls wrote:
>>> But I suspect no user pays for the extra cost of the CX2341[568]
>>> hardware MPEG encoder, if the user primarily wants uncompressed YUV
>>> video as their main format.
>> Actually, we're doing exactly that. We want a PCI card from a reputable
>> manufacturer which provides uncompressed YUV and ATSC (both OTA and
>> ClearQAM cable). As we already buy Hauppauge HVR-1110s for DVB-T and
>> uncompressed analogue, a Hauppauge card suits us, and the only thing
>> they have that fits the needs is the HVR-1600; the MPEG encoder is thus
>> left idle.
> 
> Ah. OK, this is more than an academic exercise. :)
> 
> If you can prioritize your needs for the cx18 driver, I can see what I
> can get done.
> 
The video side is now working well for me on the HVR1110 and HVR1600 -
in an ideal world, I'd have an ALSA driver for cx18 audio instead of the
video24 device. The read() bug isn't major for me, as I can just use a
slightly modified libv4l2 to cope.

> If you'd like to submit patches, I'll be happy to review them to make
> sure they don't break anything and then get them integrated.
> 
I'll be discussing this with my management next week, and they'll be
making a judgement call on whether we can cope without analogue audio on
the RF input only. If we can't, I'll be tasked with working on this; I
take it you'd prefer to have ALSA added to the driver than for me to
teach Xine to read from /dev/video24 for PCM audio?

In any case, I have some more work to do on the reworked input_v4l for
Xine, as I need to get it into a state where I can work with the Xine
guys on merging it into their mainline. This will have to be finished
before I can really dive into the cx18 driver.
-- 
Thank you for the offer of help - I'll let you know if I'm going to
start working on ALSA support in cx18,

Simon Farnsworth

