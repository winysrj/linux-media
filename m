Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49239 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab2CJOqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Mar 2012 09:46:14 -0500
Received: by yhmm54 with SMTP id m54so1542820yhm.19
        for <linux-media@vger.kernel.org>; Sat, 10 Mar 2012 06:46:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAUE0eoXAWwrzTVXWTxN_Ce0=U1bb5ravkZZeuEva5kKcFEy4A@mail.gmail.com>
References: <CAAUE0eoXAWwrzTVXWTxN_Ce0=U1bb5ravkZZeuEva5kKcFEy4A@mail.gmail.com>
Date: Sat, 10 Mar 2012 15:46:13 +0100
Message-ID: <CAL7owaAYqE6VNuNF0ptFVyXE+SNmgXq-RWUJXo8ST9uDbaABHA@mail.gmail.com>
Subject: Re: Initial tuning file update for fi-sonera
From: Christoph Pfister <christophpfister@gmail.com>
To: Mikko Autio <mikko.autio1@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updated, thanks.

Christoph


Am 8. Dezember 2011 23:23 schrieb Mikko Autio <mikko.autio1@gmail.com>:
> Update for fi-sonera
>
> Mikko
> --
>
> diff -r bec11f78be51 util/scan/dvb-c/fi-sonera
> --- a/util/scan/dvb-c/fi-sonera Wed Dec 07 15:26:50 2011 +0100
> +++ b/util/scan/dvb-c/fi-sonera Thu Dec 08 23:51:13 2011 +0200
> @@ -5,8 +5,19 @@
>  C 154000000 6900000 NONE QAM128
>  C 162000000 6900000 NONE QAM128
>  C 170000000 6900000 NONE QAM128
> +C 234000000 6900000 NONE QAM256
> +C 242000000 6900000 NONE QAM256
> +C 250000000 6900000 NONE QAM256
> +C 258000000 6900000 NONE QAM256
> +C 266000000 6900000 NONE QAM256
>  C 314000000 6900000 NONE QAM128
>  C 322000000 6900000 NONE QAM128
>  C 338000000 6900000 NONE QAM128
>  C 346000000 6900000 NONE QAM128
>  C 354000000 6900000 NONE QAM128
> +C 362000000 6900000 NONE QAM128
> +C 370000000 6900000 NONE QAM128
> +C 378000000 6900000 NONE QAM128
> +C 386000000 6900000 NONE QAM128
> +C 394000000 6900000 NONE QAM128
> +C 402000000 6900000 NONE QAM128
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
