Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbcAZX7i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 18:59:38 -0500
Date: Tue, 26 Jan 2016 15:59:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Douglas Anderson <dianders@chromium.org>
Cc: linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	robin.murphy@arm.com, tfiga@chromium.org, m.szyprowski@samsung.com,
	pawel@osciak.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	hch@infradead.org, k.debski@samsung.com,
	laurent.pinchart+renesas@ideasonboard.com, corbet@lwn.net,
	mike.looijmans@topic.nl, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, will.deacon@arm.com,
	jtp.park@samsung.com, penguin-kernel@i-love.sakura.ne.jp,
	kyungmin.park@samsung.com, carlo@caione.org,
	linux-media@vger.kernel.org, dan.j.williams@intel.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/5] dma-mapping: Patches for speeding up allocation
Message-Id: <20160126155937.6a4e4165d1cf4e513d62e942@linux-foundation.org>
In-Reply-To: <1452533428-12762-1-git-send-email-dianders@chromium.org>
References: <1452533428-12762-1-git-send-email-dianders@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 11 Jan 2016 09:30:22 -0800 Douglas Anderson <dianders@chromium.org> wrote:

> This series of patches will speed up memory allocation in dma-mapping
> quite a bit.

This is pretty much all ARM and driver stuff so I think I'll duck it. 
But I can merge it if nobody else feels a need to.

I saw a few acked-by/tested-by/etc from the v5 posting which weren't
carried over into v6 (might have been a timing race), so please fix
that up if there's an opportunity.

Regarding the new DMA_ATTR_ALLOC_SINGLE_PAGES hint: I suggest adding
"DMA_ATTR_ALLOC_SINGLE_PAGES is presently implemented only on ARM" to
the docs.  Or perhaps have a shot at implementing it elsewhere.

Typo in 4/5 changelog: "reqiurements"
