Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:65328 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3LNNiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 08:38:18 -0500
Received: by mail-vb0-f49.google.com with SMTP id x11so2016435vbb.8
        for <linux-media@vger.kernel.org>; Sat, 14 Dec 2013 05:38:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131214092443.622b069d@samsung.com>
References: <1386969579.3914.13.camel@piranha.localdomain>
	<20131214092443.622b069d@samsung.com>
Date: Sat, 14 Dec 2013 13:38:17 +0000
Message-ID: <CAOBYczoSgS-0HW32BvAb0NsEDqiU9o+DosEjRvyb66XB=fU=_g@mail.gmail.com>
Subject: Re: stable regression: tda18271_read_regs: [1-0060|M] ERROR:
 i2c_transfer returned: -19
From: Robin Becker <robin@reportlab.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
> Well, for board EM28174_BOARD_PCTV_290E, it first attaches cxd2820r
> and then the tuner tda18271.
>
> I suspect that the issue is at cxd2820r. Could you please apply this
> patch:
>         http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0db3fa2741ad8371c21b3a6785416a4afc0cc1d4
> and see if it solves the issue?
>
> Thanks!
> Mauro
>

I applied that patch to the latest 3.12.4 Arch linux kernel and it
solves the problem for me. The error is gone and my pctv 290e devices
work again. Thanks for the quick analysis.
-- 
Robin Becker
