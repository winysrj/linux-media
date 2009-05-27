Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50595 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbZE0IFF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 04:05:05 -0400
Message-ID: <4A1CF42F.2070908@iki.fi>
Date: Wed, 27 May 2009 11:05:03 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] how to get the SNR DB value for DVICO DVB-T Dual
 express card
References: <cae4ceb0905261137g7f1e7aa5w1f0361bbe704e147@mail.gmail.com>
In-Reply-To: <cae4ceb0905261137g7f1e7aa5w1f0361bbe704e147@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/26/2009 09:37 PM, Tu-Tu Yu wrote:
> Hello:
> this is the output of the status... I would like to know how to
> calculate the the SNR DB value. Thank you so much!
> The frontend they used for DVB-T DUAL express is "Zarlink zl10353 DVB-T"
>
> status 1e | signal b788 | snr 0f1f1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1e | signal b78c | snr 0f2f2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1e | signal b77c | snr 0f2f2 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1e | signal b780 | snr 0f1f1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1e | signal b774 | snr 0f1f1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1e | signal b77c | snr 0f1f1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK

0xf1/8 = 30.125dB

regards
Antti
-- 
http://palosaari.fi/
