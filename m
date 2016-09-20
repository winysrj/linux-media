Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33118 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752924AbcITLNl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 07:13:41 -0400
Date: Tue, 20 Sep 2016 13:13:38 +0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: sumit.semwal@linaro.org, arnd@arndb.de, xie.baoyou@zte.com.cn,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf/sw_sync: mark sync_timeline_create() static
Message-ID: <20160920111338.GE13275@joana>
References: <1474202961-10099-1-git-send-email-baoyou.xie@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474202961-10099-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-09-18 Baoyou Xie <baoyou.xie@linaro.org>:

> We get 1 warning when building kernel with W=1:
> drivers/dma-buf/sw_sync.c:87:23: warning: no previous prototype for 'sync_timeline_create' [-Wmissing-prototypes]
> 
> In fact, this function is only used in the file in which it is
> declared and don't need a declaration, but can be made static.
> So this patch marks it 'static'.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
> ---
>  drivers/dma-buf/sw_sync.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks for finding this.

Reviewed-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

Gustavo

