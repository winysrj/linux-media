Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f195.google.com ([209.85.160.195]:35988 "EHLO
	mail-yk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbcAZXb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 18:31:29 -0500
Received: by mail-yk0-f195.google.com with SMTP id k129so15925403yke.3
        for <linux-media@vger.kernel.org>; Tue, 26 Jan 2016 15:31:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1452533428-12762-1-git-send-email-dianders@chromium.org>
References: <1452533428-12762-1-git-send-email-dianders@chromium.org>
Date: Tue, 26 Jan 2016 20:31:28 -0300
Message-ID: <CABxcv==WXG4zq8mr+KE4zKNkgG9y8etUQM7ZQiB2rPeKz1ySLQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] dma-mapping: Patches for speeding up allocation
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Douglas Anderson <dianders@chromium.org>
Cc: Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	robin.murphy@arm.com, tfiga@chromium.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	laurent.pinchart+renesas@ideasonboard.com, pawel@osciak.com,
	Jonathan Corbet <corbet@lwn.net>, mike.looijmans@topic.nl,
	Will Deacon <will.deacon@arm.com>,
	penguin-kernel@i-love.sakura.ne.jp,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, hch@infradead.org,
	jtp.park@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
	carlo@caione.org, akpm <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Doug,

On Mon, Jan 11, 2016 at 2:30 PM, Douglas Anderson <dianders@chromium.org> wrote:

[snip]

>
> All testing was done on the chromeos kernel-3.8 and kernel-3.14.
> Sanity (compile / boot) testing was done on a v4.4-rc6-based kernel on
> rk3288, though the video codec isn't there.  I don't have graphics / MFC
> working well on exynos, so the MFC change was only compile-tested
> upstream.  Hopefully someone upstream whose setup for MFC can give a
> Tested-by for these?
>

I tested these patches on a Exynos5800 Peach Pi Chromebook. The
s5p-mfc driver probes correctly and the allocation succeeds.

I also tried to test actual video decoding using Gstreamer but ran
into issues (not related to this series) so testing that won't be
trivial for me.

It shouldn't block Doug's series though IMHO since he tested on his
platform and the patches speeds up allocation there, so is an
improvement.

Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
