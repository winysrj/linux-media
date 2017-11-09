Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:14706 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdKIPbk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Nov 2017 10:31:40 -0500
Received: from rjkm by morden.metzler with local (Exim 4.89)
        (envelope-from <rjkm@morden.metzler>)
        id 1eCokc-0000oz-Jq
        for linux-media@vger.kernel.org; Thu, 09 Nov 2017 16:28:18 +0100
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23044.29714.500132.822313@morden.metzler>
Date: Thu, 9 Nov 2017 16:28:18 +0100
To: linux-media@vger.kernel.org
Subject: DVB-S2 and S2X API extensions
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a few RFCs regarding new needed enums and
properties for DVB-S2 and DVB-S2X:

- DVB-S2/X physical layer scrambling

I currently use the inofficial DTV_PLS for setting the scrambling
sequence index (cf. ETSI EN 300 468 table 41) of
the physical layer scrambling in DVB-S2 and DVB-S2X.
Some drivers already misuse bits 8-27 of the DTV_STREAM_ID
for setting this. They also differentiate between gold, root
and combo codes.
The gold code is the actual scrambling sequence index.
The root code is just an intermediate calculation
accepted by some chips, but derived from the gold code.
It can be easily mapped one-to-one to the gold code.
(see https://github.com/DigitalDevices/dddvb/blob/master/apps/pls.c,
A more optimized version of this could be added to dvb-math.c)
The combo code does not really exist but is a by-product
of the buggy usage of a gold to root code conversion in ST chips.

So, I would propose to officially introduce a property
for the scrambling sequence index (=gold code).
Should it be called DTV_PLS (which I already used in the dddvb package)
or rather DTV_SSI?
I realized PLS can be confused with physical layer signalling which
uses the acronym PLS in the DVB-S2 specs.

DVB-S2X also defines 7 preferred scrambling code sequences
(EN 302 307-2 5.5.4) which should be checked during tuning.
If the demod does not do this, should the DVB kernel layer or
application do this?


- slices

DVB-S2 and DVB-C2, additionally to ISI/PLP, also can have
slicing. For DVB-C2 I currently use bits 8-15 of DTV_STREAM_ID as slice id.
For DVB-S2/X the misuse of bits 8-27 by some drivers for selecting
the scrambling sequence index code could cause problems.
Should there be a new property for slice selection?
It is recommended that slice id and ISI/PLP id are identical but they
can be different.


- new DVB-S2X features

DVB-S2X needs some more roll-offs, FECs and modulations. I guess adding those
should be no problem?

Do we need FE_CAN_SLICES, FE_CAN_3G_MODULATION, etc?
Or would a new delivery system type for S2X make sense?


-DVB-S2 base band frame support

There are some older patches which allowed to switch the demod
to a raw BB frame mode (if it and the bridge support this) and
have those parsed in the DVB layer.

See
https://patchwork.linuxtv.org/patch/10402/
or
https://linuxtv.org/pipermail/linux-dvb/2007-December/022217.html

Chris Lee seems to have a tree based on those:
https://bitbucket.org/updatelee/v4l-updatelee


Another method to support this is to wrap the BB frames
into sections and deliver them as a normal transport stream.
Some demods and/or PCIe bridges support this in hardware.
This has the advantage that it would even work with SAT>IP.

How should the latter method be supported in the DVB API?
With a special stream id or separate porperty?
Switching to this mode could even be done automatically
in case of non-TS streams.



Regards,
Ralph
