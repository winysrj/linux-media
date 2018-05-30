Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36749 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbeE3MX5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 08:23:57 -0400
Date: Wed, 30 May 2018 14:23:43 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH] media: arch: sh: migor: Fix TW9910 PDN gpio
Message-ID: <20180530122343.GA10472@w540>
References: <1527671604-18768-1-git-send-email-jacopo+renesas@jmondi.org>
 <CAMuHMdVsV9k0OjFMkQSiKCenxfEHgcZxrMU3a5eXRaCDdeA5-A@mail.gmail.com>
 <2981239.tGoCg7U0XF@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <2981239.tGoCg7U0XF@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Laurent, Geert,

On Wed, May 30, 2018 at 02:52:31PM +0300, Laurent Pinchart wrote:
> Hi Geert,
>
> On Wednesday, 30 May 2018 12:30:49 EEST Geert Uytterhoeven wrote:
> > Hi Jacopo,
> >
> > On Wed, May 30, 2018 at 11:13 AM, Jacopo Mondi wrote:
> > > The TW9910 PDN gpio (power down) is listed as active high in the chip
> > > manual. It turns out it is actually active low as when set to physical
> > > level 0 it actually turns the video decoder power off.
> >
> > So the picture "Typical TW9910 External Circuitry" in the datasheet, which
> > ties PDN to GND permanently, is wrong?

Also the definition of PDN pin in TW9910 manual, as reported by Laurent made me
think the pin had to stay in logical state 1 to have the chip powered
down. That's why my initial 'ACTIVE_HIGH' flag. The chip was not
recognized, but I thought it was a local problem of the Migo-R board I
was using.

Then one day I tried inverting the pin active state just to be sure,
and it started being fully operational :/

>
> The SH PTT2 line is connected directory to the TW9910 PDN signal, without any
> inverter on the board. The PDN signal is clearly documented as active-high in
> the TW9910 datasheet. Something is thus weird.

I suspect the 'active high' definition in datasheet is different from
our understanding. Their 'active' means the chip is operational, which
is not what one would expect from a powerdown pin.

>
> Jacopo, is it possible to measure the PDN signal on the board as close as
> possible to the TW9910 to see if it works as expected ?

Not for me. The board is in Japan and my multimeter doesn't have cables
that long, unfortunately.

Thanks
   j

>
> --
> Regards,
>
> Laurent Pinchart
>
>
>

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbDpfOAAoJEHI0Bo8WoVY8rPUP/2bvaGORFzFtZJnarkpmaM0Z
rMewrP2s9s76zY5/7J5SJqNme/4nwUH36UDtSyWUC6sWsqaNs5jVWi2EYlXFuZE9
kNaxHkBUVwJQtFUTCeMT1ahZxDbfvg4zkPvGAK9t85r2KSz5IemHXcJM4YkeTSdP
lBQTxCPIDKNK1ENj8UZwdeH471v28lpIVrN964RoLiA8WlllqCPJ4NF5fsmxPYsg
RghXeiKxJmxJ2SnR+kMTIk9h9WQ7CL3AaJueceHOvDtgMkNPihacPeIQhUCjPWFc
S5Ywc0wp73++TRbcNGkGexbL8WgOmw7q4TXXt7Q/5VwvJO4y3icvRijGlJAT5s3N
hhFmUFX6xFnMjry8e9rWWAHPPj+JLb9X7cs5wNB4+1GATgk/80hFasRoR2ChGAJq
hXkIYoOgvkjwnoc3jWaDvRUwfNUvPTthQB92N+Av6B0TBj0+qjR/o79hWwX5r4lt
8RCy9o644yQBzqj8OEOAfPVQ1Zeli+yP2hpO7lUuuVeJ+UUVISJ4FWqlM97YbJPo
kGn4NNiRqW5b6tGlHcZrzEOsEtpxDuZOroGKo0Ljfk060NABdWwqY4x1jPkJ9wxh
BvvGedCzQphvGzneqjLWL+VkxAwkAOi20EGc93NuiPrcZxYwCuJoLv35KfWCHS3s
d+U8pVmvkqCDAd2EfaYS
=qJZI
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
