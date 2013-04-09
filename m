Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37285 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934655Ab3DISe0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 14:34:26 -0400
Message-ID: <51645F09.9040901@iki.fi>
Date: Tue, 09 Apr 2013 21:33:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Diorser <diorser@gmx.fr>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: AverTV_A918R (af9035-af9033-tda18218) / patch proposal
References: <op.wp845xcf4bfdfw@quantal> <50E36298.3040009@iki.fi> <op.wu93cgqr4bfdfw@wheezy>
In-Reply-To: <op.wu93cgqr4bfdfw@wheezy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/09/2013 05:46 PM, Diorser wrote:
> Hello,
>
> Please find below some news for A918R
> [details @
> http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_HD_Express_A918R ]
>
> * the patch proposed to automatically load the right modules for A918R
> card is not yet available
> => http://www.mail-archive.com/linux-media@vger.kernel.org/msg56659.html
> (I don't exactly know what is missing to make it accepted).
> This patch would at least avoid having to modify dvb-usb-ids.h &
> af9035.c each time to test some git updates.
>
> * previously, in December, the signal level detection was fuzzy and not
> reliable.
> Now, the reported signal level is strictly at 0000 (good antenna RF
> signal confirmed with other device).
>
> I am aware A918R card is not the most requested one (Express card), but
> that's all I can add in case it can help, even for another card.
>
> Regards.

Patch, which adds USB ID, is not acceptable unless device is know to be 
working. It currently works only partially by loading correct modules 
but tuning does not work. Surely, it is not very many lines code to fix 
it - most likely just some GPIO setting (antenna switch?).

regards
Antti

-- 
http://palosaari.fi/
