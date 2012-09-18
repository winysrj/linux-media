Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54880 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab2IRB2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 21:28:32 -0400
Received: by pbbrr13 with SMTP id rr13so9970254pbb.19
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 18:28:32 -0700 (PDT)
Date: Tue, 18 Sep 2012 09:28:52 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 12/34] media: mx1_camera: remove the driver
Message-ID: <20120918012848.GE1338@S2101-09.ap.freescale.net>
References: <1347860103-4141-1-git-send-email-shawn.guo@linaro.org>
 <1347860103-4141-13-git-send-email-shawn.guo@linaro.org>
 <Pine.LNX.4.64.1209171031010.1689@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1209171031010.1689@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 17, 2012 at 10:33:25AM +0200, Guennadi Liakhovetski wrote:
> Ok, it used to compile not-so-long-ago, but it doesn't seem to be cared 
> for a lot lately. Let's give Paulius a bit more time to react to this 
> mail, otherwise I'll have no objections. Just as an idea, to make it a bit 
> milder we could first mark it BROKEN and add to remove schedule... But I 
> don't mind either way.
> 
I chose to remove the driver completely rather than marking it BROKEN
because the removal of the driver cleans up platform code a lot :)

Ok, if we hear anything back from Paulius in the next couple of weeks,
I keep the driver there with BROKEN marked.

Regards,
Shawn
