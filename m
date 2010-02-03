Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38761 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab0BCUtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 15:49:15 -0500
Received: by bwz19 with SMTP id 19so517641bwz.28
        for <linux-media@vger.kernel.org>; Wed, 03 Feb 2010 12:49:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B69DEDA.3020200@arcor.de>
References: <4B673790.3030706@arcor.de> <4B675B19.3080705@redhat.com>
	 <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com>
	 <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com>
	 <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de>
	 <4B69D8CC.2030008@arcor.de> <4B69DEDA.3020200@arcor.de>
Date: Wed, 3 Feb 2010 15:49:06 -0500
Message-ID: <829197381002031249w5542bccfpccfa8554e7c6b280@mail.gmail.com>
Subject: Re: [PATCH 14/15] - zl10353
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 3, 2010 at 3:38 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
> signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>
> --- a/drivers/media/dvb/frontends/zl10353.h
> +++ b/drivers/media/dvb/frontends/zl10353.h
> @@ -45,6 +45,8 @@ struct zl10353_config
>        /* clock control registers (0x51-0x54) */
>        u8 clock_ctl_1;  /* default: 0x46 */
>        u8 pll_0;        /* default: 0x15 */
> +
> +       int tm6000:1;
>  };

Why is this being submitted as its own patch?  It is code that is not
used by *anything*.  If you really did require a new field in the
zl10353 config, that field should be added in the same patch as
whatever requires it.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
