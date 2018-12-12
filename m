Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A67C65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E2B82133F
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544617116;
	bh=p9G0kSXWPqAya4f3xH/yizkVckgDP6tG9e8/pvVSxnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Y7v2vy+FC13y7wqUnRRuFLsBNEnONNhEfbU64NvpkoanGBNEG8nWjWJ9BfggoJLcX
	 bKKYwpZARvI4Ua2e1bmbNO5aWkPUaQamRzd9z5nK9Yz6J6yI3UX+FFopnbv2azWSP1
	 ti3p7qwwuPBan8nJDNTPTlBR7wzPA5YxW9MYFbCA=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E2B82133F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbeLLMSf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 07:18:35 -0500
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:48830 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbeLLMSe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 07:18:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zEgb5zAT9T0+WqSg9YP8u3jc3YA95YJEC7h3cgn47Wk=; b=BrLe1HnDy6o2ARbdNOmjhPnGg
        LQ0osaCzp0xYJ58/CSUu+/cWla6q41p3oxqICI3k5Ox3rt8T/ctR/baYbilPWn7qFJfHIemROL38c
        kfpsI1NN3Ea767+AUZC8CJhqT4bJ2lz6QKF1hKcZ1lYl23PSMBsip6BUyT3nUHtJnt0Ts=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=debutante.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpa (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1gX3T9-0003bE-6U; Wed, 12 Dec 2018 12:18:27 +0000
Received: by debutante.sirena.org.uk (Postfix, from userid 1000)
        id 7BD381125535; Wed, 12 Dec 2018 12:18:26 +0000 (GMT)
Date:   Wed, 12 Dec 2018 12:18:26 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Daniel Scheller <d.scheller@gmx.net>,
        kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, linux-next@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-media@vger.kernel.org
Subject: Re: next-20181211 build: 1 failures 32 warnings (next-20181211)
Message-ID: <20181212121826.GC6920@sirena.org.uk>
References: <E1gWnrV-00086U-3m@optimist>
 <20181211220620.GS6686@sirena.org.uk>
 <20181211221535.GA20165@flashbox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Sr1nOIr3CvdE5hEN"
Content-Disposition: inline
In-Reply-To: <20181211221535.GA20165@flashbox>
X-Cookie: The greatest remedy for anger is delay.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--Sr1nOIr3CvdE5hEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 11, 2018 at 03:15:35PM -0700, Nathan Chancellor wrote:
> On Tue, Dec 11, 2018 at 10:06:20PM +0000, Mark Brown wrote:

> > in ddbridge-ci.c and some other media files.  This is because
> > ddbridge.h includes asm/irq.h but that does not directly include headers
> > which define the above types and it appears some header changes have
> > removed an implicit inclusion of those.  Moving the asm includes after
> > the linux ones in ddbridge.h fixes this though this appears to be
> > against the coding style for media.

> I sent a patch for this yesterday, I think moving the asm includes after
> the linux ones is the correct fix according to the rest of the kernel:
> https://lore.kernel.org/linux-media/20181210233514.3069-1-natechancellor@gmail.com/

> Hopefully it can be picked up quickly.

Ah, great - thanks.  I agree this is probably the best fix, I just
wasn't sure if the media people had some other idea given the coding
style there.

--Sr1nOIr3CvdE5hEN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlwQ/JEACgkQJNaLcl1U
h9B8UAf/bhQpTYfbdWBlxI3Hh+LREC2YOitdno0yQl0nOD3MKxv0Fkno4DYV/hkl
AWh0T5M4bytJ5O4vg6uj5XtMEpivN4LNCpK2wYeb1Q++qgtpBnogCxVTNxwFcLqv
t2Em9hv7W8v357Yrj0tinrXcrtR6pcphhlpi8Jx/gmqmWWnDh1XSumBDBrkwnyL+
sZGAU2xeSImKevproorKMMLPhXHEILnColHXqEgoI5/Nk/C9zsJh+fRsEguY/ly4
WiwWBKpQWiPkqhn75NqPofC3+47CYQPL2J0/88GeMMyn1N89t1i7lo4QuP/wsCBa
euu4kjI/V4qElksEKNg4conoD2Yw1Q==
=jOVL
-----END PGP SIGNATURE-----

--Sr1nOIr3CvdE5hEN--
