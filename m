Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36792 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbZKJP2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 10:28:35 -0500
Received: by ewy3 with SMTP id 3so133024ewy.37
        for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 07:28:39 -0800 (PST)
Date: Tue, 10 Nov 2009 16:28:36 +0100
From: Domenico Andreoli <cavokz@gmail.com>
To: Roman Gaufman <hackeron@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: tw68-v2/tw68-i2c.c:145: error: unknown field
 ???client_register??? specified in initializer
Message-ID: <20091110152836.GA6860@raptus.dandreoli.com>
References: <921ad39e0911100419p3ca39ea4ycd5ac84322555fc2@mail.gmail.com>
 <b40acdb70911100426w46119c79y4226088ca3196254@mail.gmail.com>
 <921ad39e0911100440v6f146d1ci5858517cffdc0457@mail.gmail.com>
 <b40acdb70911100450i4902900eu92c3529de9b5b9a0@mail.gmail.com>
 <921ad39e0911100516i6e930650m65b5e133d581f93e@mail.gmail.com>
 <921ad39e0911100548i6f115aduba39b3b7fc570f58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <921ad39e0911100548i6f115aduba39b3b7fc570f58@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 10, 2009 at 01:48:43PM +0000, Roman Gaufman wrote:
> I swapped my graphics card and techwell DVR card places and now it
> works, thanks you!!!

could you please try the following patch swapping the boards back to
the original order?

--- a/tw68-core.c
+++ b/tw68-core.c
@@ -695,8 +695,7 @@ static int __devinit tw68_initdev(struct pci_dev *pci_dev,
        tw68_hw_init1(dev);
 
        /* get irq */
-       err = request_irq(pci_dev->irq, tw68_irq,
-                         IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
+       err = request_irq(pci_dev->irq, tw68_irq, IRQF_SHARED, dev->name, dev);
        if (err < 0) {
                printk(KERN_ERR "%s: can't get IRQ %d\n",
                       dev->name, pci_dev->irq);

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
