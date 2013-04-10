Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:64235 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765442Ab3DJAUe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 20:20:34 -0400
Received: by mail-qa0-f51.google.com with SMTP id i20so1677458qad.3
        for <linux-media@vger.kernel.org>; Tue, 09 Apr 2013 17:20:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365551600-3394-2-git-send-email-crope@iki.fi>
References: <1365551600-3394-1-git-send-email-crope@iki.fi>
	<1365551600-3394-2-git-send-email-crope@iki.fi>
Date: Tue, 9 Apr 2013 20:20:33 -0400
Message-ID: <CAGoCfiw_pyh5MchkU59Y9NJz+Rgf5B7Gvd92A1pF+e18DVWgKQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] mxl5007t: fix buggy register read
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 9, 2013 at 7:53 PM, Antti Palosaari <crope@iki.fi> wrote:
> Chip uses WRITE + STOP + READ + STOP sequence for I2C register read.
> Driver was using REPEATED START condition which makes it failing if
> I2C adapter was implemented correctly.
>
> Add use_broken_read_reg_intentionally option to keep old buggy
> implantation as there is buggy I2C adapter implementation relying
> that bug...
>
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Hi Antti,

The existing code actually looks fine.  This is actually how most
devices do register reads.

Further, it *should* be done in a single call to i2c_transfer() or
else you won't hold the lock and you will create a race condition.

This sounds more like it's a bug in the i2c master rather than the 5007 driver.

Do you have i2c bus traces that clearly show that this was the cause
of the issue?  If we need to define something as "broken" behavior, at
first glance it looks like the way *you're* proposing is the broken
behavior - presumably to work around a bug in the i2c master not
properly supporting repeated start.

Also, any reason you didn't put Mike into the cc: for this (since he
owns the driver)?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
