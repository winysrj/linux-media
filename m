Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58786 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1KNKbR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 05:31:17 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LUN00GXLBW34040@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Nov 2011 10:31:15 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LUN00DRNBW29U@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Nov 2011 10:31:15 +0000 (GMT)
Date: Mon, 14 Nov 2011 11:31:14 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] MAINTAINERS: Add m5mols driver maintainers
In-reply-to: <1321013133-8763-1-git-send-email-riverful.kim@samsung.com>
To: "HeungJun, Kim" <riverful.kim@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4EC0EDF2.7050205@samsung.com>
References: <1321013133-8763-1-git-send-email-riverful.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/2011 01:05 PM, HeungJun, Kim wrote:
> Add the maintainers for the m5mols driver
> 
> Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  MAINTAINERS |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5e587fc..91c5511 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2804,6 +2804,14 @@ L:	platform-driver-x86@vger.kernel.org
>  S:	Maintained
>  F:	drivers/platform/x86/fujitsu-laptop.c
>  
> +FUJITSU M-5MO LS CAMERA ISP DRIVER
> +M:	Kyungmin Park <kyungmin.park@samsung.com>
> +M:	Heungjun Kim <riverful.kim@samsung.com>
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	drivers/media/video/m5mols/
> +F:	include/media/m5mols.h
> +
>  FUSE: FILESYSTEM IN USERSPACE
>  M:	Miklos Szeredi <miklos@szeredi.hu>
>  L:	fuse-devel@lists.sourceforge.net
