Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab3CGW1W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Mar 2013 17:27:22 -0500
Date: Thu, 7 Mar 2013 19:26:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: oliver+list@schinagl.nl, Jean Delvare <khali@linux-fr.org>,
	Linux Media <linux-media@vger.kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: drxk driver statistics
Message-ID: <20130307192659.201d6a55@redhat.com>
In-Reply-To: <1682f22b-3a4a-4473-b22e-c8cce3477092@email.android.com>
References: <20130306183604.3015c1f0@endymion.delvare>
	<51379EB3.3040900@schinagl.nl>
	<1682f22b-3a4a-4473-b22e-c8cce3477092@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 07 Mar 2013 16:18:41 -0500
Andy Walls <awalls@md.metrocast.net> escreveu:

> Oliver Schinagl <oliver@schinagl.nl> wrote:
> 
> >On 03/06/13 18:36, Jean Delvare wrote:
> >> Hi all,
> >>
> >> I have a TerraTec Cinergy T PCIe Dual card, with DRX-3916K and
> >> DRX-3913K frontends. I am thus using the drxk dvb-frontend driver.
> >> While trying to find the best antenna, position and amplification, I
> >> found that the statistics returned by the drxk driver look quite bad:
> >>
> >> $ femon -H 3
> >> FE: DRXK DVB-T (DVBT)
> >> status SCVYL | signal   0% | snr   0% | ber 0 | unc 38822 |
> >FE_HAS_LOCK
> >> status SCVYL | signal   0% | snr   0% | ber 0 | unc 38822 |
> >FE_HAS_LOCK
> >> status SCVYL | signal   0% | snr   0% | ber 0 | unc 38822 |
> >FE_HAS_LOCK
> >>
> >> This is with TV looking reasonably good, so these figures are not
> >> plausible.
> >>
> >> $ femon 10
> >> FE: DRXK DVB-T (DVBT)
> >> status SCVYL | signal 00de | snr 00f5 | ber 00000000 | unc 000097a6 |
> >FE_HAS_LOCK
> >> status SCVYL | signal 00f0 | snr 00f5 | ber 00000000 | unc 000097a6 |
> >FE_HAS_LOCK
> >> status SCVYL | signal 0117 | snr 00f6 | ber 00000000 | unc 000097a6 |
> >FE_HAS_LOCK
> >> status SCVYL | signal 00b6 | snr 00eb | ber 00000000 | unc 000097a6 |
> >FE_HAS_LOCK
> >> status SCVYL | signal 00d1 | snr 00e7 | ber 00000000 | unc 000097a6 |
> >FE_HAS_LOCK
> >> status SCVYL | signal 0073 | snr 00ea | ber 00000000 | unc 000097a6 |
> >FE_HAS_LOCK
> >> status SCVYL | signal 00a3 | snr 00ee | ber 00000000 | unc 000097a6 |
> >FE_HAS_LOCK
> >> status SCVYL | signal 00b5 | snr 00f4 | ber 00000000 | unc 000097a6 |
> >FE_HAS_LOCK
> >> status SCVYL | signal 00ba | snr 00f3 | ber 00000000 | unc 000097a6 |
> >FE_HAS_LOCK
> >> status SCVYL | signal 00be | snr 00f0 | ber 00000000 | unc 000097a6 |
> >FE_HAS_LOCK
> >>
> >> Signal values are changing too much, snr is stable enough but way too
> >> low, ber is apparently unimplemented, and unc is never reset AFAICS
> >(it
> >> started at 1 when the system started and has been only increasing
> >since
> >> then.) On my previous card, unc was an instant measurement, not a
> >> cumulative value, not sure which is correct.
> >Yes I found that out aswell, but since image quality has always been 
> >very fine, I haven't looked what this all should be.
> >>
> >> I would like to see these statistics improved. I am willing to help,
> >> however the drxk driver is rather complex (at least to my eyes) and I
> >> do not have a datasheet so I wouldn't know where to start. Is there
> >> anyone who can work on this and/or provide some guidance?
> >>
> >> Thanks,
> >>
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media"
> >in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Unc should be a cumulative value and not reset after each read.  Then you can support a use case of 2 different apps monitoring the statistics.
> 
> I can't recall when exactly unc should be reset, but of frequency change sounds reasonable.

According with the DVBv3 API spec, never.

The DVBv5 stats API moves the policy to userspace, as it measures both
the number of uncorrected error blocks and the total amount of blocks.
Both counters are now unsigned 64 bits integers.

So, userspace may apply any policy it wants, by keeping stored the
previous counter for a given amount of time (or even using something more
sophisticated, like a convolution filter or a moving average filter).

The libdvbv5 currently applies a very simple policy for it.

Regards,
Mauro
