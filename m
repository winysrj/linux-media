Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89CC7C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 15:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53F6A214DA
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 15:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="nb0zAt2u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbfAJPmg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 10:42:36 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17930 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbfAJPmg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 10:42:36 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5c3767de0000>; Thu, 10 Jan 2019 07:42:22 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 10 Jan 2019 07:42:35 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 10 Jan 2019 07:42:35 -0800
Received: from localhost (10.124.1.5) by HQMAIL101.nvidia.com (172.20.187.10)
 with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 10 Jan 2019 15:42:35
 +0000
Date:   Thu, 10 Jan 2019 16:42:32 +0100
From:   Thierry Reding <treding@nvidia.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
CC:     <linux-media@vger.kernel.org>, <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [PATCH 1/1] v4l: ioctl: Validate num_planes for debug messages
Message-ID: <20190110154232.GB27355@ulmo>
References: <20190110142426.1124-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20190110142426.1124-1-sakari.ailus@linux.intel.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1547134942; bh=msRAUuabOhyYoapzk6in/Ho2ykmWwYrc5v/b8antQQI=;
        h=X-PGP-Universal:Date:From:To:CC:Subject:Message-ID:References:
         MIME-Version:In-Reply-To:X-NVConfidentiality:User-Agent:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:
         Content-Disposition;
        b=nb0zAt2uMtC0kpFy7zo/F4koGinqFjoZTq41wlLwLuNJgXYz4eNQzkwwRsJh2myHU
         Z9tfHrwuaX9amqdFugWrMpvSWPBLXVO15/f6/jDa1cgVtnhANSSeg+zXyJq/q3zv3r
         8uDPpd8dEuLrf7VcvrFlYagwzcWLoRIkXZWDsXm6Qr0cY6bSaiE/2BvNB9xiWF2tgz
         iETwxqGWXDnuF+IvvrEsPpyWs1TI/UW2i9lc2Vl7qylc5NqHz0zjqIIV9MDgC5XQuX
         t3Lm42LDgEJKpS56O+cPe0FTnOvwIjVgMxyvpVqpW/4e/GZrVocvTpfHpxkmoBkROn
         1aLSS/1sD3FXQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2019 at 04:24:26PM +0200, Sakari Ailus wrote:
> The num_planes field in struct v4l2_pix_format_mplane is used in a loop
> before validating it. As the use is printing a debug message in this case,
> just cap the value to the maximum allowed.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Seems reasonable:

Reviewed-by: Thierry Reding <treding@nvidia.com>

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlw3Z+gACgkQ3SOs138+
s6F/hBAAljHoptro82Kjc8+PbxBrtIGDmv3qOiVw7C/nosBCxr7T8RLiJcc+6t6E
hXgWj7s7n3A2PaIdOSqJ67r79iOxBrDEA8OXa/vK330gDmTq7DIT3aQDjqYoDRXc
AA1sggMQjl/juX2agFnwkIKC9uitGvS4bWbapqBMVdSuyj02jBQgBQaivoerqFiT
af7x4RT2vlbiJkrDVbYtWkEoyghFLhFfTCkCpiuyQmE3UaYsW4Ae1lNHdNt5PIUh
Y68gKtURmUKIxyRt0dyeLM2C3ixeHAIrP8r+dI/gidbIrlKmW+qtMAN2dNwbx5SY
xe8/tUG+zf6cRjNU8lcqRWUYkFbjVOzDr48OdHWiql5wjl4PIzK/jN6XBSI5MZl0
11cGNtyj7zpa8yVqnIxyDRm8IVWcdofXXJcH7S4UmZ7TFnF6G75XnZLHiTMVM5q3
XEvatcwdrrZVJn6gLwwMmwF5kWAkB0yJfMzAFy08NDTshCuUT6JMvnAsoRok/e9l
zpZ+cLEUr6ozwUuwrTRihixr1f5WY+bm436fb+Px/mvRfDpvSaTc2SToxeqmkHNX
CH246V9qmXvAg8rjlOzXGN5G9uk0Td5uuv0YTMOpuM91W+AL/9G5eEvML6/4Vsx0
ShgtPb8Qctr99kGsIsRSzaqK6yGWzeKM2aXI/YiAJjAzh4OCY88=
=Db0i
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
