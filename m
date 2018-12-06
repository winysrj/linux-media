Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD09C04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 19:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 131BF20989
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 19:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544123281;
	bh=j6D1aWFscqjCP3LMthKum42J+mKc0cki66GhTqYl1us=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=x75Ld9j5u/9MiAw/7iOaAxWwFZ5Su+5lDVdbwzzlhBraneMPpOvNtSpolgPtAUi3K
	 5todv/qgnDldxmILoRpkEOPQMAhEcaVB8VFI9mqKeQIdMvil7jepdY7Wmkb6ya6t05
	 /T14D9LPLGy8j10hE0n7/+EmBxIFZGkpm+cFVzkk=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 131BF20989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbeLFTIA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 14:08:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:51550 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbeLFTIA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 14:08:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kmlpV3Yi7LyJuYVZEkf4yVo+oMDLrzh9cFjf4yUmrOQ=; b=qkPjAUmfucZ6OJny+43a0g3/9Z
        QYnqXPDoQfs2WeMz5CVWOBxU+GCvOjbrArb6SkAQQT52FoU+Kbn1v4s2jN3U7PQ3gQ6HEa3quZgc2
        OGhZ7C/LLyU34p2IN9OubVCNr9tzQM4Jw//WXJ3BNqXJUsUdepFNK4s3UGLl/QAwab9F2Nkxp73X2
        7zkZwA1cAzLchjeWaDNYVhxx9wzc31UNzvSB8k0ZKE9dP6Xm/N48xtwNFemS/xHaOw03vca5ZODDC
        9pE0Lcag5T9InVz56ujn4AkfKuwhSksZnphFs1DJd8Pa+WZtDalthDbEk2pqEB/nPwAymFGRPzCoP
        V7Rvd1rw==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUz08-0003Pa-6a; Thu, 06 Dec 2018 19:07:56 +0000
Date:   Thu, 6 Dec 2018 17:07:52 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     markus.dobel@gmx.de, Brad Love <brad@nextdimension.cc>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall
 fixes
Message-ID: <20181206170752.1f3ac305@coco.lan>
In-Reply-To: <CADnq5_P-jQWQMLnJcESZf8ygPheE3F5XUq8isB9jXzCKa=L=Og@mail.gmail.com>
References: <3d7393a6287db137a69c4d05785522d5@gmx.de>
        <20181205090721.43e7f36c@coco.lan>
        <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc>
        <5528BC99-512E-4CEC-AE26-99D3991AB598@gmx.de>
        <20181206160145.2d23ac0e@coco.lan>
        <CADnq5_P-jQWQMLnJcESZf8ygPheE3F5XUq8isB9jXzCKa=L=Og@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 6 Dec 2018 13:36:24 -0500
Alex Deucher <alexdeucher@gmail.com> escreveu:

> On Thu, Dec 6, 2018 at 1:05 PM Mauro Carvalho Chehab <mchehab@kernel.org> wrote:
> >
> > Em Thu, 06 Dec 2018 18:18:23 +0100
> > Markus Dobel <markus.dobel@gmx.de> escreveu:
> >  
> > > Hi everyone,
> > >
> > > I will try if the hack mentioned fixes the issue for me on the weekend (but I assume, as if effectively removes the function).  
> >
> > It should, but it keeps a few changes. Just want to be sure that what
> > would be left won't cause issues. If this works, the logic that would
> > solve Ryzen DMA fixes will be contained into a single point, making
> > easier to maintain it.
> >  
> > >
> > > Just in case this is of interest, I neither have Ryzen nor Intel, but an HP Microserver G7 with an AMD Turion II Neo  N54L, so the machine is more on the slow side.  
> >
> > Good to know. It would probably worth to check if this Ryzen
> > bug occors with all versions of it or with just a subset.
> > I mean: maybe it is only at the first gen or Ryzen and doesn't
> > affect Ryzen 2 (or vice versa).  
> 
> The original commit also mentions some Xeons are affected too.  Seems
> like this is potentially an issue on the device side rather than the
> platform.

Maybe.

> >
> > The PCI quirks logic will likely need to detect the PCI ID of
> > the memory controllers found at the buggy CPUs, in order to enable
> > the quirk only for the affected ones.
> >
> > It could be worth talking with AMD people in order to be sure about
> > the differences at the DMA engine side.
> >  
> 
> It's not clear to me what the pci or platform quirk would do.  The
> workaround seems to be in the driver, not on the platform.

Yeah, the fix should be at the driver, but pci/quirk.c would be able
to detect memory controllers that would require a hack inside the
driver, in a similar way to what the media PCI drivers already do
for DMA controllers that don't support pci2pci transfers.

There, basically the PCI core (drivers/pci/pci.c and 
drivers/pci/quirks.c) sets a flag (pci_pci_problems) indicating
potential issues.

Then, the driver compares such flag in order to enable the specific quirk.

Ok, there would be a different way to handle it. The driver could use a 
logic similar to the one I wrote for drivers/edac/i7core_edac.c. There,
the logic seeks for some specific PCI device IDs using pci_get_device(),
adjusting the code accordingly, depending on the detected PCI devices.

In other words, running something like this (untested), at probe time should
produce similar results:

	/*
	 * FIXME: It probably makes sense to also be able to identify specific
	 * versions of the same PCI ID, just in case a latter stepping got a
	 * fix for the issue.
	 */
	const static struct {
		int vendor, dev;
	} broken_dev_id[] = {
		PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_foo,
		PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_bar,
	},

	bool cx23885_does_dma_require_reset(void) 
	{
		int i;
		struct pci_dev *pdev = NULL;

		for (i = 0; i < sizeof(broken_dev_id); i++) {
			pdev = pci_get_device(broken_dev_id[i].vendor, broken_dev_id[i].dev, NULL);
			if (pdev) {
				pci_put_device(pdev);
				return true;
			}
		}
		return false;
	}

Should work. In any case, we need to know what memory controllers 
have problems, and what are their PCI IDs, and add them (if not there yet)
at include/linux/pci_ids.h

Thanks,
Mauro
