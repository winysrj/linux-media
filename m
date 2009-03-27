Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34841 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbZC0Ktm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 06:49:42 -0400
Date: Fri, 27 Mar 2009 07:49:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Darius <augulis.darius@gmail.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>, corbet@lwn.net,
	Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [RFC] Another OV7670 Soc-camera driver
Message-ID: <20090327074933.13042d68@pedra.chehab.org>
In-Reply-To: <49C88D83.20906@gmail.com>
References: <49C88D83.20906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 24 Mar 2009 09:36:35 +0200
Darius <augulis.darius@gmail.com> wrote:

> Hi All,
> 
> seems everybody has their own OV7670 driver... I have one written from scratch too.
> It is written using Omnivision user manual, application note, and register reference settings.
> Omnivision provides settings arrays for every resolution (VGA, QVGA, QQVGA, CIF, QCIF).
> This driver has lot of harcoded magic numbers. Of course OV7670 has lot of undocumented mystery and strange bugs.
> Maybe my work could be useful merging all available OV7670 drivers into single one.
> This driver is tested with MXLADS v2.0 board.
> 
> So there it is:

Well, now, we have 3 drivers for the same device...

We should really try to merge those three into one. AFAIK, Jonathan driver were
also written using the Omnivision docs.

Cheers,
Mauro
