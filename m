Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44712 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbeG3RnG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 13:43:06 -0400
Date: Mon, 30 Jul 2018 13:07:02 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>,
        Hans de Goede <hdegoede@redhat.com>, hverkuil@xs4all.nl,
        mchehab@kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        rostedt@goodmis.org, mingo@redhat.com, isely@pobox.com,
        bhumirks@gmail.com, colin.king@canonical.com,
        linux-media@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] media: usb: pwc: Don't use coherent DMA buffers for
 ISO transfer
Message-ID: <20180730130702.27664d15@coco.lan>
In-Reply-To: <eb2b495fe7e8bbeaf3f9e2814be4923583482852.camel@collabora.com>
References: <20180617143625.32133-1-matwey@sai.msu.ru>
        <20180617143625.32133-2-matwey@sai.msu.ru>
        <c02f92a8998fc62d3e3d48aa154fbaa7e223dd10.camel@collabora.com>
        <CAJs94EavBDcFHpd0KcCZJTgWf0JC=AEDY=X8b3P2nZvt8mBCPA@mail.gmail.com>
        <eb2b495fe7e8bbeaf3f9e2814be4923583482852.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 17 Jul 2018 17:10:22 -0300
Ezequiel Garcia <ezequiel@collabora.com> escreveu:

> Yeah, and not setting URB_NO_TRANSFER_DMA_MAP makes the USB core
> create DMA mappings and use the streaming API. Which makes more
> sense in hardware without hardware coherency.
>
> The only thing that bothers me with this patch is that it's not
> really something specific to this driver. If this fix is valid
> for pwc, then it's valid for all the drivers allocating coherent
> memory.

We're actually doing this change on other drivers:
	https://git.linuxtv.org/media_tree.git/commit/?id=d571b592c6206

I suspect that the reason why all USB media drivers were using
URB_NO_TRANSFER_DMA_MAP is just because the first media USB driver
upstream used it.

On that time, I remember I tried once to not use this flag, but there
was something that broke (perhaps I just didn't know enough about the
USB layer - or perhaps some fixes happened at USB core - allowing it
to be used with ISOC transfers).

Anyway, nowadays, I fail to see a reason why not let the USB core
do the DMA maps. On my tests after this patch, at the boards I tested
(arm and x86), I was unable to see any regressions.

Thanks,
Mauro
