Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:43477 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934366AbdKPUAA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 15:00:00 -0500
Received: by mail-qt0-f172.google.com with SMTP id n61so521988qte.10
        for <linux-media@vger.kernel.org>; Thu, 16 Nov 2017 12:00:00 -0800 (PST)
Message-ID: <1510862395.8053.39.camel@ndufresne.ca>
Subject: Re: [linux-sunxi] Cedrus driver
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Giulio Benetti <giulio.benetti@micronovasrl.com>
Cc: Andreas Baierl <list@imkreisrum.de>, linux-sunxi@googlegroups.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        thomas@vitsch.nl, linux-media@vger.kernel.org
Date: Thu, 16 Nov 2017 14:59:55 -0500
In-Reply-To: <20171116110204.poakahqjz4sj7pmu@flea>
References: <1510059543-7064-1-git-send-email-giulio.benetti@micronovasrl.com>
         <1b12fa21-bfe6-9ba7-ae1d-8131ac6f4668@micronovasrl.com>
         <6fcdc0d9-d0f8-785a-bb00-b1b41c684e59@imkreisrum.de>
         <693e8786-af83-9d77-0fd4-50fa1f6a135f@micronovasrl.com>
         <20171116110204.poakahqjz4sj7pmu@flea>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-pt46Lg9YAHMlu1JVn4N1"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-pt46Lg9YAHMlu1JVn4N1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 16 novembre 2017 =C3=A0 12:02 +0100, Maxime Ripard a =C3=A9crit :
> Assuming that the request API is in, we'd need to:
>   - Finish the MPEG4 support
>   - Work on more useful codecs (H264 comes to my mind)

For which we will have to review the tables and make sure they match
the spec (the easy part). But as an example, that branch uses a table
that merge Mpeg4 VOP and VOP Short Header. We need to make sure it does
not pause problems or split it up. On top of that, ST and Rockchip
teams should give some help and sync with these tables on their side.
We also need to consider decoder like Tegra 2. In H264, they don't need
frame parsing, but just the PPS/SPS data (might just be parsed in the
driver, like CODA ?). There is other mode of operation, specially in
H264/HEVC low latency, where the decoder will be similar, but will
accept and process slices right away, without waiting for the full
frame.

We also need some doc, to be able to tell the GStreamer and FFMPEG team
how to detect and handle these decoder. I doubt the libv4l2 proposed
approach will be used for these two projects since they already have
their own parser and would like to not parse twice. As an example, we
need to document that V4L2_PIX_FMT_MPEG2_FRAME implies using the
Request API and specific CID. We should probably also ping the Chrome
Devs, which probably have couple of pending branches around this.

regards,
Nicolas



--=-pt46Lg9YAHMlu1JVn4N1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWg3uOwAKCRBxUwItrAao
HHECAJwOUnKhoJ9VFvV+vJrW0glC6f4t/wCfZP+7PkLnwxrO2BUgXXTJ3ZJdnCM=
=UWFg
-----END PGP SIGNATURE-----

--=-pt46Lg9YAHMlu1JVn4N1--
