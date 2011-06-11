Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:47712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab1FKNiU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 09:38:20 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5BDcJvf021101
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 11 Jun 2011 09:38:19 -0400
Message-ID: <4DF36FC9.6020803@redhat.com>
Date: Sat, 11 Jun 2011 10:38:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] rc-core support for Microsoft IR keyboard/mouse
References: <1307136508-19455-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1307136508-19455-1-git-send-email-jarod@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-06-2011 18:28, Jarod Wilson escreveu:
> This is a custom IR protocol decoder, for the RC-6-ish protocol used by
> the Microsoft Remote Keyboard.
> 
> http://www.amazon.com/Microsoft-Remote-Keyboard-Windows-ZV1-00004/dp/B000AOAAN8
> 
> Its a standard keyboard with embedded thumb stick mouse pointer and
> mouse buttons, along with a number of media keys. The media keys are
> standard RC-6, identical to the signals from the stock MCE remotes, and
> will be handled as such. The keyboard and mouse signals will be decoded
> and delivered to the system by an input device registered specifically
> by this driver.
> 
> Successfully tested with an mceusb-driven receiver, but this should
> actually work with any raw IR rc-core receiver.
> 
> This work is inspired by lirc_mod_mce:
> 
> http://mod-mce.sourceforge.net/
> 
> The documentation there and code aided in understanding and decoding the
> protocol, but the bulk of the code is actually borrowed more from the
> existing in-kernel decoders than anything. I did recycle the keyboard
> keycode table and a few defines from lirc_mod_mce though.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---

I did only a quick review, and everything looks fine for me. Just two comments:

> +#if 0
> +	/* Adding this reference means two input devices are associated with
> +	 * this rc-core device, which ir-keytable doesn't cope with yet */
> +	idev->dev.parent = &dev->dev;
> +#endif

Well, it was never tested with such config ;) Feel free to fix rc-core.

> +static unsigned char kbd_keycodes[256] = {
> +          0,   0,   0,   0,  30,  48,  46,  32,  18,  33,  34,  35,  23,  36,  37,  38,
> +         50,  49,  24,  25,  16,  19,  31,  20,  22,  47,  17,  45,  21,  44,   2,   3,
> +          4,   5,   6,   7,   8,   9,  10,  11,  28,   1,  14,  15,  57,  12,  13,  26,
> +         27,  43,  43,  39,  40,  41,  51,  52,  53,  58,  59,  60,  61,  62,  63,  64,
> +         65,  66,  67,  68,  87,  88,  99,  70, 119, 110, 102, 104, 111, 107, 109, 106,
> +        105, 108, 103,  69,  98,  55,  74,  78,  96,  79,  80,  81,  75,  76,  77,  71,
> +         72,  73,  82,  83,  86, 127, 116, 117, 183, 184, 185, 186, 187, 188, 189, 190,
> +        191, 192, 193, 194, 134, 138, 130, 132, 128, 129, 131, 137, 133, 135, 136, 113,
> +        115, 114,   0,   0,   0, 121,   0,  89,  93, 124,  92,  94,  95,   0,   0,   0,
> +        122, 123,  90,  91,  85,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
> +          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
> +          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
> +          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
> +          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
> +         29,  42,  56, 125,  97,  54, 100, 126, 164, 166, 165, 163, 161, 115, 114, 113,
> +        150, 158, 159, 128, 136, 177, 178, 176, 142, 152, 173, 140
> +};

This table looks weird to me: too much magic numbers there. Shouldn't
the above be replaced by KEY_* definitions?

Cheers,
Mauro

-

PS.: I would like to have one of those keyboards, in order to test some things here,
in special, for the xorg input/event proposal on my TODO list ;) Is it a cheap device?
I may try to buy one the next time I would travel to US.
