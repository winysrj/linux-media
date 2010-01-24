Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:53641 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab0AXVOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 16:14:49 -0500
Received: by fxm7 with SMTP id 7so1349446fxm.28
        for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 13:14:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7b41dd971001240258h7bce4a9dy7a00d22d6091d3da@mail.gmail.com>
References: <7b41dd971001240258h7bce4a9dy7a00d22d6091d3da@mail.gmail.com>
Date: Mon, 25 Jan 2010 01:14:48 +0400
Message-ID: <1a297b361001241314o7733d2eev2a5c18bd9b75fa08@mail.gmail.com>
Subject: Re: [PATCH] dvb-apps/util/szap/czap.c "ERROR: cannot parse service
	data"
From: Manu Abraham <abraham.manu@gmail.com>
To: klaas de waal <klaas.de.waal@gmail.com>
Cc: linux-media@vger.kernel.org, sander@vermin.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Klaas,

On Sun, Jan 24, 2010 at 2:58 PM, klaas de waal <klaas.de.waal@gmail.com> wrote:
> The czap utility (dvb-apps/util/szap/czap.c) cannot scan the channel
> configuration file when compiled on Fedora 12 with gcc-4.4.2.
>
> The czap output is:
>
> [klaas@myth2 szap]$ ./czap -c ~/.czap/ziggo-channels.conf Cartoon
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '/local/klaas/.czap/ziggo-channels.conf'
>  1 Cartoon:356000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:1660:1621
> ERROR: cannot parse service data
>
> Problem is tha the "sscanf" function uses the "%a[^:]" format
> specifier. According to "man sscanf" you need to define _GNU_SOURCE if
> you want this to work because it is a gnu-only extension.
> Adding a first line "#define _GNU_SOURCE" to czap.c and recompiling
> solves the problem.
>
> The czap output is now:
>
> [klaas@myth2 szap]$ ./czap -c ~/.czap/ziggo-channels.conf Cartoon
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '/local/klaas/.czap/ziggo-channels.conf'
>  1 Cartoon:356000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_64:1660:1621
>  1 Cartoon: f 356000000, s 6875000, i 2, fec 0, qam 3, v 0x67c, a 0x655
> status 00 | signal 0000 | snr b7b7 | ber 000fffff | unc 00000098 |
> status 1f | signal d5d5 | snr f3f3 | ber 000006c0 | unc 0000009b | FE_HAS_LOCK
> status 1f | signal d5d5 | snr f4f4 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>
> This is done on a Linux 2.6.32.2 kernel with a TT C-1501 DVB-C card.
>
> Signed-off-by: Klaas de Waal <klaas.de.waal@gmail.com>
>
> -------------------------------------------------------------------------------------------
>
> diff -r 61b72047a995 util/szap/czap.c
> --- a/util/szap/czap.c  Sun Jan 17 17:03:27 2010 +0100
> +++ b/util/szap/czap.c  Sun Jan 24 11:40:43 2010 +0100
> @@ -1,3 +1,4 @@
> +#define _GNU_SOURCE
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <sys/ioctl.h>
>

There seems to be other instances where _GNU_SOURCE needs to be
defined, from a quick look. Care to send a patch against the entire
dvb-apps tree ?

Regards,
Manu
