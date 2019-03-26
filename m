Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B17C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 15:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DF9520811
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 15:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553614283;
	bh=lQMOqh+hlgw0S72UVHMR16JQw6kaBOzjAj0JPKR2Qvw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=oQtff1HH0mIm8MovpfgHq9AJZ/7ZyDW+eyTGKpyOZ5Vx4RoT7oaFRD3iJQSmGfd57
	 xVFEQibWaggmfq6J3eqRuAe6rejoNvt/83JwmBzbf/tMPIi6+1pDA0Ul3XmkR8e9MG
	 tZ3xVxSpMX8+deKdYWG1rIlntKVIH+RXHc76dwhM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732213AbfCZPbX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:31:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:42538 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731599AbfCZPbW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 11:31:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Zl9TLIBDigLqQ3WxbGnrp7CcC0iG6j6LTLuwijtuDiQ=; b=HKMUEk83X4Eux2/1MFUA12ssn2
        hZEVjcodB/40lmPQ6VcIbUjEQFUnhI124kg0evdVhet18NflTEtvL9c1mCdsgcK2QRDEGbeBKeUuu
        FmIMzfYOmNAZBDB0+dTCDIQ3taXNSVYwCg0ruWk982AKHZZjq4X2kOxIcXh85Og2vjggsAm+VeAxN
        Hxr5pivUzJiFbaQFPCw7y3NLic4j6K80+O1B+qrfIVhpfH6OWBx2Lo8vxwd8pnVA2nm4wA5OlwBcy
        9irvK71skUE+vQVzqclHkWOYRbp/2rVL5kRkIj8JUPM/GZROONieERygBTz74JrI8Rlu3zRuy30s9
        X0giG1kg==;
Received: from 177.41.113.24.dynamic.adsl.gvt.net.br ([177.41.113.24] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h8o2p-0008Oq-Re; Tue, 26 Mar 2019 15:31:20 +0000
Date:   Tue, 26 Mar 2019 12:31:15 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Samuel CHEMLA <chemla.samuel@gmail.com>
Cc:     Sean Young <sean@mess.org>, Gregor Jasny <gjasny@googlemail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [Bug report] dvbv5-zap crash dvb-tool ARMHF builds
Message-ID: <20190326123115.5d83f450@coco.lan>
In-Reply-To: <CANJnhGfgzrLZedeoCOq3L-MaEgjtHm1Bwn1cRPr54LvwZ=RBMQ@mail.gmail.com>
References: <20190315223425.hiq3qcjhjnirsizh@gofer.mess.org>
        <20190317065242.137cb095@coco.lan>
        <20190319164507.7f95af89@coco.lan>
        <a1f296ba-3c27-ed2c-3912-4edbeeb21eba@googlemail.com>
        <20190321094127.ysurm4u26zugmnmv@gofer.mess.org>
        <20190321083044.621f1922@coco.lan>
        <35ba4e81-fc2a-87ed-8da7-43cc4543de51@googlemail.com>
        <CANJnhGfRtEwAony5Z4rFMPcu58aF2k0G+9NSkMKsq_PhfmSNqw@mail.gmail.com>
        <20190325140838.71f88eac@coco.lan>
        <CANJnhGc_qx32nm7yZheC2ioHOij8QELbnwyJkZ83G9uYTxqwtA@mail.gmail.com>
        <20190326132643.r3svehoa764xagje@gofer.mess.org>
        <CANJnhGfgzrLZedeoCOq3L-MaEgjtHm1Bwn1cRPr54LvwZ=RBMQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 26 Mar 2019 16:10:33 +0100
Samuel CHEMLA <chemla.samuel@gmail.com> escreveu:

> Hi,
>=20
>=20
> > Earlier you said "random hangs are back". When this happens, does the w=
hole
> > device become unresponsive or just dvbv5-zap? =20
> The device completely freeze, you can't even switch numlock on/off.

dvbv5-tools can't hang the machine. this is very likely happening due to
a Kernel crash.

> I said "the issue is back", it is because I **thought** it was gone.
> To be more precise:
> - on raspberry zero W, the issue is gone since Mauro's patch
> (https://git.linuxtv.org/v4l-utils.git/commit/?id=3D22b06353227e04695b1b0=
a9622b896b948adba89)
> - on raspberry 2, the issue, it is still there and the patch has no
> effect (the issue was and is still there)

RPi2 has a serious issue with their USB ports: on devices that require
more than a few mW to work, it causes several device disconnection and
re-connection, as it cannot sustain the required 5V.

Depending on how fast this happens, it could be triggering some Kernel
bug.

That affects most V4L and DVB devices. You should either use a powered
USB 2.0 hub (with may be problematic, as the USB host driver on RPi
has issues - and may cause data loss on high sustained ISOC traffic,
specially when used with hubs) or a device that has its own power
supply, like DVBSky T680C or S960.=20

> > Since this issue is "back",
> > I wouldn't be surprised this is unrelated to the fixes in 1.12.7 and 1.=
16.4. =20
> The issue doesn't appear anymore on raspberry zero W since Mauro's commit.
> So it did improve on that platform.
>=20
> > It would be useful to see the output from dmesg (best thing would be af=
ter
> > the issue occurs). =20
> You can't, device is frozen.
> Logs are not flushed to disk, and journalctl -f freeze before showing any=
thing

You can use a serial port in order to get the logs. On a serial console,
use something like:

	# dmesg -n 8

In order to make sure it will display all Kernel messages at console.

>=20
> > Also what dvb hardware are you using? =20
> I reproduced it with different two tuners: rtl2832U from RTL-SDR.COM
> and a TerraTec Cinergy T Stick+

None of them supports an external power supply.

> You can found all the details here:
> https://bugs.launchpad.net/raspbian/+bug/1819650
>=20
>=20
> Sam
>=20
>=20
> Le mar. 26 mars 2019 =C3=A0 14:26, Sean Young <sean@mess.org> a =C3=A9cri=
t :
> >
> > Hi Sam,
> >
> > On Tue, Mar 26, 2019 at 08:35:44AM +0100, Samuel CHEMLA wrote: =20
> > > Hi,
> > >
> > >
> > > I am struggling with valgrind because it always complain with either :
> > >     ASan runtime does not come first in initial library list; you
> > > should either link runtime to your application or manually preload it
> > > with LD_PRELOAD =20
> > >     -> When I LD_PRELOAD, I'm getting a segfault, but I couldn't find=
 =20
> > > any core dump
> > >
> > > or, if I link statically libasan with -static-libasan:
> > >     Shadow memory range interleaves with an existing memory mapping.
> > > ASan cannot proceed correctly. ABORTING.
> > >     ASan shadow was supposed to be located in the
> > > [0x00007fff7000-0x10007fff7fff] range.
> > >
> > >
> > > I retested again on my raspberry zero W, and I confirm i cannot
> > > reproduce the hang.
> > > Your fix did work on that device.
> > > I am testing with same OS (raspbian with latest updates, same kernel),
> > > same configure options, same USB dongle... :-(
> > > The only differences are CPU architecture (armv6 vs armv7), memory
> > > constraints, and I was not using the same channels.conf, I'll fix that
> > > today and re-check =20
> >
> > Earlier you said "random hangs are back". When this happens, does the w=
hole
> > device become unresponsive or just dvbv5-zap? Since this issue is "back=
",
> > I wouldn't be surprised this is unrelated to the fixes in 1.12.7 and 1.=
16.4.
> >
> > It would be useful to see the output from dmesg (best thing would be af=
ter
> > the issue occurs).
> >
> > Also what dvb hardware are you using?
> >
> > Thanks,
> >
> > san
> > =20
> > >
> > >
> > > Sam
> > >
> > > On 25/03/2019 18:08, Mauro Carvalho Chehab wrote:
> > >
> > > Em Mon, 25 Mar 2019 17:33:30 +0100
> > > Samuel CHEMLA <chemla.samuel@gmail.com> escreveu:
> > >
> > > Hi guys,
> > >
> > > I'm afraid I'm coming with sad news.
> > > I just tried both stable-1.12 and stable-1.16 on a raspberry pi 2, and
> > > random hangs are back (see https://bugs.launchpad.net/raspbian/+bug/1=
819650
> > > ).
> > > I previously test both branches on a raspberry zero and issues were g=
one
> > > (same raspbian version).
> > > There may be more memory issues somewhere...
> > >
> > > Could you test it with valgrind?
> > >
> > > Sam
> > >
> > > Le jeu. 21 mars 2019 =C5=95 20:59, Gregor Jasny <gjasny@googlemail.co=
m> a =C3=A9crit :
> > >
> > > Hello,
> > >
> > > On 21.03.19 12:30, Mauro Carvalho Chehab wrote:
> > >
> > > I went ahead and cherry-picked the relevant patches to -1.12, -1.14 a=
nd
> > > -1.16, and tested both dvbv5-zap and dvbv5-scan with all versions. So,
> > >
> > > we can
> > >
> > > release a new minor version for all those stable branches.
> > >
> > > After the patches, on my tests, I didn't get any memory leaks or
> > > double-free issues.
> > >
> > > I issues a new 1.12, 1.14, and 1.16 release.
> > >
> > > Thanks,
> > > Gregor
> > >
> > >
> > >
> > > Thanks,
> > > Mauro =20



Thanks,
Mauro
