Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:48771 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3F0Hlc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 03:41:32 -0400
Date: Thu, 27 Jun 2013 16:41:29 +0900
From: Simon Horman <horms@verge.net.au>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	magnus.damm@gmail.com, linux@arm.linux.org.uk, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v4 0/3] R8A7779/Marzen R-Car VIN driver support
Message-ID: <20130627074129.GB13927@verge.net.au>
References: <201305160153.29827.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305160153.29827.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 16, 2013 at 01:53:29AM +0400, Sergei Shtylyov wrote:
> Hello.
> 
>    Here's the set of 3 patches against the Simon Horman's 'renesas.git' repo,
> 'renesas-next-20130515v2' tag and my recent yet unapplied USB/I2C patches.
> Here we add the VIN driver platform code for the R8A7779/Marzen with ADV7180
> I2C video decoder.
> 
> [1/3] ARM: shmobile: r8a7779: add VIN support
> [2/3] ARM: shmobile: Marzen: add VIN and ADV7180 support
> [3/3] ARM: shmobile: Marzen: enable VIN and ADV7180 in defconfig
> 
>    The VIN driver itself has been excluded from the series as it will be developed
> against Mauro's 'media_tree.git' plus some yet unapplied patches in the future...

Sergei, is this patch-set still needing review?
