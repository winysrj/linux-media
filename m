Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:39242 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab0KMTjN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 14:39:13 -0500
Message-ID: <4CDEE95C.90601@infradead.org>
Date: Sat, 13 Nov 2010 17:39:08 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org
Subject: Re: Raw mode for SAA7134_BOARD_ENCORE_ENLTV_FM53?
References: <20101112141453.GA15756@hardeman.nu> <4CDD4DFC.4080105@infradead.org> <20101112210656.GB18719@hardeman.nu>
In-Reply-To: <20101112210656.GB18719@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-11-2010 19:06, David Härdeman escreveu:
> On Fri, Nov 12, 2010 at 12:23:56PM -0200, Mauro Carvalho Chehab wrote:
>> Em 12-11-2010 12:14, David Härdeman escreveu:
>>> Mauro,
>>>
>>> as far as I could tell, you wrote the initial support for
>>> SAA7134_BOARD_ENCORE_ENLTV_FM53 in
>>> drivers/media/video/saa7134/saa7134-input.c, right?
>>>
>>> It appears to be the only user of ir-functions.c left in that driver and
>>> I'm wondering if it could be converted to use raw_decode with a patch
>>> similar to what you committed for SAA7134_BOARD_ASUSTeK_P7131_ANALOG?
>>>
>> I need to check if I still have this board, or if it were a board that
>> someone borrowed me.
>>
>> I'll put it on my todo list.
> 
> Since that list is probably quite long, anyone else who reads this and
> who has an Encore ENLTV-FM v5.3, feel free to get in touch with me in
> the meantime.

Fortunately, the board is here. I received 4 boards almost the same time,
and I had to return 2 of them. Thankfully, this were not one of them ;)

OK, I did some tests, and it works properly with the raw decoders. So,
I'm posting 3 patches converting it to use the raw decoders, and removing
the legacy code.

There's still one old board (6+ years) at bttv that uses the raw decoding
via the old way. For now, I just moved the legacy code into bttv driver.
I think it won't be easy to find someone with this legacy hardware that
could help on some tests, so, it may take some time until we can get rid
of those legacy code there.

Cheers,
Mauro.
