Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48465 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab0FTQiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jun 2010 12:38:09 -0400
Received: by qyk1 with SMTP id 1so974880qyk.19
        for <linux-media@vger.kernel.org>; Sun, 20 Jun 2010 09:38:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277048292-19215-1-git-send-email-stefan.ringel@arcor.de>
References: <1277048292-19215-1-git-send-email-stefan.ringel@arcor.de>
Date: Sun, 20 Jun 2010 12:31:42 -0400
Message-ID: <AANLkTimY13YXeDxjR_PRZ3qLXFj-pvVKJT1QMHn445TL@mail.gmail.com>
Subject: Re: [PATCH] tm6000: add ir support
From: Jarod Wilson <jarod@wilsonet.com>
To: stefan.ringel@arcor.de
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	d.belimov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 20, 2010 at 11:38 AM,  <stefan.ringel@arcor.de> wrote:
> From: Stefan Ringel <stefan.ringel@arcor.de>
>
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/Makefile       |    3 +-
>  drivers/staging/tm6000/tm6000-cards.c |   27 +++-
>  drivers/staging/tm6000/tm6000-input.c |  357 +++++++++++++++++++++++++++++++++
>  drivers/staging/tm6000/tm6000.h       |   11 +
>  4 files changed, 396 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/staging/tm6000/tm6000-input.c
...
> diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
> new file mode 100644
> index 0000000..e45b443
> --- /dev/null
> +++ b/drivers/staging/tm6000/tm6000-input.c
> @@ -0,0 +1,357 @@
> +/*
> +   tm6000-input.c - driver for TM5600/TM6000/TM6010 USB video capture devices
> +
> +   Copyright (C) 2010 Stefan Ringel <stefan.ringel@arcor.de>
> +
> +   This program is free software; you can redistribute it and/or modify
> +   it under the terms of the GNU General Public License as published by
> +   the Free Software Foundation version 2
> +
> +   This program is distributed in the hope that it will be useful,
> +   but WITHOUT ANY WARRANTY; without even the implied warranty of
> +   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +   GNU General Public License for more details.
> +
> +   You should have received a copy of the GNU General Public License
> +   along with this program; if not, write to the Free Software
> +   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/delay.h>
> +
> +#include <linux/input.h>
> +#include <linux/usb.h>
> +
> +#include "compat.h"
> +#include "tm6000.h"
> +#include "tm6000-regs.h"

Please use the new ir-core infrastructure here. (#include
<media/ir-core.h>, #include <media/rc-map.h>, and assorted code in
drivers/media/IR/).


-- 
Jarod Wilson
jarod@wilsonet.com
