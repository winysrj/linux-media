Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:32992 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754916AbcIVIvm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 04:51:42 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>
Subject: Re: solo6010 modprobe lockup since e1ceb25a (v4.3 regression)
References: <20160915130441.ji3f3jiiebsnsbct@acer>
        <9cbb2079-f705-5312-d295-34bc3c8dadb9@xs4all.nl>
        <m3k2e5wfxy.fsf@t19.piap.pl> <20160921134554.s3tdolyej6r2w5wh@zver>
Date: Thu, 22 Sep 2016 10:51:37 +0200
In-Reply-To: <20160921134554.s3tdolyej6r2w5wh@zver> (Andrey Utkin's message of
        "Wed, 21 Sep 2016 16:45:54 +0300")
Message-ID: <m360powc4m.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrey Utkin <andrey_utkin@fastmail.com> writes:

> It happens in solo_disp_init at uploading default motion thresholds
> array.
>
> I've got a prints trace with solo6010-fix-lockup branch
> https://github.com/bluecherrydvr/linux/tree/solo6010-fix-lockup/drivers/media/pci/solo6x10
> the trace itself in jpg:
> https://decent.im:5281/upload/3793f393-e285-4514-83dd-bf08d1c8b4a2/e7ad898b-515b-4522-86a9-553daaeb0860.jpg

solo_motion_config() uses BM DMA and thus generates IRQ, this may be
indeed the ISR problem. BTW the IRQ debugging ("kernel hacking") should
catch it.
OTOH programming the DMA can be guilty as well.

I wonder if the following fixes the problem (completely untested).

diff --git a/drivers/media/pci/solo6x10/solo6x10-core.c b/drivers/media/pci/solo6x10/solo6x10-core.c
index f50d072..2d4900e 100644
--- a/drivers/media/pci/solo6x10/solo6x10-core.c
+++ b/drivers/media/pci/solo6x10/solo6x10-core.c
@@ -99,6 +99,7 @@ static irqreturn_t solo_isr(int irq, void *data)
 {
 	struct solo_dev *solo_dev = data;
 	u32 status;
+	u16 tmp;
 	int i;
 
 	status = solo_reg_read(solo_dev, SOLO_IRQ_STAT);
@@ -129,6 +130,7 @@ static irqreturn_t solo_isr(int irq, void *data)
 	if (status & SOLO_IRQ_G723)
 		solo_g723_isr(solo_dev);
 
+	pci_read_config_word(solo_dev->pdev, PCI_STATUS, &tmp) // flush write to SOLO_IRQ_STAT
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/media/pci/solo6x10/solo6x10-p2m.c b/drivers/media/pci/solo6x10/solo6x10-p2m.c
index 07c4e07..8a51d45 100644
--- a/drivers/media/pci/solo6x10/solo6x10-p2m.c
+++ b/drivers/media/pci/solo6x10/solo6x10-p2m.c
@@ -70,6 +70,7 @@ int solo_p2m_dma_desc(struct solo_dev *solo_dev,
 	unsigned int config = 0;
 	int ret = 0;
 	int p2m_id = 0;
+	u16 tmp;
 
 	/* Get next ID. According to Softlogic, 6110 has problems on !=0 P2M */
 	if (solo_dev->type != SOLO_DEV_6110 && multi_p2m) {
@@ -111,6 +112,7 @@ int solo_p2m_dma_desc(struct solo_dev *solo_dev,
 			       desc[1].ctrl);
 	}
 
+	pci_read_config_word(solo_dev->pdev, PCI_STATUS, &tmp); // flush writes
 	timeout = wait_for_completion_timeout(&p2m_dev->completion,
 					      solo_dev->p2m_jiffies);
 

> Indeed, targeted fixing would be more reasonable than making register
> r/w routines follow blocking fashion. But the driver is already complete
> and was known to be working, and I seems all places in code assume the
> blocking fashion of reg r/w, and changing that assumption may lead to
> covert bugs anywhere else, not just at probing, which may be hard to
> nail down.

The driver code doesn't have to assume anything about posted writes -
except at very specific places (as explained by Alan).

Normally, a CPU write to a register doesn't have to be flushed right
away. It would be much slower, especially if used extensively. Nobody
does anything alike since the end of the ISA bus.
The driver (and the card) can still see all operations in correct
order, in both cases.

The potential problem is a write being held in a buffer (and not making
it to the actual hardware). This may happen in ISR since the actual
write is deactivates the physical IRQ line. Otherwise the ISR terminates
and is immediately requested again - though this second call should
bring the IRQ down by reading the register (thus flushing the write
buffer) - so, while not very effective, it shouldn't lock up (but it's
a real bug worth fixing).

Also, I imagine a write to the DMA registers can be posted and the DMA
may not start in time. This shouldn't end in a lock up, either. Perhaps
a different bug is involved.


The other thing is BM DMA (card->RAM). All DMA transfers (initiated by
the card) are completed with an IRQ (either with success or failure).
This is potentially a problem as well, though it has nothing to do with
the patch in question. I guess the SOLO reads some descriptors or
something, and such writes are flushed this way.

> For now, I'll try setting pci_read_config_word() back instead of full
> revert. Does it need to be just in reg_write? No need for it in
> reg_read, right?

Sure, reg_read() doesn't write to the device.

It the patch doesn't fix the problem, what CPU and chipset are used by
the computer which exhibits the issue? Perhaps I have something similar
here and can reproduce it.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
