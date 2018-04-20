Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:57236 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbeDTTXb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 15:23:31 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Russell King <linux@armlinux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Sergey Lapin <slapin@ossfans.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mips@linux-mips.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/7] i2c: i2c-gpio: move header to platform_data
References: <20180419200015.15095-1-wsa@the-dreams.de>
        <20180419200015.15095-2-wsa@the-dreams.de>
Date: Fri, 20 Apr 2018 21:23:19 +0200
In-Reply-To: <20180419200015.15095-2-wsa@the-dreams.de> (Wolfram Sang's
        message of "Thu, 19 Apr 2018 22:00:07 +0200")
Message-ID: <874lk53cns.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wolfram Sang <wsa@the-dreams.de> writes:

> This header only contains platform_data. Move it to the proper directory.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
For mach-pxa:
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Take it through your tree, no problem for the pxa part.

Cheers.

--
Robert
