Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28885 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3FJKUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 06:20:21 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO600ECT9YPPU40@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Jun 2013 11:20:18 +0100 (BST)
Message-id: <51B5A85F.4050601@samsung.com>
Date: Mon, 10 Jun 2013 12:20:15 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, hj210.choi@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com
Subject: Re: [REVIEW PATCH v3 1/2] media: Change media device link_notify
 behaviour
References: <1370808878-11379-1-git-send-email-s.nawrocki@samsung.com>
 <1370808878-11379-2-git-send-email-s.nawrocki@samsung.com>
 <51B4FD56.6020307@iki.fi> <4863645.7uvCWtXOjj@avalon>
In-reply-to: <4863645.7uvCWtXOjj@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 06/10/2013 11:46 AM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> Should I take the series in my tree, or would you like to push it yourself to 
> avoid conflicts with other Exynos patches ?

My plan was to handle this series together with the other Exynos patches
it depends on. I would send a pull request today. I guess there would be
the least conflicts this way. Sorry about embedding this core patch in my
series.

Regards,
Sylwester
