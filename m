Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:43944 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754515AbdKITdY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Nov 2017 14:33:24 -0500
Date: Thu, 9 Nov 2017 21:33:20 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 0/4] dma-buf: Silence dma_fence __rcu sparse warnings
Message-ID: <20171109193320.GC10981@intel.com>
References: <20171102200336.23347-1-ville.syrjala@linux.intel.com>
 <e9a25939-e932-ef7a-9bba-9070f5876ae9@amd.com>
 <CAO_48GHqiC39RZ5iby4h6mT3X5=5REn+nO2XEzqoN3tx3uVpCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO_48GHqiC39RZ5iby4h6mT3X5=5REn+nO2XEzqoN3tx3uVpCQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 07, 2017 at 01:37:10PM +0530, Sumit Semwal wrote:
> Hi Ville,
> 
> On 3 November 2017 at 13:18, Christian König <christian.koenig@amd.com> wrote:
> > Patch #4 is Reviewed-by: Christian König <christian.koenig@amd.com>.
> >
> > The rest is Acked-by: Christian König <christian.koenig@amd.com>.
> >
> > Regards,
> > Christian.
> >
> >
> > Am 02.11.2017 um 21:03 schrieb Ville Syrjala:
> >>
> >> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> >>
> >> When building drm+i915 I get around 150 lines of sparse noise from
> >> dma_fence __rcu warnings. This series eliminates all of that.
> >>
> >> The first two patches were already posted by Chris, but there wasn't
> >> any real reaction, so I figured I'd repost with a wider Cc list.
> >>
> >> As for the other two patches, I'm no expert on dma_fence and I didn't
> >> spend a lot of time looking at it so I can't be sure I annotated all
> >> the accesses correctly. But I figured someone will scream at me if
> >> I got it wrong ;)
> >>
> >> Cc: Dave Airlie <airlied@redhat.com>
> >> Cc: Jason Ekstrand <jason@jlekstrand.net>
> >> Cc: linaro-mm-sig@lists.linaro.org
> >> Cc: linux-media@vger.kernel.org
> >> Cc: Alex Deucher <alexander.deucher@amd.com>
> >> Cc: Christian König <christian.koenig@amd.com>
> >> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> >> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> >>
> >> Chris Wilson (2):
> >>    drm/syncobj: Mark up the fence as an RCU protected pointer
> >>    dma-buf/fence: Sparse wants __rcu on the object itself
> >>
> >> Ville Syrjälä (2):
> >>    drm/syncobj: Use proper methods for accessing rcu protected pointers
> >>    dma-buf: Use rcu_assign_pointer() to set rcu protected pointers
> 
> For patches 2 (with Daniel's minor comment) and 4, please feel free to add my
> Acked-by: Sumit Semwal <sumit.semwal@linaro.org.

Thanks everyone. Series pushed to drm-misc-next.

> 
> >>
> >>   drivers/dma-buf/reservation.c |  2 +-
> >>   drivers/gpu/drm/drm_syncobj.c | 11 +++++++----
> >>   include/drm/drm_syncobj.h     |  2 +-
> >>   include/linux/dma-fence.h     |  2 +-
> >>   4 files changed, 10 insertions(+), 7 deletions(-)
> >>
> >
> 
> Best,
> Sumit.

-- 
Ville Syrjälä
Intel OTC
