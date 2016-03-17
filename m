Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33350 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbcCQIRY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 04:17:24 -0400
Received: by mail-wm0-f43.google.com with SMTP id l68so14398601wml.0
        for <linux-media@vger.kernel.org>; Thu, 17 Mar 2016 01:17:23 -0700 (PDT)
Date: Thu, 17 Mar 2016 09:57:31 +0200
From: Leon Romanovsky <leon@leon.nu>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	devel@driverdev.osuosl.org, kernel-mentors@selenic.com,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Add tw5864 driver
Message-ID: <20160317075731.GC25216@leon.nu>
Reply-To: leon@leon.nu
References: <1457920461-20713-1-git-send-email-andrey_utkin@fastmail.com>
 <1457920514-20792-1-git-send-email-andrey_utkin@fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1457920514-20792-1-git-send-email-andrey_utkin@fastmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 14, 2016 at 03:55:14AM +0200, Andrey Utkin wrote:
> From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> 
> Support for boards based on Techwell TW5864 chip which provides
> multichannel video & audio grabbing and encoding (H.264, MJPEG,
> ADPCM G.726).
> 
> Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> Tested-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> ---
>  MAINTAINERS                                  |    7 +
>  drivers/staging/media/Kconfig                |    2 +
>  drivers/staging/media/Makefile               |    1 +
>  drivers/staging/media/tw5864/Kconfig         |   11 +
>  drivers/staging/media/tw5864/Makefile        |    3 +
>  drivers/staging/media/tw5864/tw5864-bs.h     |  154 ++
>  drivers/staging/media/tw5864/tw5864-config.c |  359 +++++
>  drivers/staging/media/tw5864/tw5864-core.c   |  453 ++++++
>  drivers/staging/media/tw5864/tw5864-h264.c   |  183 +++
>  drivers/staging/media/tw5864/tw5864-reg.h    | 2200 ++++++++++++++++++++++++++
>  drivers/staging/media/tw5864/tw5864-tables.h |  237 +++
>  drivers/staging/media/tw5864/tw5864-video.c  | 1364 ++++++++++++++++
>  drivers/staging/media/tw5864/tw5864.h        |  280 ++++
>  include/linux/pci_ids.h                      |    1 +
>  14 files changed, 5255 insertions(+)
>  create mode 100644 drivers/staging/media/tw5864/Kconfig
>  create mode 100644 drivers/staging/media/tw5864/Makefile
>  create mode 100644 drivers/staging/media/tw5864/tw5864-bs.h
>  create mode 100644 drivers/staging/media/tw5864/tw5864-config.c
>  create mode 100644 drivers/staging/media/tw5864/tw5864-core.c
>  create mode 100644 drivers/staging/media/tw5864/tw5864-h264.c
>  create mode 100644 drivers/staging/media/tw5864/tw5864-reg.h
>  create mode 100644 drivers/staging/media/tw5864/tw5864-tables.h
>  create mode 100644 drivers/staging/media/tw5864/tw5864-video.c
>  create mode 100644 drivers/staging/media/tw5864/tw5864.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 409509d..7bb1fa9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11195,6 +11195,13 @@ T:	git git://linuxtv.org/media_tree.git
>  S:	Odd fixes
>  F:	drivers/media/usb/tm6000/
>  
> +TW5864 VIDEO4LINUX DRIVER
> +M:	Bluecherry Maintainers <maintainers@bluecherrydvr.com>

I wonder if this the right thing to do. Generally speaking a maintainer is a
person and not a corporate.

> +M:	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> +L:	linux-media@vger.kernel.org
> +S:	Supported
> +F:	drivers/staging/media/tw5864/

<snip>

> +
> --- /dev/null
> +++ b/drivers/staging/media/tw5864/tw5864-bs.h
> @@ -0,0 +1,154 @@
> +/*
> + *  TW5864 driver - Exp-Golomb code functions
> + *
> + *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
> + *  Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>

You don't need to state your name here. It is written in git log.
