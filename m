Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:52839 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752624AbeDRNew (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 09:34:52 -0400
Date: Wed, 18 Apr 2018 15:34:47 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 10/10] media: ov772x: avoid accessing registers under
 power saving mode
Message-ID: <20180418133447.GD3999@w540>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-11-git-send-email-akinobu.mita@gmail.com>
 <20180418125536.GB3999@w540>
 <20180418131702.rgxtqct6htzt3rnq@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="h56sxpGKRmy85csR"
Content-Disposition: inline
In-Reply-To: <20180418131702.rgxtqct6htzt3rnq@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--h56sxpGKRmy85csR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,

On Wed, Apr 18, 2018 at 04:17:02PM +0300, Sakari Ailus wrote:
> On Wed, Apr 18, 2018 at 02:55:36PM +0200, jacopo mondi wrote:
> > Hi Akinobu,
> >
> > On Mon, Apr 16, 2018 at 11:51:51AM +0900, Akinobu Mita wrote:
> > > The set_fmt() in subdev pad ops, the s_ctrl() for subdev control handler,
> > > and the s_frame_interval() in subdev video ops could be called when the
> > > device is under power saving mode.  These callbacks for ov772x driver
> > > cause updating H/W registers that will fail under power saving mode.
> > >
> >
> > I might be wrong, but if the sensor is powered off, you should not
> > receive any subdev_pad_ops function call if sensor is powered off.
>
> This happens (now that the driver supports sub-device uAPI) if the user
> opens a sub-device node but the main driver has not powered the sensor on.

Indeed. Sorry for the noise. Could you please check my reply to [08/10] as well?

Thanks
   j

>
> --
> Sakari Ailus
> sakari.ailus@linux.intel.com

--h56sxpGKRmy85csR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa10l3AAoJEHI0Bo8WoVY8quQQAIzRq0JRlk2/VwIbPgVCe4bF
rHKAc/8kWxD9EbxJW4cU6GCjDohaj2CkeolmwBMDVg4nvo/Iy52MUo1v8WVAt78F
g8KbB/V+rbybFA1pp999GQtQhpPEXUC4BAId5DoOWkAzbnKXV8DlF1NKpPgij0CH
VlkTlZPHGcgGib8Cs1jPS3r7rHAaFb6Yx6jHR2gthF3tKHDKft9t7lQrqYH79G+h
okomFbP+pLaYbMNgpdlw7l7webM0LoxQdVRA04WgCfd3MjP3CZNUP9WmJNkrbckN
554BHiPGmtL8wOSLcVj8ImRdWV1OcX5VbIbXDfZCj41+yOS21f58PLM8jKm03ClG
9keSkU0cGRgmezcNIQx6yaDSnAhOsoMdzmxH6UUiyK0g0LsRdP4/sSdNeQIoERJC
eKP10LzfGrOm2qZRIQbjt6yipvD9/XWgcoML2JqgweCGbmY3ljgpoyXHoAuoZknG
5UF8w+ugQH2XWbMpcZX8o/UlticvSy7T6EMWueEvXQL8pmWZ4+hPebcUoCT0GNeY
4J0r9OHvJ1wl+pcyJLnmA7Bt4fQfC3iNN3Q2DwWRGymR3IRfVXFBTuBXQUDe+3R6
teIDKuVPqZmQHhaH3Nb/oPkP247yUFRWy5wzi5M2rLwID+Jl5F1T/l3cEzDCyXxy
sQyAem8HGJFuBxnOKJ2E
=KqNl
-----END PGP SIGNATURE-----

--h56sxpGKRmy85csR--
