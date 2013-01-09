Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55173 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab3AIHs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 02:48:58 -0500
Date: Wed, 9 Jan 2013 08:48:38 +0100
From: Michael Olbrich <m.olbrich@pengutronix.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Alessandro Rubini <rubini@gnudd.com>, federico.vaga@gmail.com,
	mchehab@infradead.org, pawel@osciak.com, hans.verkuil@cisco.com,
	giancarlo.asnaghi@st.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, s.nawrocki@samsung.com
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
Message-ID: <20130109074838.GH13335@pengutronix.de>
References: <3892735.vLSnhhCRFi@harkonnen>
 <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
 <1399400.izKZgEHXnP@harkonnen>
 <12929800.xFTBAueAE0@harkonnen>
 <20130106230947.GA17979@mail.gnudd.com>
 <20130107124050.3fc5031b@lwn.net>
 <20130107181500.24c56803@redhat.com>
 <50EBC1C1.3060208@samsung.com>
 <20130108073130.38a8cc3d@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108073130.38a8cc3d@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 08, 2013 at 07:31:30AM -0700, Jonathan Corbet wrote:
> On Tue, 08 Jan 2013 07:50:41 +0100
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > > Couldn't this performance difference be due to the usage of GFP_DMA inside
> > > the VB2 code, like Federico's new patch series is proposing?
> > >
> > > If not, why are there a so large performance penalty?  
> > 
> > Nope, this was caused rather by a very poor CPU access to non-cached (aka
> > 'coherent') memory and the way the video data has been accessed/read 
> > with CPU.
> 
> Exactly.  Uncached memory *hurts*, especially if you're having to touch it
> all with the CPU.

Even worse, on ARMv7 (at least) the cache implements or is necessary for
(I'm not an expert here) unaligned access. I've seen applications crash
on non-cached memory with a bus error because gcc assumes unaligned access
works. And there isn't even a exception handler in the kernel, probably for
the same reason.

Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
