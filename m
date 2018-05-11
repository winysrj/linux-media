Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:57694 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752507AbeEKH1p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 03:27:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Ezequiel Garcia <ezequiel@collabora.com>,
        "Sumit Semwal" <sumit.semwal@linaro.org>,
        "Gustavo Padovan" <gustavo@padovan.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20180509201449.27452-1-ezequiel@collabora.com>
Cc: kernel@collabora.com, "Ezequiel Garcia" <ezequiel@collabora.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <20180509201449.27452-1-ezequiel@collabora.com>
Message-ID: <152602366168.22269.11696001916463464983@mail.alporthouse.com>
Subject: Re: [PATCH] dma-fence: Make dma_fence_add_callback() fail if signaled with
 error
Date: Fri, 11 May 2018 08:27:41 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Ezequiel Garcia (2018-05-09 21:14:49)
> Change how dma_fence_add_callback() behaves, when the fence
> has error-signaled by the time it is being add. After this commit,
> dma_fence_add_callback() returns the fence error, if it
> has error-signaled before dma_fence_add_callback() is called.

Why? What problem are you trying to solve? fence->error does not imply
that the fence has yet been signaled, and the caller wants a callback
when it is signaled.
-Chris
