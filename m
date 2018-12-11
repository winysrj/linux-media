Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138DBC6783B
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 22:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C82E62084E
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 22:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544566004;
	bh=r43q6rHgsV0i+2+LQ7gn0mqdvn+SLog7CSCJjoNmckY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1GSkbDUiaRC3zOak1vdqV4Z/ErJG/1Y7+Y5AgupkVJFeYWNqgI0FYQrVb6UgIlZj2
	 E4lGjBemP33JkCerFXF3c+PSH7XceNPqU1OKrkn58YM9xpIiFtsYoC7Zx8RfliJn5S
	 S8nQp9JkHpm/CLj/4HSxLnUFrB1LcxvmmktqJqYk=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C82E62084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbeLKWGn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 17:06:43 -0500
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:59918 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeLKWGl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 17:06:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1a5LI433qsniaJpxptBQzNkDdDlyUwQqgrCDn64a2cg=; b=kz1a0G0aS4wx7eoG6EdVxTJcF
        RSvPEETn96WASQltJzCBkelQGfHH2YmT6DfAs7xmnFdykze1cFIrdXUzX5JZkDr/ykEPMKyIHilS7
        XtSL17ZqR7OyiIWRLEEfL54LylwelkVjP1uZWM7QO8D+FwW4dwEWEnLXHT1WCz7U5Lz+8=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=debutante.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpa (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1gWqAX-0001kk-3I; Tue, 11 Dec 2018 22:06:21 +0000
Received: by debutante.sirena.org.uk (Postfix, from userid 1000)
        id 81847112540E; Tue, 11 Dec 2018 22:06:20 +0000 (GMT)
Date:   Tue, 11 Dec 2018 22:06:20 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Daniel Scheller <d.scheller@gmx.net>
Cc:     kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, linux-next@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-media@vger.kernel.org
Subject: Re: next-20181211 build: 1 failures 32 warnings (next-20181211)
Message-ID: <20181211220620.GS6686@sirena.org.uk>
References: <E1gWnrV-00086U-3m@optimist>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="daC8KDjlMyCcZyAo"
Content-Disposition: inline
In-Reply-To: <E1gWnrV-00086U-3m@optimist>
X-Cookie: Immanuel doesn't pun, he Kant.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--daC8KDjlMyCcZyAo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 11, 2018 at 07:38:33PM +0000, Build bot for Mark Brown wrote:

Today's -next fails to build an arm allmodconfig due to:

> 	arm-allmodconfig
> ../arch/arm/include/asm/irq.h:35:50: error: unknown type name 'cpumask_t'
> ../arch/arm/include/asm/irq.h:36:9: error: unknown type name 'bool'
> ../arch/arm/include/asm/irq.h:35:50: error: unknown type name 'cpumask_t'
> ../arch/arm/include/asm/irq.h:36:9: error: unknown type name 'bool'
> ../arch/arm/include/asm/irq.h:35:50: error: unknown type name 'cpumask_t'
> ../arch/arm/include/asm/irq.h:36:9: error: unknown type name 'bool'
> ../arch/arm/include/asm/irq.h:35:50: error: unknown type name 'cpumask_t'
> ../arch/arm/include/asm/irq.h:36:9: error: unknown type name 'bool'

in ddbridge-ci.c and some other media files.  This is because
ddbridge.h includes asm/irq.h but that does not directly include headers
which define the above types and it appears some header changes have
removed an implicit inclusion of those.  Moving the asm includes after
the linux ones in ddbridge.h fixes this though this appears to be
against the coding style for media.

--daC8KDjlMyCcZyAo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlwQNNsACgkQJNaLcl1U
h9BIhAf/QxLriJgoTE64TXKs4ezWsRnAcKuzXFd4w9zMxqvclE6DzD4fm+SWAq5G
tt93m2jwK8z2TPI1CswtNqTJJB0x3gEwoj9LRnxA0z8W+1PuzS9urBgkxDUdJWQN
9/1v3c0sTzCgBKHcALmQTZdOEQroYfo6YLRDqmWY6W2sPciAlHOBtZePsScCYJZs
dc7bQQiC7G+9WhYqAB6AVjDT/gJy/X9Qz02BkKswOrmmi75r2eICVkYH64QZiCni
hTSMu7ucS8EDBWUE5Mqma9Hpv5Uii35Ts8r15V0mtj3XopczqDrIikauAC0jcCFu
ju9LRTsWKyf8vQU1Lae9yH0afyzBVA==
=kNcS
-----END PGP SIGNATURE-----

--daC8KDjlMyCcZyAo--
