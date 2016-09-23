Return-path: <linux-media-owner@vger.kernel.org>
Received: from pegasos-out.vodafone.de ([80.84.1.38]:34226 "EHLO
        pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932390AbcIWSJj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 14:09:39 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by pegasos-out.vodafone.de (Rohrpostix2  Daemon) with ESMTP id 98ACC6000DB
        for <linux-media@vger.kernel.org>; Fri, 23 Sep 2016 19:59:48 +0200 (CEST)
Received: from pegasos-out.vodafone.de ([127.0.0.1])
        by localhost (rohrpostix2.prod.vfnet.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id i48TySgL8X13 for <linux-media@vger.kernel.org>;
        Fri, 23 Sep 2016 19:59:46 +0200 (CEST)
Subject: Re: [Intel-gfx] [PATCH 11/11] dma-buf: Do a fast lockless check for
 poll with timeout=0
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        intel-gfx@lists.freedesktop.org, linux-media@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>
References: <20160829070834.22296-1-chris@chris-wilson.co.uk>
 <20160829070834.22296-11-chris@chris-wilson.co.uk>
 <20160923135044.GM3988@dvetter-linux.ger.corp.intel.com>
 <20160923152044.GG28107@nuc-i3427.alporthouse.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
Message-ID: <a09b41cd-f907-226a-98f9-d9cf34fd6d2a@vodafone.de>
Date: Fri, 23 Sep 2016 19:59:44 +0200
MIME-Version: 1.0
In-Reply-To: <20160923152044.GG28107@nuc-i3427.alporthouse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.09.2016 um 17:20 schrieb Chris Wilson:
> On Fri, Sep 23, 2016 at 03:50:44PM +0200, Daniel Vetter wrote:
>> On Mon, Aug 29, 2016 at 08:08:34AM +0100, Chris Wilson wrote:
>>> Currently we install a callback for performing poll on a dma-buf,
>>> irrespective of the timeout. This involves taking a spinlock, as well as
>>> unnecessary work, and greatly reduces scaling of poll(.timeout=0) across
>>> multiple threads.
>>>
>>> We can query whether the poll will block prior to installing the
>>> callback to make the busy-query fast.
>>>
>>> Single thread: 60% faster
>>> 8 threads on 4 (+4 HT) cores: 600% faster
>>>
>>> Still not quite the perfect scaling we get with a native busy ioctl, but
>>> poll(dmabuf) is faster due to the quicker lookup of the object and
>>> avoiding drm_ioctl().
>>>
>>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>>> Cc: Sumit Semwal <sumit.semwal@linaro.org>
>>> Cc: linux-media@vger.kernel.org
>>> Cc: dri-devel@lists.freedesktop.org
>>> Cc: linaro-mm-sig@lists.linaro.org
>>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Need to strike the r-b here, since Christian König pointed out that
>> objects won't magically switch signalling on.
> Oh, it also means that
>
> commit fb8b7d2b9d80e1e71f379e57355936bd2b024be9
> Author: Jammy Zhou <Jammy.Zhou@amd.com>
> Date:   Wed Jan 21 18:35:47 2015 +0800
>
>      reservation: wait only with non-zero timeout specified (v3)
>      
>      When the timeout value passed to reservation_object_wait_timeout_rcu
>      is zero, no wait should be done if the fences are not signaled.
>      
>      Return '1' for idle and '0' for busy if the specified timeout is '0'
>      to keep consistent with the case of non-zero timeout.
>      
>      v2: call fence_put if not signaled in the case of timeout==0
>      
>      v3: switch to reservation_object_test_signaled_rcu
>      
>      Signed-off-by: Jammy Zhou <Jammy.Zhou@amd.com>
>      Reviewed-by: Christian König <christian.koenig@amd.com>
>      Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
>      Reviewed-By: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>      Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
>
> is wrong. And reservation_object_test_signaled_rcu() is unreliable.

Ups indeed, that patch is wrong as well.

I suggest that we just enable the signaling in this case as well.

Regards,
Christian.

> -Chris
>

