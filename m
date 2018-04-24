Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:46017 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbeDXHQ2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 03:16:28 -0400
Date: Tue, 24 Apr 2018 09:16:22 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, architt@codeaurora.org,
        a.hajda@samsung.com, airlied@linux.ie, daniel@ffwll.ch,
        peda@axentia.se, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] media: Add LE version of RGB LVDS formats
Message-ID: <20180424071622.GE17088@w540>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524130269-32688-6-git-send-email-jacopo+renesas@jmondi.org>
 <1733883.PFymhGyeZa@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Lb0e7rgc7IsuDeGj"
Content-Disposition: inline
In-Reply-To: <1733883.PFymhGyeZa@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Lb0e7rgc7IsuDeGj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

HI Laurent,

On Mon, Apr 23, 2018 at 04:06:01PM +0300, Laurent Pinchart wrote:
> Hi Jacopo,
>
> Thank you for the patch.
>
> On Thursday, 19 April 2018 12:31:06 EEST Jacopo Mondi wrote:
> > Some LVDS controller can output swapped versions of LVDS RGB formats.
> > Define and document them in the list of supported media bus formats
>
> I wouldn't introduce those new formats as we don't need them. As a general
> rule we would like to have at least one user for any new format added to the
> API.

I was about to point you to patch [8/8], as the newly introduced
formats allow replacing the DRM_BUS_FLAG_DATA_ flags, defined in
drm_connector.h and which I struggled to find a more appropiate place
where to move them. Or I either duplicate them for bridges, but I
prefer not to, or we remove them, and defining some dedicated formats,
seems more natural to me...

I'll reply to your comment on [8/8] on the format names and other
details.

Thanks
   j

>
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  Documentation/media/uapi/v4l/subdev-formats.rst | 174 +++++++++++++++++++++
> >  include/uapi/linux/media-bus-format.h           |   5 +-
> >  2 files changed, 178 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst
> > b/Documentation/media/uapi/v4l/subdev-formats.rst index 9fcabe7..9a5263c
> > 100644
> > --- a/Documentation/media/uapi/v4l/subdev-formats.rst
> > +++ b/Documentation/media/uapi/v4l/subdev-formats.rst
> > @@ -1669,6 +1669,64 @@ JEIDA defined bit mapping will be named
> >        - b\ :sub:`2`
> >        - g\ :sub:`1`
> >        - r\ :sub:`0`
> > +    * .. _MEDIA-BUS-FMT-RGB666-1X7X3-SPWG_LE:
> > +
> > +      - MEDIA_BUS_FMT_RGB666_1X7X3_SPWG_LE
> > +      - 0x101b
> > +      - 0
> > +      -
> > +      -
> > +      - b\ :sub:`2`
> > +      - g\ :sub:`1`
> > +      - r\ :sub:`0`
> > +    * -
> > +      -
> > +      - 1
> > +      -
> > +      -
> > +      - b\ :sub:`3`
> > +      - g\ :sub:`2`
> > +      - r\ :sub:`1`
> > +    * -
> > +      -
> > +      - 2
> > +      -
> > +      -
> > +      - b\ :sub:`4`
> > +      - g\ :sub:`3`
> > +      - r\ :sub:`2`
> > +    * -
> > +      -
> > +      - 3
> > +      -
> > +      -
> > +      - b\ :sub:`5`
> > +      - g\ :sub:`4`
> > +      - r\ :sub:`3`
> > +    * -
> > +      -
> > +      - 4
> > +      -
> > +      -
> > +      - d
> > +      - g\ :sub:`5`
> > +      - r\ :sub:`4`
> > +    * -
> > +      -
> > +      - 5
> > +      -
> > +      -
> > +      - d
> > +      - b\ :sub:`0`
> > +      - r\ :sub:`5`
> > +    * -
> > +      -
> > +      - 6
> > +      -
> > +      -
> > +      - d
> > +      - b\ :sub:`1`
> > +      - g\ :sub:`0`
> >      * .. _MEDIA-BUS-FMT-RGB888-1X7X4-SPWG:
> >
> >        - MEDIA_BUS_FMT_RGB888_1X7X4_SPWG
> > @@ -1727,6 +1785,64 @@ JEIDA defined bit mapping will be named
> >        - b\ :sub:`2`
> >        - g\ :sub:`1`
> >        - r\ :sub:`0`
> > +    * .. _MEDIA-BUS-FMT-RGB888-1X7X4-SPWG_LE:
> > +
> > +      - MEDIA_BUS_FMT_RGB888_1X7X4_SPWG_LE
> > +      - 0x101c
> > +      - 0
> > +      -
> > +      - r\ :sub:`6`
> > +      - b\ :sub:`2`
> > +      - g\ :sub:`1`
> > +      - r\ :sub:`0`
> > +    * -
> > +      -
> > +      - 1
> > +      -
> > +      - r\ :sub:`7`
> > +      - b\ :sub:`3`
> > +      - g\ :sub:`2`
> > +      - r\ :sub:`1`
> > +    * -
> > +      -
> > +      - 2
> > +      -
> > +      - g\ :sub:`6`
> > +      - b\ :sub:`4`
> > +      - g\ :sub:`3`
> > +      - r\ :sub:`2`
> > +    * -
> > +      -
> > +      - 3
> > +      -
> > +      - g\ :sub:`7`
> > +      - b\ :sub:`5`
> > +      - g\ :sub:`4`
> > +      - r\ :sub:`3`
> > +    * -
> > +      -
> > +      - 4
> > +      -
> > +      - b\ :sub:`6`
> > +      - d
> > +      - g\ :sub:`5`
> > +      - r\ :sub:`4`
> > +    * -
> > +      -
> > +      - 5
> > +      -
> > +      - b\ :sub:`7`
> > +      - d
> > +      - b\ :sub:`0`
> > +      - r\ :sub:`5`
> > +    * -
> > +      -
> > +      - 6
> > +      -
> > +      - d
> > +      - d
> > +      - b\ :sub:`1`
> > +      - g\ :sub:`0`
> >      * .. _MEDIA-BUS-FMT-RGB888-1X7X4-JEIDA:
> >
> >        - MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA
> > @@ -1785,6 +1901,64 @@ JEIDA defined bit mapping will be named
> >        - b\ :sub:`4`
> >        - g\ :sub:`3`
> >        - r\ :sub:`2`
> > +    * .. _MEDIA-BUS-FMT-RGB888-1X7X4-JEIDA_LE:
> > +
> > +      - MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA_LE
> > +      - 0x101d
> > +      - 0
> > +      -
> > +      - r\ :sub:`0`
> > +      - b\ :sub:`4`
> > +      - g\ :sub:`3`
> > +      - r\ :sub:`2`
> > +    * -
> > +      -
> > +      - 1
> > +      -
> > +      - r\ :sub:`1`
> > +      - b\ :sub:`5`
> > +      - g\ :sub:`4`
> > +      - r\ :sub:`3`
> > +    * -
> > +      -
> > +      - 2
> > +      -
> > +      - g\ :sub:`0`
> > +      - b\ :sub:`6`
> > +      - g\ :sub:`5`
> > +      - r\ :sub:`4`
> > +    * -
> > +      -
> > +      - 3
> > +      -
> > +      - g\ :sub:`1`
> > +      - b\ :sub:`7`
> > +      - g\ :sub:`6`
> > +      - r\ :sub:`5`
> > +    * -
> > +      -
> > +      - 4
> > +      -
> > +      - b\ :sub:`0`
> > +      - d
> > +      - g\ :sub:`7`
> > +      - r\ :sub:`6`
> > +    * -
> > +      -
> > +      - 5
> > +      -
> > +      - b\ :sub:`1`
> > +      - d
> > +      - b\ :sub:`2`
> > +      - r\ :sub:`7`
> > +    * -
> > +      -
> > +      - 6
> > +      -
> > +      - d
> > +      - d
> > +      - b\ :sub:`3`
> > +      - g\ :sub:`2`
> >
> >  .. raw:: latex
> >
> > diff --git a/include/uapi/linux/media-bus-format.h
> > b/include/uapi/linux/media-bus-format.h index 9e35117..5bea7c0 100644
> > --- a/include/uapi/linux/media-bus-format.h
> > +++ b/include/uapi/linux/media-bus-format.h
> > @@ -34,7 +34,7 @@
> >
> >  #define MEDIA_BUS_FMT_FIXED			0x0001
> >
> > -/* RGB - next is	0x101b */
> > +/* RGB - next is	0x101f */
> >  #define MEDIA_BUS_FMT_RGB444_1X12		0x1016
> >  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
> >  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
> > @@ -49,13 +49,16 @@
> >  #define MEDIA_BUS_FMT_RBG888_1X24		0x100e
> >  #define MEDIA_BUS_FMT_RGB666_1X24_CPADHI	0x1015
> >  #define MEDIA_BUS_FMT_RGB666_1X7X3_SPWG		0x1010
> > +#define MEDIA_BUS_FMT_RGB666_1X7X3_SPWG_LE	0x101b
> >  #define MEDIA_BUS_FMT_BGR888_1X24		0x1013
> >  #define MEDIA_BUS_FMT_GBR888_1X24		0x1014
> >  #define MEDIA_BUS_FMT_RGB888_1X24		0x100a
> >  #define MEDIA_BUS_FMT_RGB888_2X12_BE		0x100b
> >  #define MEDIA_BUS_FMT_RGB888_2X12_LE		0x100c
> >  #define MEDIA_BUS_FMT_RGB888_1X7X4_SPWG		0x1011
> > +#define MEDIA_BUS_FMT_RGB888_1X7X4_SPWG_LE	0x101c
> >  #define MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA	0x1012
> > +#define MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA_LE	0x101d
> >  #define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
> >  #define MEDIA_BUS_FMT_RGB888_1X32_PADHI		0x100f
> >  #define MEDIA_BUS_FMT_RGB101010_1X30		0x1018
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>

--Lb0e7rgc7IsuDeGj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa3tnGAAoJEHI0Bo8WoVY8NkUP/jbr7QVwPmgIzNo86QV+ptKD
NvhDLZpNQSlbEYtUSPr0Eb67cF26O1U21Ezf2c0oEQc1QsrGtF5KgBqQHrlL87Yn
ksAvgT9wZbwwR0L+MP4KO/nP+s/adiCf7/f79Okz0xWYivJ7uJv63+XImKtEW85K
OUP7WKfnw8CjKVSwbIRmWthVl2K3NNZvrZzjfGFYwGWr9U8RmYTmRaP86Cku1UbA
P/vCNm9fzECJXLzNsycIfLaeJ9nCtKn4wleI0+X+CXNq5LPZS8JLPnHqFzjE7eLb
2GNNce01ZICrBn5SyjLJptk1rAq9ht7CIclkqoi7wuQKSirohyZCCtP768vh0njd
CXDXYaPu80ZRUB0fcFcGZ6pKPMWXFnUqRvQyC3FAlXiShkX4qBNl6ghU5qI4YLk5
4KtuDw3jALjKLiTf9wZ57Sxm0SekvjJBgzHse0++BrtkxWpgmkE+RfJBXOBC5npi
1sU8SkZFIK1DzuMBZ/vR5MANME27p4RKn7+CTsSEEnlv4l309vzfcv86eCwS9F+a
Xrba5tRfh+FwixDXcOxy0IDIfMCpCQBO+tYOgjEvcQW4kD/UwOLHZEHAdnZSMl8G
ouanzzBuYhFL7Fdeq0wCsqQT45G8j6NsubR7bSAJsSC225OSVJtKPCLjTE/a9woz
nN0j14ay7AszUdBYFUms
=ToEU
-----END PGP SIGNATURE-----

--Lb0e7rgc7IsuDeGj--
