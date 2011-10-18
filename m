Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59792 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab1JRWDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 18:03:54 -0400
Received: by bkbzt19 with SMTP id zt19so1285152bkb.19
        for <linux-media@vger.kernel.org>; Tue, 18 Oct 2011 15:03:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E9DF719.7000609@fastmail.co.uk>
References: <4E9DF719.7000609@fastmail.co.uk>
Date: Tue, 18 Oct 2011 18:03:53 -0400
Message-ID: <CAGoCfiyb9MGuYr+LLF_5gzcczANO=DT=W-jfP6y-5ncdvm+JLA@mail.gmail.com>
Subject: Re: PVR-2200 error with what I think is tuning
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Greg Bowyer <gbowyer@fastmail.co.uk>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 18, 2011 at 6:00 PM, Greg Bowyer <gbowyer@fastmail.co.uk> wrote:
> Hi there
>
> You probably get this a lot, with the latest and greatest drivers from your
> git repository at Steve Tosh's website I get the following after a few days
>
> [198934.085303] tda18271_write_regs: [4-0060|S] ERROR: idx = 0x5, len = 1,
> i2c_transfer returned: -5
> [198934.085310] tda18271_init: [4-0060|S] error -5 on line 831
> [198934.085317] tda18271_tune: [4-0060|S] error -5 on line 909
> [198934.085324] tda18271_set_params: [4-0060|S] error -5 on line 994
> [198934.085331] saa7164_cmd_send() No free sequences
> [198934.085336] saa7164_api_i2c_read() error, ret(1) = 0xc
> [198934.085341] tda10048_readreg: readreg error (ret == -5)
>
>
> [198934.087195] tda10048_readreg: readreg error (ret == -5)
> [198934.087209] saa7164_cmd_send() No free sequences
> [198934.087214] saa7164_api_i2c_read() error, ret(1) = 0xc
> [198934.087220] tda10048_readreg: readreg error (ret == -5)
>
> My tuning software is tvheadend (which I would prefer to keep)
>
> I started to look at the sourcecode, but I know too little about I2C to make
> any sense of what might be bugging out
>
> Is there anything I can do to avoid this ?

Just an FYI:  that doesn't actually look like an i2c problem or some
other problem with the tuner or demodulator.  It looks like the
saa7164 itself is wedged.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
