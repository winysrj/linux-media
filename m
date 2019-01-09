Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282F1C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECCFF206B6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547057881;
	bh=313J75pRSdWBx+s0b8l0AI9icPNGOqqYuBfcA0aYkkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wYDXgTzQV1tXz6/znssFK5+jvZKhWgbx8zUXMK+GKipBVpHLphPesgD/952NCTIvS
	 jYL6tnTboDDs6rKJ/P9go/yVvfuKw7xK3HRL2QB7DJGf9QgNqTjwRnsX9ZXTwdiMW9
	 s5U7U28zLiXdUlj9q5O8B3AClvuYtCzkaaLRGAZw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfAISRz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:17:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbfAISRy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 13:17:54 -0500
Received: from earth.universe (dyndsl-095-033-009-186.ewe-ip-backbone.de [95.33.9.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C50FD20859;
        Wed,  9 Jan 2019 18:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547057872;
        bh=313J75pRSdWBx+s0b8l0AI9icPNGOqqYuBfcA0aYkkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IxD1sY1xWGN1Xj1uhaGkjogiFUVrTr+rTdaZlCkVb+QmL2oWJW9xMEbAn2WBmxQKh
         JXjKYCvdoQ102NFbso0wQl/MRQFbMF0dqaMNCNXLSq+1lsLDDcsai50afnehBrRtUS
         TcMwM8XaxxBuEDGjFWyrYtXmGtODKfb4jxYnc95o=
Received: by earth.universe (Postfix, from userid 1000)
        id F18763C08E2; Wed,  9 Jan 2019 19:17:50 +0100 (CET)
Date:   Wed, 9 Jan 2019 19:17:50 +0100
From:   Sebastian Reichel <sre@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-bluetooth@vger.kernel.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] media: wl128x-radio: simplify
 fmc_prepare/fmc_release
Message-ID: <20190109181750.lqcm2bhg4wubuavu@earth.universe>
References: <20181221011752.25627-1-sre@kernel.org>
 <20181221011752.25627-11-sre@kernel.org>
 <20181222192934.GA15237@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a7a3feumpr3jovsz"
Content-Disposition: inline
In-Reply-To: <20181222192934.GA15237@amd>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--a7a3feumpr3jovsz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

On Sat, Dec 22, 2018 at 08:29:34PM +0100, Pavel Machek wrote:
> On Fri 2018-12-21 02:17:48, Sebastian Reichel wrote:
> > From: Sebastian Reichel <sebastian.reichel@collabora.com>
> >=20
> > Remove unused return code from fmc_prepare() and fmc_release() to
> > simplify the code a bit.
>=20
>=20
> >  /*
> >   * This function will be called from FM V4L2 release function.
> >   * Unregister from ST driver.
> >   */
> > -int fmc_release(struct fmdev *fmdev)
> > +void fmc_release(struct fmdev *fmdev)
> >  {
> >  	static struct st_proto_s fm_st_proto;
> >  	int ret;
> > =20
> >  	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
> >  		fmdbg("FM Core is already down\n");
> > -		return 0;
> > +		return;
> >  	}
> >  	/* Service pending read */
> >  	wake_up_interruptible(&fmdev->rx.rds.read_queue);
> > @@ -1611,7 +1606,6 @@ int fmc_release(struct fmdev *fmdev)
> >  		fmdbg("Successfully unregistered from ST\n");
> > =20
> >  	clear_bit(FM_CORE_READY, &fmdev->flag);
> > -	return ret;
> >  }
>=20
>=20
> You probably leave unused variable (ret) here. I guess that's okay as
> you remove it later in the series...?

It's still being used after this patch (but indeed removed in a
later patch).

> Also... I'd kind of expect _prepare routine to return int. Even if it
> currently does not do anything that could return error, I'd kind of
> expect allocations being done there...

well the driver is basically feature complete and all allocations
happen in probe :)

-- Sebastian

--a7a3feumpr3jovsz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlw2Os4ACgkQ2O7X88g7
+pqZzg//bTzS3nZUi6Vb7quyzAZCP2Af55tTDRC/h7KzMPLcFFYdQi6m6lg3rUir
gKRmQ7u+2a6CjclVTLAHfYUZ5au2MzUkhkoxcUPqVp6WJJDxCvnFHfyHBGoCVUXf
5TGCOOF89GtohkSGoONEIYQZXIy+MAOTGpvmCIHkbIKWQ37BT1mxqsoAYGEQ51wb
8qgQ0/hfhudtEqiP5qFQyxHJT3G3IXPuBQoBL/T/MZzkGP+XdL0KusXE4FNKUkgS
Ex8cvUsu88t1VKxQyLmi8UDPpLS4kG8dybC2lX9NZUcvupZgD8/YXK7XtrmKAQbB
NLFpAuIqvU5vsYRAuEGqMY5UxoLvdfVpNX4WhXk775bwuDJgwCWjusEyG7eBOx3A
1+Pv/K0ABOHe9bvc9uGpVjXQM5mmlLrBDxYfSGr14MW6ydc7MKqsY+M7aQl1yz2H
dYWAXVOaQY/vcFib8x6Ef2rPEbGTh1y8AaOm2rOTYP5NtWW/Z2b7UY8Egwbg/c7p
rcmlYTgEW1M+suekjnJlHk9LErLmN2mv/GnI9tdp1r0LTe09SuYRFh1wPVNrdX//
eVH7T900J2XHgvZDpDapwiuE0/rWgCeeWcIe4QIgIotWiygq8g1MLqbtkaL5SXyX
WzLSTuoTxhA70QnT7C2LS57UADMDhXjjDqryLhnZSmdxhu0g+LQ=
=/dmx
-----END PGP SIGNATURE-----

--a7a3feumpr3jovsz--
