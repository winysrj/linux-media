Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33739 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752554AbdEHOby (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 10:31:54 -0400
Date: Mon, 8 May 2017 11:31:51 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/4] dma-buf: Improve a size determination in
 dma_buf_attach()
Message-ID: <20170508143151.GB28331@joana>
References: <3d972fa2-787a-d1f2-ff86-5c05494e00d3@users.sourceforge.net>
 <cff83dc6-4391-d9b1-6ac2-791d5a3e2eb4@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cff83dc6-4391-d9b1-6ac2-791d5a3e2eb4@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-05-08 SF Markus Elfring <elfring@users.sourceforge.net>:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 8 May 2017 10:50:09 +0200
> 
> Replace the specification of a data structure by a pointer dereference
> as the parameter for the operator "sizeof" to make the corresponding size
> determination a bit safer according to the Linux coding style convention.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/dma-buf/dma-buf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Gustavo Padovan <gustavo.padovan@collabora.com>                    

Gustavo
 
