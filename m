Return-path: <linux-media-owner@vger.kernel.org>
Received: from t3rror.net ([213.133.102.34]:59083 "EHLO mail.t3rror.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143AbZGMPMa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 11:12:30 -0400
From: Boris Cuber <me@boris64.net>
Reply-To: me@boris64.net
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.31] V4L/DVB fixes
Date: Mon, 13 Jul 2009 17:12:21 +0200
References: <200907121550.36679.me@boris64.net> <200907131413.50826.zzam@gentoo.org> <200907131529.25786.cyber.bogh@gmx.de>
In-Reply-To: <200907131529.25786.cyber.bogh@gmx.de>
Cc: "'cyber.bogh'" <cyber.bogh@gmx.de>,
	"'Matthias Schwarzott'" <zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1485090.HuaTPL2USL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200907131712.26909.me@boris64.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1485090.HuaTPL2USL
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Am Montag, 13. Juli 2009 schrieben Sie:
> Am Montag 13 Juli 2009 14:13:50 schrieben Sie:
> > On Sonntag, 12. Juli 2009, Boris Cuber wrote:
> > > Hi kernel folks!
> > >
> > > Problem:
> > > Since kernel-2.6.31-rc* my dvb-s adapter (Technisat SkyStar2 DVB card)
> > > refuses to work (worked fine in every kernel up to 2.6.30.1).
> > > So anything pulled into the new kernel seems to have broken
> > > something (at least for me :/).
> > >
> > > I opened a detailed bug report here:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=3D13709
> > > Please let me know if i can help in finding a solution
> > > or testing a patch /whatever.
> >
> > This looks like it is related to this patch:
> >
> > commit d66b94b4aa2f40e134f8c07c58ae74ef3d523ee0
> > Author: Patrick Boettcher <pb@linuxtv.org>
> > Date:   Wed May 20 05:08:26 2009 -0300
> >
> >     V4L/DVB (11829): Rewrote frontend-attach mechanism to gain noise-le=
ss
> > deactivation of submodules
> >
> >     This patch is reorganizing the frontend-attach mechanism in order to
> >     gain noise-less (superflous prints) deactivation of submodules.
> >
> >     Credits go to Uwe Bugla for helping to clean and test the code.
> >
> >     Signed-off-by: Uwe Bugla <uwe.bugla@gmx.de>
> >     Signed-off-by: Patrick Boettcher <pb@linuxtv.org>
> >     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >
> >
> >
> > All frontend-attach related code is wrapped by ifdefs like this:
> > #if defined(CONFIG_DVB_MT312_MODULE) ||
> > defined(CONFIG_DVB_STV0299_MODULE) <CODE>
> > #endif
> >
> > So this code will only be compiled if one of the two drivers is compiled
> > as a module, having them compiled in will omit this code.

Hi Matthias

thank you for your help. I manually edited=20
those #ifdefs to temporary get around my problem.
My dvb adapter is working again ;)


>
> Yes. And that's exactly the way things were planned and should also stay,
> even if there exist a thousands of "Boris64" who do not have the slightest
> idea about what kernel compilation is or could be.....

Well, i always thought compiling your own kernel is about choice.
And _my_ choice always was:
I don't want use modules, because booting a monolithic=20
kernel on my computer is slightly faster.


>
> No matter if we're talking about the main module, the frontend, the backe=
nd
> or whatever other part of not only a DVB driver:
> None of them is permanently needed while the machine is running. So kmod
> can kick them out of the memory if they aren't needed, if they were
> compiled as module.
>
> But if you compile them into the kernel you are wasting system resources
> because the main kernel becomes too big (I'd call that a "Windoze-effect"=
).
>
> So compiling those drivers a module is gold, and any other choice is simp=
ly
> nonsense.
>
> > Trent Piepho seems to already have a patch for this, but it is not yet
> > merged into the kernel.
>
> May Trent Piepho do whatever he likes. I do not think that any further
> patch is necessary for that driver section.
>
> It would rather be necessary for some quirky users to enlarge their limit=
ed
> brain and understand what kernel compilation means and is here for.
>
> > Regards
> > Matthias
>
> CU
>
> cyber.bogh
>
> P. S.: The other part that really makes me utmost angry about the "Boris'=
s"
> in that world:
>
> If you're doing really hard for months to enhance things, and you urgently
> need testers to help and invest brain those Boris's aren't visible at all.
> Nowhere!

Those "Boris's" can't remember that anyone ever asked'em to help.
And "they" didn't subscribe to this list until "their" dvb card(s) didn't
work anymore for some reason.


>
> Once things are done they come back and all they have got to do then is to
> complain for stupid nonsense...
>
> How did Lou Reed say?
> "Stick a fork in their ass, turn it over and they're done!"
>

Have a nice day,
regards, Boris

--nextPart1485090.HuaTPL2USL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJKW07aAAoJEONrv02ePEYN7IIP/2vXM8Qjdjnn7K1+tFJsA0W0
Tdl2dqxFQf6eBlIO3Hnc3Rl2oGLyW5ONufJkm/Td4AtAAUtccoUFyt49lgjA81H9
kwzUY6iPVfn1E4c8ZAiI+MDwBvtjncAjXGHqZe6+Ie2Ep5eQEXtZFnRcaU+6UNOZ
c0/O0Rniq0tU31lXXJYyUcGqq0pkN+0YfOAcKX6lKvzvWg/SS99cZfBMQueM3U1A
C9qappzrcREevSlTf+7DqqCGqtgW70McgjQfj5dGDCiAuaRSpxfDYckiho1w9CGc
kof8NrQfjrrEsZJkMrxAUXoXFkzQoadx7kj25iHyfszFs4nO+Maj5rZwdt0bkxN5
/aYT/ZibAFDtLE0INDpig+u7awAoroe+0JlivwCEIe8kZMqUlw2Jc45ZvfCxy1Wr
fPK/fY7b1jmjnKEIwKLCFX/SAZEHo7cEXl/8S/IMTR45CUxo1wNj6Ft/9vRqbJkH
2guamvzaE/OsUct33I53Y+0iApDgEqXV9bYIzbvl+rIFKFxyhckQq7eFe2/YT2SM
ib9ztYYE4Z+fU81zJI3srB40IOmE8+vhvJVWniHFhKEZLtADWjCxpec6zFu//Gfn
IqVwQT6s7T6Ed1nm452ZrCZZQwaMNVeyiajINGDYhfC72ueiIWfvxxsKf15Ua3u9
winhxXnnhudBu/M8KlQT
=+Fw6
-----END PGP SIGNATURE-----

--nextPart1485090.HuaTPL2USL--
