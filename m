Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:49981 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZCDMkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 07:40:09 -0500
Received: by bwz26 with SMTP id 26so2799679bwz.37
        for <linux-media@vger.kernel.org>; Wed, 04 Mar 2009 04:40:06 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Matthias Schwarzott <zzam@gentoo.org>
Subject: Re: [PATCH] Typo in lnbp21.c / changeset: 10800:ba740eb2348e
Date: Wed, 4 Mar 2009 14:40:33 +0200
References: <200903041111.15083.zzam@gentoo.org>
In-Reply-To: <200903041111.15083.zzam@gentoo.org>
Cc: linux-media@vger.kernel.org, Mauro Chehab <mchehab@infradead.org>,
	Abylai Ospan <aospan@netup.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903041440.33687.liplianin@me.by>
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4 марта 2009, linux-media@vger.kernel.org wrote:
> Hi there!
>
> lnbp21 does show strange messages at depmod.
>
> WARNING: Loop detected: /lib/modules/2.6.28-tuxonice-r1/v4l/lnbp21.ko which
> needs lnbp21.ko again!
> WARNING: Module /lib/modules/2.6.28-tuxonice-r1/v4l/lnbp21.ko ignored, due
> to loop
>
> So I had a look at latest change and noticed there was a typo in the
> function name, it should be lnbh24_attach, and not lnbp24_attach I guess.
> The attached patch fixes this.
>
> Regards
> Matthias
Hi Matthias
Yes, You are right.
What an unfortunate misprint and  lack of attention from my side :(
I confirm your patch.

Mauro, please apply this patch.

Best Regards 
Igor
