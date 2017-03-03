Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42857 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751445AbdCCNat (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 08:30:49 -0500
Date: Fri, 3 Mar 2017 14:29:49 +0100
From: Michal Hocko <mhocko@kernel.org>
To: Laura Abbott <labbott@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com,
        romlem@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/12] Ion cleanup in preparation for moving out of
 staging
Message-ID: <20170303132949.GC31582@dhcp22.suse.cz>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488491084-17252-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 02-03-17 13:44:32, Laura Abbott wrote:
> Hi,
> 
> There's been some recent discussions[1] about Ion-like frameworks. There's
> apparently interest in just keeping Ion since it works reasonablly well.
> This series does what should be the final clean ups for it to possibly be
> moved out of staging.
> 
> This includes the following:
> - Some general clean up and removal of features that never got a lot of use
>   as far as I can tell.
> - Fixing up the caching. This is the series I proposed back in December[2]
>   but never heard any feedback on. It will certainly break existing
>   applications that rely on the implicit caching. I'd rather make an effort
>   to move to a model that isn't going directly against the establishement
>   though.
> - Fixing up the platform support. The devicetree approach was never well
>   recieved by DT maintainers. The proposal here is to think of Ion less as
>   specifying requirements and more of a framework for exposing memory to
>   userspace.
> - CMA allocations now happen without the need of a dummy device structure.
>   This fixes a bunch of the reasons why I attempted to add devicetree
>   support before.
> 
> I've had problems getting feedback in the past so if I don't hear any major
> objections I'm going to send out with the RFC dropped to be picked up.
> The only reason there isn't a patch to come out of staging is to discuss any
> other changes to the ABI people might want. Once this comes out of staging,
> I really don't want to mess with the ABI.

Could you recapitulate concerns preventing the code being merged
normally rather than through the staging tree and how they were
addressed?
-- 
Michal Hocko
SUSE Labs
