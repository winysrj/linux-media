Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:56249 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbbA2Bj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 20:39:56 -0500
Received: by mail-oi0-f41.google.com with SMTP id z81so22196685oif.0
        for <linux-media@vger.kernel.org>; Wed, 28 Jan 2015 17:39:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54C8C612.1030701@linaro.org>
References: <1422424845-14906-1-git-send-email-sumit.semwal@linaro.org> <54C8C612.1030701@linaro.org>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 28 Jan 2015 17:57:28 +0530
Message-ID: <CAO_48GF7CQvY4dF4RoXytSkAQPf-AMsO9Co_UvpS4hr4TY_Wig@mail.gmail.com>
Subject: Re: [PATCH v2] dma-buf: cleanup dma_buf_export() to make it easily extensible
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	rmk+kernel@arm.linux.org.uk, Dave Airlie <airlied@linux.ie>,
	kgene@kernel.org, daniel.vetter@intel.com,
	Thierry Reding <thierry.reding@gmail.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	intel-gfx@lists.freedesktop.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28 January 2015 at 16:50, Daniel Thompson <daniel.thompson@linaro.org> wrote:
> On 28/01/15 06:00, Sumit Semwal wrote:
<snip>
>> +/**
>> + * helper macro for exporters; zeros and fills in most common values
>> + */
>> +#define DEFINE_DMA_BUF_EXPORT_INFO(a)                        \
>> +     struct dma_buf_export_info a = {0};             \
>> +     exp_info.exp_name = KBUILD_MODNAME
>> +
>
> This risks generating C99 warnings unless used with care (and only once
> per function). Shouldn't this be more like:
>
> #define DEFINE_DMA_BUF_EXPORT_INFO(a) \
>     struct dma_buf_export_info a = { .exp_name = KBUILD_MODNAME }
>

Ah! My bad; thanks for catching this, Daniel; I'll send out the
updated patch in a minute!
> Daniel.
>



-- 
Thanks and regards,

Sumit Semwal
Kernel Team Lead - Linaro Mobile Group
Linaro.org │ Open source software for ARM SoCs
