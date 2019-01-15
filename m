Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF41C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 17:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 980E420657
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 17:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547573001;
	bh=mnIGL5NMEyUrY0+Y0qlIEX4g8QnEdyAuThKhVwGh59c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=EljfMOMs5pAJvQSwefHbTKckyCa5WsMQS0ebJClb9xPrHD18bih0Dx3ljvBa9zJtb
	 Bm3rMzzg/QUbK5ycHKTZYcJLa8F+b0x84SHxD1qdRMv/tjVsITJkowdg/svhXJCZLj
	 9WH8tcIN2cbL+piU/fOy2C+2Snq+WBWycjVsyGlM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbfAORXQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 12:23:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:56610 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729434AbfAORXP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 12:23:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mnIGL5NMEyUrY0+Y0qlIEX4g8QnEdyAuThKhVwGh59c=; b=NzTsGaqgrgL61zze3lZTWhCMO4
        gqZTRAjFc7sVYkgdauIaQ909RSmzwxN3j9VjR1v70MUln/BjiknWsUXEol25ZyGoOTC9CkJP1b1CS
        8UV8l2PNU04JGEhnAzliFzGEwkYD10P+tPztWNckjeqWs+9JVrFum36PXijQOUM4EqFZXnCp1ZBsx
        qbDAFqb3TIMgUItNRFSy83JjMaHqMU68Ej5ivKDuuPp54jH8xo3WwFZOU3+Ianpk1pzurTGvf6jlh
        ZxCaZxszvD4E6yvttwvewz7SJFk0X7d8ohUUGpivO+q92+BWeAEjyS+N+p4prFv8D++0rPYcQcZP8
        VeqMTD4w==;
Received: from [186.213.247.186] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gjSQf-0007Mq-PR; Tue, 15 Jan 2019 17:23:10 +0000
Date:   Tue, 15 Jan 2019 15:23:05 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Antti Palosaari <crope@iki.fi>
Cc:     Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] si2157: add detection of si2177 tuner
Message-ID: <20190115152305.036117d3@coco.lan>
In-Reply-To: <6fd7ef13-ef56-db58-73f2-e0b9921b70ed@nextdimension.cc>
References: <1545343031-20935-1-git-send-email-brad@nextdimension.cc>
        <1545343031-20935-2-git-send-email-brad@nextdimension.cc>
        <7e3c07bd-b9be-d9fc-8d52-577825bbc315@iki.fi>
        <6fd7ef13-ef56-db58-73f2-e0b9921b70ed@nextdimension.cc>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 15 Jan 2019 10:32:01 -0600
Brad Love <brad@nextdimension.cc> escreveu:

> Hi Antti,
>=20
>=20
> On 09/01/2019 11.36, Antti Palosaari wrote:
> > On 12/20/18 11:57 PM, Brad Love wrote: =20
> >> Works in ATSC and QAM as is, DVB is completely untested.
> >>
> >> Firmware required.
> >>
> >> Signed-off-by: Brad Love <brad@nextdimension.cc>
> >> ---
> >> =C2=A0 drivers/media/tuners/si2157.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 6=
 ++++++
> >> =C2=A0 drivers/media/tuners/si2157_priv.h | 3 ++- =20
> >
> > =20
> >> =C2=A0 #define SI2158_A20_FIRMWARE "dvb-tuner-si2158-a20-01.fw"
> >> =C2=A0 #define SI2141_A10_FIRMWARE "dvb-tuner-si2141-a10-01.fw"
> >> -
> >> +#define SI2157_A30_FIRMWARE "dvb-tuner-si2157-a30-05.fw" =20
> >
> > Why you added 05 to that file name? I added that spare number for
> > cases you have to replace firmware to another for some reason thus by
> > default case it should be 01.
> > =20
>=20
> Barring any explanation of the naming convention, I made it look similar
> to the previous two, while reflecting the firmware version. This is
> firmware 3.0.5. I have no problem "starting from 1", but reflecting the
> firmware version seemed like the sane idea. I'll resubmit if desired.

Hi Antti,

Whatever firmware name convention policy you decide works for me, but
it would be really cool if you could send a patch ading a comment just
before the firmware naming macros documenting it, as it would avoid=20
further discussions and patch resubmissions ;-)

Thanks,
Mauro
