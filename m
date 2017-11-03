Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0043.outbound.protection.outlook.com ([104.47.36.43]:48492
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752465AbdKCHsu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Nov 2017 03:48:50 -0400
Subject: Re: [PATCH 0/4] dma-buf: Silence dma_fence __rcu sparse warnings
To: Ville Syrjala <ville.syrjala@linux.intel.com>,
        dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@redhat.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
References: <20171102200336.23347-1-ville.syrjala@linux.intel.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <e9a25939-e932-ef7a-9bba-9070f5876ae9@amd.com>
Date: Fri, 3 Nov 2017 08:48:23 +0100
MIME-Version: 1.0
In-Reply-To: <20171102200336.23347-1-ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch #4 is Reviewed-by: Christian König <christian.koenig@amd.com>.

The rest is Acked-by: Christian König <christian.koenig@amd.com>.

Regards,
Christian.

Am 02.11.2017 um 21:03 schrieb Ville Syrjala:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>
> When building drm+i915 I get around 150 lines of sparse noise from
> dma_fence __rcu warnings. This series eliminates all of that.
>
> The first two patches were already posted by Chris, but there wasn't
> any real reaction, so I figured I'd repost with a wider Cc list.
>
> As for the other two patches, I'm no expert on dma_fence and I didn't
> spend a lot of time looking at it so I can't be sure I annotated all
> the accesses correctly. But I figured someone will scream at me if
> I got it wrong ;)
>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Jason Ekstrand <jason@jlekstrand.net>
> Cc: linaro-mm-sig@lists.linaro.org
> Cc: linux-media@vger.kernel.org
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
>
> Chris Wilson (2):
>    drm/syncobj: Mark up the fence as an RCU protected pointer
>    dma-buf/fence: Sparse wants __rcu on the object itself
>
> Ville Syrjälä (2):
>    drm/syncobj: Use proper methods for accessing rcu protected pointers
>    dma-buf: Use rcu_assign_pointer() to set rcu protected pointers
>
>   drivers/dma-buf/reservation.c |  2 +-
>   drivers/gpu/drm/drm_syncobj.c | 11 +++++++----
>   include/drm/drm_syncobj.h     |  2 +-
>   include/linux/dma-fence.h     |  2 +-
>   4 files changed, 10 insertions(+), 7 deletions(-)
>
