Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48140 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZEaVac (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 17:30:32 -0400
Date: Sun, 31 May 2009 18:30:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [09051_50] Siano: smscore - Add big endian support
Message-ID: <20090531183028.2cc922a0@pedra.chehab.org>
In-Reply-To: <495724.2537.qm@web110816.mail.gq1.yahoo.com>
References: <495724.2537.qm@web110816.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 May 2009 08:48:47 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> escreveu:

> 
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1242748399 -10800
> # Node ID a93ebe0069b3d7d8d791ccb620a7797508cf724c
> # Parent  4d75f9d1c4f96d65a8ad312c21e488a212ee58a3
> [09051_50] Siano: smscore - Add big endian support
> 
> From: Uri Shkolnik <uris@siano-ms.com>
> 
> Add support for big endian target, to the smscore module.
> 
> Priority: normal

This patch didn't apply:

$ patch -p1 -i /home/v4l/in_patches/lmml_24749_09051_50_siano_smscore_add_big_endian_support.patch
patching file linux/drivers/media/dvb/siano/smscoreapi.c
Hunk #1 FAILED at 34.
Hunk #2 FAILED at 467.
Hunk #3 succeeded at 541 (offset -8 lines).
Hunk #5 succeeded at 593 (offset -8 lines).
Hunk #7 succeeded at 753 (offset -21 lines).
Hunk #9 succeeded at 1022 (offset -89 lines).
Hunk #10 FAILED at 1526.
Hunk #11 FAILED at 1576.
Hunk #12 FAILED at 1625.
5 out of 12 hunks FAILED -- saving rejects to file linux/drivers/media/dvb/siano/smscoreapi.c.rej

Maybe this patch depends on one of the patches where changes are requested



Cheers,
Mauro
