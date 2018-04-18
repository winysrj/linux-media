Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:41789 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753775AbeDRMNW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 08:13:22 -0400
Date: Wed, 18 Apr 2018 14:13:17 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 04/10] media: ov772x: add media controller support
Message-ID: <20180418121317.GF20486@w540>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-5-git-send-email-akinobu.mita@gmail.com>
 <20180418112814.GA20486@w540>
 <20180418115816.4awh2xejtng6q2ui@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Pql/uPZNXIm1JCle"
Content-Disposition: inline
In-Reply-To: <20180418115816.4awh2xejtng6q2ui@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Pql/uPZNXIm1JCle
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,

On Wed, Apr 18, 2018 at 02:58:16PM +0300, Sakari Ailus wrote:
> On Wed, Apr 18, 2018 at 01:28:14PM +0200, jacopo mondi wrote:
> > Hi Akinobu,
> >
> > On Mon, Apr 16, 2018 at 11:51:45AM +0900, Akinobu Mita wrote:
> > > Create a source pad and set the media controller type to the sensor.
> > >
> > > Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >
> > Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
> >
> > Not strictly on this patch, but I'm a bit confused on the difference
> > between CONFIG_MEDIA_CONTROLLER and CONFIG_VIDEO_V4L2_SUBDEV_API...
> > Doesn't media controller support mandate implementing subdev APIs as
> > well?
>
> The subdev uAPI depends on MC.

Again, sorry for not being clear. Can an mc-compliant device not
implement sudev uAPIs ?

Thanks
  j

>
> --
> Sakari Ailus
> sakari.ailus@linux.intel.com

--Pql/uPZNXIm1JCle
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa1zZdAAoJEHI0Bo8WoVY8ci8P/i1aadpxqCIHA66YROkZXpN+
HhFKKLq9euHnZXukna9LwagzlNL1kH2LyDMZWf6JNQ7ZXXVQ/mTrjVLbyo2rwmfi
gVgDN+QPWWSHpZEBOw0NJPFgZKOZRfFgJOpSylPkF0A31TBRVjZi9Qcjht2ift74
NT4QgXjbKhHVmp53CNU+4B6dhyXiRYNzpJChOM1Iir6zjcinynwTfk8SE7VwNjcp
5eq6ImZEOgBRS1Q6Uf3fsKzrJ1XhyNd1Izc5e1uBoXfeDrgIQ9EXhNrz1a/Yx1vO
N0uDQwA224sAW9IKZFoCSKkzMkfx/QeVZPa2mPQxZjjWke/43tzJuMCg1eXZR7Qm
/GrfrvXC/ilnvYNzLuyI69fuL7IOpUZfyCD9YjcO0Au4u96hfr5eL1LO6uefLY7V
Dphgjd8NvGY0eFPNFYezNsq0CyVd3/J4XehOiQBWCK4IDigGbqmgQaA4k5Xw8AJJ
XMy5ctt60n9Bmcr3WHcN7nn9mCzihopNAgvbLqHA2AoQqaK0HQowW3fbj2GkVZMu
iPTZPtlxfrGQ2rtFsaPlgwLDo5tHsrCP50VSqRUSWEswAAFoZxF7cErBcoDxsxSZ
UcYbGKorCAuzWQ0t1v5G7JQ3K0hBW8uDXmqqOhFbaz15Jsov4A8SD/xZz3wmOCiM
UoKOTba0xibwzRvxu+hG
=uoKI
-----END PGP SIGNATURE-----

--Pql/uPZNXIm1JCle--
