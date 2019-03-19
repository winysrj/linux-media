Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B1A8C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 18:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E366920685
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 18:07:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="sQEU/Bip"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfCSSHg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 14:07:36 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43153 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbfCSSHg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 14:07:36 -0400
Received: by mail-qt1-f196.google.com with SMTP id v32so23218658qtc.10
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2019 11:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=QcAy04BeDhbXVFKJncZn1jN/YUmZ8HVS2INZitEjTxY=;
        b=sQEU/Bipx7Sg8T4yl0NaZCMzzQ9y3/USp/y0eowKSMk7lbxEQdDF2Q9PbUTssKQFLi
         cFFAgopEBdflYkKrEh9JVnZMOIxpa6Ogrk2gavbm3seqPzuRq9YkTAyUnHG9FBQOwszn
         IVyU2gEXXJW0Yt8rc3A7W/6VVCLuMAaGYzv7nH3tYuZFxa6mhr5lp94cepr755BVJ4GX
         0USyyKqc7JEtGgGddXxzr0qAIikkrHse0sjiOHU3TzXMqgIWWa9LyPaHAyDoA6LA9oTh
         HHM9stSHzx26n23oufVY/QRe9bTQokiaJn2unemoqm7TpVOIPM9xN4uMNuxNwMlcoHkh
         AZ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=QcAy04BeDhbXVFKJncZn1jN/YUmZ8HVS2INZitEjTxY=;
        b=ewP5cycz8A4U/Z3swVklYSwZeJtUcj5F3dMro3ZYSgCBEKtSLX/rQeVuKtEZ1SAdnH
         nuRSUsgO1EyjAuaZWrVE3tG7W/zyqDYQzxDo14w0wU5KWkXUdHesfSD67FyyaPSvo7Q/
         iFGBmxOopGscF1ewFoeV56gAU3JDOXHsLOtsl3P+4nx+88szGLZhmAOLKMa8GHVEY9Ty
         vGWCDksIvhMpIwPO2Yon8+8kqsyhSrmY4B2ZMMVkt8z+6v4NuYyS1eGGTKCvwwkoDqbv
         c34+liTWm+iQ3WNUupDYG5thQXDbeYaafXpmWfWIzHVvEkW9Jlt335Ul8/rRK6hi3+ix
         Rk1w==
X-Gm-Message-State: APjAAAUr8p0vowfaDhUO7rgpO35rk63abiIvv8IABGVYFEvVk/GpXZ9H
        I7p9Xmz5xxReTUQ6I3wq3kaQjA==
X-Google-Smtp-Source: APXvYqwLIu/tMxXbV35fyqdDMHZHcvw3jI9crqHeqanrM5cyw5AQGXzXrAxRiCohnKDTQreWRIExHQ==
X-Received: by 2002:ac8:2df8:: with SMTP id q53mr3161621qta.132.1553018855348;
        Tue, 19 Mar 2019 11:07:35 -0700 (PDT)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id s76sm8587233qki.42.2019.03.19.11.07.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 11:07:34 -0700 (PDT)
Message-ID: <53351fc1d3be8a268171162bc68939d38953d13a.camel@ndufresne.ca>
Subject: Re: [RFC PATCH 2/3] media: v4l2: Extend pixel formats to unify
 single/multi-planar handling (and more)
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Hirokazu Honda <hiroh@chromium.org>
Date:   Tue, 19 Mar 2019 14:07:32 -0400
In-Reply-To: <20190319145243.25047-3-boris.brezillon@collabora.com>
References: <20190319145243.25047-1-boris.brezillon@collabora.com>
         <20190319145243.25047-3-boris.brezillon@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-Dx8FD3Oc5gy58I5s9AWH"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-Dx8FD3Oc5gy58I5s9AWH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 19 mars 2019 =C3=A0 15:52 +0100, Boris Brezillon a =C3=A9crit :
> +/**
> + * struct v4l2_plane_ext_pix_format - additional, per-plane format defin=
ition
> + * @modifier:          modifier applied to the format (used for tiled fo=
rmats
> + *                     and other kind of HW-specific formats, like compr=
essed
> + *                     formats)

I have never seen HW that would allow per-plane modifiers on the DRM
side, and I believe the newer API (enumeration) ignores this per-plane
idea. Would be nice to investigate/verify this and avoid doing the same
mistake.

> + * @sizeimage:         maximum size in bytes required for data, for whic=
h
> + *                     this plane will be used
> + * @bytesperline:      distance in bytes between the leftmost pixels in =
two
> + *                     adjacent lines
> + */
> +struct v4l2_plane_ext_pix_format {
> +       __u64 modifier;
> +       __u32 sizeimage;
> +       __u32 bytesperline;
> +};

--=-Dx8FD3Oc5gy58I5s9AWH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXJEv5AAKCRBxUwItrAao
HJi6AJ9hVXdR/7kG605kVMyiGIWL1rY+wwCeIpzj2Q6olyAd817Zk+0gnjYVjhs=
=L2hK
-----END PGP SIGNATURE-----

--=-Dx8FD3Oc5gy58I5s9AWH--

