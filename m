Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63421 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab2FFQhB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2012 12:37:01 -0400
Received: by gglu4 with SMTP id u4so5141779ggl.19
        for <linux-media@vger.kernel.org>; Wed, 06 Jun 2012 09:37:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1206061759010.12739@axis700.grange>
References: <1337987696-31728-1-git-send-email-festevam@gmail.com>
	<1337987696-31728-6-git-send-email-festevam@gmail.com>
	<20120529092030.GI30400@pengutronix.de>
	<CAOMZO5DrVWNKscMdXORTJo+fss+O5Lykc+5hJ1d33Ae7M1mcHg@mail.gmail.com>
	<Pine.LNX.4.64.1206061759010.12739@axis700.grange>
Date: Wed, 6 Jun 2012 13:37:01 -0300
Message-ID: <CAOMZO5D1dUxcShc0xU9hMJbyNZAnw5gYndA-3bv1G0Et-sTUTA@mail.gmail.com>
Subject: Re: [PATCH 06/15] video: mx1_camera: Use clk_prepare_enable/clk_disable_unprepare
From: Fabio Estevam <festevam@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, kernel@pengutronix.de,
	shawn.guo@freescale.com,
	Fabio Estevam <fabio.estevam@freescale.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wed, Jun 6, 2012 at 1:04 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:

> Yes, I'll pick up #6 and 7. #8 is not for me - mx2_emmaprp is not an
> soc-camera driver, I'm not maintaining it. I understand, these patches are
> not really bug-fixes (is clk_prepare() a NOP on mx*?) and can wait until
> 3.6? Or should they be considered correctness fixes and go into 3.5?

On i.MX we have transitioned to the common clock framework and my
understanding is that we need the
clk_prepare_enable/clk_disable_unprepare changes now. I experienced
some kernel oops in some drivers that were not converted, so this
patch series aim to address the clock conversion for the remaining imx
drivers.

I think this is 3.5 material.

Sascha, would you agree?

Thanks,

Fabio Estevam
