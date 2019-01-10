Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B7DC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 12:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CCD8214C6
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 12:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="eb8tKi6L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfAJMvc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 07:51:32 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9604 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfAJMvc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 07:51:32 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5c373fc50000>; Thu, 10 Jan 2019 04:51:17 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 10 Jan 2019 04:51:30 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 10 Jan 2019 04:51:30 -0800
Received: from localhost (10.124.1.5) by HQMAIL101.nvidia.com (172.20.187.10)
 with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 10 Jan 2019 12:51:29
 +0000
Date:   Thu, 10 Jan 2019 13:51:27 +0100
From:   Thierry Reding <treding@nvidia.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
CC:     <linux-media@vger.kernel.org>, <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [PATCH 1/1] v4l: ioctl: Validate num_planes before using it
Message-ID: <20190110125126.GA17156@ulmo>
References: <20190110124319.22230-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20190110124319.22230-1-sakari.ailus@linux.intel.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1547124677; bh=D5Wob1yyA3W/6aP6JYzIGvJCxxkRVG9Cn2NZO/ZQmWU=;
        h=X-PGP-Universal:Date:From:To:CC:Subject:Message-ID:References:
         MIME-Version:In-Reply-To:X-NVConfidentiality:User-Agent:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:
         Content-Disposition;
        b=eb8tKi6LZzw87/5Sr9Ena7o1FaAx8fzZfrDeKruSkoRoqVo7keQ43TD1g2aw4+a3s
         J986MKhdfgE3cosVlZsk8+fjbevVp+DRS4czUV9/IqrnVf8NMTlB5Z1SrMY8580sTk
         6N9Uts5HT/cjGlVoaJHUiwMvvATIE5PykcCKVKoDctX82wnbaFwYDbSh/ztffetGB2
         xNh/f2Vn5PN8BBtx+l3bh7wEGVb7Kr9a3d0+xMX0pAfS3iim6p1QfD/2cdLha/ToTf
         JN1H1swPP4+4l/5DqcfhvYpPp0YzhSJs0OCxyS9pqcl8Hqhyo8fD6+F/dP6m23iAJ0
         0mEpnw35S5rLQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2019 at 02:43:19PM +0200, Sakari Ailus wrote:
> The for loop to reset the memory of the plane reserved fields runs over
> num_planes provided by the user without validating it. Ensure num_planes
> is no more than VIDEO_MAX_PLANES before the loop.
>=20
> Fixes: 4e1e0eb0e074 ("media: v4l2-ioctl: Zero v4l2_plane_pix_format reser=
ved fields")
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi folks,
>=20
> This patch goes on top of Thierry's patch "media: v4l2-ioctl: Clear only
> per-plane reserved fields".
>=20
>  drivers/media/v4l2-core/v4l2-ioctl.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-co=
re/v4l2-ioctl.c
> index 392f1228af7b5..9e68a608ac6d3 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1551,6 +1551,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *o=
ps,
>  		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> +			break;
>  		for (i =3D 0; i < p->fmt.pix_mp.num_planes; i++)
>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>  		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
> @@ -1581,6 +1583,8 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *o=
ps,
>  		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> +			break;
>  		for (i =3D 0; i < p->fmt.pix_mp.num_planes; i++)
>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>  		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
> @@ -1648,6 +1652,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops =
*ops,
>  		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> +			break;
>  		for (i =3D 0; i < p->fmt.pix_mp.num_planes; i++)
>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>  		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
> @@ -1678,6 +1684,8 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops =
*ops,
>  		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> +		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> +			break;
>  		for (i =3D 0; i < p->fmt.pix_mp.num_planes; i++)
>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
>  		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);

Do we also want to validate the instance in v4l_print_format() before
using it?

Reviewed-by: Thierry Reding <treding@nvidia.com>

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlw3P8sACgkQ3SOs138+
s6FMnhAApsf4evQez1rRD6W5p8vIQFbHs7lBvstoBXsYRINrbusUf+px2O9k2N7E
3Oc2FU2hiRihdXPUQd8/schBsGvSr/zzSqLq6TuWPcXx1bkkKIM5q1xyF3Y3cy4L
GbutAuQJ17nzWi/IIXjQUvmPznR1PhFATz3PI3i/h+CwzCX8/0Go9O8XKpQ0+8au
dIh80YbVS50XOkzt2/BxoONTD6QyHCNopvC2W4mALB6Y1SIKErI4+s0N922DGpTe
sz8WpCkznovl6ylpKUxdSsGna4mDjGoWavA4N1mC6gqubnh9bntt8aYLkcMDuq0w
z9iTen7C+WzaqGTXEhtG0hiS4wY6yfzwGuOGBhUteSb/ls+orWv4z1yQayV3+RIA
bOMzkKGNLKld8wmnaLomTNBbCNUCTQMZ68vfLjzNPLIC9CyWBzZEJzBcrA4vV5zA
FU2HsSZzY1zGcNbYtshj6GARY0sKeENYmDVN+co79G/biiy6V+2oxLsLbLmpnn9R
+jnO2udNUmC/WvshVsf56ydQz3yzHMVKm472cdH9H00jPjinkX9p4itQ32P0JaEu
38OZaKU51k9u/dy6AmLUiVomCXgCXPDXmlsnDzzOcqiAnrVHN5RrLZ26ZqxlPn/x
M8tn1+/5zUiK9Gut/W1eaxZUjf9AtU6GLFjGQ+MS4rKqY33Med0=
=iKT4
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
