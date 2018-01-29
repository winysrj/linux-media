Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:58053 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbeA2Ljr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 06:39:47 -0500
Date: Mon, 29 Jan 2018 20:39:43 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: ir-spi: fix duty cycle
Message-id: <20180129113943.GT7575@gangnam.samsung>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-disposition: inline
In-reply-to: <20180127140537.12606-1-sean@mess.org>
References: <CGME20180127140542epcas2p20f88ebde4056afaeb14d1e86f9c3a1cf@epcas2p2.samsung.com>
        <20180127140537.12606-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On Sat, Jan 27, 2018 at 02:05:37PM +0000, Sean Young wrote:
> Calculate the pulse rather than having a few preset values.
> 
> Cc: Andi Shyti <andi.shyti@samsung.com>
> Signed-off-by: Sean Young <sean@mess.org>

Looks good to me.

Acked-by: Andi Shyti <andi.shyti@samsung.com>

Thanks,
Andi
