Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49903 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751262AbdCCLHf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 06:07:35 -0500
Date: Fri, 3 Mar 2017 14:04:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com,
        devel@driverdev.osuosl.org, romlem@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 04/12] staging: android: ion: Call dma_map_sg for
 syncing and mapping
Message-ID: <20170303110329.GA4132@mwanda>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
 <1488491084-17252-5-git-send-email-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488491084-17252-5-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 02, 2017 at 01:44:36PM -0800, Laura Abbott wrote:
>  static struct sg_table *ion_map_dma_buf(struct dma_buf_attachment *attachment,
>  					enum dma_data_direction direction)
>  {
>  	struct dma_buf *dmabuf = attachment->dmabuf;
>  	struct ion_buffer *buffer = dmabuf->priv;
> +	struct sg_table *table;
> +	int ret;
> +
> +	/*
> +	 * TODO: Need to sync wrt CPU or device completely owning?
> +	 */
> +
> +	table = dup_sg_table(buffer->sg_table);
>  
> -	ion_buffer_sync_for_device(buffer, attachment->dev, direction);
> -	return dup_sg_table(buffer->sg_table);
> +	if (!dma_map_sg(attachment->dev, table->sgl, table->nents,
> +			direction)){
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +err:
> +	free_duped_table(table);
> +	return ERR_PTR(ret);

ret isn't initialized on success.

>  }
>  

regards,
dan carpenter
