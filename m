Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:58329 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752974AbdK1M1A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 07:27:00 -0500
Date: Tue, 28 Nov 2017 13:26:48 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas van Kleef <thomas@vitsch.nl>
Cc: Giulio Benetti <giulio.benetti@micronovasrl.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [linux-sunxi] Cedrus driver
Message-ID: <20171128122648.akxe7ro2mxmliedw@flea.home>
References: <1511868059-2055094631.224aeb721c@prakkezator.vehosting.nl>
 <5d1cad5b-7d36-71fd-2e23-3bfe05f6e56f@vitsch.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="migqq2gmlyycjxqr"
Content-Disposition: inline
In-Reply-To: <5d1cad5b-7d36-71fd-2e23-3bfe05f6e56f@vitsch.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--migqq2gmlyycjxqr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 28, 2017 at 12:20:59PM +0100, Thomas van Kleef wrote:
> > So, I have been rebasing to 4.14.0 and have the cedrus driver working.
> I have pulled linux-mainline 4.14.0. Then pulled the requests2 branch fro=
m Hans
> Verkuil's media_tree. I have a patch available of the merge between these=
 2
> branches.
> After this I pulled the sunxi-cedrus repository from Florent Revests gith=
ub. I
> believe this one is the same as the ones you are cloning right now.
> I have merged this and have a patch available for this as well.
>=20
> So to summarize:
>  o pulled linux 4.14 from:
>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>  o pulled requests2 from:
>     https://git.linuxtv.org/hverkuil/media_tree.git?h=3Drequests2
>     will be replaced with the work, when it is done, in:
>      https://git.linuxtv.org/hverkuil/media_tree.git?h=3Dctrl-req-v2
>  o pulled linux-sunxi-cedrus from:
>     https://github.com/FlorentRevest/linux-sunxi-cedrus
>=20
>  o merged and made patch between linux4.14 and requests2
>  o merged and made patch with linux-sunxi-cedrus
>  o Verified that the video-engine is decofing mpeg-2 on the Allwinner A20.
>=20
> So maybe if someone is interested in this, I could place the patches some=
where?
> Just let me know.

Please create a pull request on the github repo. The point we set it
up was to share code. Forking repos and so on is kind of pointless.

> It would be nice to be able to play a file, so I would have to prepare our
> custom player and make a patch between the current sunxi-cedrus-drv-video=
 and
> the one on https://github.com/FlorentRevest/sunxi-cedrus-drv-video.
> So I will start with this if there is any interest.
>=20
> Should I be working in sunxi-next I wonder?

I'd rather stick on 4.14. sunxi-next wouldn't bring any benefit, and
we want to provide something that works first, and always merging next
will always distract us from the actual code.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--migqq2gmlyycjxqr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlodVgQACgkQ0rTAlCFN
r3S+tg//YGZujrA+m8QjlfYqDFLFTHKOytwgfvlTUhjIJhlvVMAVF/CCX9/ZikNO
bXQH+IS1u2RhLVHNK7W/Y+IxW3qngFBjAJX72OTx+N4m4/x7Q6RRQiOtTs2Ps2Ej
MMe7873RhkrIo/Ki+BEJJyvh53KB8jEF3DF8fdvx3a8SGfqsrfGlCGQmO/MGSxzM
qq02/c6kiqMaaJTRR5aC763gDt7FGHijX/ofNK1POdxNNcrPfkjb6eopj7VwSEpS
aGALqoYGZWOZWw+6SCJEZQW5Cr24ltnXRfj9a6R7HUfGGhpEwnv5wJhIT4a9sYW6
qLhvGu5JrULLwJg725QH0dhyjH+JSut9x1s57UgVbvi0jM3o+yJKmN1n20qdUII4
DqEFahC0HK6cnJdOHE9HXPMqQWCp3CjVfutK99wmDmgw1UGcGNs9BYIEe6BlpfCh
7gT2udeKAD01cEJsr8asr7yGWnIzOb2jGRlXvCRo4t2iYIyi/Hb5OysCkDT85Ubj
/TNU4J7mp/grhbatytLDk/qSA+bdSrEZc5HHBk8fO2sAVcMROQxlXKn/C6klD4ZI
9qnpniWEAEH0yDdBUhd+U/wq6yGW3D5W+qlnDDvQ9qbKvr3CQgmKt4sdVY9yaeIi
VVkZdF/vy6WIFSRKonvBJIuP2LeGWDDIUpVcnrHVq4kh/IngPkU=
=705I
-----END PGP SIGNATURE-----

--migqq2gmlyycjxqr--
