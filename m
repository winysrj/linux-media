Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:42041 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3DVEVX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 00:21:23 -0400
Date: Mon, 22 Apr 2013 13:21:20 +0900
From: Simon Horman <horms@verge.net.au>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	mchehab@redhat.com, linux-media@vger.kernel.org, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH 0/5] OKI ML86V7667 driver and R8A7778/BOCK-W VIN support
Message-ID: <20130422042120.GN15680@verge.net.au>
References: <201304210013.46110.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304210013.46110.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 21, 2013 at 12:13:45AM +0400, Sergei Shtylyov wrote:
> Hello.
> 
>    Here's the set of 4 patches against the Simon Horman's 'renesas.git' repo,
> 'renesas-next-20130419' tag and my recent yet unapplied patches. Here we
> add the OKI ML86V7667 video decoder driver and the VIN platform code working on
> the R8A7778/BOCK-W with ML86V7667. The driver patch also applies (with offsets)
> to Mauro's 'media_tree.git'...
> 
> [1/5] V4L2: I2C: ML86V7667 video decoder driver
> [2/5] sh-pfc: r8a7778: add VIN pin groups
> [3/5] ARM: shmobile: r8a7778: add VIN support
> [4/5] ARM: shmobile: BOCK-W: add VIN and ADV7180 support
> [5/5] ARM: shmobile: BOCK-W: enable VIN and ADV7180 in defconfig

Hi Sergei,

it seems to me that patches 2 and 3 of the series could
be applied to my tree without further delay. Would you
like me to do that?
