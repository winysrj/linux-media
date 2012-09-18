Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47255 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab2IRBtT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 21:49:19 -0400
Received: by pbbrr13 with SMTP id rr13so9999227pbb.19
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 18:49:19 -0700 (PDT)
Date: Tue, 18 Sep 2012 09:49:39 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org
Subject: Re: [PATCH 26/34] media: mx2_camera: remove dead code in
 mx2_camera_add_device
Message-ID: <20120918014936.GG1338@S2101-09.ap.freescale.net>
References: <1347860103-4141-1-git-send-email-shawn.guo@linaro.org>
 <1347860103-4141-27-git-send-email-shawn.guo@linaro.org>
 <Pine.LNX.4.64.1209171017460.1689@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1209171017460.1689@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 17, 2012 at 10:18:42AM +0200, Guennadi Liakhovetski wrote:
> Hi Shawn
> 
> Thanks for the clean up. Would you like these patches to go via a single 
> tree, presumably, arm-soc? In this case
> 
Yes, to save the cross-tree dependency, I would like to have the series
go via arm-soc tree as a whole.

> On Mon, 17 Sep 2012, Shawn Guo wrote:
> 
> > This is a piece of code becoming dead since commit 2c9ba37 ([media]
> > V4L: mx2_camera: remove unsupported i.MX27 DMA mode, make EMMA
> > mandatory).  It should have been removed together with the commit.
> > Remove it now.
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: linux-media@vger.kernel.org
> 
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
Thanks, Guennadi.

-- 
Regards,
Shawn
