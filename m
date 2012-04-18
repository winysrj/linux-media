Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54433 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2DRTHh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 15:07:37 -0400
Date: Wed, 18 Apr 2012 20:10:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
	linaro-mm-sig@lists.linaro.org,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org, Rob Clark <rob.clark@linaro.org>,
	Rebecca Schultz Zavin <rebecca@android.com>
Subject: Re: [PATCH] dma-buf: mmap support
Message-ID: <20120418201011.46d44f4b@pyramind.ukuu.org.uk>
In-Reply-To: <201204181406.14159.arnd@arndb.de>
References: <1334757146-28335-1-git-send-email-daniel.vetter@ffwll.ch>
	<201204181406.14159.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> How do you ensure that no device can do DMA on the buffer while it's mapped
> into user space in a noncoherent manner?

Why do we want to enforce that ? We provide the appropriate base service
but you need to know what you are doing. In reality a lot of use cases
are going to need far more than a simple kernel API could try and guess
coherency rules about.

