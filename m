Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60853 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759791AbcHEPT5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2016 11:19:57 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OBF00866ZX58700@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 05 Aug 2016 16:19:53 +0100 (BST)
Subject: Re: [PATCHv2] s5p-tv: remove obsolete driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <2e2aa6f8-9eb7-cee3-6182-600b7c090f37@xs4all.nl>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <0202f8bb-90e8-5b11-bebe-2c358e6b0959@samsung.com>
Date: Fri, 05 Aug 2016 17:19:44 +0200
MIME-version: 1.0
In-reply-to: <2e2aa6f8-9eb7-cee3-6182-600b7c090f37@xs4all.nl>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/2016 03:38 PM, Hans Verkuil wrote:
> The s5p-tv driver has been replaced by the exynos drm driver for quite a
> long time now. Remove this driver to avoid having duplicate drivers,
> of which this one is considered dead code by Samsung.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
