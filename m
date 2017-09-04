Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:54643 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753557AbdIDNkw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 09:40:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Chris Wilson <chris@chris-wilson.co.uk>
To: =?utf-8?q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>,
        daniel.vetter@ffwll.ch, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
References: <1504531653-13779-1-git-send-email-deathsimple@vodafone.de>
In-Reply-To: <1504531653-13779-1-git-send-email-deathsimple@vodafone.de>
Message-ID: <150453243791.23157.6907537389223890207@mail.alporthouse.com>
Subject: Re: [PATCH] dma-fence: fix dma_fence_get_rcu_safe
Date: Mon, 04 Sep 2017 14:40:37 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Christian König (2017-09-04 14:27:33)
> From: Christian König <christian.koenig@amd.com>
> 
> The logic is buggy and unnecessary complex. When dma_fence_get_rcu() fails to
> acquire a reference it doesn't necessary mean that there is no fence at all.
> 
> It usually mean that the fence was replaced by a new one and in this situation
> we certainly want to have the new one as result and *NOT* NULL.

Which is not guaranteed by the code you wrote either.

The point of the comment is that the mb is only inside the successful
kref_atomic_inc_unless_zero, and that only after that mb do you know
whether or not you have the current fence.

You can argue that you want to replace the
	if (!dma_fence_get_rcu())
		return NULL
with
	if (!dma_fence_get_rcu()
		continue;
but it would be incorrect to say that by simply ignoring the
post-condition check that you do have the right fence.
-Chris
