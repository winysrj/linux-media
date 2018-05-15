Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:54765 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752602AbeEOJyF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 05:54:05 -0400
Subject: Re: [PATCH 3/7] s5p-mfc: fix two sparse warnings
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <e504deb8-ce01-1bfb-a430-2b7bd4184cae@samsung.com>
Date: Tue, 15 May 2018 11:53:57 +0200
MIME-version: 1.0
In-reply-to: <20180514131346.15795-4-hverkuil@xs4all.nl>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20180514131346.15795-1-hverkuil@xs4all.nl>
        <CGME20180514131355epcas2p2c365c6e6832bf16e7d9f2eb5f02d72a4@epcas2p2.samsung.com>
        <20180514131346.15795-4-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2018 03:13 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> media-git/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c: In function 'vidioc_querycap':
> media-git/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1317:2: warning: 'strncpy' output may be truncated copying 31 bytes from a string of length 31 [-Wstringop-truncation]
>   strncpy(cap->card, dev->vfd_enc->name, sizeof(cap->card) - 1);
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> media-git/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c: In function 'vidioc_querycap':
> media-git/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:275:2: warning: 'strncpy' output may be truncated copying 31 bytes from a string of length 31 [-Wstringop-truncation]
>   strncpy(cap->card, dev->vfd_dec->name, sizeof(cap->card) - 1);
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
