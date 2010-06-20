Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41867 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab0FTNv1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jun 2010 09:51:27 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OQKvl-000872-In
	for linux-media@vger.kernel.org; Sun, 20 Jun 2010 15:51:25 +0200
Received: from nemi.mork.no ([148.122.252.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 20 Jun 2010 15:51:25 +0200
Received: from bjorn by nemi.mork.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 20 Jun 2010 15:51:25 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] Mantis: append tasklet maintenance for DVB stream delivery
Date: Sun, 20 Jun 2010 15:51:15 +0200
Message-ID: <87vd9dbyng.fsf@nemi.mork.no>
References: <4C1DFD75.3080606@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marko Ristola <marko.ristola@kolumbus.fi> writes:

> The following schedule might also be a problem:
> 1. mantis_core_exit: mantis_dma_stop()
> 2. mantis_core_exit: mantis_dma_exit().

Note that mantis_core_exit() is never called.  Unless I've missed
something, the drivers/media/dvb/mantis/mantis_core.{h,c} files can
just be deleted.  They look like some development leftovers?


Bjørn

