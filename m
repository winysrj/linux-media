Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-00272701.pphosted.com ([67.231.145.144]:52580 "EHLO
        mx0a-00272701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966464AbeCHFXO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Mar 2018 00:23:14 -0500
From: "French, Nicholas A." <naf@ou.edu>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
CC: "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: ivtv: use arch_phys_wc_add() and require PAT disabled
Date: Thu, 8 Mar 2018 05:23:09 +0000
Message-ID: <DM5PR03MB3035CCBF9718D7E42B35357FD3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
References: <DM5PR03MB3035EE1AFCEE298AFB15AC46D3C60@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180301171936.GU14069@wotan.suse.de>
 <DM5PR03MB303587F12D7E56B951730A76D3D90@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180307190205.GA14069@wotan.suse.de>
 <DM5PR03MB30352350D588A81D2D02BE93D3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180308040601.GQ14069@wotan.suse.de>,<20180308041411.GR14069@wotan.suse.de>
In-Reply-To: <20180308041411.GR14069@wotan.suse.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 08, 2018 at 04:14:11AM +0000, Luis R. Rodriguez wrote:
> On Thu, Mar 08, 2018 at 04:06:01AM +0000, Luis R. Rodriguez wrote:
>  > On Thu, Mar 08, 2018 at 03:16:29AM +0000, French, Nicholas A. wrote:
> > >=20
>  > > Ah, I see. So my proposed ioremap_wc call was only "working" by alia=
sing the
>  > > ioremap_nocache()'d mem area and not actually using write combining =
at all.
>  >=20
>  > There are some debugging PAT toys out there I think but I haven't play=
ed with
>  > them yet or I forgot how to to confirm or deny this sort of effort, bu=
t
>  > likeley.
>=20
>  In fact come to think of it I believe some neurons are telling me that i=
f
>  two type does not match we'd get an error?

I based my guess on some text i read in "PATting Linux" [1]:
"ioremap interfaces will succeed if there is an existing,
more lenient mapping. Example: If there is an existing
uncached mapping to a physical range, any request for
write-back or write-combine mapping will succeed, but
will eventually map the memory as uncached"

But I will try to get some debugpat going to confirm.

[1] =3D https://www.kernel.org/doc/ols/2008/ols2008v2-pages-135-144.pdf

> > So unless there is a io-re-remap to change the caching status of a subs=
et of
> > the decoder's memory once we find out what the framebuffer offset is in=
side
> > the original iremap_nocache'd area, then its a no go for write combinin=
g to
> > the framebuffer with PAT.
>=20
> No what if the framebuffer driver is just requested as a secondary step
> after firmware loading?

Its a possibility. The decoder firmware gets loaded at the beginning of the=
 decoder
memory range and we know its length, so its possible to ioremap_nocache eno=
ugh=20
room for the firmware only on init and then ioremap the remaining non-firmw=
are
decoder memory areas appropriately after the firmware load succeeds...
=20
> > > On the other hand, it works fine for me with a nocache'd framebuffer.=
 It's
> > > certainly better for me personally to have a nocache framebuffer with
> > > PAT-enabled than the framebuffer completely disabled with PAT-enabled=
, but I
> > > don't think I would even propose to rollback the x86 nopat requiremen=
t in
> > > general. Apparently the throngs of people using this super-popular dr=
iver
> > > feature haven't complained in the last couple years, so maybe its OK =
for me
> > > to just patch the pat-enabled guard out and deal with a nocache'd
> > > framebuffer.
> >=20
> > Nope, best you add a feature to just let you disable wc stuff, to enabl=
e
> > life with PAT.

I'm not sure I understand what you mean.

Perhaps the easy answer is to change the fatal is-pat-enabled check to just=
 a
warning like "you have PAT enabled, so wc is disabled for the framebuffer.=
=20
if you want wc, use the nopat parameter"?

- Nick=
