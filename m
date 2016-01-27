Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:35896 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbcA0AjV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 19:39:21 -0500
Received: by mail-yk0-f177.google.com with SMTP id v14so222333614ykd.3
        for <linux-media@vger.kernel.org>; Tue, 26 Jan 2016 16:39:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160126155937.6a4e4165d1cf4e513d62e942@linux-foundation.org>
References: <1452533428-12762-1-git-send-email-dianders@chromium.org>
	<20160126155937.6a4e4165d1cf4e513d62e942@linux-foundation.org>
Date: Tue, 26 Jan 2016 19:39:20 -0500
Message-ID: <CAD=FV=V9ZJrmD=F8363mhg8+JQiTRg=g6DuZR2KJRbfU=K455w@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] dma-mapping: Patches for speeding up allocation
From: Doug Anderson <dianders@chromium.org>
To: Russell King <linux@arm.linux.org.uk>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Christoph Hellwig <hch@infradead.org>, k.debski@samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>, mike.looijmans@topic.nl,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Will Deacon <will.deacon@arm.com>, jtp.park@samsung.com,
	penguin-kernel@i-love.sakura.ne.jp,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Carlo Caione <carlo@caione.org>, linux-media@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Jan 26, 2016 at 3:59 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 11 Jan 2016 09:30:22 -0800 Douglas Anderson <dianders@chromium.org> wrote:
>
>> This series of patches will speed up memory allocation in dma-mapping
>> quite a bit.
>
> This is pretty much all ARM and driver stuff so I think I'll duck it.
> But I can merge it if nobody else feels a need to.

I was going to ask what the next steps were for this series.
Presumably I could post the patch to Russell's patch tracker if folks
want me to do that.  Alternatively it could go through the ARM-SOC
tree?


> I saw a few acked-by/tested-by/etc from the v5 posting which weren't
> carried over into v6 (might have been a timing race), so please fix
> that up if there's an opportunity.

Right.  Both Robin and Tomasz gave their Reviewed-by to Patch #1 in v5
even after v6 was posted.


> Regarding the new DMA_ATTR_ALLOC_SINGLE_PAGES hint: I suggest adding
> "DMA_ATTR_ALLOC_SINGLE_PAGES is presently implemented only on ARM" to
> the docs.  Or perhaps have a shot at implementing it elsewhere.

Warning sounds good.


> Typo in 4/5 changelog: "reqiurements"

Thanks for catching!


I'm happy to post up a v6 with these things fixed or I'm happy for
whoever is applying it to make these small fixes themselves.  Any
volunteers?  Olof, Arnd, or Russell: any of you want these patches?


-Doug
