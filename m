Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54944 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbZJ0Mgh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 08:36:37 -0400
Date: Tue, 27 Oct 2009 10:36:00 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Pawel Osciak <p.osciak@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
Subject: Re: V4L2_MEMORY_USERPTR support in videobuf-core
Message-ID: <20091027103600.109b9afb@pedra.chehab.org>
In-Reply-To: <E4D3F24EA6C9E54F817833EAE0D912AC07D2F45C6B@bssrvexch01.BS.local>
References: <E4D3F24EA6C9E54F817833EAE0D912AC07D2F45C6B@bssrvexch01.BS.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Oct 2009 11:59:54 +0100
Pawel Osciak <p.osciak@samsung.com> escreveu:

> Hello,
> could anybody confirm that there is no full/working support for USERPTR in
> current videobuf-core? That is the conclusion I came up with after a more 
> thorough investigation.
> 
> I am currently working to fix that, and will hopefully be posting patches in
> the coming days/weeks. Is there any other development effort underway related
> to this problem?

Hi Pawel,

The last time I tested the support for userptr at videobuf-core, it were
working on x86 plataforms. On that time, I used vivi with videobuf-dma-sg
for such tests (it were before its conversion to use videobuf-vmalloc).
As support for userptr on videobuf-vmalloc is missing, vivi can't be used
for such tests anymore (a good contribution would be to add userptr support
on videobuf-vmalloc).

Maybe you're suffering some platform-specific issues.



Cheers,
Mauro
