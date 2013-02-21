Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:25968 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3BUG5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Feb 2013 01:57:42 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MIK008O85XC3MF0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 21 Feb 2013 15:57:40 +0900 (KST)
Received: from [10.90.51.60] by mmp1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MIK007326033670@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 21 Feb 2013 15:57:39 +0900 (KST)
Message-id: <5125C574.5060307@samsung.com>
Date: Thu, 21 Feb 2013 15:57:56 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
MIME-version: 1.0
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, l.krishna@samsung.com,
	kgene.kim@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v7 0/2] Add display-timing node parsing to exynos drm fimd
References: <1361423512-2882-1-git-send-email-vikas.sajjan@linaro.org>
In-reply-to: <1361423512-2882-1-git-send-email-vikas.sajjan@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please refer my comments about v6 patch.


On 02/21/2013 02:11 PM, Vikas Sajjan wrote:
> Add display-timing node parsing to drm fimd and depends on
> the display helper patchset at
> http://lists.freedesktop.org/archives/dri-devel/2013-January/033998.html
>
> It also adds pinctrl support for drm fimd.
>
> changes since v6:
> 	addressed comments from Inki Dae <inki.dae@samsung.com> to
> 	separated out the pinctrl functionality and made a separate patch.
>
> changes since v5:
> 	- addressed comments from Inki Dae <inki.dae@samsung.com>,
> 	to remove the allocation of 'fbmode' and replaced
> 	'-1'in "of_get_fb_videomode(dev->of_node, fbmode, -1)" with
> 	OF_USE_NATIVE_MODE.
>
> changes since v4:
> 	- addressed comments from Paul Menzel
> 	<paulepanter@users.sourceforge.net>, to modify the commit message
>
> changes since v3:
> 	- addressed comments from Sean Paul <seanpaul@chromium.org>, to modify
> 	the return values and print messages.
>
> changes since v2:
> 	- moved 'devm_pinctrl_get_select_default' function call under
> 		'if (pdev->dev.of_node)', this makes NON-DT code unchanged.
> 		(reported by: Rahul Sharma <r.sh.open@gmail.com>)
>
> changes since v1:
> 	- addressed comments from Sean Paul <seanpaul@chromium.org>
>
>
> Vikas Sajjan (2):
>    video: drm: exynos: Add display-timing node parsing using video
>      helper function
>    video: drm: exynos: Add pinctrl support to fimd
>
>   drivers/gpu/drm/exynos/exynos_drm_fimd.c |   36 ++++++++++++++++++++++++++----
>   1 file changed, 32 insertions(+), 4 deletions(-)
>

