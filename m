Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC49C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 16:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2EDC21924
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 16:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="C48leLF1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfBOQYg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 11:24:36 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37738 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfBOQYf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 11:24:35 -0500
Received: by mail-qk1-f194.google.com with SMTP id m9so6019409qkl.4
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 08:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=U0QiU4gwFgxHIQfhySXiWx23tsEB4zn1oWk8GmNybnw=;
        b=C48leLF17JcfoX4t7dFmDPr1xROc+8FVxND/1lKQfJf2IV9tf2MjzYzhLQgV9HVk9L
         eNI744vkFj0rMQE/WNSSTyq/pDORXwv17n490X5ryy6coObK1u39OY6/GfsWPBtmh+e5
         fEm3ssLFvB4Ln//DspB1h+EKU65DHcwwYM/zuf9EMIMkU0ORJiaZKsuLG6T16KxBubTJ
         D0Kxvfbv9AlZiyMsInWF9O1N8YRs3TE1YEOG7pnQUmBCKvdly0TSIoWrSi/B7VgwAL8K
         lkGyFecgo86EWlJ74tjJHgTo4aUhJn3Ks7CgttOUbrsNqnN2gmNBSpENpO0xZWyMiUZ6
         GLRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=U0QiU4gwFgxHIQfhySXiWx23tsEB4zn1oWk8GmNybnw=;
        b=Giw/C5auziPyzOxI4VNRpNcfqD7dUjtrMzeSuTsYrl7tutWtoKTK0GUg+A9ATQoNSs
         YsGR4jF/Aw/cclFbyJAlSlLvjYvYyrvfPO+tskBvcVRZLSE6rTKD9uFzVp2U9N3yznwW
         4lBQil1q7RGWahQEtPsmEqtAixcbqoRBEM03aVfJCs5AyCmpp1S0IGRGaFXOF04VS86H
         ezC8HGrWVO0XdFkJKILRn4xeqFtfB7Yi6U365n+wF/3YErWWzb8qOqnnHYTjxq8944L7
         2k/iDFY5t0vEEvrFBK/tu4H5U6XCIy5wcZGq1SE92pyvc+g8GPqOL3qD/ayAyEtm7mEg
         F8fw==
X-Gm-Message-State: AHQUAuYeGagpSEyuqZ3DuIVrIZDXTcgp+appovcyzY4wT7Pr5nSunp1K
        Lg3MwNY2rZzVZHTzcLV4X2d/bg==
X-Google-Smtp-Source: AHgI3IamrYiJMXSmIEhVu73Gh0piPtMHRjKGI4FSjDL84VyTPXwGaj0+KtH+mUIM/O46dxk3vvK5bg==
X-Received: by 2002:a37:d4d7:: with SMTP id s84mr7939976qks.28.1550247874533;
        Fri, 15 Feb 2019 08:24:34 -0800 (PST)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id 41sm3194397qtm.71.2019.02.15.08.24.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Feb 2019 08:24:33 -0800 (PST)
Message-ID: <04f7cf49df32b39f88b14a84df4fa38b1c7d24f6.camel@ndufresne.ca>
Subject: Re: [PATCH v7] media: imx: add mem2mem device
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>
Cc:     linux-media <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sascha Hauer <kernel@pengutronix.de>
Date:   Fri, 15 Feb 2019 11:24:32 -0500
In-Reply-To: <1550229020.4531.12.camel@pengutronix.de>
References: <20190117155032.3317-1-p.zabel@pengutronix.de>
         <CAJ+vNU0HCBr2vz-D=Z8zC+JAmZ6bhsi7TCRhB827uPQj-8esDQ@mail.gmail.com>
         <1550229020.4531.12.camel@pengutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-N+hOTfpMds6iseULiofb"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-N+hOTfpMds6iseULiofb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 15 f=C3=A9vrier 2019 =C3=A0 12:10 +0100, Philipp Zabel a =C3=A9=
crit :
> > I'm also not sure how to specify hflip/vflip... I don't think
> > extra-controls parses 'hflip', 'vflip' as ipu_csc_scaler_s_ctrl gets
> > called with V4L2_CID_HFLIP/V4L2_CID_VFLIP but ctrl->val is always 0.
>=20
> You can use v4l2-ctl -L to list the CID names, they are horizontal_flip
> and vertical_flip, respectively. Again, the input and output formats
> must be different because GStreamer doesn't know about the flipping yet:
>=20
> gst-launch-1.0 videotestsrc ! video/x-raw,width=3D320,height=3D240 ! v4l2=
video10convert extra-controls=3Dcid,horizontal_flip=3D1 ! video/x-raw,width=
=3D640,height=3D480 ! kmssink can-scale=3Dfalse
>=20
> We'd have to add actual properties for rotate/flip to v4l2convert,
> instead of using theextra-controls workaround, probable something
> similar to the video-direction property of the software videoflip
> element.

Note that we have a disable-passthrough property in master, a trivial
patch to backport if you need it.

https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/commit/fe5236be87=
71ea82c850ebebe19cf1064d112bf0

--=-N+hOTfpMds6iseULiofb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXGbnwAAKCRBxUwItrAao
HE2wAJ4pStZkhO9u19LWzO5nNO9Tpn1cAwCfZO0GB6j76Q/v1M/tftlTKJfyKAs=
=ymJC
-----END PGP SIGNATURE-----

--=-N+hOTfpMds6iseULiofb--

