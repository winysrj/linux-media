Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40662 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759145Ab1JFVOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 17:14:00 -0400
Received: by wwf22 with SMTP id 22so4897282wwf.1
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2011 14:13:59 -0700 (PDT)
Message-ID: <4e8e1a15.8dcfe30a.28b8.243e@mx.google.com>
Subject: Re: [PATCH] af9013 frontend tuner bus lock
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Josu Lazkano <josu.lazkano@gmail.com>
Cc: Jason Hecker <jwhecker@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Thu, 06 Oct 2011 22:13:51 +0100
In-Reply-To: <CAL9G6WXX2eGmoT+ozv1F0JQdSV5JPwbB0vn70UL+ghgkLGsYQg@mail.gmail.com>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	 <CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	 <CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
	 <4e8b8099.95d1e30a.4bee.0501@mx.google.com>
	 <CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
	 <CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
	 <CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
	 <CAL9G6WXX2eGmoT+ozv1F0JQdSV5JPwbB0vn70UL+ghgkLGsYQg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2011-10-06 at 01:12 +0200, Josu Lazkano wrote:
> 2011/10/6 Jason Hecker <jwhecker@gmail.com>:
> >> http://palosaari.fi/linux/v4l-dvb/firmware/af9015/5.1.0.0/dvb-usb-af9015.fw
> >
> > 5.1?  OK, I might eventually try that one too.
> >

> Oct  5 21:40:46 htpc kernel: [ 5576.241897] af9013: I2C read failed reg:d2e6
> Oct  5 23:07:33 htpc kernel: [10782.852522] af9013: I2C read failed reg:d2e6
> Oct  5 23:20:11 htpc kernel: [11540.824515] af9013: I2C read failed reg:d07c
> Oct  6 00:11:41 htpc kernel: [14631.122384] af9013: I2C read failed reg:d2e6
> Oct  6 00:26:13 htpc kernel: [15502.900549] af9013: I2C read failed reg:d2e6
> Oct  6 00:39:58 htpc kernel: [16328.273015] af9013: I2C read failed reg:d330
> 
> My signal is this:
> 
> (idle)
> $ femon -H -a 4
> FE: Afatech AF9013 DVB-T (DVBT)
> status S     | signal  75% | snr   0% | ber 0 | unc 0 |
> status S     | signal  75% | snr   0% | ber 0 | unc 0 |
> status S     | signal  75% | snr   0% | ber 0 | unc 0 |
> status S     | signal  75% | snr   0% | ber 0 | unc 0 |
> status S     | signal  74% | snr   0% | ber 0 | unc 0 |
> status S     | signal  74% | snr   0% | ber 0 | unc 0 |
> 
> (watching)
> $ femon -H -a 5
> FE: Afatech AF9013 DVB-T (DVBT)
> status SCVYL | signal  74% | snr   0% | ber 142 | unc 319408 | FE_HAS_LOCK
> status SCVYL | signal  74% | snr   0% | ber 142 | unc 319408 | FE_HAS_LOCK
> status SCVYL | signal  74% | snr   0% | ber 31 | unc 319430 | FE_HAS_LOCK
> status SCVYL | signal  74% | snr   0% | ber 31 | unc 319430 | FE_HAS_LOCK
> status SCVYL | signal  74% | snr   0% | ber 56 | unc 319519 | FE_HAS_LOCK
> status SCVYL | signal  74% | snr   0% | ber 0 | unc 319519 | FE_HAS_LOCK
> status SCVYL | signal  74% | snr   0% | ber 0 | unc 319519 | FE_HAS_LOCK
> 
> There are lots of ber and unc bits, I have connected the TV to the
> same wire and there is a good signal.
Using femon bypasses the bus lock, so changes will have to be made to
the patch.

At the moment it looks like not much change.  Unless the corruption in
the first frontend can be solved.

Regards

Malcolm

