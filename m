Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56869 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0EFKED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 06:04:03 -0400
Received: by fxm10 with SMTP id 10so4964476fxm.19
        for <linux-media@vger.kernel.org>; Thu, 06 May 2010 03:04:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273135577.16031.11.camel@plop>
References: <1273135577.16031.11.camel@plop>
Date: Thu, 6 May 2010 12:04:01 +0200
Message-ID: <q2u846899811005060304m7538cb13ic3074f290a1a3517@mail.gmail.com>
Subject: Re: stv090x vs stv0900
From: HoP <jpetrous@gmail.com>
To: Pascal Terjan <pterjan@mandriva.com>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	"Igor M. Liplianin" <liplianin@netup.ru>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pascal,

> I was adding support for a non working version of DVBWorld HD 2104
>
> It is listed on
> http://www.linuxtv.org/wiki/index.php/DVBWorld_HD_2104_FTA_USB_Box as :
>
> =====
> for new solution : 2104B (Sharp0169 Tuner)
>
>      * STV6110A tuner
>      * ST0903 demod
>      * Cyrix CY7C68013A USB controller
> =====
>
> The 2104A is supposed to be working and also have ST0903 but uses
> stv0900, so I tried using it too but did not manage to get it working.
>
> I now have some working code by using stv090x + stv6110x (copied config
> from budget) but I am wondering why do we have 2 drivers for stv0900,
> and is stv0900 supposed to handle stv0903 devices or is either the code
> or the wki wrong about 2104A?
>
> Also, are they both maintained ? I wrote a patch to add get_frontend to
> stv090x but stv0900 also does not have it and I don't know which one
> should get new code.
>
> And stv6110x seems to also handle stv6110 which also exists as a
> separate module...

Hehe, you are not only one who is fooled by current situation
regarding demods stv0900/stv0903 and plls stv6110.

Current status-quo is not good. Same question is asked here
again and again. Interesting that it is against usual rule
having only one driver for every chip in kernel, but this time that
rather strong rule was not applied. Dunno why.

May be someone from "knowings" can answer that on wiki?

/Honza

PS: FYI I'm also using BOTH variants in 2 projects. For me
both look very similar and work w/o probs. So I can't tell you
which is better :)
