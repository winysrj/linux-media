Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51523 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0HXGj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 02:39:28 -0400
Received: by iwn5 with SMTP id 5so4259063iwn.19
        for <linux-media@vger.kernel.org>; Mon, 23 Aug 2010 23:39:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7c8fa4a65634e5cab19a.1281876184@roadrunner.athome>
References: <7c8fa4a65634e5cab19a.1281876184@roadrunner.athome>
Date: Tue, 24 Aug 2010 08:39:27 +0200
Message-ID: <AANLkTinsLtmpCCPV-8CaWDOW-sOpM1u-prPDVxBxLNcV@mail.gmail.com>
Subject: Re: [PATCH] update DVB-C scan files for hu-Digikabel
From: Christoph Pfister <christophpfister@gmail.com>
To: Marton Balint <cus@fazekas.hu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

2010/8/15 Marton Balint <cus@fazekas.hu>:
> # HG changeset patch
> # User Marton Balint <cus@fazekas.hu>
> # Date 1281875940 -7200
> # Node ID 7c8fa4a65634e5cab19ace3a17d15c29e31d07e4
> # Parent  16157edcb447ec50184ccb9dcefc8c6c3da88aa5
> update DVB-C scan files for hu-Digikabel

Applied, thanks.

Christoph


> Signed-off-by: Marton Balint <cus@fazekas.hu>
>
> diff -r 16157edcb447 -r 7c8fa4a65634 util/scan/dvb-c/hu-Digikabel
> --- a/util/scan/dvb-c/hu-Digikabel      Tue Aug 03 13:24:24 2010 +0200
> +++ b/util/scan/dvb-c/hu-Digikabel      Sun Aug 15 14:39:00 2010 +0200
> @@ -14,11 +14,8 @@
>  C 394000000 6900000 NONE QAM256
>  C 402000000 6900000 NONE QAM256
>  C 410000000 6900000 NONE QAM256
> +C 762000000 6900000 NONE QAM256
>  C 770000000 6900000 NONE QAM256
>  C 778000000 6900000 NONE QAM256
>  C 786000000 6900000 NONE QAM256
>  C 794000000 6900000 NONE QAM256
> -C 834000000 6900000 NONE QAM256
> -C 842000000 6900000 NONE QAM256
> -C 850000000 6900000 NONE QAM256
> -C 858000000 6900000 NONE QAM256
