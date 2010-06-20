Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:50882 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753526Ab0FTQpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jun 2010 12:45:04 -0400
Message-ID: <4C1E456D.8040301@arcor.de>
Date: Sun, 20 Jun 2010 18:44:29 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	d.belimov@gmail.com
Subject: Re: [PATCH] tm6000: add ir support
References: <1277048292-19215-1-git-send-email-stefan.ringel@arcor.de> <AANLkTimY13YXeDxjR_PRZ3qLXFj-pvVKJT1QMHn445TL@mail.gmail.com>
In-Reply-To: <AANLkTimY13YXeDxjR_PRZ3qLXFj-pvVKJT1QMHn445TL@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Am 20.06.2010 18:31, schrieb Jarod Wilson:
> On Sun, Jun 20, 2010 at 11:38 AM,  <stefan.ringel@arcor.de> wrote:
>> From: Stefan Ringel <stefan.ringel@arcor.de>
>>
>> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>> ---
>>  drivers/staging/tm6000/Makefile       |    3 +-
>>  drivers/staging/tm6000/tm6000-cards.c |   27 +++-
>>  drivers/staging/tm6000/tm6000-input.c |  357
+++++++++++++++++++++++++++++++++
>>  drivers/staging/tm6000/tm6000.h       |   11 +
>>  4 files changed, 396 insertions(+), 2 deletions(-)
>>  create mode 100644 drivers/staging/tm6000/tm6000-input.c
> ...
>> diff --git a/drivers/staging/tm6000/tm6000-input.c
b/drivers/staging/tm6000/tm6000-input.c
>> new file mode 100644
>> index 0000000..e45b443
>> --- /dev/null
>> +++ b/drivers/staging/tm6000/tm6000-input.c
>> @@ -0,0 +1,357 @@
>> +/*
>> +   tm6000-input.c - driver for TM5600/TM6000/TM6010 USB video capture
devices
>> +
>> +   Copyright (C) 2010 Stefan Ringel <stefan.ringel@arcor.de>
>> +
>> +   This program is free software; you can redistribute it and/or modify
>> +   it under the terms of the GNU General Public License as published by
>> +   the Free Software Foundation version 2
>> +
>> +   This program is distributed in the hope that it will be useful,
>> +   but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +   GNU General Public License for more details.
>> +
>> +   You should have received a copy of the GNU General Public License
>> +   along with this program; if not, write to the Free Software
>> +   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/delay.h>
>> +
>> +#include <linux/input.h>
>> +#include <linux/usb.h>
>> +
>> +#include "compat.h"
>> +#include "tm6000.h"
>> +#include "tm6000-regs.h"
>
> Please use the new ir-core infrastructure here. (#include
> <media/ir-core.h>, #include <media/rc-map.h>, and assorted code in
> drivers/media/IR/).
>
>
It use the new code (for example rc map in tm6000-card.c), but I can
added the header files. It doesn't use software encoding, it use
hardware encodeing.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQEcBAEBAgAGBQJMHkVtAAoJEAWtPFjxMvFGgA8IAKeW68Acv0jgJcV4gIWFiEk1
DFVdcvqbWQHbFzLPi427QjFFao8YRXT+XDnADVmYzneBAlcnsdfwHgi4ufCjB9BX
FqPhrhaePluGW4YmSGLHX135wNhfa8ZLSg7WMN0gNkif+4bJ1ZAXUtE1nVwzasVW
LHCY1IX5JtUH19PYdsozkJBgfyLAfgqmP7S35not6zsAjXsimp2vid4UNJ55MyOo
gcrkzcCxqaMkxLc3wKBtwrtb3hUQbJp3znkjPvIJTcFh5wzm+4yr9sk2heObNJVY
n7DVS+YMegBugq9wKNWNiL+eZQQ/IR8okm0qDneleP0seKirL2JHGeDw2z9CePk=
=09n5
-----END PGP SIGNATURE-----

