Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8978 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaG2NX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 09:23:28 -0400
Message-id: <53D7A046.1090809@samsung.com>
Date: Tue, 29 Jul 2014 15:23:18 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Zhaowei Yuan <zhaowei.yuan@samsung.com>
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	m.chehab@samsung.com, kyungmin.park@samsung.com,
	jtp.park@samsung.com, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] media: s5p_mfc: Check the right pointer after allocation
References: <1406088312-5205-1-git-send-email-zhaowei.yuan@samsung.com>
In-reply-to: <1406088312-5205-1-git-send-email-zhaowei.yuan@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/07/14 06:05, Zhaowei Yuan wrote:
> It should be bank2_virt to be checked after dma allocation
> instead of dev->fw_virt_addr.

This patch is not applicable to the media master branch [1].
Additionally, AFAICS dma_alloc_coherent return value should be tested
for NULL, rather than for ERR_PTR() value. It seems you have some
incorrect changes in your tree, which this patch depends on.

[1] http://git.linuxtv.org/cgit.cgi/media_tree.git
