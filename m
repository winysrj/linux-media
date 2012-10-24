Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35995 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934461Ab2JXHr2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 03:47:28 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so105417wey.19
        for <linux-media@vger.kernel.org>; Wed, 24 Oct 2012 00:47:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5BpJAEdwKRVE47D+7wggLsvCXtPcv272UPYsZV6v3vKMg@mail.gmail.com>
References: <1349791352-9829-1-git-send-email-fabio.estevam@freescale.com>
	<Pine.LNX.4.64.1210222301100.32591@axis700.grange>
	<CAOMZO5BpJAEdwKRVE47D+7wggLsvCXtPcv272UPYsZV6v3vKMg@mail.gmail.com>
Date: Wed, 24 Oct 2012 09:47:27 +0200
Message-ID: <CACKLOr355VFgxPGUXwkyFHxW95p7JaF=wdhF1FYsQdM-37d7ng@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] [media]: mx2_camera: Fix regression caused by
 clock conversion
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	mchehab@infradead.org, kernel@pengutronix.de, gcembed@gmail.com,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23 October 2012 00:17, Fabio Estevam <festevam@gmail.com> wrote:
> Hi Guennadi
>
> On Mon, Oct 22, 2012 at 7:07 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
>> ? I don't find a clock named "per" and associated with "mx2-camera.0" in
>> arch/arm/mach-imx/clk-imx27.c. I only find it in clk-imx25.c. Does this
>> mean, that this your patch is for i.MX25? But you're saying it's for
>> i.MX27. Confused...
>
> I provide this mx27 clock in the first patch of the series:
> http://patchwork.linuxtv.org/patch/14915/

Yes, I made the same mistake.



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
