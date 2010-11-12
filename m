Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:48948 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab0KLOYB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 09:24:01 -0500
Message-ID: <4CDD4DFC.4080105@infradead.org>
Date: Fri, 12 Nov 2010 12:23:56 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org
Subject: Re: Raw mode for SAA7134_BOARD_ENCORE_ENLTV_FM53?
References: <20101112141453.GA15756@hardeman.nu>
In-Reply-To: <20101112141453.GA15756@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-11-2010 12:14, David Härdeman escreveu:
> Mauro,
> 
> as far as I could tell, you wrote the initial support for
> SAA7134_BOARD_ENCORE_ENLTV_FM53 in
> drivers/media/video/saa7134/saa7134-input.c, right?
> 
> It appears to be the only user of ir-functions.c left in that driver and
> I'm wondering if it could be converted to use raw_decode with a patch
> similar to what you committed for SAA7134_BOARD_ASUSTeK_P7131_ANALOG?
> 
I need to check if I still have this board, or if it were a board that
someone borrowed me.

I'll put it on my todo list.

Cheers,
Mauro
