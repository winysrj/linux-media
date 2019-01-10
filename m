Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04323C43444
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 17:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA46F20657
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 17:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547142195;
	bh=DcwRp4geh15gjmpDaSUBHFzXU/i/OwLPXS3EmX1LQwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Z4wXpoR3aVbTesQWSG+cwP76bNQ2wbPhys/b/w11c31dBjZnjJfUG5GQTjhMFL8G1
	 eYm0HldYN9fGcvBd0V3MIB82ttJauVaKNZTWgIn9cEwkJ/a6zbjAqWJTgXcw70qyqC
	 t0sKg68DtjbJWh8mofzRh3tOcDjEwMS+nhH5+z9A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbfAJRmE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 12:42:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbfAJRmD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 12:42:03 -0500
Received: from earth.universe (host-091-097-085-127.ewe-ip-backbone.de [91.97.85.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8761420685;
        Thu, 10 Jan 2019 17:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547142122;
        bh=DcwRp4geh15gjmpDaSUBHFzXU/i/OwLPXS3EmX1LQwA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z0YfJeTBkQ+A3FTSuWLZgZR3/fp5HLmoKRkcyt66p/2ojMri9B+3ZadNAqD8jqByw
         UH79eALqI+bofOzbJ8x5bn0LdYrWD+F/oD6k/qDYWywHDVXWnUiSw2ACm/yK2l57kH
         vE7bVgnMM3RfTc4d8/MH8XPtb2s71I9utdz8gNCM=
Received: by earth.universe (Postfix, from userid 1000)
        id 973C33C08E2; Thu, 10 Jan 2019 18:42:00 +0100 (CET)
Date:   Thu, 10 Jan 2019 18:42:00 +0100
From:   Sebastian Reichel <sre@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-bluetooth@vger.kernel.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] Add support for FM radio in hcill and kill TI_ST
Message-ID: <20190110174200.dtabgkcsvci7ptf5@earth.universe>
References: <20181221011752.25627-1-sre@kernel.org>
 <20181222200827.GC15237@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="izgndclbtthitgpl"
Content-Disposition: inline
In-Reply-To: <20181222200827.GC15237@amd>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--izgndclbtthitgpl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Dec 22, 2018 at 09:08:28PM +0100, Pavel Machek wrote:
> Merry Christmas!
>=20
> > This moves all remaining users of the legacy TI_ST driver to hcill (pat=
ches
> > 1-3). Then patches 4-7 convert wl128x-radio driver to a standard platfo=
rm
> > device driver with support for multiple instances. Patch 7 will result =
in
> > (userless) TI_ST driver no longer supporting radio at runtime. Patch 8-=
11 do
> > some cleanups in the wl128x-radio driver. Finally patch 12 removes the =
TI_ST
> > specific parts from wl128x-radio and adds the required infrastructure t=
o use it
> > with the serdev hcill driver instead. The remaining patches 13 and 14 r=
emove
> > the old TI_ST code.
> >=20
> > The new code has been tested on the Motorola Droid 4. For testing the a=
udio
> > should be configured to route Ext to Speaker or Headphone. Then you nee=
d to
> > plug headphone, since its cable is used as antenna. For testing there i=
s a
> > 'radio' utility packages in Debian. When you start the utility you need=
 to
> > specify a frequency, since initial get_frequency returns an error:
> >=20
> > $ radio -f 100.0
>=20
> Ok, it seems  the driver does not work built-in, due to firmware issue:
>=20
> root@devuan:/home/user# dmesg | grep wl12
> [    1.018951] reg-fixed-voltage regulator-wl12xx: GPIO lookup for
> consumer (null)
> [    1.026550] reg-fixed-voltage regulator-wl12xx: using device tree
> for GPIO lookup
> [    1.034271] of_get_named_gpiod_flags: can't parse 'gpios' property
> of node '/regulator-wl12xx[0]'
> [    1.043487] of_get_named_gpiod_flags: parsed 'gpio' property of
> node '/regulator-wl12xx[0]' - status (0)
> [    4.151885] wl12xx_driver wl12xx.1.auto: Direct firmware load for
> ti-connectivity/wl128x-nvs.bin failed with error -2
> [   11.368286] vwl1271: disabling
> root@devuan:/home/user# find /lib/firmware/ | grep wl128
> /lib/firmware/ti-connectivity/wl128x-fw-5-plt.bin
> /lib/firmware/ti-connectivity/wl128x-fw-5-mr.bin
> /lib/firmware/ti-connectivity/wl128x-fw-5-sr.bin
> /lib/firmware/ti-connectivity/wl128x-nvs.bin
> root@devuan:/home/user#
>
> Ideas welcome... ... ... am I supposed to compile wl128-nvs.bin into
> the kernel using EXTRA_FIRMWARE?

This is due to the driver loading before the rootfs is available.
You can workaround this without touching your kernel configuration by
rebinding the driver via sysfs: https://lwn.net/Articles/143397/

-- Sebastian

--izgndclbtthitgpl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlw3g+UACgkQ2O7X88g7
+pp02A/+LdobdlOclsOQ8qABdONlxr5vq+1EKYO1Ndt4hVsVlwFnwdgiYe8hePbP
Jwm7B54dSKqNB6PvM+R2+Z8wdx9Dj5J7yeFEZTukU+HvVlydS+DC+puJeMAxl34C
pxciUELVgRWb5bAjvEAkGxCVCgl3g46O2rlP5SCGT+wK3+U70QweN5JuYCHUOuZl
4bmfFvJJsAUsgWT/7skv7sFYxkeYtf6sVd8t4B3kuEhz3zygglFT6vJ23Mz1GSKn
7txon8q33fRIuGtFgxDdqluXK6p/Jey5UvVck2CGoy2CI2D44B6FcpcwsuMQ2lS5
qq+rzBUlR6PptlDp490VM0AfJjSpqVj+kZ4VJJOAZJhHSVV8C8NZ0SNMLMqkxWRo
ype8zG3qk8OA+NffHxe/eYO/HRySixTM/3uRe23SLrtzESy4crUBsED3erxHdLLd
yIMVAkEOBLh7zDonKzhRAxAbWp1vc7HTJ90EQ1PeD9i+nSYlQWTLsKIp/ClYikk5
eOaQ5BsojO/9MSH+yoJ/+kUbmtCvo1e4hFD2EJ3S6p2yxJ1qjMK8QuKeSpuW4hYE
veV79BoXBmfn0qYUze2PICUDrtjAZW0DYeD1qfxJFjt0In2ajyR42ZrOkhWgwxSO
DcreKJaLjVFe4hPRp9DuzpdNAaLWeKDHfXlLEEa0BQ2uP2wwdLw=
=pHLn
-----END PGP SIGNATURE-----

--izgndclbtthitgpl--
