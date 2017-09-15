Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:51329 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750879AbdIOIsz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 04:48:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Colin King <colin.king@canonical.com>,
        "Sumit Semwal" <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20170914230516.6056-1-colin.king@canonical.com>
Cc: linaro-mm-sig@lists.linaro.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170914230516.6056-1-colin.king@canonical.com>
Message-ID: <150546532831.19729.6169136066415731528@mail.alporthouse.com>
Subject: Re: [PATCH] dma-buf: remove redundant initialization of sg_table
Date: Fri, 15 Sep 2017 09:48:48 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Colin King (2017-09-15 00:05:16)
> From: Colin Ian King <colin.king@canonical.com>
> 
> sg_table is being initialized and is never read before it is updated
> again later on, hence making the initialization redundant. Remove
> the initialization.
> 
> Detected by clang scan-build:
> "warning: Value stored to 'sg_table' during its initialization is
> never read"
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris
