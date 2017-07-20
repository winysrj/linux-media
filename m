Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:35506 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754043AbdGTSEk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 14:04:40 -0400
Received: by mail-wr0-f176.google.com with SMTP id k71so20373914wrc.2
        for <linux-media@vger.kernel.org>; Thu, 20 Jul 2017 11:04:39 -0700 (PDT)
Date: Thu, 20 Jul 2017 20:04:29 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org, jasmin@anw.at,
        rjkm@metzlerbros.de
Subject: Re: [PATCH v3 01/10] [media] dvb-frontends: add ST STV0910 DVB-S/S2
 demodulator frontend driver
Message-ID: <20170720200429.4359691a@audiostation.wuest.de>
In-Reply-To: <20170720142124.0363f432@vento.lan>
References: <20170703172104.27283-1-d.scheller.oss@gmail.com>
        <20170703172104.27283-2-d.scheller.oss@gmail.com>
        <20170720142124.0363f432@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Thu, 20 Jul 2017 14:21:24 -0300
schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> The right coding style for multi-line comments is:
> 
> 	/*
> 	 * foo
> 	 * bar
> 	 */
> 
> I ended by merging this series,[...]

Thanks alot!

> but please send a fixup patch
> when you have some time.
> 
> Btw, specially for new drivers, it could worth running checkpatch in
> scritct mode:

Well. Honestly, I wasn't fully aware of the "strict" option (at least
until Jasmin was told about it, but then the patches were there for
some time already). Since I have two (maybe three) minors for the
stv0910 driver in my GIT which I'd like to also submit, I will check
and fix up things in addition.

> Several of those warnings can be automatically fixed with:
> 
> ./scripts/checkpatch.pl -f $(git diff 435945e08551|diffstat -p1
> -l|grep -v MAINT) --strict --fix-inplace
> 
> But you need to review if the results are ok.

Thanks for the hints!

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
