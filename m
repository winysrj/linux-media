Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759546Ab2D0LGn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 07:06:43 -0400
Message-ID: <4F9A7DB6.8090103@redhat.com>
Date: Fri, 27 Apr 2012 08:06:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Subject: Re: [PATCH 1/6 v2] dvbsky, montage dvb-s/s2 TS202x tuner and M88DS3103
 demodulator driver
References: <1327228731.2540.3.camel@tvbox>, <4F2185A1.2000402@redhat.com>, <201204152353103757288@gmail.com>, <201204201601166255937@gmail.com>, <4F9130BB.8060107@iki.fi>, <201204211045557968605@gmail.com>, <4F958640.9010404@iki.fi>, <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>, <201204262103053283195@gmail.com>, <4F994CA8.8060200@redhat.com> <201204271505580788207@gmail.com>
In-Reply-To: <201204271505580788207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-04-2012 04:06, nibble.max escreveu:
> ---
>  drivers/media/dvb/frontends/Kconfig          |   14 +
>  drivers/media/dvb/frontends/Makefile         |    3 +
>  drivers/media/dvb/frontends/m88ds3103.c      | 1153 ++++++++++++++++++++++++++
>  drivers/media/dvb/frontends/m88ds3103.h      |   67 ++
>  drivers/media/dvb/frontends/m88ds3103_priv.h |  413 +++++++++
>  drivers/media/dvb/frontends/m88ts202x.c      |  590 +++++++++++++
>  drivers/media/dvb/frontends/m88ts202x.h      |   63 ++
>  7 files changed, 2303 insertions(+)
>  create mode 100644 drivers/media/dvb/frontends/m88ds3103.c
>  create mode 100644 drivers/media/dvb/frontends/m88ds3103.h
>  create mode 100644 drivers/media/dvb/frontends/m88ds3103_priv.h
>  create mode 100644 drivers/media/dvb/frontends/m88ts202x.c
>  create mode 100644 drivers/media/dvb/frontends/m88ts202x.h

No, this is not what we've agreed. You should, instead, take Konstantin's driver, 
breaking it into two separate ones, without touching the copyrights. Then, apply
what else is needed for ds3103/ts2123.

> diff --git a/drivers/media/dvb/frontends/m88ds3103.c b/drivers/media/dvb/frontends/m88ds3103.c
> new file mode 100644
> index 0000000..392cada
> --- /dev/null
> +++ b/drivers/media/dvb/frontends/m88ds3103.c
> @@ -0,0 +1,1153 @@
> +/*
> +    Montage Technology M88DS3103/3000 - DVBS/S2 Satellite demod driver
> +
> +    Copyright (C) 2011 Max nibble<nibble.max@gmail.com>

Adding your copyright like that only justifies if you make significant contributions
to the code. Adding support for a new card or a new chip within the same chip family
in general don't fit on that. 

If Konstantin is ok, you may, instead, add, at the bottom of the copyright list, something like:

    Copyright (C) 2011 Max nibble<nibble.max@gmail.com>
		- Add support for ds3103

> +    Copyright (C) 2010 Montage Technology<www.montage-tech.com>
> +    Fix some bug and add M88DS3103 code, M88DS3000 code based on DS3000.c.
> +
> +    Copyright (C) 2009 Konstantin Dimitrov <kosio.dimitrov@gmail.com>
> +
> +    Copyright (C) 2009 TurboSight.com

Regards,
Mauro
