Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B5F1C04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 19:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECC9A20850
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 19:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544124734;
	bh=ZaMiXrZbMGVlVfZs32yxQ8zDyqVhjDPQ3CjXLHAOmK4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=aSNa4qtkL+B3V25Yu2B0/rUs1PTp6zJvijLvJVYPCeYrstk31i2Ym5enloLh1canu
	 nAoYa2+do+hVbagwKfZEioOnIEqlqEaLhIa4bN0bkPYE4SffSVbaHWnUMbGzRNrL6R
	 w+4m73vy5k6XW37BVmg+4sHtukng8lmYxNyyNipc=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECC9A20850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbeLFTcN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 14:32:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:53772 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbeLFTcN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 14:32:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ScIiRfaMECNqxzbOhDTZktFIyg5YSveLDpygGlUUWoQ=; b=sWiZd6qSBUnlEmNukEkjHo+r7z
        h7BD+pYyMFdEcubM+f55d/+zMba2Ac8kIuenq2tuoKw8EY7GWBeAtuPun/+SdO0kKl4g6ZIWSHKzs
        MxWgq4kw8Qvh0phsKTNzxcSSrmv0tagdIeU0QsOCryhaNLgQnRZ07RJnO+scI+iMH9vtThhBfffhE
        hROV2YyVjIU+Gn8kdGjpm8cTEtzSI/ooZTP47C0BLCwrggcshTiBPsbt6UVnF4BD0zD/pi+76wgbS
        tUTtCqqx5/prizgrfvnm+tnEo2DzjKJhAAWZTi/EpIge3qbhnbraYcsWPqFR6Cb7qU445ATsqvmke
        PxHwKhWA==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUzNY-0004LA-Ui; Thu, 06 Dec 2018 19:32:09 +0000
Date:   Thu, 6 Dec 2018 17:32:04 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     markus.dobel@gmx.de, Brad Love <brad@nextdimension.cc>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall
 fixes
Message-ID: <20181206173204.21b9366e@coco.lan>
In-Reply-To: <20181206170752.1f3ac305@coco.lan>
References: <3d7393a6287db137a69c4d05785522d5@gmx.de>
        <20181205090721.43e7f36c@coco.lan>
        <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc>
        <5528BC99-512E-4CEC-AE26-99D3991AB598@gmx.de>
        <20181206160145.2d23ac0e@coco.lan>
        <CADnq5_P-jQWQMLnJcESZf8ygPheE3F5XUq8isB9jXzCKa=L=Og@mail.gmail.com>
        <20181206170752.1f3ac305@coco.lan>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 6 Dec 2018 17:07:52 -0200
Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:

> Em Thu, 6 Dec 2018 13:36:24 -0500
> Alex Deucher <alexdeucher@gmail.com> escreveu:
> 
> > On Thu, Dec 6, 2018 at 1:05 PM Mauro Carvalho Chehab <mchehab@kernel.org> wrote:  
> > >
> > > Em Thu, 06 Dec 2018 18:18:23 +0100
> > > Markus Dobel <markus.dobel@gmx.de> escreveu:
> > >    
> > > > Hi everyone,
> > > >
> > > > I will try if the hack mentioned fixes the issue for me on the weekend (but I assume, as if effectively removes the function).    
> > >
> > > It should, but it keeps a few changes. Just want to be sure that what
> > > would be left won't cause issues. If this works, the logic that would
> > > solve Ryzen DMA fixes will be contained into a single point, making
> > > easier to maintain it.
> > >    
> > > >
> > > > Just in case this is of interest, I neither have Ryzen nor Intel, but an HP Microserver G7 with an AMD Turion II Neo  N54L, so the machine is more on the slow side.    
> > >
> > > Good to know. It would probably worth to check if this Ryzen
> > > bug occors with all versions of it or with just a subset.
> > > I mean: maybe it is only at the first gen or Ryzen and doesn't
> > > affect Ryzen 2 (or vice versa).    
> > 
> > The original commit also mentions some Xeons are affected too.  Seems
> > like this is potentially an issue on the device side rather than the
> > platform.  
> 
> Maybe.
> 
> > >
> > > The PCI quirks logic will likely need to detect the PCI ID of
> > > the memory controllers found at the buggy CPUs, in order to enable
> > > the quirk only for the affected ones.
> > >
> > > It could be worth talking with AMD people in order to be sure about
> > > the differences at the DMA engine side.
> > >    
> > 
> > It's not clear to me what the pci or platform quirk would do.  The
> > workaround seems to be in the driver, not on the platform.  
> 
> Yeah, the fix should be at the driver, but pci/quirk.c would be able
> to detect memory controllers that would require a hack inside the
> driver, in a similar way to what the media PCI drivers already do
> for DMA controllers that don't support pci2pci transfers.
> 
> There, basically the PCI core (drivers/pci/pci.c and 
> drivers/pci/quirks.c) sets a flag (pci_pci_problems) indicating
> potential issues.
> 
> Then, the driver compares such flag in order to enable the specific quirk.
> 
> Ok, there would be a different way to handle it. The driver could use a 
> logic similar to the one I wrote for drivers/edac/i7core_edac.c. There,
> the logic seeks for some specific PCI device IDs using pci_get_device(),
> adjusting the code accordingly, depending on the detected PCI devices.
> 
> In other words, running something like this (untested), at probe time should
> produce similar results:
> 
> 	/*
> 	 * FIXME: It probably makes sense to also be able to identify specific
> 	 * versions of the same PCI ID, just in case a latter stepping got a
> 	 * fix for the issue.
> 	 */
> 	const static struct {
> 		int vendor, dev;
> 	} broken_dev_id[] = {
> 		PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_foo,
> 		PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_bar,
> 	},
> 
> 	bool cx23885_does_dma_require_reset(void) 
> 	{
> 		int i;
> 		struct pci_dev *pdev = NULL;
> 
> 		for (i = 0; i < sizeof(broken_dev_id); i++) {
> 			pdev = pci_get_device(broken_dev_id[i].vendor, broken_dev_id[i].dev, NULL);
> 			if (pdev) {
> 				pci_put_device(pdev);
> 				return true;
> 			}
> 		}
> 		return false;
> 	}
> 
> Should work. In any case, we need to know what memory controllers 
> have problems, and what are their PCI IDs, and add them (if not there yet)
> at include/linux/pci_ids.h
> 
> Thanks,
> Mauro

To be clearer, I'm thinking on something like the (untested)
code below (untested).

PS.: the PCI ID used there may be wrong. I just added one in
order to have a proof of concept.

Thanks,
Mauro

[PATCH] media: cx23885: only reset DMA on problematic CPUs

It is reported that changeset 95f408bbc4e4 ("media: cx23885:
Ryzen DMA related RiSC engine stall fixes") caused regresssions
with other CPUs.

Ensure that the quirk will be applied only for the CPUs that
are known to cause problems.

Fixes: 95f408bbc4e4 ("media: cx23885: Ryzen DMA related RiSC engine stall fixes")
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 39804d830305..48da7d194cc1 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -23,6 +23,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kmod.h>
 #include <linux/kernel.h>
+#include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
@@ -603,8 +604,13 @@ static void cx23885_risc_disasm(struct cx23885_tsport *port,
 
 static void cx23885_clear_bridge_error(struct cx23885_dev *dev)
 {
-	uint32_t reg1_val = cx_read(TC_REQ); /* read-only */
-	uint32_t reg2_val = cx_read(TC_REQ_SET);
+	uint32_t reg1_val, reg2_val;
+
+	if (!dev->need_dma_reset)
+		return;
+
+	reg1_val = cx_read(TC_REQ); /* read-only */
+	reg2_val = cx_read(TC_REQ_SET);
 
 	if (reg1_val && reg2_val) {
 		cx_write(TC_REQ, reg1_val);
@@ -2058,6 +2064,31 @@ void cx23885_gpio_enable(struct cx23885_dev *dev, u32 mask, int asoutput)
 	/* TODO: 23-19 */
 }
 
+static struct {
+	int vendor, dev;
+} const broken_dev_id[] = {
+	/* According with
+	 * https://openbenchmarking.org/system/1703021-RI-AMDZEN08075/Ryzen%207%201800X/lspci,
+	 * 0x1451 is PCI ID for the IOMMU found on Ryzen 7
+	 */
+	{ PCI_VENDOR_ID_AMD, 0x1451 },
+};
+
+static bool cx23885_does_need_dma_reset(void)
+{
+	int i;
+	struct pci_dev *pdev = NULL;
+
+	for (i = 0; i < sizeof(broken_dev_id); i++) {
+		pdev = pci_get_device(broken_dev_id[i].vendor, broken_dev_id[i].dev, NULL);
+		if (pdev) {
+			pci_dev_put(pdev);
+			return true;
+		}
+	}
+	return false;
+}
+
 static int cx23885_initdev(struct pci_dev *pci_dev,
 			   const struct pci_device_id *pci_id)
 {
@@ -2069,6 +2100,8 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	if (NULL == dev)
 		return -ENOMEM;
 
+	dev->need_dma_reset = cx23885_does_need_dma_reset();
+
 	err = v4l2_device_register(&pci_dev->dev, &dev->v4l2_dev);
 	if (err < 0)
 		goto fail_free;
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index d54c7ee1ab21..cf965efabe66 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -451,6 +451,8 @@ struct cx23885_dev {
 	/* Analog raw audio */
 	struct cx23885_audio_dev   *audio_dev;
 
+	/* Does the system require periodic DMA resets? */
+	unsigned int		need_dma_reset:1;
 };
 
 static inline struct cx23885_dev *to_cx23885(struct v4l2_device *v4l2_dev)

