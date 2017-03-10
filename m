Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34809 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935082AbdCJMkt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 07:40:49 -0500
Received: by mail-wr0-f193.google.com with SMTP id u48so11496271wrc.1
        for <linux-media@vger.kernel.org>; Fri, 10 Mar 2017 04:40:48 -0800 (PST)
Date: Fri, 10 Mar 2017 13:40:43 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Brian Starkey <brian.starkey@arm.com>
Cc: Laura Abbott <labbott@redhat.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Rom Lemarchand <romlem@google.com>, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/12] Ion cleanup in preparation for moving out of
 staging
Message-ID: <20170310124043.45hdu64wd4acf4it@phenom.ffwll.local>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
 <20170303132949.GC31582@dhcp22.suse.cz>
 <cf383b9b-3cbc-0092-a071-f120874c053c@redhat.com>
 <20170306074258.GA27953@dhcp22.suse.cz>
 <20170306104041.zghsicrnadoap7lp@phenom.ffwll.local>
 <20170306105805.jsq44kfxhsvazkm6@sirena.org.uk>
 <20170306160437.sf7bksorlnw7u372@phenom.ffwll.local>
 <CA+M3ks77Am3Fx-ZNmgeM5tCqdM7SzV7rby4Es-p2F2aOhUco9g@mail.gmail.com>
 <26bc57ae-d88f-4ea0-d666-2c1a02bf866f@redhat.com>
 <20170310103112.GA15945@e106950-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170310103112.GA15945@e106950-lin.cambridge.arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 10, 2017 at 10:31:13AM +0000, Brian Starkey wrote:
> Hi,
> 
> On Thu, Mar 09, 2017 at 09:38:49AM -0800, Laura Abbott wrote:
> > On 03/09/2017 02:00 AM, Benjamin Gaignard wrote:
> 
> [snip]
> 
> > > 
> > > For me those patches are going in the right direction.
> > > 
> > > I still have few questions:
> > > - since alignment management has been remove from ion-core, should it
> > > be also removed from ioctl structure ?
> > 
> > Yes, I think I'm going to go with the suggestion to fixup the ABI
> > so we don't need the compat layer and as part of that I'm also
> > dropping the align argument.
> > 
> 
> Is the only motivation for removing the alignment parameter that
> no-one got around to using it for something useful yet?
> The original comment was true - different devices do have different
> alignment requirements.
> 
> Better alignment can help SMMUs use larger blocks when mapping,
> reducing TLB pressure and the chance of a page table walk causing
> display underruns.

Extending ioctl uapi is easy, trying to get rid of bad uapi is much
harder. Given that right now we don't have an ion allocator that does
alignment I think removing it makes sense. And if we go with lots of
heaps, we might as well have an ion heap per alignment that your hw needs,
so there's different ways to implement this in the future.

At least from the unix device memory allocator pov it's probably simpler
to encode stuff like this into the heap name, instead of having to pass
heap + list of additional properties/constraints.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
