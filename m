Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51442 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754119AbdL1UY4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 15:24:56 -0500
Date: Thu, 28 Dec 2017 21:24:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        clayton@craftyguy.net, martijn@brixit.nl,
        Filip =?utf-8?Q?Matijevi=C4=87?= <filip.matijevic.pz@gmail.com>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: Re: v4.15: camera problems on n900
Message-ID: <20171228202453.GA20142@amd>
References: <20171227210543.GA19719@amd>
 <20171227211718.favif66afztygfje@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20171227211718.favif66afztygfje@kekkonen.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-12-27 23:17:19, Sakari Ailus wrote:
> On Wed, Dec 27, 2017 at 10:05:43PM +0100, Pavel Machek wrote:
> > Hi!
> >=20
> > In v4.14, back camera on N900 works. On v4.15-rc1.. it works for few
> > seconds, but then I get repeated oopses.
> >=20
> > On v4.15-rc0.5 (commit ed30b147e1f6e396e70a52dbb6c7d66befedd786),
> > camera does not start.	 =20
> >=20
> > Any ideas what might be wrong there?
>=20
> What kind of oopses do you get?

Hmm. bisect pointed to commit that can't be responsible.... Ideas
welcome.

										Pavel

# bad: [fb3f95c11904adf26c2bd86fe1b1613c921710b5] Config for v4.15-rc0.5
# good: [c213cf57c2f15ee226c14dd7157caa334c3ef7c8] Make config similar to n=
950 case. Still works on n900.
git bisect start 'mini-v4.15' 'mini-v4.14'
# good: [06410bdec961a55e78e01d4fda199f709a84e17f] Merge /data/l/clean-cg i=
nto mini-v4.14
git bisect good 06410bdec961a55e78e01d4fda199f709a84e17f
# bad: [fc35c1966e1372a21a88f6655279361e2f92713f] Merge tag 'clk-for-linus'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux
git bisect bad fc35c1966e1372a21a88f6655279361e2f92713f
# good: [bebc6082da0a9f5d47a1ea2edc099bf671058bd4] Linux 4.14
git bisect good bebc6082da0a9f5d47a1ea2edc099bf671058bd4
# good: [5bbcc0f595fadb4cac0eddc4401035ec0bd95b09] Merge git://git.kernel.o=
rg/pub/scm/linux/kernel/git/davem/net-next
git bisect good 5bbcc0f595fadb4cac0eddc4401035ec0bd95b09
# bad: [5b0e2cb020085efe202123162502e0b551e49a0e] Merge tag 'powerpc-4.15-1=
' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux
git bisect bad 5b0e2cb020085efe202123162502e0b551e49a0e
# good: [f150891fd9878ef0d9197c4e8451ce67c3bdd014] Merge tag 'exynos-drm-ne=
xt-for-v4.15' of git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-=
exynos into drm-next
git bisect good f150891fd9878ef0d9197c4e8451ce67c3bdd014
# good: [93ea0eb7d77afab34657715630d692a78b8cea6a] Merge tag 'leaks-4.15-rc=
1' of git://github.com/tcharding/linux
git bisect good 93ea0eb7d77afab34657715630d692a78b8cea6a
# bad: [2bf16b7a73caf3435f782e4170cfe563675e10f9] Merge tag 'char-misc-4.15=
-rc1' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
git bisect bad 2bf16b7a73caf3435f782e4170cfe563675e10f9
# good: [ef674997e49760137ca9a90aac41a9922ac399b2] media: staging: atomisp:=
 Convert timers to use timer_setup()
git bisect good ef674997e49760137ca9a90aac41a9922ac399b2
# good: [b1cb7372fa822af6c06c8045963571d13ad6348b] dvb_frontend: don't use-=
after-free the frontend struct
git bisect good b1cb7372fa822af6c06c8045963571d13ad6348b
# good: [c9fe0f8fa4136c2451dcc012e48fbf4470d6b592] hyper-v: trace vmbus_on_=
msg_dpc()
git bisect good c9fe0f8fa4136c2451dcc012e48fbf4470d6b592
# good: [e20d2b291ba2f5441fd4aacd746c21e60d48b559] nvmem: imx-ocotp: Pass p=
arameters via a struct
git bisect good e20d2b291ba2f5441fd4aacd746c21e60d48b559
# good: [0ff26c662d5f3b26674d5205c8899d901f766acb] driver core: Fix device =
link deferred probe
git bisect good 0ff26c662d5f3b26674d5205c8899d901f766acb
# good: [d4035a8c1ff7288af9e47d6d05384f14c9308ea1] MAINTAINERS: Update VME =
subsystem tree.
git bisect good d4035a8c1ff7288af9e47d6d05384f14c9308ea1
# bad: [e60e1ee60630cafef5e430c2ae364877e061d980] Merge tag 'drm-for-v4.15'=
 of git://people.freedesktop.org/~airlied/linux
git bisect bad e60e1ee60630cafef5e430c2ae364877e061d980
# bad: [5d352e69c60e54b5f04d6e337a1d2bf0dbf3d94a] Merge tag 'media/v4.15-1'=
 of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
git bisect bad 5d352e69c60e54b5f04d6e337a1d2bf0dbf3d94a
# good: [f2ecc3d0787e05d9145722feed01d4a11ab6bec1] Merge tag 'staging-4.15-=
rc1' into v4l_for_linus
git bisect good f2ecc3d0787e05d9145722feed01d4a11ab6bec1
# first bad commit: [5d352e69c60e54b5f04d6e337a1d2bf0dbf3d94a] Merge tag 'm=
edia/v4.15-1' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/mchehab=
/linux-media


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlpFUxUACgkQMOfwapXb+vKb+QCeOT25hf6CcbXQ29FyZX57Ho76
VI4An2YNEyTVN4iSi7xYm06CR36zMfPW
=eDo0
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
