Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18073 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab3DVONU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:13:20 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLN0053NU53J0C0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Apr 2013 15:13:18 +0100 (BST)
Message-id: <5175457D.4050408@samsung.com>
Date: Mon, 22 Apr 2013 16:13:17 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com
Subject: Re: [PATCH 00/12] exynos4-is driver fixes
References: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/22/2013 04:03 PM, Sylwester Nawrocki wrote:
> This patch series includes fixes for several issues found during
> testing all exynos4-is device drivers build as modules. The exynos4-is
> build with all sub-drivers as 'M' is hopefully now free of all serious
> issues, but one. I.e. the requirement now is to have all sub-device
> drivers, including the sensor subdev drivers, built as modules.

Hmm, to avoid issues all drivers must now be either statically linked or
build as modules and all need to be inserted, the all removed. Leaving
any one loaded all time may lead to a disaster... This is not a new
issue and and is related to all drivers using MC framework, thus I plan
to address it for 3.11.

> The problem when some of the sub-device drivers is statically linked
> is that the media links of a media entity just unregistered from
> the media device are not fully cleaned up in the media controller
> API. This means other entities can have dangling pointers to the links
> array owned by en entity just removed and freed. The problem is not
> existent when all media entites are registered/unregistred together.
> In such a case it doesn't hurt that media_entity_cleanup() function
> just frees the links array.
> 
> I will post a separate RFC patch to address this issue, since it is
> not trivial where the link references should be removed from all
> involved media entities.
> 
> I verified that adding a call to media_entity_remove_links() as in
> patch [1] to the v4l2_sdubdev_unregister_function() eliminates all
> weird crashes present before, when inserting/removing all the host
> driver modules while the sensor driver stays loaded.
> 
> [1] http://git.linuxtv.org/snawrocki/samsung.git/commitdiff/f7007880a37c28beef845aa0787696aa8cead1cd
