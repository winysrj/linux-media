Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4433.biz.mail.alibaba.com ([47.88.44.33]:55967 "EHLO
        out4433.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751610AbdCCJCY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 04:02:24 -0500
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Laura Abbott'" <labbott@redhat.com>,
        "'Sumit Semwal'" <sumit.semwal@linaro.org>,
        "'Riley Andrews'" <riandrews@android.com>, <arve@android.com>
Cc: <romlem@google.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <linaro-mm-sig@lists.linaro.org>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "'Brian Starkey'" <brian.starkey@arm.com>,
        "'Daniel Vetter'" <daniel.vetter@intel.com>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Benjamin Gaignard'" <benjamin.gaignard@linaro.org>,
        <linux-mm@kvack.org>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com> <1488491084-17252-4-git-send-email-labbott@redhat.com>
In-Reply-To: <1488491084-17252-4-git-send-email-labbott@redhat.com>
Subject: Re: [RFC PATCH 03/12] staging: android: ion: Duplicate sg_table
Date: Fri, 03 Mar 2017 16:18:27 +0800
Message-ID: <07df01d293f6$bcfb4f30$36f1ed90$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: zh-cn
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On March 03, 2017 5:45 AM Laura Abbott wrote: 
> 
> +static struct sg_table *dup_sg_table(struct sg_table *table)
> +{
> +	struct sg_table *new_table;
> +	int ret, i;
> +	struct scatterlist *sg, *new_sg;
> +
> +	new_table = kzalloc(sizeof(*new_table), GFP_KERNEL);
> +	if (!new_table)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ret = sg_alloc_table(new_table, table->nents, GFP_KERNEL);
> +	if (ret) {
> +		kfree(table);

Free new table?

> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	new_sg = new_table->sgl;
> +	for_each_sg(table->sgl, sg, table->nents, i) {
> +		memcpy(new_sg, sg, sizeof(*sg));
> +		sg->dma_address = 0;
> +		new_sg = sg_next(new_sg);
> +	}
> +

Do we need a helper, sg_copy_table(dst_table, src_table)?

> +	return new_table;
> +}
> +
