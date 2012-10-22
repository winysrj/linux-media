Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61980 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab2JVWRD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 18:17:03 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so2982293oag.19
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2012 15:17:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1210222301100.32591@axis700.grange>
References: <1349791352-9829-1-git-send-email-fabio.estevam@freescale.com>
	<Pine.LNX.4.64.1210222301100.32591@axis700.grange>
Date: Mon, 22 Oct 2012 20:17:02 -0200
Message-ID: <CAOMZO5BpJAEdwKRVE47D+7wggLsvCXtPcv272UPYsZV6v3vKMg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] [media]: mx2_camera: Fix regression caused by
 clock conversion
From: Fabio Estevam <festevam@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, mchehab@infradead.org,
	kernel@pengutronix.de, gcembed@gmail.com,
	javier.martin@vista-silicon.com, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi

On Mon, Oct 22, 2012 at 7:07 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> ? I don't find a clock named "per" and associated with "mx2-camera.0" in
> arch/arm/mach-imx/clk-imx27.c. I only find it in clk-imx25.c. Does this
> mean, that this your patch is for i.MX25? But you're saying it's for
> i.MX27. Confused...

I provide this mx27 clock in the first patch of the series:
http://patchwork.linuxtv.org/patch/14915/

Regards,

Fabio Estevam
