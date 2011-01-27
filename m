Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.10]:44243 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1A0IWj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 03:22:39 -0500
Date: Thu, 27 Jan 2011 09:22:55 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-arm-kernel@lists.infradead.org, Detlev Zundel <dzu@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: Re: [PATCH 2/2] dma: ipu_idmac: do not lose valid received data in
 the irq handler
Message-ID: <20110127092255.2cb6f0a3@wker>
In-Reply-To: <1296031789-1721-3-git-send-email-agust@denx.de>
References: <1296031789-1721-1-git-send-email-agust@denx.de>
	<1296031789-1721-3-git-send-email-agust@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Reading the commit message again I now realize that there is
a mistake. 

On Wed, 26 Jan 2011 09:49:49 +0100
Anatolij Gustschin <agust@denx.de> wrote:
...
> received data. DMA_BUFx_RDY won't be set by the IPU, so waiting
> for this event in the interrupt handler is wrong.

This should read 'DMAIC_x_CUR_BUF flag won't be flipped here by
the IPU, so waiting for this event in the EOF interrupt handler
is wrong.'

I'll submit another patch fixing the commit message.

Anatolij
