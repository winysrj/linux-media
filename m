Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbZEKWhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 18:37:10 -0400
Date: Mon, 11 May 2009 19:37:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH 3/3 ] big rework of TS for saa7134
Message-ID: <20090511193705.0e06fac8@pedra.chehab.org>
In-Reply-To: <20090428195200.69d103e7@glory.loctelecom.ru>
References: <20090428195200.69d103e7@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 28 Apr 2009 19:52:00 +1000
Dmitri Belimov <d.belimov@gmail.com> escreveu:

> Hi all.
> 
> 1. Add start/stop TS function.
> 2. Move setup DMA of TS to DMA function.
> 3. Write support cupture via MMAP
> 4. Rework startup and finish process, remove simple FSM.
> 
> This is patch from our customer. I checked this.

Dmitri,

Could you please re-send this patch, this time with your SOB?



Cheers,
Mauro
