Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46067 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab2DAV44 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 17:56:56 -0400
Message-ID: <4F78CF26.3080704@iki.fi>
Date: Mon, 02 Apr 2012 00:56:54 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] AF9033 read_ber and read_ucblocks implementation
References: <4F75A7FE.8090405@iki.fi> <201204012011.29830.hfvogt@gmx.net> <201204012307.31742.hfvogt@gmx.net> <201204012319.12575.hfvogt@gmx.net>
In-Reply-To: <201204012319.12575.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02.04.2012 00:19, Hans-Frieder Vogt wrote:
> Implementation of af9033_read_ber and af9033_read_ucblocks functions.
>
> Signed-off-by: Hans-Frieder Vogt<hfvogt@gmx.net>

>   drivers/media/dvb/dvb-usb/af9033.c |   68 +++++++++++++++++++++++++++++++++++--

Same wrong path issue.

> +	/* only update data every half second */
> +	if (time_after(jiffies, state->last_stat_check + 500 * HZ / 1000)) {

500 * HZ looks odd. I suspect correct way is to use some macros for 
that. See af9013 example usage of jiffies or explain the reason why 500 
* HZ :)

> +		sw = ~sw;

I don't see any reason for that?


It looked somehow complex, but I trust those calculations are kinda correct.


IMHO it is enough to put random raw number from register to UCB and BER 
counters. Random numbers are good enough unless you are making 
measurement equipment. But off-course correct calculations are allowed.

regards
Antti
-- 
http://palosaari.fi/
