Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47015 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab2EGNZu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 09:25:50 -0400
Message-ID: <4FA7CD5B.3020902@iki.fi>
Date: Mon, 07 May 2012 16:25:47 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
	Gianluca Gennari <gennarone@gmail.com>
Subject: Re: [PATCH v2] af9033: implement ber and ucb functions
References: <201204071634.34179.hfvogt@gmx.net>
In-Reply-To: <201204071634.34179.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07.04.2012 17:34, Hans-Frieder Vogt wrote:
> af9033: implement read_ber and read_ucblocks functions. Version 2 of patch that
> reflects my findings on the behaviour of abort_cnt, err_cnt and bit_cnt:
>
> - bit_cnt is always 0x2710 (10000)
> - abort_cnt is between 0 and 0x2710
> - err_cnt is between 0 and 640000 (= 0x2710 * 8 * 8)
>
> in the current implementation BER is calculated as the number of bit errors per
> processed bits, ignoring those bits that are already discarded and counted in
> abort_cnt, i.e. UCBLOCKS.

It still increases UCBLOCKS counter every query even there is no signal 
at all. BER is in that case always maximum value. Hymps, maybe I just 
apply that still in order to go ahead...

status 00 | signal 0000 | snr 0000 | ber ffffffff | unc 0024b105 |
status 00 | signal 0000 | snr 0000 | ber ffffffff | unc 0024d815 |

One of my plans is to block that kind of "illegal" situations in 
frontend core level. As UCB and BER counters are only valid in case of 
demod is LOCKed.

regards
Antti
-- 
http://palosaari.fi/
