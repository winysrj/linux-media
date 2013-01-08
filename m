Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:40583 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756424Ab3AHObc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jan 2013 09:31:32 -0500
Date: Tue, 8 Jan 2013 07:31:30 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Alessandro Rubini <rubini@gnudd.com>, federico.vaga@gmail.com,
	mchehab@infradead.org, pawel@osciak.com, hans.verkuil@cisco.com,
	giancarlo.asnaghi@st.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, s.nawrocki@samsung.com
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
Message-ID: <20130108073130.38a8cc3d@lwn.net>
In-Reply-To: <50EBC1C1.3060208@samsung.com>
References: <3892735.vLSnhhCRFi@harkonnen>
	<1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
	<1399400.izKZgEHXnP@harkonnen>
	<12929800.xFTBAueAE0@harkonnen>
	<20130106230947.GA17979@mail.gnudd.com>
	<20130107124050.3fc5031b@lwn.net>
	<20130107181500.24c56803@redhat.com>
	<50EBC1C1.3060208@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 08 Jan 2013 07:50:41 +0100
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> > Couldn't this performance difference be due to the usage of GFP_DMA inside
> > the VB2 code, like Federico's new patch series is proposing?
> >
> > If not, why are there a so large performance penalty?  
> 
> Nope, this was caused rather by a very poor CPU access to non-cached (aka
> 'coherent') memory and the way the video data has been accessed/read 
> with CPU.

Exactly.  Uncached memory *hurts*, especially if you're having to touch it
all with the CPU.

jon
