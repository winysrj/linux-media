Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35152 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbbH3Jxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2015 05:53:49 -0400
Received: by wicne3 with SMTP id ne3so50262700wic.0
        for <linux-media@vger.kernel.org>; Sun, 30 Aug 2015 02:53:48 -0700 (PDT)
Subject: Re: [BUG] STV0299 has bogus CAN_INVERSION_AUTO flag
To: Johann Klammer <klammerj@a1.net>, linux-media@vger.kernel.org
References: <55DB3608.5010906@a1.net>
Cc: hverkuil@xs4all.nl
From: Malcolm Priestley <tvboxspy@gmail.com>
Message-ID: <55E2D2A8.5010607@gmail.com>
Date: Sun, 30 Aug 2015 10:53:44 +0100
MIME-Version: 1.0
In-Reply-To: <55DB3608.5010906@a1.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24/08/15 16:19, Johann Klammer wrote:
> from gdb dump:
> [...]
> info = {
>        name = "ST STV0299 DVB-S", '\000' <repeats 111 times>, type = FE_QPSK,
>        frequency_min = 950000, frequency_max = 2150000,
>        frequency_stepsize = 125, frequency_tolerance = 0,
>        symbol_rate_min = 1000000, symbol_rate_max = 45000000,
>        symbol_rate_tolerance = 500, notifier_delay = 0,
>        caps = (FE_CAN_INVERSION_AUTO | FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO | FE_CAN_QPSK)},
> [...]
>
> when tuning:
> [...]
Hi
..
> [331020.207352] stv0299 does not support auto-inversion
> [331020.507480] stv0299 does not support auto-inversion
> [331020.807610] stv0299 does not support auto-inversion
> [331021.107747] stv0299 does not support auto-inversion
> [...]
> (but how the heck should I know?)

I am using the stv0299 with no problems at all, the code hasn't changed 
much in years. I am using linux 4.2-rc6

You shouldn't be getting that message as dvb core does the auto 
inversion for the driver.

I looked through the code and can't find any fault.


Regards


Malcolm






