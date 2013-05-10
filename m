Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37957 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3EJJTg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 05:19:36 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMK00ICYSK20G90@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 May 2013 10:19:31 +0100 (BST)
Message-id: <518CBBA2.7020905@samsung.com>
Date: Fri, 10 May 2013 11:19:30 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kbuild@01.org, Kyungmin Park <kyungmin.park@samsung.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [kbuild] [linuxtv-samsung:next/exynos-is 3/17]
 drivers/media/media-entity.c:477:1-11: second lock on line 479
References: <20130509232644.GI30128@mwanda>
In-reply-to: <20130509232644.GI30128@mwanda>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/10/2013 01:26 AM, Dan Carpenter wrote:
> Hi Sylwester,
> 
> FYI, there are coccinelle warnings in

Thanks a lot for this bug report. I've just re-tested the patch
and the bug is evident there, looks like it was introduced in
a "last minute" changes and the test environment wasn't updated
properly. The corrected patch to follow.

Regards,
Sylwester

> tree:   git://linuxtv.org/snawrocki/samsung.git next/exynos-is
> head:   90029a2ca496f71ba629ea932ac761e16f4e823b
> commit: cae9aa2c7b182d1b687196292059bca2f2cedf0f [3/17] media: Add function removing all media entity links
> 
>>> drivers/media/media-entity.c:477:1-11: second lock on line 479
> --
>>> drivers/media/media-entity.c:477:1-11: second lock on line 479
> 
> git remote add linuxtv-samsung git://linuxtv.org/snawrocki/samsung.git
> git remote update linuxtv-samsung
> git checkout cae9aa2c7b182d1b687196292059bca2f2cedf0f
> vim +477 drivers/media/media-entity.c
> 
> cae9aa2c Sylwester Nawrocki 2013-05-08  471  
> cae9aa2c Sylwester Nawrocki 2013-05-08  472  void media_entity_remove_links(struct media_entity *entity)
> cae9aa2c Sylwester Nawrocki 2013-05-08  473  {
> cae9aa2c Sylwester Nawrocki 2013-05-08  474  	if (WARN_ON_ONCE(entity->parent == NULL))
> cae9aa2c Sylwester Nawrocki 2013-05-08  475  		return;
> cae9aa2c Sylwester Nawrocki 2013-05-08  476  
> cae9aa2c Sylwester Nawrocki 2013-05-08 @477  	mutex_lock(&entity->parent->graph_mutex);
> cae9aa2c Sylwester Nawrocki 2013-05-08  478  	__media_entity_remove_links(entity);
> cae9aa2c Sylwester Nawrocki 2013-05-08 @479  	mutex_lock(&entity->parent->graph_mutex);
> cae9aa2c Sylwester Nawrocki 2013-05-08  480  }
> cae9aa2c Sylwester Nawrocki 2013-05-08  481  EXPORT_SYMBOL_GPL(media_entity_remove_links);
> cae9aa2c Sylwester Nawrocki 2013-05-08  482  
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> _______________________________________________
> kbuild mailing list
> kbuild@lists.01.org
> https://lists.01.org/mailman/listinfo/kbuild
