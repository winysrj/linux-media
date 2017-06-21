Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36682 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdFUU5R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 16:57:17 -0400
Received: by mail-wr0-f193.google.com with SMTP id 77so29805164wrb.3
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 13:57:16 -0700 (PDT)
Date: Wed, 21 Jun 2017 22:57:12 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        rjkm@metzlerbros.de
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, crope@iki.fi, "Jasmin J." <jasmin@anw.at>
Subject: Re: DD support improvements (was: Re: [PATCH v3 00/13]
 stv0367/ddbridge: support CTv6/FlexCT hardware)
Message-ID: <20170621225712.426d3a17@audiostation.wuest.de>
In-Reply-To: <20170620161043.1e6a1364@vento.lan>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
        <20170412212327.5b75be19@macbox>
        <20170507174212.2e45ab71@audiostation.wuest.de>
        <20170528234537.3bed2dde@macbox>
        <20170619221821.022fc473@macbox>
        <20170620093645.6f72fd1a@vento.lan>
        <20170620204121.4cff42d1@macbox>
        <20170620161043.1e6a1364@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Tue, 20 Jun 2017 16:10:43 -0300
schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Tue, 20 Jun 2017 20:41:21 +0200
> Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
>=20
> > Not sure about Thomas, but I know that Jasmin doesn't own and/ore uses
> > such cards. However, for upcoming patches, I'll try to drag people to
> > the list for some comments, thanks for the pointer. =20
>=20
> Yeah, if you can drag people to help reviewing/testing (and even
> coding), that would be really cool, as we'll be able to better
> do our reviews.

For the upcoming bigger changes around ddbridge and new demod/tuner drivers=
, I'll try to do so. Though this would mostly be for Tested-By's, but still.


> > - Maybe for 4.14: Support for the CineS2 V7 and FlexV4 line of
> >   cards/modules. This mainly involves a new demod driver (stv0910) and
> >   a new tuner driver (stv6111). Permissions for this are cleared with
> >   Ralph already. The glue code needed in ddbridge is rather easy, and
> >   as some ground work (mostly the MachXO2 support from the 2841 series)
> >   is now in, the changes are quite small. Patches are ready so far but
> >   need more cleanup (checkpatch fixes, camel case and such things). =20
>=20
> Please try to sync it with Ralph, in a way that his code won't
> diverge from the upstream one, as this will make easier for both
> sides to keep the Kernel in track with driver improvements.

This is not going to work. DD (Ralph and Manfred Voelkel) sort of maintain =
a shared code base between their Windows driver and the Linux kernel driver=
 sources. While they didn't explicitely stated this, this can be noticed by=
 the remarks and commented code in their OSS code, and the commit messages =
in their dddvb GIT (e.g. "sync with windows driver"). I've already cleaned =
up a lot of this (I believe no one wants to see such stuff in the linux ker=
nel tree). If we're additionally going to replace all things camel case, wi=
th some more cleaning and maybe code shuffling after like a V4 patch series=
, those two sources are out of sync in a way that no automatic sync by appl=
ying patches will be possible anymore. So, pushing from vendor's upstream t=
o the kernel seems to be the only option, and in fact, if the whole driver/=
package stack completely lives in the kernel sources, maybe DD even decide =
to directly commit upstream (kernel) again.

Putting Ralph into "To:", really like to hear an opinion from him on this w=
hole subject.

> > - The "big" ddbridge update. I'm thinking of two ways to do this:
> >=20
> >   * Do this in one commit, being a huge code bump, bringing ddbridge to
> >     version 0.9.28 (as per vendor versioning). This is mostly ready and
> >     successful in use by many testers and in my Gentoo ddbridge kernel
> >     sources overlay. Should get some more cleanups though (still some
> >     GTL link bits left which are not needed), and all fixes which went
> >     to the in-kernel driver like __user annotations need to be put back
> >     in. Big drawback: A mess to review.
> >=20
> >   * Try to tear apart most if not all upstream vendor driver tar
> >     archives and recreate individual patches out of this. For
> >     reference, we need to go from what is in the kernel which is
> >     something inbetween v0.5 and v0.8 up to and including version
> >     0.9.29. I'm currently working on this from time to time, and I can
> >     assure you that this is an extremely tedious and unthankful thing
> >     to do (currently nearly done with 0.9.9b, approx. 20 releases
> >     left). This might be better to review, but this will also result in
> >     something like 100-200 commits, without guarantee of having
> >     everything correct. =20
>=20
> The second approach is preferred, but, as you said, it is a very
> complex task, and has bad effect that, at the time you're updating
> it, the DD driver will be changed.

I'd welcome it if we could put approach two somewhat aside for at least the=
 reasons outlined :)

> The first approach will require some things to work, though:
>=20
> - the "legacy" driver should be kept at the Kernel for some time,
>   in order to provide a "fall back" for those that find issues with
>   the new version;

=46rom what can be gathered from forums and such, the current ("upstream") ve=
rsion doesn't show some (if any) issues. Though I'm aware that MSI interrup=
ts are still an issue on a lot of hardware platforms, but disabling that op=
tion by default in the driver and toggling this via a Kconfig option works =
around this, since w/o MSI things work like a charm. Thats a problem that n=
eeds to be resolved by the vendor though.

Still, I understand you that you'd like to keep this around. Not exactly su=
re though how to achieve this in detail. Renaming media/pci/ddbridge to e.g=
. media/pci/ddbridge-legacy is the easy part, but if we don't want to mix u=
p commits, one point in the commit history remains where there's a driver n=
amed ddbridge-legacy and no ddbridge (driver missing) exists (commit: "rena=
me ddbridge to ddbridge-legacy", commit+1: "import updated and cleaned ddbr=
idge driver from vendor package"). Also, it must be made sure that both dri=
vers at best won't be built at the same time due to overlapping PCI IDs, po=
ssibly leading to additional issues on users installs.

> - you'll still need to patch DD tree, as I'm pretty sure there are
>   changes on the upstream driver that will need to be ported there;

The same as for the stv0910 code applies here, in addition that it's not su=
re if DD even wants this. DD even has KERNEL_VERSION_CODE ifdefs in some pl=
aces. And - most importantly - they carry around an old version of the DVB =
core API (from what it looks, around linux-3.10, not exactly sure) which ev=
en was modified by some IOCTLs, vars, defines and the netstream and modulat=
or support. I managed to remove all core API change deps from everything tu=
ner related (and thats the reason things work in harmony with and in curren=
t kernels), but getting all this over to DD or even merge things from DD in=
to the media subsystem will get "interesting".

> - This is a very painful thing to do. While I might accept do it
>   once, I won't accept repeat it again a second time. So, if we do
>   that, we need to agree with you and Ralph that any change at the
>   DD tree will be submitted ASAP upstream, in order to avoid future
>   gaps.

Well, I can offer you: For the new STV0910, STV6111 and MXL5XX, as well as =
ddbridge itself when it's done, I can take over maintainership, in a way th=
at when dddvb upstream changes emerge, I'll take care of submitting (releva=
nt) things to linux-media quickly (as my work and private time schedule all=
ows). However, since I'm not too far into all things kernel and DVB core ye=
t, I would need help on other things from others.

This task is definitely doable when we get to a point that the current brid=
ge code is in the kernel tree. DD recently started to publish driver change=
s in small increments, which - if you know a few things about the internals=
 and know what differs in both versions - is a rather easy task.

Yet, to achieve this, I'd really propose doing the "big bang" once and do t=
he final cleanup during that process (and yes, the cleanup IS neccessary!).

> > If you like, I'm happy and very open to discuss this further with you! =
=20
>=20
> Feel free to do it ;)

On it :)

> > BTW, you might have seen this - I posted four more patches which'll add
> > DVBv5 signal stats to the DDB part of the stv0367 code. If you don't
> > mind doing a quick inbetween-review of this, this would be nice if this
> > could go in alongside the DD support (so, for 4.13 aswell). =20
>=20
> I intend to do more patch reviews this week. I'll try to take a look
> on them.

Series already posted as v2 with (most of) the remarks from Antti addressed.

Best regards,
Daniel Scheller
--=20
https://github.com/herrnst
