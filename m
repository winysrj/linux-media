Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33591 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754632AbdEHObS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 10:31:18 -0400
Date: Mon, 8 May 2017 11:31:15 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] dma-buf: Combine two function calls into one in
 dma_buf_debug_show()
Message-ID: <20170508143115.GA28331@joana>
References: <3d972fa2-787a-d1f2-ff86-5c05494e00d3@users.sourceforge.net>
 <b8a85220-039a-e4bb-c74b-d76baab234e8@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8a85220-039a-e4bb-c74b-d76baab234e8@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-05-08 SF Markus Elfring <elfring@users.sourceforge.net>:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 8 May 2017 10:32:44 +0200
> 
> A bit of data was put into a sequence by two separate function calls.
> Print the same data by a single function call instead.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/dma-buf/dma-buf.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Reviewed-by: Gustavo Padovan <gustavo.padovan@collabora.com>

Gustavo
