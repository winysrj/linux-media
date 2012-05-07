Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49151 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382Ab2EGSrL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 14:47:11 -0400
Message-ID: <4FA818AA.6020709@iki.fi>
Date: Mon, 07 May 2012 21:47:06 +0300
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
>
> Signed-off-by: Hans-Frieder Vogt<hfvogt@gmx.net>

Applied and PULL requested via my tree. Thanks!

regards
Antti

-- 
http://palosaari.fi/
