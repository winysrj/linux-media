Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39197 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3JOHoV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 03:44:21 -0400
Message-id: <525CF251.1040003@samsung.com>
Date: Tue, 15 Oct 2013 09:44:17 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Seung-Woo Kim <sw0312.kim@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	m.chehab@samsung.com
Subject: Re: [PATCH v2] s5p-jpeg: fix uninitialized use in hdr parse
References: <525918C1.7090704@gmail.com>
 <1381725810-20202-1-git-send-email-sw0312.kim@samsung.com>
In-reply-to: <1381725810-20202-1-git-send-email-sw0312.kim@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Seung-Woo,

On 14/10/13 06:43, Seung-Woo Kim wrote:
> For hdr parse error, it can return false without any assignments
> which cause following build warning.
> 
> drivers/media/platform/s5p-jpeg/jpeg-core.c: In function 's5p_jpeg_parse_hdr':
> drivers/media/platform/s5p-jpeg/jpeg-core.c:432: warning: 'components' may be used uninitialized in this function
> drivers/media/platform/s5p-jpeg/jpeg-core.c:433: warning: 'height' may be used uninitialized in this function
> drivers/media/platform/s5p-jpeg/jpeg-core.c:433: warning: 'width' may be used uninitialized in this function
> 
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> ---
> change from v1
> - add build warning to commit message

Thanks for amending it, the patch added to my tree for v3.13.

--
Regards,
Sylwester
