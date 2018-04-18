Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:53805 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbeDRMMN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 08:12:13 -0400
Date: Wed, 18 Apr 2018 14:12:04 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 01/10] media: ov772x: allow i2c controllers without
 I2C_FUNC_PROTOCOL_MANGLING
Message-ID: <20180418121204.GE20486@w540>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-2-git-send-email-akinobu.mita@gmail.com>
 <20180418100549.GA17088@w540>
 <20180418104154.lyqj4qipa3d44jb4@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ryJZkp9/svQ58syV"
Content-Disposition: inline
In-Reply-To: <20180418104154.lyqj4qipa3d44jb4@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ryJZkp9/svQ58syV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Wed, Apr 18, 2018 at 01:41:54PM +0300, Sakari Ailus wrote:
> On Wed, Apr 18, 2018 at 12:05:49PM +0200, jacopo mondi wrote:
> > Hi Akinobu,
> >
> > On Mon, Apr 16, 2018 at 11:51:42AM +0900, Akinobu Mita wrote:
> > > The ov772x driver only works when the i2c controller have
> > > I2C_FUNC_PROTOCOL_MANGLING.  However, many i2c controller drivers don=
't
> > > support it.
> > >
> > > The reason that the ov772x requires I2C_FUNC_PROTOCOL_MANGLING is that
> > > it doesn't support repeated starts.
> > >
> > > This changes the reading ov772x register method so that it doesn't
> > > require I2C_FUNC_PROTOCOL_MANGLING by calling two separated i2c messa=
ges.
> > >
> > > Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > ---
> > > * v2
> > > - Replace the implementation of ov772x_read() instead of adding an
> > >   alternative method
> >
> > I now wonder if my initial reply to this patch was wrong, and where
> > possible we should try to use smbus operations...
> >
> > From Documentation/i2c/smbus-protocol
> > "If you write a driver for some I2C device, please try to use the SMBus
> > commands if at all possible... " and that's because, according to
> > documentation, most I2c adapters support smbus protocol but may not
> > support the full i2c command set.
> >
> > The fact this driver then restricts the supported adapters to the ones
> > that support protocol mangling makes me think your change is fine,
> > but as it often happens, I would scale this to more knowledgable
> > people...
>
> Do you actually need to use this on SMBus adapters? A lot of sensor drive=
rs
> just use I=C2=B2C; if SMBus support is really needed it can be always add=
ed back
> later on...

That was actually my question, sorry for not being clear.

As the documentation says that SMBus has to be preferred when
possible, I was wondering if ditching it completely in favour of plain
I2c was wrong or not... I assume from your answer it is fine.

>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi

--ryJZkp9/svQ58syV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa1zYUAAoJEHI0Bo8WoVY8n2AP/16QmYlwEWjp5F5aKXSSzurN
GhG1+mZP000rGB8CLkE4xkdXRGXV59bQ0lk5PlJDuTs+kPwvf4Cm4mPgP7ZejcI1
eE/Y9Q+2GMKlFauyH3uxM0RiRjTlG95J6hwTQfW2pfpA6cTfKu+lHcuP5gIR6wmL
jmrw5rGu3LiHNW6kJ2DbNknNX64NRZRbiLA0UY9h5K5Aoq3C9k/uHW+Bf1IxXPk7
j9cTiLl2xIUh2eqdUlbvivyk2HuxMA/tOYJTS0kzVfQS3wv2oSV5ipD1QaaATsdx
PryemyQ5lR/IMaFvhcAtetWTCEJukv5NSi1IMrp2ltj3kWflyoT+Hg+rdtESBky0
0WPBrgcmoOOkXqsxoAihb6QMNRUqOFWNJRwzAFmAohZ9314AWJu4uwFZq1oAkRkt
iT/PKrzTfaGD8PPG5QKfoIK6tC471olzU+8pBo8XlvHmnVxpgO+zzwj38YYGV6zj
JlXwzm0z5v3yH9QqObn7t+fN6B1XKCVrrqGEok8KCY9TXq2Nf48ZPUqRJ3BOLkTF
KyaqPSIGUeb4AIablhbe5WSrWDTaBCMRUkl+oR9ZsQ67VQdXmSeQTI6Sf4TERz+b
lE6v2JLykfayaZasxkTUMHJZqAITbqZ2UIrJ/Hl2a17sYFvoGsIcTD2GXUhy2qo/
HfDb1cGuziLtBg+BXrbt
=uqTw
-----END PGP SIGNATURE-----

--ryJZkp9/svQ58syV--
