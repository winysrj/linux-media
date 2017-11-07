Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:44669 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932420AbdKGIHc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Nov 2017 03:07:32 -0500
Received: by mail-wr0-f193.google.com with SMTP id u97so3536039wrc.1
        for <linux-media@vger.kernel.org>; Tue, 07 Nov 2017 00:07:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e9a25939-e932-ef7a-9bba-9070f5876ae9@amd.com>
References: <20171102200336.23347-1-ville.syrjala@linux.intel.com> <e9a25939-e932-ef7a-9bba-9070f5876ae9@amd.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 7 Nov 2017 13:37:10 +0530
Message-ID: <CAO_48GHqiC39RZ5iby4h6mT3X5=5REn+nO2XEzqoN3tx3uVpCQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] dma-buf: Silence dma_fence __rcu sparse warnings
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ville,

On 3 November 2017 at 13:18, Christian K=C3=B6nig <christian.koenig@amd.com=
> wrote:
> Patch #4 is Reviewed-by: Christian K=C3=B6nig <christian.koenig@amd.com>.
>
> The rest is Acked-by: Christian K=C3=B6nig <christian.koenig@amd.com>.
>
> Regards,
> Christian.
>
>
> Am 02.11.2017 um 21:03 schrieb Ville Syrjala:
>>
>> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>>
>> When building drm+i915 I get around 150 lines of sparse noise from
>> dma_fence __rcu warnings. This series eliminates all of that.
>>
>> The first two patches were already posted by Chris, but there wasn't
>> any real reaction, so I figured I'd repost with a wider Cc list.
>>
>> As for the other two patches, I'm no expert on dma_fence and I didn't
>> spend a lot of time looking at it so I can't be sure I annotated all
>> the accesses correctly. But I figured someone will scream at me if
>> I got it wrong ;)
>>
>> Cc: Dave Airlie <airlied@redhat.com>
>> Cc: Jason Ekstrand <jason@jlekstrand.net>
>> Cc: linaro-mm-sig@lists.linaro.org
>> Cc: linux-media@vger.kernel.org
>> Cc: Alex Deucher <alexander.deucher@amd.com>
>> Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
>> Cc: Sumit Semwal <sumit.semwal@linaro.org>
>> Cc: Chris Wilson <chris@chris-wilson.co.uk>
>>
>> Chris Wilson (2):
>>    drm/syncobj: Mark up the fence as an RCU protected pointer
>>    dma-buf/fence: Sparse wants __rcu on the object itself
>>
>> Ville Syrj=C3=A4l=C3=A4 (2):
>>    drm/syncobj: Use proper methods for accessing rcu protected pointers
>>    dma-buf: Use rcu_assign_pointer() to set rcu protected pointers

For patches 2 (with Daniel's minor comment) and 4, please feel free to add =
my
Acked-by: Sumit Semwal <sumit.semwal@linaro.org.

>>
>>   drivers/dma-buf/reservation.c |  2 +-
>>   drivers/gpu/drm/drm_syncobj.c | 11 +++++++----
>>   include/drm/drm_syncobj.h     |  2 +-
>>   include/linux/dma-fence.h     |  2 +-
>>   4 files changed, 10 insertions(+), 7 deletions(-)
>>
>

Best,
Sumit.
