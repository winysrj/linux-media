Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:39401 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab0KLVG7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 16:06:59 -0500
Date: Fri, 12 Nov 2010 22:06:56 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: Re: Raw mode for SAA7134_BOARD_ENCORE_ENLTV_FM53?
Message-ID: <20101112210656.GB18719@hardeman.nu>
References: <20101112141453.GA15756@hardeman.nu>
 <4CDD4DFC.4080105@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CDD4DFC.4080105@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Nov 12, 2010 at 12:23:56PM -0200, Mauro Carvalho Chehab wrote:
>Em 12-11-2010 12:14, David Härdeman escreveu:
>> Mauro,
>> 
>> as far as I could tell, you wrote the initial support for
>> SAA7134_BOARD_ENCORE_ENLTV_FM53 in
>> drivers/media/video/saa7134/saa7134-input.c, right?
>> 
>> It appears to be the only user of ir-functions.c left in that driver and
>> I'm wondering if it could be converted to use raw_decode with a patch
>> similar to what you committed for SAA7134_BOARD_ASUSTeK_P7131_ANALOG?
>> 
>I need to check if I still have this board, or if it were a board that
>someone borrowed me.
>
>I'll put it on my todo list.

Since that list is probably quite long, anyone else who reads this and
who has an Encore ENLTV-FM v5.3, feel free to get in touch with me in
the meantime.

-- 
David Härdeman
