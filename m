Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44559 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab1BNJ5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 04:57:41 -0500
Received: by fxm20 with SMTP id 20so4969521fxm.19
        for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 01:57:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1102071740380.31738@axis700.grange>
References: <1296031789-1721-3-git-send-email-agust@denx.de>
	<1296476549-10421-1-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1102031104090.21719@axis700.grange>
	<20110205143505.0b300a3a@wker>
	<Pine.LNX.4.64.1102051735270.11500@axis700.grange>
	<20110205210457.7218ecdc@wker>
	<Pine.LNX.4.64.1102071205570.29036@axis700.grange>
	<20110207122147.4081f47d@wker>
	<Pine.LNX.4.64.1102071232440.29036@axis700.grange>
	<20110207144530.70d9dab1@wker>
	<Pine.LNX.4.64.1102071740380.31738@axis700.grange>
Date: Mon, 14 Feb 2011 01:57:39 -0800
Message-ID: <AANLkTinpP6hoy_cz7qb1+izjO6_LEeQDfVfVwB-QrRiu@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] dma: ipu_idmac: do not lose valid received data in
 the irq handler
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Anatolij Gustschin <agust@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>,
	Detlev Zundel <dzu@denx.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	"Koul, Vinod" <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 7, 2011 at 8:49 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Ok, I've found the reason. Buffer number repeats, when there is an
> underrun, which is happening in my tests, when frames are arriving quickly
> enough, but the user-space is not fast enough to process them, e.g., when
> it is writing them to files over NFS or even just displaying on the LCD.
> Without your patch these underruns happen just as well, they just don't
> get recognised, because there's always one buffer delayed, so, the queue
> is never empty.
>
> Dan, please add my
>
> Reviewed-(and-tested-)by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks, applied v2.

--
Dan
