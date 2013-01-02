Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:65532 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3ABXOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 18:14:43 -0500
Message-ID: <50E4BF5E.9060108@gmail.com>
Date: Thu, 03 Jan 2013 00:14:38 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>,
	Tony Prisk <linux@prisktech.co.nz>
CC: Sergei Shtylyov <sshtylyov@mvista.com>,
	kernel-janitors@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-kernel@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 6/6] clk: s5p-g2d: Fix incorrect usage of IS_ERR_OR_NULL
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz> <1355852048-23188-7-git-send-email-linux@prisktech.co.nz> <50D62BC9.9010706@mvista.com> <50E32C06.5020104@gmail.com> <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com>
In-Reply-To: <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/02/2013 06:10 AM, Dan Carpenter wrote:
> clk_get() returns NULL if CONFIG_HAVE_CLK is disabled.

It's not a problem for this driver, as it never dereferences what's
returned from clk_get(). It would have to include <plat/clock.h>, which
it doesn't and which would have clearly indicated abuse of the clock API.

Moreover, this driver now depends on architectures that select HAVE_CLK,
so it couldn't be build when CONFIG_HAVE_CLK is disabled.

> I told Tony about this but everyone has been gone with end of year
> holidays so it hasn't been addressed.
>
> Tony, please fix it so people don't apply these patches until
> clk_get() is updated to not return NULL.  It sucks to have to revert
> patches.

As explained by Russell many times, the clock API users should not care
whether the value returned from clk_get() is NULL or not. It should only
be tested with IS_ERR(). The patches look fine to me, no need to do
anything.

---

Regards,
Sylwester
