Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:33397 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919AbZKDVqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 16:46:14 -0500
Received: by ewy3 with SMTP id 3so3623421ewy.37
        for <linux-media@vger.kernel.org>; Wed, 04 Nov 2009 13:46:18 -0800 (PST)
Date: Wed, 4 Nov 2009 22:46:07 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: TD <topper.doggle@googlemail.com>
cc: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Struggling with Astra 2D (Freesat) / Happauage
 Nova-HD-S2
In-Reply-To: <alpine.DEB.2.01.0911040518120.29421@ybpnyubfg.ybpnyqbznva>
Message-ID: <alpine.DEB.2.01.0911042230060.29421@ybpnyubfg.ybpnyqbznva>
References: <hcnd9s$c1f$1@ger.gmane.org> <20091102231735.63fd30c4@bk.ru> <hcnsfa$v70$1@ger.gmane.org> <alpine.DEB.2.01.0911030516050.29421@ybpnyubfg.ybpnyqbznva> <hcqi4n$ghe$1@ger.gmane.org> <alpine.DEB.2.01.0911040518120.29421@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replying to myself is the first sign that I need to be committed
to a mental institution.  So here goes.

On Wed, 4 Nov 2009, BOUWSMA Barry wrote:

> The other possibility, given that two of the four inputs to
> your multiswitch work, is that the two low-band inputs have
> been crossed.

Thinking more about this, I don't think this is the case,
if someone hasn't already corrected me -- there is a range
of frequencies which, last time I scanned, were shared by
both polarisations, with identical symbol rates.  Although
this was not legitimate input for an earlier `scan' and I've
hacked a script to work around this.

### frequency pairs, h+v, mostly 27500 from 11200 upwards
S 11222170 H 27500
S 11223670 V 27500
#
S 11259670 V 27500
####   This has an odd SR.... NO MORE...  S 11264470 H 22000
S 11261170 H 27500
#
S 11307000 V 27500
S 11307000 H 27500
#
S 11343000 V 27500
####   This has an odd SR....  NO MORE...  S 11344000 H 22000
S 11344500 H 27500
#
S 11388830 H 27500
S 11390330 V 27500

This continues, more or less, through 11500.  In other words,
if your two low-band inputs to the multiswitch were reversed,
you'd still get something on the above frequencies, even if
the actual parameters you'd be reading wouldn't match what is
actually transmitted.

Sorry for the misleading info I posted earlier.  If there is
any cabling problem, I'm positive it would have been noted
as the BBC channels are certain to be ones checked by any
halfway competent technician.

As far as the possibility that your tuner card isn't
properly switching into low-band, if you were to modify
your scan file so that the successfully-tuned frequencies
above 11700 are repeated but with a value corresponding
to the different IF frequency, and you can again receive
the same services, then that would point to that problem.

I'd give an example, but that would require me to think.
But here's the idea -- if you've tuned 11720, that's with
an IF of 10600.  With an IF of 9750, you'd want to be tuning
to 11720 - (10600-9750) MHz.

If that makes any sense.


thanks,
barry bouwsma
