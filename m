Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:8346 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3CFRgO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 12:36:14 -0500
Date: Wed, 6 Mar 2013 18:36:04 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: drxk driver statistics
Message-ID: <20130306183604.3015c1f0@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have a TerraTec Cinergy T PCIe Dual card, with DRX-3916K and
DRX-3913K frontends. I am thus using the drxk dvb-frontend driver.
While trying to find the best antenna, position and amplification, I
found that the statistics returned by the drxk driver look quite bad:

$ femon -H 3
FE: DRXK DVB-T (DVBT)
status SCVYL | signal   0% | snr   0% | ber 0 | unc 38822 | FE_HAS_LOCK
status SCVYL | signal   0% | snr   0% | ber 0 | unc 38822 | FE_HAS_LOCK
status SCVYL | signal   0% | snr   0% | ber 0 | unc 38822 | FE_HAS_LOCK

This is with TV looking reasonably good, so these figures are not
plausible.

$ femon 10
FE: DRXK DVB-T (DVBT)
status SCVYL | signal 00de | snr 00f5 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
status SCVYL | signal 00f0 | snr 00f5 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
status SCVYL | signal 0117 | snr 00f6 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
status SCVYL | signal 00b6 | snr 00eb | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
status SCVYL | signal 00d1 | snr 00e7 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
status SCVYL | signal 0073 | snr 00ea | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
status SCVYL | signal 00a3 | snr 00ee | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
status SCVYL | signal 00b5 | snr 00f4 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
status SCVYL | signal 00ba | snr 00f3 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK
status SCVYL | signal 00be | snr 00f0 | ber 00000000 | unc 000097a6 | FE_HAS_LOCK

Signal values are changing too much, snr is stable enough but way too
low, ber is apparently unimplemented, and unc is never reset AFAICS (it
started at 1 when the system started and has been only increasing since
then.) On my previous card, unc was an instant measurement, not a
cumulative value, not sure which is correct.

I would like to see these statistics improved. I am willing to help,
however the drxk driver is rather complex (at least to my eyes) and I
do not have a datasheet so I wouldn't know where to start. Is there
anyone who can work on this and/or provide some guidance?

Thanks,
-- 
Jean Delvare
