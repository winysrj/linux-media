Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34087 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbcBVUsT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 15:48:19 -0500
Received: by mail-io0-f180.google.com with SMTP id 9so192710234iom.1
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2016 12:48:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e151c4d64bba4c070ee4e5e444b6683592b628c2.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
	<e151c4d64bba4c070ee4e5e444b6683592b628c2.1456167652.git.mchehab@osg.samsung.com>
Date: Mon, 22 Feb 2016 15:48:18 -0500
Message-ID: <CAOcJUbzPOHj0BOBbBNvrSRaLH8btBDsZ534z9CR6unRFEaYpAQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] [media] dib9000: read16/write16 could return an error code
From: Michael Ira Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 22, 2016 at 2:09 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Both dib9000_read16_attr and dib9000_write16_attr can return an
> error code. However, they currently return an u16. This produces the
> following warnings on smatch:
>
>         drivers/media/dvb-frontends/dib9000.c:262 dib9000_read16_attr() warn: signedness bug returning '(-121)'
>         drivers/media/dvb-frontends/dib9000.c:321 dib9000_write16_attr() warn: signedness bug returning '(-22)'
>         drivers/media/dvb-frontends/dib9000.c:353 dib9000_write16_attr() warn: signedness bug returning '(-121)'
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/dvb-frontends/dib9000.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

While reviewing this, I was originally concerned with
"dib9000_read16_attr" but after tracing through the functions, I see
that the change looks OK.

For the function, "dib9000_write16_attr",  we will only ever return
-EINVAL, 0, or possibly the return value of i2c_transfer.  It is OK to
convert the function to return 'int' here instead of 'u16'.

This change looks reasonable as well.

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>
