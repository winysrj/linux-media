Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:63467 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752510AbdEHK0o (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 06:26:44 -0400
Subject: Re: [PATCH 8/8] omapdrm: hdmi4: hook up the HDMI CEC support
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-9-hverkuil@xs4all.nl>
 <144b95df-8eb2-1307-1157-2eb2572c51aa@xs4all.nl>
CC: <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <7d3ab159-9284-bcc8-80f0-cbc621769203@ti.com>
Date: Mon, 8 May 2017 13:26:39 +0300
MIME-Version: 1.0
In-Reply-To: <144b95df-8eb2-1307-1157-2eb2572c51aa@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="mOtCcgobi96rDw5D6fOXSwWtKFPmpU0JB"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--mOtCcgobi96rDw5D6fOXSwWtKFPmpU0JB
Content-Type: multipart/mixed; boundary="fLVeqnQvpxH5TbpQtmm3J1cILeApiL5KH";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hans.verkuil@cisco.com>,
 Peter Ujfalusi <peter.ujfalusi@ti.com>
Message-ID: <7d3ab159-9284-bcc8-80f0-cbc621769203@ti.com>
Subject: Re: [PATCH 8/8] omapdrm: hdmi4: hook up the HDMI CEC support
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-9-hverkuil@xs4all.nl>
 <144b95df-8eb2-1307-1157-2eb2572c51aa@xs4all.nl>
In-Reply-To: <144b95df-8eb2-1307-1157-2eb2572c51aa@xs4all.nl>

--fLVeqnQvpxH5TbpQtmm3J1cILeApiL5KH
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06/05/17 14:58, Hans Verkuil wrote:

> My assumption was that hdmi_display_disable() was called when the hotpl=
ug would go
> away. But I discovered that that isn't the case, or at least not when X=
 is running.
> It seems that the actual HPD check is done in hdmic_detect() in
> omapdrm/displays/connector-hdmi.c.

For some HW it's done there (in the case there's no IP handling the
HPD), but in some cases it's done in tpd12s015 driver (e.g. pandaboard),
and in some cases it also could be done in the hdmi driver (if the HPD
is handled by the HDMI IP, but at the moment we don't have this case
supported in the SW).

> But there I have no access to hdmi.core (needed for the hdmi4_cec_set_p=
hys_addr() call).
>=20
> Any idea how to solve this? I am not all that familiar with drm, let al=
one omapdrm,
> so if you can point me in the right direction, then that would be very =
helpful.

Hmm, indeed, looks the the output is kept enabled even if HPD drops and
the connector status is changed to disconnected.

I don't have a very good solution... I think we have to add a function
to omapdss_hdmi_ops, which the connector-hdmi and tpd12s015 drivers can
call when they detect a HPD change. That call would go to the HDMI IP
driver.

Peter is about to send hotplug-interrupt-handling series, I think the
HPD function work should be done on top of that, as otherwise it'll just
conflict horribly.

 Tomi


--fLVeqnQvpxH5TbpQtmm3J1cILeApiL5KH--

--mOtCcgobi96rDw5D6fOXSwWtKFPmpU0JB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJZEEffAAoJEPo9qoy8lh71HzMP/jFLAU/SdF+FAyllt2iXxqXo
Y3nQq2aO6ubxL5zg6484ryv8xMur2D8+2xmzi/OECC0ayhKePKN3tFEVMy4SVB+z
4hY0tjawEY455MSpKMjuSHM+XhEfCZwel1C7OjhE/34yJGWG9o9zPC5Pt11QwAw0
jqpq/8Ook4K5AXs+fc9XakvzJA2vM6vntiLm4oZOUjsP4lLnhPfvkCX15+ilmyCT
P8K4CPdu0TEpK6PXsI9du53vvXlHqJjWif592ih7JERyVv5sBG1aQaSyM6vWyvV9
IaLgG6ov1JBamkumsg0oYiiHWaU5PHOgenzlizM/aBqhe1uX9qNVmyU1R0+561Rk
rjakLVcOOHelNodskMO05gEQkQeNY0zHPIQI6G2rBPbHS1kHtjssD76G5KqTEjLi
lPCPk+MY9S2pLxa+RzIUKrQk9jC9jtK/Uog1JDruUMzfrr2V0TbROLkcqnW9j+2u
gH2mfAQIToMrFFFeBssr45K/H+XB18dMEJdQzssayGXdSv/JcVWRksqS+tDFJc8c
stF1ABEQrEiKUnhkcfANUWImPI80Oy7URWPyTC2EBapll2l3wzgI2By1AOI2aBSL
U35da6vt+SRwhDi4l1ktfO2owcVsKrUEYkV7uePSWdyST5Hc47mwEm48lljzcGKE
+McqsyZsIBwNNniN6v8K
=OXE+
-----END PGP SIGNATURE-----

--mOtCcgobi96rDw5D6fOXSwWtKFPmpU0JB--
