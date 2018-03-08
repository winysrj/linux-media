Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-00272701.pphosted.com ([67.231.145.144]:57288 "EHLO
        mx0a-00272701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750761AbeCHDzn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 22:55:43 -0500
From: "French, Nicholas A." <naf@ou.edu>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
CC: "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: ivtv: use arch_phys_wc_add() and require PAT disabled
Date: Thu, 8 Mar 2018 03:16:29 +0000
Message-ID: <DM5PR03MB30352350D588A81D2D02BE93D3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
References: <DM5PR03MB3035EE1AFCEE298AFB15AC46D3C60@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180301171936.GU14069@wotan.suse.de>
 <DM5PR03MB303587F12D7E56B951730A76D3D90@DM5PR03MB3035.namprd03.prod.outlook.com>,<20180307190205.GA14069@wotan.suse.de>
In-Reply-To: <20180307190205.GA14069@wotan.suse.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 07, 2018 at 07:02:05PM +0000, Luis R. Rodriguez wrote:
> On Tue, Mar 06, 2018 at 09:01:10PM +0000, French, Nicholas A. wrote:
> > any reason why PAT can't be enabled for ivtvfb as simply as in the atta=
ched
> > patch?
>
> Prior to your change the OSD buffer was obtained using the itv->dec_mem +=
 oi->video_rbase
> given itv->dec_mem was initialized via [...]
>         itv->dec_mem =3D ioremap_nocache(itv->base_addr + IVTV_DECODER_OF=
FSET - oi->video_buffer_size,
>                                 IVTV_DECODER_SIZE);

Ah, I see. So my proposed ioremap_wc call was only "working" by aliasing th=
e ioremap_nocache()'d mem area and not actually using write combining at al=
l.

> So what I'd do is change the ioremap_nocache()'d size by substracting
> oi->video_buffer_size -- but then you have to ask yourself how you'd get
> that size. If its something you can figure out then great.

Size is easy since its hardcoded, but unfortunately getting the offset of t=
he framebuffer inside the decoders memory to remove from the ioremap_nocach=
e call is a chicken and egg problem: the offset is determined by querying t=
he firmware that has been loaded to the decoder. the firmware itself will b=
e loaded after the ioremap_nocache call at an offset from the address it re=
turns.

So unless there is a io-re-remap to change the caching status of a subset o=
f the decoder's memory once we find out what the framebuffer offset is insi=
de the original iremap_nocache'd area, then its a no go for write combining=
 to the framebuffer with PAT.

On the other hand, it works fine for me with a nocache'd framebuffer. It's =
certainly better for me personally to have a nocache framebuffer with PAT-e=
nabled than the framebuffer completely disabled with PAT-enabled, but I don=
't think I would even propose to rollback the x86 nopat requirement in gene=
ral. Apparently the throngs of people using this super-popular driver featu=
re haven't complained in the last couple years, so maybe its OK for me to j=
ust patch the pat-enabled guard out and deal with a nocache'd framebuffer.

- Nick    =
