Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43448 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751619AbeFDWYo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 18:24:44 -0400
Subject: Re: [PATCH v2 8/9] xen/gntdev: Implement dma-buf import functionality
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-9-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <7ef4f26e-4225-ea7e-8183-9a6c3fe69345@oracle.com>
Date: Mon, 4 Jun 2018 18:28:18 -0400
MIME-Version: 1.0
In-Reply-To: <20180601114132.22596-9-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/01/2018 07:41 AM, Oleksandr Andrushchenko wrote:
>  /* ------------------------------------------------------------------ */
>  
> +static int
> +dmabuf_imp_grant_foreign_access(struct page **pages, u32 *refs,
> +				int count, int domid)
> +{
> +	grant_ref_t priv_gref_head;
> +	int i, ret;
> +
> +	ret = gnttab_alloc_grant_references(count, &priv_gref_head);
> +	if (ret < 0) {
> +		pr_err("Cannot allocate grant references, ret %d\n", ret);
> +		return ret;
> +	}
> +
> +	for (i = 0; i < count; i++) {
> +		int cur_ref;
> +
> +		cur_ref = gnttab_claim_grant_reference(&priv_gref_head);
> +		if (cur_ref < 0) {
> +			ret = cur_ref;
> +			pr_err("Cannot claim grant reference, ret %d\n", ret);
> +			goto out;
> +		}
> +
> +		gnttab_grant_foreign_access_ref(cur_ref, domid,
> +						xen_page_to_gfn(pages[i]), 0);
> +		refs[i] = cur_ref;
> +	}
> +
> +	ret = 0;

return 0?

> +
> +out:
> +	gnttab_free_grant_references(priv_gref_head);
> +	return ret;
> +}
> +
