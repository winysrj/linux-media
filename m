Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34715 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbbK0H1U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2015 02:27:20 -0500
Date: Fri, 27 Nov 2015 12:57:08 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: =?utf-8?B?6rmA7KCV67Cw?= <jb09.kim@samsung.com>
Cc: sumit.semwal@linaro.org, gregkh@linuxfoundation.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH] driver:dma bug_fix : access freed memory
Message-ID: <20151127072708.GA29368@sudip-pc>
References: <1606811477.1531761448603090175.JavaMail.weblogic@epmlwas01d>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1606811477.1531761448603090175.JavaMail.weblogic@epmlwas01d>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 27, 2015 at 05:44:53AM +0000, 김정배 wrote:
> From 8f6aeb362d9e44f29d46ae7694cdfee4408406ce Mon Sep 17 00:00:00 2001
> From: "KIM JUGNBAE" <jb09.kim@samsung.com>
> Date: Thu, 26 Nov 2015 16:28:47 +0900
> Subject: [PATCH] bug_fix : access freed memory

This part should not be present in the patch.

> 
> sync_fenc_free & fence_check_cb_func would be executed at
> other cpu. fence_check_cb_func access freed fence memory after
> kfree(fence) at sync_fence_free.
> To escaped this issue, atomic_read(&fence->status) need to be
> protected by child_list_lock.
> 
> Signed-off-by: "kimjungbae\" " <jb09.kim@samsung.com>"

The From name and the Signed-off-by name shouls be same. Mayvbe you can
consider having Kim Jugnbae (or Jungbae) as both.

> ---
>  drivers/dma-buf/fence.c              |   13 +++++++++++++
>  drivers/staging/android/sync.c       |   10 +++++++---
>  drivers/staging/android/sync_debug.c |    2 ++
>  include/linux/fence.h                |    1 +
>  4 files changed, 23 insertions(+), 3 deletions(-)

Usually staging patches can not touch anything outside staging.

regards
sudip
