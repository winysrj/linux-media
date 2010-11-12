Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:50172 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0KLQWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 11:22:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
Date: Fri, 12 Nov 2010 17:23:25 +0100
Cc: Jimmy Rubin <jimmy.rubin@stericsson.com>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	Dan Johansson <dan.johansson@stericsson.com>,
	Linus Walleij <linus.walleij@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com> <1289390653-6111-9-git-send-email-jimmy.rubin@stericsson.com> <1289390653-6111-10-git-send-email-jimmy.rubin@stericsson.com>
In-Reply-To: <1289390653-6111-10-git-send-email-jimmy.rubin@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201011121723.25978.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday 10 November 2010, Jimmy Rubin wrote:
> This patch adds support for the MCDE, Memory-to-display controller,
> found in the ST-Ericsson ux500 products.
> 
> This patch adds the necessary build files for MCDE and the bus that
> all displays are connected to.
> 

Can you explain why you need a bus for this?

With the code you currently have, there is only a single driver associated
with this bus type, and also just a single device that gets registered here!

>+static int __init mcde_subsystem_init(void)
>+{
>+       int ret;
>+       pr_info("MCDE subsystem init begin\n");
>+
>+       /* MCDE module init sequence */
>+       ret = mcde_init();
>+       if (ret)
>+               return ret;
>+       ret = mcde_display_init();
>+       if (ret)
>+               goto mcde_display_failed;
>+       ret = mcde_dss_init();
>+       if (ret)
>+               goto mcde_dss_failed;
>+       ret = mcde_fb_init();
>+       if (ret)
>+               goto mcde_fb_failed;
>+       pr_info("MCDE subsystem init done\n");
>+
>+       return 0;
>+mcde_fb_failed:
>+       mcde_dss_exit();
>+mcde_dss_failed:
>+       mcde_display_exit();
>+mcde_display_failed:
>+       mcde_exit();
>+       return ret;
>+}

Splitting up the module into four sub-modules and then initializing
everything from one place indicates that something is done wrong
on a global scale.

If you indeed need a bus, that should be a separate module that gets
loaded first and then has the other modules build on top of.

I'm not sure how the other parts layer on top of one another, can you
provide some more insight?

>From what I understood so far, you have a single multi-channel display
controller (mcde_hw.c) that drives the hardware.
Each controller can have multiple frame buffers attached to it, which
in turn can have multiple displays attached to each of them, but your
current configuration only has one of each, right?

Right now you have a single top-level bus device for the displays,
maybe that can be integrated into the controller so the displays are
properly rooted below the hardware that drives them.

The frame buffer device also looks weird. Right now you only seem
to have a single frame buffer registered to a driver in the same
module. Is that frame buffer not dependent on a controller?

>+#ifdef MODULE
>+module_init(mcde_subsystem_init);
>+#else
>+fs_initcall(mcde_subsystem_init);
>+#endif

This is not a file system ;-)

	Arnd
