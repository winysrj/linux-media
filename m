Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:33886 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbcA2WOu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 17:14:50 -0500
Received: by mail-yk0-f176.google.com with SMTP id a85so85774393ykb.1
        for <linux-media@vger.kernel.org>; Fri, 29 Jan 2016 14:14:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD=FV=XEML4UqV-oVR4doZNSq6bNxDvpc-4745JTBZgf4d9UYA@mail.gmail.com>
References: <1452533428-12762-1-git-send-email-dianders@chromium.org>
	<20160126155937.6a4e4165d1cf4e513d62e942@linux-foundation.org>
	<CAD=FV=V9ZJrmD=F8363mhg8+JQiTRg=g6DuZR2KJRbfU=K455w@mail.gmail.com>
	<CAOesGMg=7mzZ6wKgjB1Po3706FGYu+D06YWWBBTya6KOE7531g@mail.gmail.com>
	<CAD=FV=XEML4UqV-oVR4doZNSq6bNxDvpc-4745JTBZgf4d9UYA@mail.gmail.com>
Date: Fri, 29 Jan 2016 14:14:50 -0800
Message-ID: <CAD=FV=XwnQ2dPi0YsD12vpqQxPDAJ9RNhWfHkJhszEhxiSrU7Q@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] dma-mapping: Patches for speeding up allocation
From: Doug Anderson <dianders@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>, mike.looijmans@topic.nl,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Will Deacon <will.deacon@arm.com>, jtp.park@samsung.com,
	penguin-kernel@i-love.sakura.ne.jp,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Carlo Caione <carlo@caione.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, Jan 29, 2016 at 1:58 PM, Doug Anderson <dianders@chromium.org> wrote:
>> I think it makes sense to send these through Russell's tracker for him
>> to merge, especially since I don't think there are any dependencies on
>> them for SoC-specific patches coming up.
>
> Sounds good.  I'll make the nitfixes and I'll post a v7 directly to
> Russell's tracker.  I'll follow up here with a link to those patches.

For your viewing pleasure:

8505/1 dma-mapping: Optimize allocation
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8505/1

8506/1 common: DMA-mapping: add DMA_ATTR_ALLOC_SINGLE_PAGES attribute
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8506/1

8507/1 dma-mapping: Use DMA_ATTR_ALLOC_SINGLE_PAGES hint to optimize alloc
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8507/1

8508/1 videobuf2-dc: Let drivers specify DMA attrs
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8508/1

8509/1 s5p-mfc: Set DMA_ATTR_ALLOC_SINGLE_PAGES
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8509/1

---

Changes in v7 (AKA the above patches):
- Add Robin and Tomasz Reviewed-by.
- Add Javier Tested-by.
- Add note that this is only implemented on ARM (Andrew Morton).
- Typo in commit message "reqiurements" (Andrew Morton).


-Doug
