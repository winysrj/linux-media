Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47345 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab2FFDnE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2012 23:43:04 -0400
Received: by bkcji2 with SMTP id ji2so5232985bkc.19
        for <linux-media@vger.kernel.org>; Tue, 05 Jun 2012 20:43:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120529092030.GI30400@pengutronix.de>
References: <1337987696-31728-1-git-send-email-festevam@gmail.com>
	<1337987696-31728-6-git-send-email-festevam@gmail.com>
	<20120529092030.GI30400@pengutronix.de>
Date: Wed, 6 Jun 2012 00:43:03 -0300
Message-ID: <CAOMZO5DrVWNKscMdXORTJo+fss+O5Lykc+5hJ1d33Ae7M1mcHg@mail.gmail.com>
Subject: Re: [PATCH 06/15] video: mx1_camera: Use clk_prepare_enable/clk_disable_unprepare
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: kernel@pengutronix.de, shawn.guo@freescale.com,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,

On Tue, May 29, 2012 at 6:20 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Fri, May 25, 2012 at 08:14:47PM -0300, Fabio Estevam wrote:
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> Prepare the clock before enabling it.
>>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: <linux-media@vger.kernel.org>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Can patches 6, 7 and 8 be applied?
