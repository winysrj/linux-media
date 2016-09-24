Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:60281 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759532AbcIXJIA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Sep 2016 05:08:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: sumit.semwal@linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, xie.baoyou@zte.com.cn
Subject: Re: [PATCH] dma-buf/sw_sync: mark sync_timeline_create() static
Date: Sat, 24 Sep 2016 11:07:44 +0200
Message-ID: <1638426.ZIktWlTxEQ@wuerfel>
In-Reply-To: <1474691626-7037-1-git-send-email-baoyou.xie@linaro.org>
References: <1474691626-7037-1-git-send-email-baoyou.xie@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday, September 24, 2016 12:33:46 PM CEST Baoyou Xie wrote:
> We get 1 warning when building kernel with W=1:
> drivers/dma-buf/sw_sync.c:87:23: warning: no previous prototype for 'sync_timeline_create' [-Wmissing-prototypes]
> 
> In fact, this function is only used in the file in which it is
> declared and don't need a declaration, but can be made static.
> So this patch marks it 'static'.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
