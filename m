Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64120 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab1AaF4E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 00:56:04 -0500
Received: by wwa36 with SMTP id 36so5438040wwa.1
        for <linux-media@vger.kernel.org>; Sun, 30 Jan 2011 21:56:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110127092255.2cb6f0a3@wker>
References: <1296031789-1721-1-git-send-email-agust@denx.de>
	<1296031789-1721-3-git-send-email-agust@denx.de>
	<20110127092255.2cb6f0a3@wker>
Date: Sun, 30 Jan 2011 21:56:02 -0800
Message-ID: <AANLkTinkv5PszU3-_rQx50rymJPXEc5oDkbvczbtjmfx@mail.gmail.com>
Subject: Re: [PATCH 2/2] dma: ipu_idmac: do not lose valid received data in
 the irq handler
From: Dan Williams <dan.j.williams@intel.com>
To: Anatolij Gustschin <agust@denx.de>
Cc: Detlev Zundel <dzu@denx.de>, Markus Niebel <Markus.Niebel@tqs.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jan 27, 2011 at 12:22 AM, Anatolij Gustschin <agust@denx.de> wrote:
> Reading the commit message again I now realize that there is
> a mistake.
>
> On Wed, 26 Jan 2011 09:49:49 +0100
> Anatolij Gustschin <agust@denx.de> wrote:
> ...
>> received data. DMA_BUFx_RDY won't be set by the IPU, so waiting
>> for this event in the interrupt handler is wrong.
>
> This should read 'DMAIC_x_CUR_BUF flag won't be flipped here by
> the IPU, so waiting for this event in the EOF interrupt handler
> is wrong.'
>
> I'll submit another patch fixing the commit message.
>

Ok, also looking for a reviewed/acked by Guennadi.

--
Dan
