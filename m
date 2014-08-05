Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:54352 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbaHEXcF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 19:32:05 -0400
Message-id: <53E16974.5000404@samsung.com>
Date: Wed, 06 Aug 2014 08:32:04 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
MIME-version: 1.0
To: Zhaowei Yuan <zhaowei.yuan@samsung.com>,
	linux-media@vger.kernel.org, k.debski@samsung.com,
	m.chehab@samsung.com, kyungmin.park@samsung.com,
	jtp.park@samsung.com
Cc: linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH V2] media: s5p_mfc: Release ctx->ctx if failed to allocate
 ctx->shm
References: <1407231076-15506-1-git-send-email-zhaowei.yuan@samsung.com>
In-reply-to: <1407231076-15506-1-git-send-email-zhaowei.yuan@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/05/2014 06:31 PM, Zhaowei Yuan wrote:
> ctx->ctx should be released if the following allocation for ctx->shm
> gets failed.
> 
> Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    1 +
>  1 file changed, 1 insertion(+)
>  mode change 100644 => 100755 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c

It's wrong to change file permission, please don't make a same mistake.
