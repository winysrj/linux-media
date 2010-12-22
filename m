Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62959 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab0LVDtn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Dec 2010 22:49:43 -0500
Received: by wyb28 with SMTP id 28so4636863wyb.19
        for <linux-media@vger.kernel.org>; Tue, 21 Dec 2010 19:49:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTim-GBA+q+-pMYz8HR5syHNPG_2EgS3cKy5H_geu@mail.gmail.com>
References: <AANLkTim-GBA+q+-pMYz8HR5syHNPG_2EgS3cKy5H_geu@mail.gmail.com>
Date: Wed, 22 Dec 2010 03:49:40 +0000
Message-ID: <AANLkTikTsCQMpUuEvUXCbeShBdC+XjTDcE36iq9KGdG2@mail.gmail.com>
Subject: Re: Avermedia A700 failing with 2.6.32, worked with 2.6.30
From: Mikhail Ramendik <mr@ramendik.ru>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 22 December 2010 01:07, Mikhail Ramendik <mr@ramendik.ru> wrote:

> I have Avermedia A700, a DVB-S card. I also have Debian lenny, which,
> with kernel
> 2.6.30 from backports.org, displayed satelite video successfully.
>
> However, once I installed kernel 2.6.32 from backports.org (which I
> needed for certain network hardware), DVB no longer works, even though
> the card is unchanged.

Apparently resolved. The module settings needed to be changed - to
card=140 (no tuner setting). The DVB device is visible now. Sorry.

-- 
Yours, Mikhail Ramendik

Unless explicitly stated, all opinions in my mail are my own and do
not reflect the views of any organization
