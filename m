Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44430 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab2DZIn6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 04:43:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3200AUHW9GHE90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Apr 2012 09:44:04 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M320082EW98LH@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Apr 2012 09:43:56 +0100 (BST)
Date: Thu, 26 Apr 2012 10:43:55 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/1] s5p-fimc: media_entity_pipeline_start() may fail
In-reply-to: <1335091479-26943-1-git-send-email-sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Message-id: <4F990ACB.8040809@samsung.com>
References: <1335091479-26943-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

thank you for the patch.

On 04/22/2012 12:44 PM, Sakari Ailus wrote:
> Take into account media_entity_pipeline_start() may fail. This patch is
> dependent on "media: Add link_validate() op to check links to the sink pad".
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

I will apply it on my tree for 3.5, when your remaining patches are merged
into the media tree. I really hope they are not delayed another kernel
release.


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
