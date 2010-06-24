Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:36996 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961Ab0FXMcy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jun 2010 08:32:54 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1ORlbv-0007Dm-4K
	for linux-media@vger.kernel.org; Thu, 24 Jun 2010 14:32:51 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 24 Jun 2010 14:32:51 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 24 Jun 2010 14:32:51 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: CI-Module not working on Technisat Cablestar HD2
Date: Thu, 24 Jun 2010 14:32:39 +0200
Message-ID: <87r5jw4nmg.fsf@nemi.mork.no>
References: <AANLkTinz5Wvd7XuFIxsMMOV2XUTEXAafRUgXiBMLpEQn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pascal Hahn <derpassi@gmail.com> writes:

> I can't see any of the expected mantis_ca_init but couldn't figure out
> in the code where that gets called.

I don't think it is.  It was at some point, but it seems to be removed.
Most likely because it wasn't considered ready at the time this driver
was merged(?)

BTW, there is a potentional null dereference in mantis_irq_handler(),
which will do

        ca = mantis->mantis_ca;
..
        if (stat & MANTIS_INT_IRQ0) {
                dprintk(MANTIS_DEBUG, 0, "<%s>", label[1]);
                mantis->gpif_status = rst_stat;
                wake_up(&ca->hif_write_wq);
                schedule_work(&ca->hif_evm_work);
        }

This will blow up if (stat & MANTIS_INT_IRQ0) is true, since
mantis->mantis_ca never is allocated.  But then I guess that the
hardware should normally prevent (stat & MANTIS_INT_IRQ0) from being
true as long as the ca system isn't initiated, so this does not pose a
problem in practice.

Still doesn't look good.



Bjørn

