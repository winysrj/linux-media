Return-path: <mchehab@pedra>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50721 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab0I0TmM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 15:42:12 -0400
Date: Mon, 27 Sep 2010 12:42:17 -0700
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v3] OMAP1: Add support for SoC camera interface
Message-ID: <20100927194216.GZ4211@atomide.com>
References: <201009270302.28655.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009270302.28655.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [100926 17:55]:
> This patch adds a definition of the OMAP1 camera interface platform device, 
> and a function that allows for providing a board specific platform data. 
> The device will be used with the upcoming OMAP1 SoC camera interface driver.
> 
> Created and tested against linux-2.6.36-rc5 on Amstrad Delta.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
> 
> Tony,
> I hope this now satisfies your requirements.
> 
> I resubmit only this updated patch, not the other two, Amstrad Delta specific, 
> which you have alredy applied. Those are still valid (work for me), only the 
> not yet merged include/media/omap1_camera.h header file is required for 
> successfull compilation of board-ams-delta.c. I hope this is not a problem.

Yes thanks. Queuing these three for the upcoming merge window.

Tony
