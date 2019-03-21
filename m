Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91F3C10F00
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 19:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2CA521902
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 19:14:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="qitNWf19"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbfCUTOM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 15:14:12 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35094 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728445AbfCUTOM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 15:14:12 -0400
Received: by mail-qt1-f195.google.com with SMTP id h39so7949650qte.2
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2019 12:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=Aigz3u/0IYmN9fWYlHNTFuzwhsqPqGG63AbvSDJCD9w=;
        b=qitNWf19ikwk1BNCYaO3FzglNJWIN+1Tlh1st8ha3F6X00gfw7mpGydeccjzv7Y/I3
         ABt/ugLI9ATzbxEac8+6cMoF7pwAQxC+Xcqn293l79UDw4/gR8R3fKwe08ST2QqRbIgk
         wysNB6qrfMHg6GbNg/lBwAgRLp5hTAl+CJXAsII3Si8cVGSAmX2lxSo80vL6L1ze73Vr
         0q6+bX4qr+F1JVCsZo0BVYtderSdhQ0POPvLNSKVsKo85wACWQJk1Suo6bWfp9EW97jN
         hWK8i2eJ1cO8UcgeYRF4pjVKbG5ZzbrtJoFGtU4eqBBGldnrxedAj/dp3MIoNwRPCSl9
         tAaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=Aigz3u/0IYmN9fWYlHNTFuzwhsqPqGG63AbvSDJCD9w=;
        b=KviUSR4zJxRD9ACnhTw2B1gi7WIIJOrSD74RHkoG3h5apGNxJqY+YblxIcJS8zFkb3
         qsnoOiHuWZFjTZPB0RvYu/S+OtMyyTFz1ChXtpYnNY22YHXMwslJBYZOzDaWT+jKEb2F
         U3CfQXtsOLDn1eYr87Z0qll39B+WJDypgr2KzOg2y/KM6z4z1fYGz4sYHXwfRFl25pcA
         EY4h3JE0FBOqHYy6h2gIhHkbToEFpBPurDMyVwMKBOYFggMeY2HjXfTJj9DihntLkHeC
         ckoMmrvgYXqwywKBrhUJMi1CpzS6vKUcr0Uasm14nQmQvnObEnrKp3R7Td14myoaE94n
         M5dQ==
X-Gm-Message-State: APjAAAU23QXwoP5wyUjfyfqNoR4ua1mnomjHrLrcCyIvUPFG9QJDiPQi
        Qv6gnNf6x86OPeE5UkYthUPFVA==
X-Google-Smtp-Source: APXvYqxEfzsyAqka+ObZVM7ImwAMdWzci5z61uULRY9I6lmeoAJ96qT3whgyjUFHow33iMLKt4uUqw==
X-Received: by 2002:ac8:2b28:: with SMTP id 37mr4386394qtu.69.1553195649912;
        Thu, 21 Mar 2019 12:14:09 -0700 (PDT)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id l123sm2880100qkf.90.2019.03.21.12.14.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Mar 2019 12:14:09 -0700 (PDT)
Message-ID: <ac5329d77f83af2804c240ebe479ec323b60aec3.camel@ndufresne.ca>
Subject: Re: [RFC PATCH 18/20] lib: image-formats: Add v4l2 formats support
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-media@vger.kernel.org, Daniel Stone <daniels@collabora.com>
Date:   Thu, 21 Mar 2019 15:14:06 -0400
In-Reply-To: <20190321163532.GG3888@intel.com>
References: <c97024b97d3261dcf41aad3c8bc1c5d9906f33c9.1553032382.git-series.maxime.ripard@bootlin.com>
         <d8f4a31e35b1702230ced4a0cb43c10d1c7e60c8.camel@ndufresne.ca>
         <20190320142739.GK3888@intel.com>
         <a13f7fdeaf1a5e97f21a6048da765705b59d64c2.camel@ndufresne.ca>
         <20190320160939.GR3888@intel.com>
         <f3f8749e30aad81bc39ed9b60cd308ac5f3c6707.camel@ndufresne.ca>
         <20190320164133.GT3888@intel.com>
         <d46b30ca8962d3c31b1273cf010ca9fb7b145fe8.camel@ndufresne.ca>
         <20190320183914.GV3888@intel.com>
         <46df4fb13636b90c147839b0aa5ad1ac33030461.camel@bootlin.com>
         <20190321163532.GG3888@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-YEa96ySSibK4Yq8yRLAj"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-YEa96ySSibK4Yq8yRLAj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 21 mars 2019 =C3=A0 18:35 +0200, Ville Syrj=C3=A4l=C3=A4 a =C3=A9c=
rit :
> > I'm not sure what it's worth, but there is a "pixel format guide"
> > project that is all about matching formats from one API to another:=20
> > https://afrantzis.com/pixel-format-guide/ (and it has an associated
> > tool too).
> >=20
> > On the page about DRM, it seems that they got the word that DRM formats
> > are the native pixel order in little-endian systems:
> > https://afrantzis.com/pixel-format-guide/drm.html
>=20
> Looks consistent with the official word in drm_fourcc.h.
>=20
> $ python3 -m pfg find-compatible V4L2_PIX_FMT_XBGR32 drm
> Format: V4L2_PIX_FMT_XBGR32
> Is compatible on all systems with:
>         DRM_FORMAT_XRGB8888
> Is compatible on little-endian systems with:
> Is compatible on big-endian systems with:
>=20
> $ python3 -m pfg find-compatible DRM_FORMAT_XRGB8888 v4l2
> Format: DRM_FORMAT_XRGB8888
> Is compatible on all systems with:
>         V4L2_PIX_FMT_XBGR32
> Is compatible on little-endian systems with:
> Is compatible on big-endian systems with:
>=20
> Even works both ways :)
>=20
> > Perhaps some drivers have been abusing the format definitions, leading
> > to the inconsistencies that Nicolas could witness?
>=20
> That is quite possible, perhaps even likely. No one really
> seems interested in making sure big endian systems actually
> work properly. I believe the usual approach is to hack
> around semi-rnadomly until the correct colors accidentally
> appear on the screen.

We did not hack around randomly. The code in GStreamer is exactly what
the DRM and Wayland dev told us to do (they provided the initial
patches to make it work). These are initially patches from Intel for
what it's worth (see the wlvideoformat.c header [0]). Even though I
just notice that in this file, it seems that we ended up with a
different mapping order for WL and DRM format in 24bit RGB (no
padding), clearly is a bug. That being said, there is no logical
meaning for little endian 24bit RGB, you can't load a pixel on CPU in a
single op. Just saying since I would not know which one of the two
mapping here is right. I would probably have to go testing what DRM
drivers do, which may not mean anything. I would also ask and get
contradictory answers.

I have never myself tested these on big endian drivers though, as you
say, nobody seems to care about graphics on those anymore. So the easy
statement is to say they are little endian, like you just did, and
ignore the legacy, but there is some catch. YUV formats has been added
without applying this rules. So V4L2 YUYV match YUYV in DRM format name
instead of little endian UYVY. (at least 4 tested drivers implements it
this way). Same for NV12, for which little endian CPU representation
would swap the UV paid on a 16bit word.

To me, all the YUV stuff is the right way, because this is what the
rest of the world is doing, it's not ambiguous.

[0] https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/master/ex=
t/wayland/wlvideoformat.c#L86



Nicolas

--=-YEa96ySSibK4Yq8yRLAj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXJPifwAKCRBxUwItrAao
HFlVAJ9FstJlPcaUbG2TYcchrUB8SP5jzgCaAxYrAUOaaMlup2o4lx/q2zRNIZI=
=iSpb
-----END PGP SIGNATURE-----

--=-YEa96ySSibK4Yq8yRLAj--

