Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E63FC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 17:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EE632087C
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 17:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553533783;
	bh=uibXXmgBYELjgOG0VY+mpQzazdrOespDLyLqF/PteHc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=lE00cRZwDmqDhaBYkkwgNF3JLRjrEw3cHo/RYl8Ho8+RSTzn9iAZwO9Ljl0w3LY2k
	 xJ7Jgvod6H39H5tyPmHsdvApP8hEUNL9ZvmcwcTex8dIQ+YpKmtA6QqkwHpQ+9wZl8
	 LgZIay3Vcx0+eUYv9nnSkRB9kcZ0zWRQe2yBkjiM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbfCYRJg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 13:09:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:48358 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730326AbfCYRIs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 13:08:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uibXXmgBYELjgOG0VY+mpQzazdrOespDLyLqF/PteHc=; b=dyZcC5wIW3ZQPfaUGbXuF4ywO8
        zhMO5odI9W5k73xUNUedJ7ezBhRPVuYZSZN7VlGOw6AgTqAlv+PMBLF3TALpkDg20kbVvrDQvoiHF
        Z1CWOABuC/trsrhjLEIe6PNhhSUTXhIIE/oqlBCmnqC3lTj3+05RMCCKp/RMU0rzhkF7rhjrK+Ii0
        uTgfN/YXhXMic4RLzSYUGPrOyCxm9gOob3ki0oKTRHYpBls7hSkW1ySP78u1ugS1JUX+idWE2bdUw
        QuQfNP2ZwqehjBkIwEtKB9qs6BAanv3ZHAm7vQH16pS3ZOR6yjv+M1jlfQ7VRK58aP0wzeqR1q+Rb
        IKqqsggw==;
Received: from 177.41.113.24.dynamic.adsl.gvt.net.br ([177.41.113.24] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h8T5Z-0000KO-O1; Mon, 25 Mar 2019 17:08:46 +0000
Date:   Mon, 25 Mar 2019 14:08:38 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Samuel CHEMLA <chemla.samuel@gmail.com>
Cc:     Gregor Jasny <gjasny@googlemail.com>, Sean Young <sean@mess.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [Bug report] dvbv5-zap crash dvb-tool ARMHF builds
Message-ID: <20190325140838.71f88eac@coco.lan>
In-Reply-To: <CANJnhGfRtEwAony5Z4rFMPcu58aF2k0G+9NSkMKsq_PhfmSNqw@mail.gmail.com>
References: <f4b69417-06c3-f9ab-2973-ae23d76088b8@gmail.com>
        <29bad771-843c-1dee-906c-6e9475aed7d8@gmail.com>
        <d291e164-993f-232a-f01b-0f8c17087004@googlemail.com>
        <20190315223425.hiq3qcjhjnirsizh@gofer.mess.org>
        <20190317065242.137cb095@coco.lan>
        <20190319164507.7f95af89@coco.lan>
        <a1f296ba-3c27-ed2c-3912-4edbeeb21eba@googlemail.com>
        <20190321094127.ysurm4u26zugmnmv@gofer.mess.org>
        <20190321083044.621f1922@coco.lan>
        <35ba4e81-fc2a-87ed-8da7-43cc4543de51@googlemail.com>
        <CANJnhGfRtEwAony5Z4rFMPcu58aF2k0G+9NSkMKsq_PhfmSNqw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Mon, 25 Mar 2019 17:33:30 +0100
Samuel CHEMLA <chemla.samuel@gmail.com> escreveu:

> Hi guys,
>=20
> I'm afraid I'm coming with sad news.
> I just tried both stable-1.12 and stable-1.16 on a raspberry pi 2, and
> random hangs are back (see https://bugs.launchpad.net/raspbian/+bug/18196=
50
> ).
> I previously test both branches on a raspberry zero and issues were gone
> (same raspbian version).
> There may be more memory issues somewhere...

Could you test it with valgrind?=20

>=20
> Sam
>=20
> Le jeu. 21 mars 2019 =C3=A0 20:59, Gregor Jasny <gjasny@googlemail.com> a=
 =C3=A9crit :
>=20
> > Hello,
> >
> > On 21.03.19 12:30, Mauro Carvalho Chehab wrote: =20
> > > I went ahead and cherry-picked the relevant patches to -1.12, -1.14 a=
nd
> > > -1.16, and tested both dvbv5-zap and dvbv5-scan with all versions. So=
, =20
> > we can =20
> > > release a new minor version for all those stable branches.
> > >
> > > After the patches, on my tests, I didn't get any memory leaks or
> > > double-free issues. =20
> >
> > I issues a new 1.12, 1.14, and 1.16 release.
> >
> > Thanks,
> > Gregor
> >
> > =20



Thanks,
Mauro
