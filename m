Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:9592 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab3DYJ7G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 05:59:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 0/7] Add copy time stamp handling to mem2mem drivers
Date: Thu, 25 Apr 2013 11:58:47 +0200
Cc: linux-media@vger.kernel.org
References: <1366883390-12890-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1366883390-12890-1-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304251158.47036.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 25 April 2013 11:49:43 Kamil Debski wrote:
> Hi,
> 
> This set of patches adds support for copy time stamp handling in the following
> mem2mem drivers:

While you are at it, can you also take a look at this patch?

https://patchwork.linuxtv.org/patch/18025/

If it is OK, can you add it to your tree?

Regards,

	Hans

> * CODA video codec
> * Exynos GScaler
> * m2m-deinterlace
> * mx2_emmaprp
> * Exynos G2D
> * Exynos Jpeg
> In addition there is a slight optimisation for the Exynos MFC driver.
> 
> Best wishes,
> Kamil Debski
> 
> Kamil Debski (7):
>   s5p-g2d: Add copy time stamp handling
>   s5p-jpeg: Add copy time stamp handling
>   s5p-mfc: Optimize copy time stamp handling
>   coda: Add copy time stamp handling
>   exynos-gsc: Add copy time stamp handling
>   m2m-deinterlace: Add copy time stamp handling
>   mx2-emmaprp: Add copy time stamp handling
> 
>  drivers/media/platform/coda.c               |    5 +++++
>  drivers/media/platform/exynos-gsc/gsc-m2m.c |    5 +++++
>  drivers/media/platform/m2m-deinterlace.c    |    5 +++++
>  drivers/media/platform/mx2_emmaprp.c        |    5 +++++
>  drivers/media/platform/s5p-g2d/g2d.c        |    5 +++++
>  drivers/media/platform/s5p-jpeg/jpeg-core.c |    5 +++++
>  drivers/media/platform/s5p-mfc/s5p_mfc.c    |   10 ++++------
>  7 files changed, 34 insertions(+), 6 deletions(-)
> 
> 
