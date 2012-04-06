Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:54295 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751588Ab2DFIfG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2012 04:35:06 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] af9033: implement ber and ucb functions
Date: Fri, 6 Apr 2012 10:34:56 +0200
Cc: linux-media@vger.kernel.org
References: <201204032259.43658.hfvogt@gmx.net> <4F7B79F0.7010707@iki.fi>
In-Reply-To: <4F7B79F0.7010707@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204061034.56132.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, 4. April 2012 schrieb Antti Palosaari:
> On 03.04.2012 23:59, Hans-Frieder Vogt wrote:
> > af9033: implement read_ber and read_ucblocks functions.
> > 
> > Signed-off-by: Hans-Frieder Vogt<hfvogt@gmx.net>
> 
> For my quick test UCB counter seems to reset every query. That is
> violation of API. See http://www.kernel.org/doc/htmldocs/media.html> 

Indeed, interesting.
I quickly checked the behaviour with a dibcom based stick (dib7000p 
demodulator) and the uncorrected block number reduces there as well. It seems, 
other demodulator drivers ignore this detail as well. But that's not meant to 
be an excuse.....

$ tzap -r sixx
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/xxxx/.tzap/channels.conf'
tuning to 754000000 Hz
video pid 0x0111, audio pid 0x0112
status 1f | signal a7f5 | snr 007c | ber 001fffff | unc 000001f2 | FE_HAS_LOCK
status 1f | signal a539 | snr 0080 | ber 00091280 | unc 00001071 | FE_HAS_LOCK
status 1f | signal a5eb | snr 0084 | ber 000a06e0 | unc 00000c6c | FE_HAS_LOCK
status 1f | signal a620 | snr 0087 | ber 0009f4b0 | unc 00000d78 | FE_HAS_LOCK
status 1f | signal a60c | snr 0080 | ber 000a5af0 | unc 00000df3 | FE_HAS_LOCK
status 1f | signal a68f | snr 0082 | ber 0009bfa0 | unc 00000e6f | FE_HAS_LOCK
status 1f | signal a678 | snr 007e | ber 000a17b0 | unc 00000cb8 | FE_HAS_LOCK
status 1f | signal a679 | snr 0085 | ber 000ad900 | unc 000009ea | FE_HAS_LOCK
status 1f | signal a6ee | snr 0082 | ber 000b0fa0 | unc 0000075c | FE_HAS_LOCK


> Do you have attenuator you can run tests yourself? It is very cheap and
> useful when coding that kind of signal statistics.

I haven't got an attenuator, but some very weak signals (see above), which 
should serve the same purpose.

> 
> Current API does not even define anymore units for BER and UCB, so those
> calculations are not necessary. Anyhow, you can add some calculations if
> you wish.
> 
> 
> regards
> Antti
cheers,

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
