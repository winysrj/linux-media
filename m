Return-Path: <SRS0=vP0A=OZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA13C43387
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 14:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29F64217F9
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 14:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544970205;
	bh=KY0PafWuY8mgM0nXKr8HpoBR+97RSbkmgMLGqH1Gl90=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=PNNdJ8fPyvPBikOWp68Xqd2dt4RnfHmFYCgQYpdZUmxiGJrzahryRgC0f1tntBpX5
	 hMYuGbQ3EwXrMKSQtmL9IoPQf0YUgtuKVB55Nb174DcOjYUYkyFUF7kVkEWUnLfc1j
	 pKa9SiF5BvZAWg5PqoT/V4zgFIPzNZjp/nS6juMY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbeLPOXY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 16 Dec 2018 09:23:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:46664 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbeLPOXY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Dec 2018 09:23:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3S+2h8FWzpbgU2S8+Augw+jqr2useME1ECgtMoSNx3E=; b=S4l7raCOUawRd69fdJq+9LBFOE
        59cXlIntu/Ru8JlDUKL1vsRWAee65PUeM4SbpKHX7aALIIlkm/5kyDuSHMqmBeMJKjz1Rcfqzhncy
        vTZUs8Q95FHwCrd1cGko3I4bga9EmiAVeMdHhtgS87H8r+av6kD5t7357zfHbs2o2pp4vOeInAsWy
        swTM9uoX2UqXMfdA9CYBemQKwKr5YkNqgr6nIyYhLtAwHA0Hi1Jr/e3WxB8XJ8RUSFbkTkJY6u9uK
        95ah+5pWyqw5l/FCCXiNZjf9Mgs/NiujnkGe0hg5NP46/KYdxxrVy/2yOMqyc6qRnPexSvhFbk637
        tmH2TKfg==;
Received: from 177.96.232.231.dynamic.adsl.gvt.net.br ([177.96.232.231] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gYXKC-00010e-TT; Sun, 16 Dec 2018 14:23:21 +0000
Date:   Sun, 16 Dec 2018 12:23:15 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Markus Dobel <markus.dobel@gmx.de>,
        Brad Love <brad@nextdimension.cc>,
        Alex Deucher <alexdeucher@gmail.com>
Cc:     linux-media@vger.kernel.org, linux-media-owner@vger.kernel.org
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall
 fixes
Message-ID: <20181216122315.2539ae80@coco.lan>
In-Reply-To: <8858694d5934ce78e46ef48d6f90061a@gmx.de>
References: <3d7393a6287db137a69c4d05785522d5@gmx.de>
        <20181205090721.43e7f36c@coco.lan>
        <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc>
        <5528BC99-512E-4CEC-AE26-99D3991AB598@gmx.de>
        <20181206160145.2d23ac0e@coco.lan>
        <8858694d5934ce78e46ef48d6f90061a@gmx.de>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Sun, 16 Dec 2018 11:37:02 +0100
Markus Dobel <markus.dobel@gmx.de> escreveu:

> On 06.12.2018 19:01, Mauro Carvalho Chehab wrote:
> > Em Thu, 06 Dec 2018 18:18:23 +0100
> > Markus Dobel <markus.dobel@gmx.de> escreveu:
> >  =20
> >> Hi everyone,
> >>=20
> >> I will try if the hack mentioned fixes the issue for me on the weekend=
=20
> >> (but I assume, as if effectively removes the function). =20
> >=20
> > It should, but it keeps a few changes. Just want to be sure that what
> > would be left won't cause issues. If this works, the logic that would
> > solve Ryzen DMA fixes will be contained into a single point, making
> > easier to maintain it. =20
>=20
> Hi,
>=20
> I wanted to have this setup running stable for a few days before=20
> replying, that's why I am answering only now.
>=20
> But yes, as expected, with Mauro's hack, the driver has been stable for=20
> me for about a week, with several
> scheduled recordings in tvheadend, none of them missed.
>=20
> So, adding a reliable detection for affected chipsets, where the `if=20
> (1)` currently is, should work.

Markus,

Thanks for testing!

Brad/Alex,

I guess we should then stick with this patch:
	https://patchwork.linuxtv.org/patch/53351/

The past approach that we used on cx88, bttv and other old drivers
were to patch drivers/pci/quirks.c, making them to "taint" DMA
memory controllers that were known to bad affect on media devices,
and then some logic at the drivers to check for such "taint".

However, that would require to touch another subsystem, with
usually cause delays. Also, as Alex pointed, this could well
be just a matter of incompatibility between the cx23885 and
the Ryzen DMA controller, and may not affect any other drivers.

So, let's start with a logic like what I proposed, fine
tuning it to the Ryzen DMA controllers with we know have
troubles with the driver.=20

We need to list the PCI ID of the memory controllers at the
device ID table on that patch, though. At the RFC patch,
I just added an IOMMU PCI ID from a randon Ryzen CPU:

	+static struct {
	+	int vendor, dev;
	+} const broken_dev_id[] =3D {
	+	/* According with
	+	 * https://openbenchmarking.org/system/1703021-RI-AMDZEN08075/Ryzen%207%=
201800X/lspci,
	+	 * 0x1451 is PCI ID for the IOMMU found on Ryzen 7
	+	 */
	+	{ PCI_VENDOR_ID_AMD, 0x1451 },
	+};
	+

Ideally, the ID for the affected Ryzen DMA engines should be there at
include/linux/pci_ids.h, instead of hard-coded inside a driver.

Also, we should, instead, add there the PCI IDs of the DMA engines
that are known to have problems with the cx23885.

There one thing that still bothers me: could this problem be due to
some BIOS setup [1]? If so, are there any ways for dynamically
disabling such features inside the driver?

[1] like this: https://www.techarp.com/bios-guide/cpu-pci-write-buffer/

Brad,

=46rom your reports about the DMA issues, do you know what generations
of the Ryzen are affected?=20

Alex,

Do you know if are there any differences at the IP block for the
DMA engine used on different Ryzen CPUs? I mean: I suspect that
the engine for Ryzen 2nd generation would likely be different than=20
the one at the 1st generation, but, along the same generation, does
the Ryzen 3, 5, 7 and Threadripper use the same DMA engine?

Thanks,
Mauro
