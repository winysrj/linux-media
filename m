Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58188 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab2GXVzK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 17:55:10 -0400
Received: by wgbfm10 with SMTP id fm10so3897510wgb.1
        for <linux-media@vger.kernel.org>; Tue, 24 Jul 2012 14:55:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <500C5B9B.8000303@iki.fi>
References: <500C5B9B.8000303@iki.fi>
Date: Tue, 24 Jul 2012 17:55:09 -0400
Message-ID: <CAOcJUbw-8zG-j7YobgKy7k5vp-k_trkaB5fYGz605KdUQHKTGQ@mail.gmail.com>
Subject: Re: tda18271 driver power consumption
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 22, 2012 at 3:59 PM, Antti Palosaari <crope@iki.fi> wrote:
> Moi Michael,
> I just realized tda18271 driver eats 160mA too much current after attach.
> This means, there is power management bug.
>
> When I plug my nanoStick it eats total 240mA, after tda18271 sleep is called
> it eats only 80mA total which is reasonable. If I use Digital Devices
> tda18271c2dd driver it is total 110mA after attach, which is also quite OK.

Thanks for the report -- I will take a look at it.

...patches are welcome, of course :-)

-Mike
