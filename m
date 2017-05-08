Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36525 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752598AbdEHOc3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 10:32:29 -0400
Date: Mon, 8 May 2017 11:32:26 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] dma-buf: Adjust a null pointer check in
 dma_buf_attach()
Message-ID: <20170508143226.GC28331@joana>
References: <3d972fa2-787a-d1f2-ff86-5c05494e00d3@users.sourceforge.net>
 <1deb58e7-7eac-55d6-235a-baf72f392371@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1deb58e7-7eac-55d6-235a-baf72f392371@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-05-08 SF Markus Elfring <elfring@users.sourceforge.net>:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 8 May 2017 10:54:17 +0200
> 
> The script "checkpatch.pl" pointed information out like the following.
> 
> Comparison to NULL could be written "!attach"
> 
> Thus adjust this expression.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/dma-buf/dma-buf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Gustavo Padovan <gustavo.padovan@collabora.com>

Gustavo
