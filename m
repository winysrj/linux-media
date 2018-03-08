Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43964 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754066AbeCHEGD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 23:06:03 -0500
Date: Thu, 8 Mar 2018 04:06:01 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: "French, Nicholas A." <naf@ou.edu>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: ivtv: use arch_phys_wc_add() and require PAT disabled
Message-ID: <20180308040601.GQ14069@wotan.suse.de>
References: <DM5PR03MB3035EE1AFCEE298AFB15AC46D3C60@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180301171936.GU14069@wotan.suse.de>
 <DM5PR03MB303587F12D7E56B951730A76D3D90@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180307190205.GA14069@wotan.suse.de>
 <DM5PR03MB30352350D588A81D2D02BE93D3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR03MB30352350D588A81D2D02BE93D3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 08, 2018 at 03:16:29AM +0000, French, Nicholas A. wrote:
> On Wed, Mar 07, 2018 at 07:02:05PM +0000, Luis R. Rodriguez wrote:
> > On Tue, Mar 06, 2018 at 09:01:10PM +0000, French, Nicholas A. wrote:
> > > any reason why PAT can't be enabled for ivtvfb as simply as in the attached
> > > patch?
> >
> > Prior to your change the OSD buffer was obtained using the itv->dec_mem + oi->video_rbase
> > given itv->dec_mem was initialized via [...]
> >         itv->dec_mem = ioremap_nocache(itv->base_addr + IVTV_DECODER_OFFSET - oi->video_buffer_size,
> >                                 IVTV_DECODER_SIZE);
> 
> Ah, I see. So my proposed ioremap_wc call was only "working" by aliasing the
> ioremap_nocache()'d mem area and not actually using write combining at all.

There are some debugging PAT toys out there I think but I haven't played with
them yet or I forgot how to to confirm or deny this sort of effort, but
likeley.

> > So what I'd do is change the ioremap_nocache()'d size by substracting
> > oi->video_buffer_size -- but then you have to ask yourself how you'd get
> > that size. If its something you can figure out then great.
> 
> Size is easy since its hardcoded, but unfortunately getting the offset of the
> framebuffer inside the decoders memory to remove from the ioremap_nocache
> call is a chicken and egg problem: the offset is determined by querying the
> firmware that has been loaded to the decoder. the firmware itself will be
> loaded after the ioremap_nocache call at an offset from the address it
> returns.

What I expected. Probably why no one had tried before to clean it up.

> So unless there is a io-re-remap to change the caching status of a subset of
> the decoder's memory once we find out what the framebuffer offset is inside
> the original iremap_nocache'd area, then its a no go for write combining to
> the framebuffer with PAT.

No what if the framebuffer driver is just requested as a secondary step
after firmware loading?

> On the other hand, it works fine for me with a nocache'd framebuffer. It's
> certainly better for me personally to have a nocache framebuffer with
> PAT-enabled than the framebuffer completely disabled with PAT-enabled, but I
> don't think I would even propose to rollback the x86 nopat requirement in
> general. Apparently the throngs of people using this super-popular driver
> feature haven't complained in the last couple years, so maybe its OK for me
> to just patch the pat-enabled guard out and deal with a nocache'd
> framebuffer.

Nope, best you add a feature to just let you disable wc stuff, to enable
life with PAT.

  Luis
