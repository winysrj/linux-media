Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C169FC04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 08:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85D4C206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 08:40:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pPRp7L5u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85D4C206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbeLEIku (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 03:40:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:40758 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbeLEIkt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 03:40:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=g7xtgWp88hgFXq2CAQDwVsGPhXCHErj0ThYQwp28HhU=; b=pPRp7L5u8UefkLY/gtMXKBg38Y
        LTcz+tKRiNEi1TU40rIlfaXuz0m/HWhEqF/2FeR1fEzYAz3/EXCd+4b+rAwnAqh0Cm4rrdZ4QUH1S
        p5jgsX45E/Em1mErvH/DvxcvCTUle7TTzsXeKF+rM3O0RyldDBZsf7+FmXhHmoWS/LatujXYrvfYO
        BPycL/yZpPaCENxEr59afeO/ni45jYfSs76Cw7wO3FZds2RrcHiP8tVdjs5WJUnzbuMQcei0IJ9fU
        H1DoUbhkjCaeeHx/AiZtxYuHITOmlaUG0l8nJfpXDw1pDtVafSYgPwBX+4W61782J+NxAZ9G2Hdv8
        AkE8QAMw==;
Received: from [191.33.148.129] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUSjf-00041S-S1; Wed, 05 Dec 2018 08:40:48 +0000
Date:   Wed, 5 Dec 2018 06:40:44 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc:     linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] libdvbv5: do not adjust DVB time daylight saving
Message-ID: <20181205064044.37e44059@coco.lan>
In-Reply-To: <20180707112057.7235-1-neolynx@gmail.com>
References: <20180707112057.7235-1-neolynx@gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Sat,  7 Jul 2018 13:20:54 +0200
Andr=C3=A9 Roth <neolynx@gmail.com> escreveu:

> This makes dvb_time available outside of EIT parsing, and
> struct tm to reflect the actual values received from DVB.
>=20
> Signed-off-by: Andr=C3=A9 Roth <neolynx@gmail.com>
> ---
>  lib/include/libdvbv5/descriptors.h | 11 +++++++++++
>  lib/include/libdvbv5/eit.h         | 10 ----------
>  lib/libdvbv5/descriptors.c         | 37 ++++++++++++++++++++++++++++++++=
+++++
>  lib/libdvbv5/tables/eit.c          | 28 ----------------------------
>  4 files changed, 48 insertions(+), 38 deletions(-)
>=20
> diff --git a/lib/include/libdvbv5/descriptors.h b/lib/include/libdvbv5/de=
scriptors.h
> index cb21470c..31f4c73f 100644
> --- a/lib/include/libdvbv5/descriptors.h
> +++ b/lib/include/libdvbv5/descriptors.h
> @@ -47,6 +47,7 @@
>  #include <unistd.h>
>  #include <stdint.h>
>  #include <arpa/inet.h>
> +#include <time.h>
> =20
>  /**
>   * @brief Maximum size of a table session to be parsed
> @@ -159,6 +160,16 @@ uint32_t dvb_bcd(uint32_t bcd);
>  void dvb_hexdump(struct dvb_v5_fe_parms *parms, const char *prefix,
>  		 const unsigned char *buf, int len);
> =20
> +/**
> + * @brief Converts a DVB formatted timestamp into struct tm
> + * @ingroup dvb_table
> + *
> + * @param data		event on DVB time format
> + * @param tm		pointer to struct tm where the converted timestamp will
> + *			be stored.
> + */
> +void dvb_time(const uint8_t data[5], struct tm *tm);
> +
>  /**
>   * @brief parse MPEG-TS descriptors
>   * @ingroup dvb_table
> diff --git a/lib/include/libdvbv5/eit.h b/lib/include/libdvbv5/eit.h
> index 9129861e..5af266b1 100644
> --- a/lib/include/libdvbv5/eit.h
> +++ b/lib/include/libdvbv5/eit.h
> @@ -209,16 +209,6 @@ void dvb_table_eit_free(struct dvb_table_eit *table);
>  void dvb_table_eit_print(struct dvb_v5_fe_parms *parms,
>  			 struct dvb_table_eit *table);
> =20
> -/**
> - * @brief Converts a DVB EIT formatted timestamp into struct tm
> - * @ingroup dvb_table
> - *
> - * @param data		event on DVB EIT time format
> - * @param tm		pointer to struct tm where the converted timestamp will
> - *			be stored.
> - */
> -void dvb_time(const uint8_t data[5], struct tm *tm);
> -

This seems to break the existing ABI.

>  #ifdef __cplusplus
>  }
>  #endif
> diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
> index 0683dc1b..ccec503c 100644
> --- a/lib/libdvbv5/descriptors.c
> +++ b/lib/libdvbv5/descriptors.c
> @@ -56,6 +56,14 @@
>  #include <libdvbv5/desc_ca_identifier.h>
>  #include <libdvbv5/desc_extension.h>
> =20
> +#ifdef ENABLE_NLS
> +# include "gettext.h"
> +# include <libintl.h>
> +# define _(string) dgettext(LIBDVBV5_DOMAIN, string)
> +#else
> +# define _(string) string
> +#endif
> +
>  static void dvb_desc_init(uint8_t type, uint8_t length, struct dvb_desc =
*desc)
>  {
>  	desc->type   =3D type;
> @@ -1391,3 +1399,32 @@ void dvb_hexdump(struct dvb_v5_fe_parms *parms, co=
nst char *prefix, const unsign
>  		dvb_loginfo("%s%s %s %s", prefix, hex, spaces, ascii);
>  	}
>  }
> +
> +void dvb_time(const uint8_t data[5], struct tm *tm)
> +{
> +  /* ETSI EN 300 468 V1.4.1 */
> +  int year, month, day, hour, min, sec;
> +  int k =3D 0;
> +  uint16_t mjd;
> +
> +  mjd   =3D *(uint16_t *) data;
> +  hour  =3D dvb_bcd(data[2]);
> +  min   =3D dvb_bcd(data[3]);
> +  sec   =3D dvb_bcd(data[4]);
> +  year  =3D ((mjd - 15078.2) / 365.25);
> +  month =3D ((mjd - 14956.1 - (int) (year * 365.25)) / 30.6001);
> +  day   =3D mjd - 14956 - (int) (year * 365.25) - (int) (month * 30.6001=
);
> +  if (month =3D=3D 14 || month =3D=3D 15) k =3D 1;
> +  year +=3D k;
> +  month =3D month - 1 - k * 12;
> +
> +  tm->tm_sec   =3D sec;
> +  tm->tm_min   =3D min;
> +  tm->tm_hour  =3D hour;
> +  tm->tm_mday  =3D day;
> +  tm->tm_mon   =3D month - 1;
> +  tm->tm_year  =3D year;
> +  tm->tm_isdst =3D -1; /* do not adjust */

It seems that the only real change here is that you replaced 1 by -1 here,
in order for the mktime() to not handle daylight saving time.

Why are you also moving this out of eit.c/eit.h?

> +  mktime( tm );
> +}
> +
> diff --git a/lib/libdvbv5/tables/eit.c b/lib/libdvbv5/tables/eit.c
> index a6ba566a..799e4c9a 100644
> --- a/lib/libdvbv5/tables/eit.c
> +++ b/lib/libdvbv5/tables/eit.c
> @@ -154,34 +154,6 @@ void dvb_table_eit_print(struct dvb_v5_fe_parms *par=
ms, struct dvb_table_eit *ei
>  	dvb_loginfo("|_  %d events", events);
>  }
> =20
> -void dvb_time(const uint8_t data[5], struct tm *tm)
> -{
> -  /* ETSI EN 300 468 V1.4.1 */
> -  int year, month, day, hour, min, sec;
> -  int k =3D 0;
> -  uint16_t mjd;
> -
> -  mjd   =3D *(uint16_t *) data;
> -  hour  =3D dvb_bcd(data[2]);
> -  min   =3D dvb_bcd(data[3]);
> -  sec   =3D dvb_bcd(data[4]);
> -  year  =3D ((mjd - 15078.2) / 365.25);
> -  month =3D ((mjd - 14956.1 - (int) (year * 365.25)) / 30.6001);
> -  day   =3D mjd - 14956 - (int) (year * 365.25) - (int) (month * 30.6001=
);
> -  if (month =3D=3D 14 || month =3D=3D 15) k =3D 1;
> -  year +=3D k;
> -  month =3D month - 1 - k * 12;
> -
> -  tm->tm_sec   =3D sec;
> -  tm->tm_min   =3D min;
> -  tm->tm_hour  =3D hour;
> -  tm->tm_mday  =3D day;
> -  tm->tm_mon   =3D month - 1;
> -  tm->tm_year  =3D year;
> -  tm->tm_isdst =3D 1; /* dst in effect, do not adjust */
> -  mktime( tm );
> -}
> -
> =20
>  const char *dvb_eit_running_status_name[8] =3D {
>  	[0] =3D "Undefined",



Thanks,
Mauro
