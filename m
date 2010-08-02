Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:18612 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab0HBLPm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 07:15:42 -0400
Date: Mon, 02 Aug 2010 13:13:49 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v3 1/8] ARM: Samsung: Add register definitions for Samsung
 S5P SoC camera interface
In-reply-to: <20100802105216.GD30670@n2100.arm.linux.org.uk>
To: 'Russell King - ARM Linux' <linux@arm.linux.org.uk>,
	Pawel Osciak <p.osciak@samsung.com>
Cc: 'Kukjin Kim' <kgene.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kyungmin.park@samsung.com,
	linux-media@vger.kernel.org
Message-id: <011701cb3233$cba1f1a0$62e5d4e0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1279902083-21250-1-git-send-email-s.nawrocki@samsung.com>
 <1279902083-21250-2-git-send-email-s.nawrocki@samsung.com>
 <00ba01cb2c8f$02fc8480$08f58d80$%kim@samsung.com>
 <003001cb322d$fc976b10$f5c64130$%osciak@samsung.com>
 <20100802105216.GD30670@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, August 02, 2010 12:52 PM Russell King wrote:

> On Mon, Aug 02, 2010 at 12:32:20PM +0200, Pawel Osciak wrote:
> > Well, some of them are indeed unused, but it's not an uncommon practice
> in
> > kernel and might help future developers.
> 
> On the other hand, arch/arm is getting soo big that we need to do
> something about this - and one solution is to avoid unnecessary
> definitions that we're not using.
> 
> Another good idea is to put definitions along side the drivers which
> they're relevant to - maybe in a local driver-name.h file which
> driver-name.c includes, or maybe even within driver-name.c if they're
> not excessive.  This has the advantage of distributing the "bloat" to
> where its actually used, and means that the driver isn't dependent so
> much on arch/arm or even the SoC itself.

Well, with FIMC driver we just followed the style from other Samsung
drivers. Just take a look at video/s3c-fb or usb/gadget/s3c-hsotg.c.
I personally like to keep the same style for all drivers for Samsung
IPs. Changing the style of all of them requires some amount of work,
that would delay this particular driver even more so we will definitely
miss the merge window.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


