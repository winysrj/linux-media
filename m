Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45145 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750761AbeCHEOM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 23:14:12 -0500
Date: Thu, 8 Mar 2018 04:14:11 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Cc: "French, Nicholas A." <naf@ou.edu>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: ivtv: use arch_phys_wc_add() and require PAT disabled
Message-ID: <20180308041411.GR14069@wotan.suse.de>
References: <DM5PR03MB3035EE1AFCEE298AFB15AC46D3C60@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180301171936.GU14069@wotan.suse.de>
 <DM5PR03MB303587F12D7E56B951730A76D3D90@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180307190205.GA14069@wotan.suse.de>
 <DM5PR03MB30352350D588A81D2D02BE93D3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180308040601.GQ14069@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180308040601.GQ14069@wotan.suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 08, 2018 at 04:06:01AM +0000, Luis R. Rodriguez wrote:
> On Thu, Mar 08, 2018 at 03:16:29AM +0000, French, Nicholas A. wrote:
> > On Wed, Mar 07, 2018 at 07:02:05PM +0000, Luis R. Rodriguez wrote:
> > > On Tue, Mar 06, 2018 at 09:01:10PM +0000, French, Nicholas A. wrote:
> > > > any reason why PAT can't be enabled for ivtvfb as simply as in the attached
> > > > patch?
> > >
> > > Prior to your change the OSD buffer was obtained using the itv->dec_mem + oi->video_rbase
> > > given itv->dec_mem was initialized via [...]
> > >         itv->dec_mem = ioremap_nocache(itv->base_addr + IVTV_DECODER_OFFSET - oi->video_buffer_size,
> > >                                 IVTV_DECODER_SIZE);
> > 
> > Ah, I see. So my proposed ioremap_wc call was only "working" by aliasing the
> > ioremap_nocache()'d mem area and not actually using write combining at all.
> 
> There are some debugging PAT toys out there I think but I haven't played with
> them yet or I forgot how to to confirm or deny this sort of effort, but
> likeley.

In fact come to think of it I believe some neurons are telling me that if
two type does not match we'd get an error?

  Luis
