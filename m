Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:54417 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab3DRNaW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 09:30:22 -0400
Date: Thu, 18 Apr 2013 22:30:22 +0900
From: Simon Horman <horms@verge.net.au>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, magnus.damm@gmail.com,
	linux-media@vger.kernel.org, matsu@igel.co.jp
Subject: Re: [PATCH 4/4] ARM: shmobile: Marzen: enable VIN and ADV7180 in
 defconfig
Message-ID: <20130418133022.GD20929@verge.net.au>
References: <201304180206.39465.sergei.shtylyov@cogentembedded.com>
 <201304180217.28176.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304180217.28176.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 18, 2013 at 02:17:27AM +0400, Sergei Shtylyov wrote:
> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> 
> Add the VIN and ADV7180 drivers to 'marzen_defconfig'.
> 
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
>  arch/arm/configs/marzen_defconfig |    7 +++++++
>  1 file changed, 7 insertions(+)

Thanks, queued-up for v3.11 in the defconfig-marzen branch.
