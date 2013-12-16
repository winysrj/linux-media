Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33540 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3LPD0i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Dec 2013 22:26:38 -0500
Received: by mail-wi0-f175.google.com with SMTP id hi5so1545071wib.2
        for <linux-media@vger.kernel.org>; Sun, 15 Dec 2013 19:26:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1387158047.1563.YahooMailNeo@web120606.mail.ne1.yahoo.com>
References: <1387158047.1563.YahooMailNeo@web120606.mail.ne1.yahoo.com>
Date: Sun, 15 Dec 2013 22:26:36 -0500
Message-ID: <CAGoCfiyJvKR_rs2RhpssBPDtSWbGOYDxqujMDk0KqQgBuQp_mw@mail.gmail.com>
Subject: Re: [3.12.5] Regression with PCTV 290e DVB-T2 adapter.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I have just tested my PCTV 290e DVB-T2 adapter with 3.12.5 and discovered that it fails with logs of messages like these:
>
> [11720.780975] __tda18271_write_regs: [7-0060|M] ERROR: idx = 0x5, len = 1, i2c_transfer returned: -19
> [11720.788726] tda18271_init: [7-0060|M] error -19 on line 832
> [11720.793001] tda18271_tune: [7-0060|M] error -19 on line 910
> [11720.797279] tda18271_set_params: [7-0060|M] error -19 on line 985
>
> Reverting to 3.11.10 fixes this problem. I have raised https://bugzilla.kernel.org/show_bug.cgi?id=67041

Already reported and fixed.  See the thread that's been going on over
the last two days named "stable regression: tda18271_read_regs:
[1-0060|M] ERROR: i2c_transfer returned: -19".

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
