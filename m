Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39405 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753304AbeE3Mvh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 08:51:37 -0400
Date: Wed, 30 May 2018 14:51:24 +0200
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
Message-ID: <20180530125124.GB10472@w540>
References: <1527671604-18768-1-git-send-email-jacopo+renesas@jmondi.org>
 <2981239.tGoCg7U0XF@avalon>
 <20180530122343.GA10472@w540>
 <14986389.IZxnRVqLam@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <14986389.IZxnRVqLam@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Laurent,

On Wed, May 30, 2018 at 03:38:01PM +0300, Laurent Pinchart wrote:
> Hi Jacopo,
>
> On Wednesday, 30 May 2018 15:23:43 EEST jacopo mondi wrote:
> > On Wed, May 30, 2018 at 02:52:31PM +0300, Laurent Pinchart wrote:
> > > On Wednesday, 30 May 2018 12:30:49 EEST Geert Uytterhoeven wrote:
> > >> On Wed, May 30, 2018 at 11:13 AM, Jacopo Mondi wrote:
> > >>> The TW9910 PDN gpio (power down) is listed as active high in the chip
> > >>> manual. It turns out it is actually active low as when set to physical
> > >>> level 0 it actually turns the video decoder power off.
> > >>
> > >> So the picture "Typical TW9910 External Circuitry" in the datasheet,
> > >> which ties PDN to GND permanently, is wrong?
> >
> > Also the definition of PDN pin in TW9910 manual, as reported by Laurent made
> > me think the pin had to stay in logical state 1 to have the chip powered
> > down. That's why my initial 'ACTIVE_HIGH' flag. The chip was not
> > recognized, but I thought it was a local problem of the Migo-R board I
> > was using.
> >
> > Then one day I tried inverting the pin active state just to be sure,
> > and it started being fully operational :/
> >
> > > The SH PTT2 line is connected directory to the TW9910 PDN signal, without
> > > any inverter on the board. The PDN signal is clearly documented as
> > > active-high in the TW9910 datasheet. Something is thus weird.
> >
> > I suspect the 'active high' definition in datasheet is different from
> > our understanding. Their 'active' means the chip is operational, which
> > is not what one would expect from a powerdown pin.
> >
> > > Jacopo, is it possible to measure the PDN signal on the board as close as
> > > possible to the TW9910 to see if it works as expected ?
> >
> > Not for me. The board is in Japan and my multimeter doesn't have cables
> > that long, unfortunately.
>
> How about trying that during your next trip to Japan ? :-)

Ok, I'll stop looking for cables 10.000km long on amazon.
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbDp5MAAoJEHI0Bo8WoVY8QHUQAMcVg1vDw1YGbzxaH77Jq4Wi
SJR3p0SOmO8DMrnDLa9Gcp4Bv5DNb7ldiZ9eHszdx8kuzxx4Zj9sowvw9i1c8wZF
kXECE6TTVv0rnUszLi64ueRVHy9MMICOVzIHDIp5YdFhwoWJAhiU/RRbgRSNBw9K
pNtQMqXFVRFLIyOenH3N3AcvqRdK+C1IXjDmdqAwEZ98dp+uS2L5AeyvqnDOS4r0
BwQOp8wzcXoyNv/PI98KaWvqGfRaLVhVMWe7gdwuFVMijGCWMtg2EtteMbr6+zwZ
9eNDx1nvusGcgwOaTfkAaphEMmhjMqNuU7bp2E0UwVF6+0IKfO3sAtUq1nvZhXyr
TsDIki1mQs1h7ZA3AawUnVII92Zb9ekWJaylgARrgIfNdBq77ZnQRwROV3dHgvII
2NxM9WxP/hqu2a5NchlkKQi+fDYBd4OhagvMP6D3lwQ5JL7nlV+Z/U9+3ex8RZJb
xmQYlfc5ThZ3lcMc+0vnYmeOEVm93HLnRWqOINcM7zNhw0Rezb+oYSwsLZg96l30
RC36Kh3LSsERVhfg51b9cdqhQiYi6uVPbqyyGFABBtSE4OfOJi32Q5lg/RbkS/fb
eWoJxcVclJ+r1cZjJQucN7dzSrhzCaE67NQGzd/t08zi2q3m+uKVaYzLd32DiNzk
KOK1HE5D94Q+lz7kwLcx
=ptHo
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
