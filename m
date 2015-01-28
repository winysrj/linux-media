Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41431 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbbA2BtK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 20:49:10 -0500
Date: Wed, 28 Jan 2015 11:23:39 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, rmk+kernel@arm.linux.org.uk,
	airlied@linux.ie, kgene@kernel.org, daniel.vetter@intel.com,
	thierry.reding@gmail.com, pawel@osciak.com,
	m.szyprowski@samsung.com, gregkh@linuxfoundation.org,
	linaro-kernel@lists.linaro.org, robdclark@gmail.com,
	daniel@ffwll.ch, intel-gfx@lists.freedesktop.org,
	linux-tegra@vger.kernel.org, inki.dae@samsung.com
Subject: Re: [PATCH v3] dma-buf: cleanup dma_buf_export() to make it easily
 extensible
Message-ID: <20150128112339.164c55fd@recife.lan>
In-Reply-To: <1422449643-7829-1-git-send-email-sumit.semwal@linaro.org>
References: <1422449643-7829-1-git-send-email-sumit.semwal@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 28 Jan 2015 18:24:03 +0530
Sumit Semwal <sumit.semwal@linaro.org> escreveu:

> +/**
> + * helper macro for exporters; zeros and fills in most common values
> + */
> +#define DEFINE_DMA_BUF_EXPORT_INFO(a)	\
> +	struct dma_buf_export_info a = { .exp_name = KBUILD_MODNAME }
> +

I suspect that this will let the other fields not initialized.

You likely need to do:

#define DEFINE_DMA_BUF_EXPORT_INFO(a)	\
	struct dma_buf_export_info a = { 	\
	.exp_name = KBUILD_MODNAME;		\
	.fields = 0;				\
...
}

Regards,
Mauro
