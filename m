Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:41219 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbeGTIZ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jul 2018 04:25:27 -0400
Date: Fri, 20 Jul 2018 09:38:20 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: sakari.ailus@iki.fi
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v4 2/3] media: ov772x: use SCCB regmap
Message-ID: <20180720073820.GF6784@w540>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
 <20180719074736.GA6784@w540>
 <20180719084208.4zdwt4vzcop4hve7@ninjato>
 <2173334.CLADOdgFxd@avalon>
 <20180719131019.2kolodvc4r5ewqic@lanttu.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JSkcQAAxhB1h8DcT"
Content-Disposition: inline
In-Reply-To: <20180719131019.2kolodvc4r5ewqic@lanttu.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, Jul 19, 2018 at 04:10:20PM +0300, sakari.ailus@iki.fi wrote:
> On Thu, Jul 19, 2018 at 03:14:06PM +0300, Laurent Pinchart wrote:
> > On Thursday, 19 July 2018 11:42:08 EEST Wolfram Sang wrote:
> > > > > -static int ov772x_mask_set(struct i2c_client *client, u8  comman=
d, u8
> > > > > mask,
> > > > > -			   u8  set)
> > > > > -{
> > > > > -	s32 val =3D ov772x_read(client, command);
> > > > > -
> > > > > -	if (val < 0)
> > > > > -		return val;
> > > > > -
> > > > > -	val &=3D ~mask;
> > > > > -	val |=3D set & mask;
> > > > > -
> > > > > -	return ov772x_write(client, command, val);
> > > > > -}
> > > > > -
> > > >
> > > > If I were you I would have kept these functions and wrapped the reg=
map
> > > > operations there. This is not an issue though if you prefer it this
> > > > way :)
> > >
> > > I have suggested this way. It is not a show stopper issue, but I still
> > > like this version better.
> >
> > Wrapping the regmap functions minimizes the diff and makes it easier to
> > backport the driver.

This was my reasoning too, but I'm happy with the current
implementation. Thanks Akinobu for handling this!

>
> May be, but using the regmap functions directly makes the driver cleaner.
> Most drivers have some kind of wrappers around the I=C2=B2C framework (or
> regmap) functions; this one is one of the few to get rid of them.
>
> The two could be done in a separate patch, too, albeit I think the current
> one seems fine as such.
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi

--JSkcQAAxhB1h8DcT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbUZFsAAoJEHI0Bo8WoVY8xYUP/R6e5qUtBgY0rxxzzGt6l+Gh
+ANvSsmeZX0cAIzdTjTdj2DPOlDMv0enciKjO0enwDZTAXiyPU1Wn8n6XUext7s+
I7o2hsoMf1w1NIyOPAXlISvnZ0Dc8iFeNA3E0M/rck/cz/d3tUjc/7ZWX0oC4ZeZ
stOKf0PRa/vjv3jQjqIEK6QnA41EP8VzKIiSh9+HMWoasiiN0FiZsPwF51nwgzsR
pi/T4gS1NdYSBeN3JkmsCDcM/wjk81FuuvHLVrtj6U4zHUYwqZ+MWiC6l1AjpdCe
Cx6n/To52os5R+XPJstZxUoZwDEeAYHGq0sHAZBoPYsp442t8sixH5AO9rE/sbLc
DvM5VYksoiBkem4k+M6oTxMGXrIdtXRlSUWRDmpCavfJRLLtWa91FRme7l6iPJKo
m6y1YxbpPkGhvj+I3lPXyuNn3jwLGgLOj/BScGMyBnG2vCzvjLnTi4bBWRwo+JQV
aDQGXiyFpM5UqwVWIIuE8g+60ItT/9ap96rixrVfDsLN2yyvjUNAUi5nfJ207Ocj
9WyIkrzgKDxUn/9/R/sPUpxDRyQji2OlyCyZ3wKAyNe1EWmfl7rZkuaovpvQ5oBu
LtRibGdJpVxSglX8k7fmrDfO5frFzyciZeQNr8Ny/p88ttKFZbGb5ToeWFF1WDuP
iPnhbP6hx1VJv7hZ9XG4
=qXJo
-----END PGP SIGNATURE-----

--JSkcQAAxhB1h8DcT--
