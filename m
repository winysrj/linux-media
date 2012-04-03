Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33521 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab2DCWaK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 18:30:10 -0400
Message-ID: <4F7B79F0.7010707@iki.fi>
Date: Wed, 04 Apr 2012 01:30:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] af9033: implement ber and ucb functions
References: <201204032259.43658.hfvogt@gmx.net>
In-Reply-To: <201204032259.43658.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.04.2012 23:59, Hans-Frieder Vogt wrote:
> af9033: implement read_ber and read_ucblocks functions.
>
> Signed-off-by: Hans-Frieder Vogt<hfvogt@gmx.net>

For my quick test UCB counter seems to reset every query. That is 
violation of API. See http://www.kernel.org/doc/htmldocs/media.html

Do you have attenuator you can run tests yourself? It is very cheap and 
useful when coding that kind of signal statistics.

Current API does not even define anymore units for BER and UCB, so those 
calculations are not necessary. Anyhow, you can add some calculations if 
you wish.


regards
Antti
-- 
http://palosaari.fi/
