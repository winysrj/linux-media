Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46398 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095AbZJIPWb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Oct 2009 11:22:31 -0400
Date: Fri, 9 Oct 2009 17:21:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: kernel-janitors@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Martin Dauskardt <martin.dauskardt@gmx.de>,
	"Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] media/video:  adding __init/__exit macros to various
 drivers
In-Reply-To: <200909290219.01623.PeterHuewe@gmx.de>
Message-ID: <alpine.LSU.2.00.0910091721260.19284@wotan.suse.de>
References: <200909290219.01623.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 29 Sep 2009, Peter Huewe wrote:

> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of the following drivers in media video:
>     drivers/media/video/ivtv/ivtv-driver.c
>     drivers/media/video/cx18/cx18-driver.c
>     drivers/media/video/davinci/dm355_ccdc.c
>     drivers/media/video/davinci/dm644x_ccdc.c
>     drivers/media/video/saa7164/saa7164-core.c
>     drivers/media/video/saa7134/saa7134-core.c
>     drivers/media/video/cx23885/cx23885-core.c

This doesn't seem to be present in linux-next as of today. I have queued 
in in trivial tree.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
