Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34806 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753594AbdCFQNm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 11:13:42 -0500
Received: by mail-wm0-f67.google.com with SMTP id u132so6519831wmg.1
        for <linux-media@vger.kernel.org>; Mon, 06 Mar 2017 08:13:41 -0800 (PST)
Date: Mon, 6 Mar 2017 17:04:37 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com,
        romlem@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/12] Ion cleanup in preparation for moving out of
 staging
Message-ID: <20170306160437.sf7bksorlnw7u372@phenom.ffwll.local>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
 <20170303132949.GC31582@dhcp22.suse.cz>
 <cf383b9b-3cbc-0092-a071-f120874c053c@redhat.com>
 <20170306074258.GA27953@dhcp22.suse.cz>
 <20170306104041.zghsicrnadoap7lp@phenom.ffwll.local>
 <20170306105805.jsq44kfxhsvazkm6@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170306105805.jsq44kfxhsvazkm6@sirena.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 06, 2017 at 11:58:05AM +0100, Mark Brown wrote:
> On Mon, Mar 06, 2017 at 11:40:41AM +0100, Daniel Vetter wrote:
> 
> > No one gave a thing about android in upstream, so Greg KH just dumped it
> > all into staging/android/. We've discussed ION a bunch of times, recorded
> > anything we'd like to fix in staging/android/TODO, and Laura's patch
> > series here addresses a big chunk of that.
> 
> > This is pretty much the same approach we (gpu folks) used to de-stage the
> > syncpt stuff.
> 
> Well, there's also the fact that quite a few people have issues with the
> design (like Laurent).  It seems like a lot of them have either got more
> comfortable with it over time, or at least not managed to come up with
> any better ideas in the meantime.

See the TODO, it has everything a really big group (look at the patch for
the full Cc: list) figured needs to be improved at LPC 2015. We don't just
merge stuff because merging stuff is fun :-)

Laurent was even in that group ...
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
