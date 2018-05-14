Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:56113 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755169AbeENQs2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 12:48:28 -0400
Received: by mail-wm0-f44.google.com with SMTP id a8-v6so14692210wmg.5
        for <linux-media@vger.kernel.org>; Mon, 14 May 2018 09:48:27 -0700 (PDT)
Date: Mon, 14 May 2018 18:48:23 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>, kernel@collabora.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-fence: Make dma_fence_add_callback() fail if
 signaled with error
Message-ID: <20180514164823.GH28661@phenom.ffwll.local>
References: <20180509201449.27452-1-ezequiel@collabora.com>
 <152602366168.22269.11696001916463464983@mail.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152602366168.22269.11696001916463464983@mail.alporthouse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 11, 2018 at 08:27:41AM +0100, Chris Wilson wrote:
> Quoting Ezequiel Garcia (2018-05-09 21:14:49)
> > Change how dma_fence_add_callback() behaves, when the fence
> > has error-signaled by the time it is being add. After this commit,
> > dma_fence_add_callback() returns the fence error, if it
> > has error-signaled before dma_fence_add_callback() is called.
> 
> Why? What problem are you trying to solve? fence->error does not imply
> that the fence has yet been signaled, and the caller wants a callback
> when it is signaled.

On top this is incosistent, e.g. we don't do the same for any of the other
dma_fence interfaces. Plus there's the issue that you might alias errno
values with fence errno values.

I think keeping the error codes from the functions you're calling distinct
from the error code of the fence itself makes a lot of sense. The first
tells you whether your request worked out (or why not), the second tells
you whether the asynchronous dma operation (gpu rendering, page flip,
whatever) that the dma_fence represents worked out (or why not). That's 2
distinct things imo.

Might be good to show us the driver code that needs this behaviour so we
can discuss how to best handle your use-case.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
