Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49232 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679AbaKOBgn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 20:36:43 -0500
Message-ID: <5466AE29.2080502@iki.fi>
Date: Sat, 15 Nov 2014 03:36:41 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: CrazyCat <crazycat69@narod.ru>,
	linux-media <linux-media@vger.kernel.org>,
	Olli Salonen <olli.salonen@iki.fi>
Subject: Re: [PATCH 1/3] tuners: si2157: Si2148 support.
References: <1918522.5V5b9CGsli@computer> <5466A606.8030805@iki.fi> <525911416014537@web7h.yandex.ru>
In-Reply-To: <525911416014537@web7h.yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/15/2014 03:22 AM, CrazyCat wrote:
> 2148 is 2158 without analog support. Same firmware.
>
> 15.11.2014, 03:02, "Antti Palosaari" <crope@iki.fi>:
>> I wonder if we should define own firmware for Si2148-A20 just for sure.
>> Olli?

But still... I have seen one case where even same revision of si2168 
needs different firmware. It is not very clear for me how SiLabs uses 
these firmwares, but at least it seems to be:

* There is different versions done from same chips. A10 < A20 < A30 < 
B40 and so. I think that means digital logic inside of chip is changed 
when they change that revision number.

* Every chip has a ROM, containing default firmware. Firmware which 
driver downloads is just a patch to that ROM. ROM is updated regularly 
when new patch of chips are manufactured.


So currently I have feeling it is better to define as many firmware 
files as there chip revisions available, even same firmware works for 
multiple chip models/versions/revisions.

regards
Antti

-- 
http://palosaari.fi/
