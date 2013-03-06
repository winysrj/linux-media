Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab3CFVOb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 16:14:31 -0500
Date: Wed, 6 Mar 2013 18:14:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: oliver+list@schinagl.nl, oliver@schinagl.nl,
	Linux Media <linux-media@vger.kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: drxk driver statistics
Message-ID: <20130306181411.7e6f0e4a@redhat.com>
In-Reply-To: <51379EB3.3040900@schinagl.nl>
References: <20130306183604.3015c1f0@endymion.delvare>
	<51379EB3.3040900@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 06 Mar 2013 20:53:23 +0100
Oliver Schinagl <oliver@schinagl.nl> escreveu:

> On 03/06/13 18:36, Jean Delvare wrote:
> > Hi all,
> >
> > I have a TerraTec Cinergy T PCIe Dual card, with DRX-3916K and
> > DRX-3913K frontends. I am thus using the drxk dvb-frontend driver.
> > While trying to find the best antenna, position and amplification, I
> > found that the statistics returned by the drxk driver look quite bad:
> >
> > $ femon -H 3
> > FE: DRXK DVB-T (DVBT)
> > status SCVYL | signal   0% | snr   0% | ber 0 | unc 38822 | FE_HAS_LOCK
> > status SCVYL | signal   0% | snr   0% | ber 0 | unc 38822 | FE_HAS_LOCK
> > status SCVYL | signal   0% | snr   0% | ber 0 | unc 38822 | FE_HAS_LOCK
> >
> > This is with TV looking reasonably good, so these figures are not
> > plausible.
> >
> > $ femon 10
> > FE: DRXK DVB-T (DVBT)
> > status SCVYL | signal 00de | snr 00f5 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
> > status SCVYL | signal 00f0 | snr 00f5 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
> > status SCVYL | signal 0117 | snr 00f6 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
> > status SCVYL | signal 00b6 | snr 00eb | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
> > status SCVYL | signal 00d1 | snr 00e7 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
> > status SCVYL | signal 0073 | snr 00ea | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
> > status SCVYL | signal 00a3 | snr 00ee | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
> > status SCVYL | signal 00b5 | snr 00f4 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
> > status SCVYL | signal 00ba | snr 00f3 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
> > status SCVYL | signal 00be | snr 00f0 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
> >
> > Signal values are changing too much, snr is stable enough but way too
> > low, ber is apparently unimplemented, and unc is never reset AFAICS (it
> > started at 1 when the system started and has been only increasing since
> > then.) On my previous card, unc was an instant measurement, not a
> > cumulative value, not sure which is correct.
> Yes I found that out aswell, but since image quality has always been 
> very fine, I haven't looked what this all should be.
> >
> > I would like to see these statistics improved. I am willing to help,
> > however the drxk driver is rather complex (at least to my eyes) and I
> > do not have a datasheet so I wouldn't know where to start. Is there
> > anyone who can work on this and/or provide some guidance?

Terratec released some time ago the source code for Azureus 6007 that
uses the drx-k demod. I think it is still there at:
	http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz

The stats logic there is a little more complete than the one backported to
the Kernel. I've plans to add support for DVBv5 statistics, but, even
on the above driver, it was not trivial to discover the scale for the
parameters.

-- 

Cheers,
Mauro
