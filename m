Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:37300 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753400AbeDSUZo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 16:25:44 -0400
Date: Thu, 19 Apr 2018 13:25:40 -0700
From: Tony Lindgren <tony@atomide.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Russell King <linux@armlinux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sergey Lapin <slapin@ossfans.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mips@linux-mips.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/7] i2c: i2c-gpio: move header to platform_data
Message-ID: <20180419202540.GM5671@atomide.com>
References: <20180419200015.15095-1-wsa@the-dreams.de>
 <20180419200015.15095-2-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180419200015.15095-2-wsa@the-dreams.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Wolfram Sang <wsa@the-dreams.de> [180419 20:02]:
> This header only contains platform_data. Move it to the proper directory.

Acked-by: Tony Lindgren <tony@atomide.com>
