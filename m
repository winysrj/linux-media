Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42175 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab1FARhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 13:37:40 -0400
Received: by iyb14 with SMTP id 14so22673iyb.19
        for <linux-media@vger.kernel.org>; Wed, 01 Jun 2011 10:37:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <15083eb9eb32e906d296.1306844713@roadrunner>
References: <15083eb9eb32e906d296.1306844713@roadrunner>
Date: Wed, 1 Jun 2011 19:37:39 +0200
Message-ID: <BANLkTim4vgoG_7_-pVqPkEijOHsymNt-sw@mail.gmail.com>
Subject: Re: [PATCH] update dvb-c scanfile hu-Digikabel
From: Christoph Pfister <christophpfister@gmail.com>
To: Marton Balint <cus@fazekas.hu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/5/31 Marton Balint <cus@fazekas.hu>:
> # HG changeset patch
> # User Marton Balint <cus@fazekas.hu>
> # Date 1306844422 -7200
> # Node ID 15083eb9eb32e906d2961597965320d328b3782e
> # Parent  7ebf32ed9124c7e58049dc9f59b514a222757b7d
> update dvb-c scanfile hu-Digikabel

Pushed, thanks.

Christoph


> diff -r 7ebf32ed9124 -r 15083eb9eb32 util/scan/dvb-c/hu-Digikabel
> --- a/util/scan/dvb-c/hu-Digikabel      Tue May 17 08:50:08 2011 +0200
> +++ b/util/scan/dvb-c/hu-Digikabel      Tue May 31 14:20:22 2011 +0200
> @@ -6,6 +6,7 @@
>  #  Szazhalombatta, Bekescsaba, Bekes, Eger, Komlo, Oroszlany
>  # In some of the cities not all the frequencies are available.
>  # freq sr fec mod
> +C 121000000 6900000 NONE QAM256
>  C 354000000 6900000 NONE QAM256
>  C 362000000 6900000 NONE QAM256
>  C 370000000 6900000 NONE QAM256
> @@ -14,8 +15,11 @@
>  C 394000000 6900000 NONE QAM256
>  C 402000000 6900000 NONE QAM256
>  C 410000000 6900000 NONE QAM256
> +C 746000000 6900000 NONE QAM256
> +C 754000000 6900000 NONE QAM256
>  C 762000000 6900000 NONE QAM256
>  C 770000000 6900000 NONE QAM256
>  C 778000000 6900000 NONE QAM256
>  C 786000000 6900000 NONE QAM256
>  C 794000000 6900000 NONE QAM256
> +C 850000000 6900000 NONE QAM256
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
