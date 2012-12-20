Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:52603 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab2LTB02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Dec 2012 20:26:28 -0500
Received: by mail-ob0-f170.google.com with SMTP id wp18so2778594obc.1
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2012 17:26:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com>
References: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com>
Date: Thu, 20 Dec 2012 11:26:27 +1000
Message-ID: <CAPM=9twKSyYzg_Fv6JQM9tBCATgH_z8+TGPmkv_ritHH4XYOUg@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Add debugfs support
From: Dave Airlie <airlied@gmail.com>
To: sumit.semwal@ti.com
Cc: sumit.semwal@linaro.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 14, 2012 at 7:36 PM,  <sumit.semwal@ti.com> wrote:
> From: Sumit Semwal <sumit.semwal@linaro.org>
>
> Add debugfs support to make it easier to print debug information
> about the dma-buf buffers.
>

I like thie idea,

/home/airlied/devel/kernel/drm-2.6/drivers/base/dma-buf.c: In function
‘dma_buf_describe’:
/home/airlied/devel/kernel/drm-2.6/drivers/base/dma-buf.c:563:5:
warning: format ‘%d’ expects argument of type ‘int’, but argument 6
has type ‘long int’ [-Wformat]
/home/airlied/devel/kernel/drm-2.6/drivers/base/dma-buf.c: At top level:
/home/airlied/devel/kernel/drm-2.6/drivers/base/dma-buf.c:528:123:
warning: ‘dma_buf_init’ defined but not used [-Wunused-function]

not sure my compiler does though.

Dave.
