Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,URIBL_SBL,URIBL_SBL_A autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627E2C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 21:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30AD520656
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 21:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="QBpMRmJ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfANVRZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 16:17:25 -0500
Received: from mail-qt1-f176.google.com ([209.85.160.176]:42203 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfANVRZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 16:17:25 -0500
Received: by mail-qt1-f176.google.com with SMTP id d19so642859qtq.9
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 13:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=CnKLfBguFzaCpQ66olaHVeB7DXtrb10RvmDh3tzM5O0=;
        b=QBpMRmJ2iQoOATpyE209lProLIGYoIjIi2u7fDIZ8zA29MmOmmYyB1g3C1e45lyJ5v
         HnH+tOdQTspvWRnPC8JdyCs6K2N5cC/1pg1YxmMf9HJEZ9kGo6S+W091O3P3cvcfSEOH
         adSjTlIpJp5f/ri7AE4TMfSWp52W7Q3jCkQ++7iEnDBVs7Va+y6Ro7eIUPnAVGuy4lrq
         R7k71ZIIQuYEkUvZvZk/gQjc0S/AgEBwBo16rkGqI/02gfFi7p/sEUFuj1AavSj5U0cq
         7yQfZNFvH0+FHv0aNwk8+de5IXrE9Ar8sYGcQO5Hr2emz5L5WyACOg7NpbACapJj/pxu
         a1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=CnKLfBguFzaCpQ66olaHVeB7DXtrb10RvmDh3tzM5O0=;
        b=r/qzuPB4jMm9K8xkieyExosicA6scRKKFSgGQk+thJltIEnqH4PwzF2+yVTxQYcKhT
         9AT410YGQK5G0MjrSOqcuPjJAsBzPpBGKZwRYUdRYTachHKNzDixLiDoJInNrGe3Z/DG
         dId5h3bmYWspXopp1vePtMwRg7i5DC7tVxEN0QX3MiyOd9+Fk46BlNZAfBLMiZb+zDF0
         2aBgWzUAvtCqbxdvtaH/DaHu5w8goOwG6IMUNeWqqAxvIMm+61PcRMJHmso1JTebfBVg
         MX0bdTRgNW7i0FYllOfuuNgGWso5ZVge84oeQYSVJjV8j3v67ODSjjUhhfFbkv7AagyR
         pT/A==
X-Gm-Message-State: AJcUukdjYM3FkKQ7MxxeDbE9RPyAmhhm8QEB45rsiFdjC7hhooPud4Kk
        QxyQlEPxtpI0uDtyUm/aS1qr+g==
X-Google-Smtp-Source: ALg8bN6OYuRP2hhqtj7cHyQyYMtcpLSagfsrJsSebxsSkZpHk8b74Yuc4A6qFBQ6z6YWH8xpOR3fxg==
X-Received: by 2002:ac8:43d0:: with SMTP id w16mr412358qtn.78.1547500644142;
        Mon, 14 Jan 2019 13:17:24 -0800 (PST)
Received: from tpx230-nicolas (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id r1sm52265951qte.28.2019.01.14.13.17.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Jan 2019 13:17:23 -0800 (PST)
Message-ID: <97bc9b1c7799b1d962d8dddfb1cda341816f662c.camel@ndufresne.ca>
Subject: Re: [PATCH v5] media: imx: add mem2mem device
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>, kernel@pengutronix.de
Date:   Mon, 14 Jan 2019 16:17:21 -0500
In-Reply-To: <1546961428.5406.4.camel@pengutronix.de>
References: <20181203114804.17078-1-p.zabel@pengutronix.de>
         <4acdd5bd4af28f33ae60d4ac244292e71dd9780d.camel@ndufresne.ca>
         <1546961428.5406.4.camel@pengutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-iyKbD3n0WplPI7arAqnk"
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-iyKbD3n0WplPI7arAqnk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 08 janvier 2019 =C3=A0 16:30 +0100, Philipp Zabel a =C3=A9crit :
> > # To demonstrate (with patched gst-plugins-bad https://paste.fedoraproj=
ect.org/paste/rs-CbEq7coL4XSKrnWpEDw)
> > gst-launch-1.0 videotestsrc ! video/x-raw,format=3DYUY2 ! v4l2convert !=
 video/x-raw,format=3DxRGB ! kmssink
>=20
> Is this with an old kernel? Since c525350f6ed0 ("media: imx: use well
> defined 32-bit RGB pixel format") that command line should make this
> select V4L2_PIX_FMT_XRGB32 ("BX24").

You can now discard this report. Starting from 5.0-rc2, this conversion
works.

Nicolas

--=-iyKbD3n0WplPI7arAqnk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXDz8YQAKCRBxUwItrAao
HNG8AKDKMzNd8qeWUcMAvC2JVRR+H9ArJACfWxmDxgCUfyHTn9qwPyw4EwsccJM=
=dR8l
-----END PGP SIGNATURE-----

--=-iyKbD3n0WplPI7arAqnk--

