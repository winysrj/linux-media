Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57454 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935038AbeFMBMb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 21:12:31 -0400
Subject: Re: [PATCH v3 4/9] xen/grant-table: Allow allocating buffers suitable
 for DMA
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-5-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <4ab26c9a-155a-cd04-fbf6-c38c6429959b@oracle.com>
Date: Tue, 12 Jun 2018 21:12:15 -0400
MIME-Version: 1.0
In-Reply-To: <20180612134200.17456-5-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/12/2018 09:41 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> 
> Extend grant table module API to allow allocating buffers that can
> be used for DMA operations and mapping foreign grant references
> on top of those.
> The resulting buffer is similar to the one allocated by the balloon
> driver in terms that proper memory reservation is made
> ({increase|decrease}_reservation and VA mappings updated if needed).
> This is useful for sharing foreign buffers with HW drivers which
> cannot work with scattered buffers provided by the balloon driver,
> but require DMAable memory instead.
> 
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

with a small nit below


> ---
>   drivers/xen/Kconfig       | 13 ++++++
>   drivers/xen/grant-table.c | 97 +++++++++++++++++++++++++++++++++++++++
>   include/xen/grant_table.h | 18 ++++++++
>   3 files changed, 128 insertions(+)
> 
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index e5d0c28372ea..39536ddfbce4 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -161,6 +161,19 @@ config XEN_GRANT_DEV_ALLOC
>   	  to other domains. This can be used to implement frontend drivers
>   	  or as part of an inter-domain shared memory channel.
>   
> +config XEN_GRANT_DMA_ALLOC
> +	bool "Allow allocating DMA capable buffers with grant reference module"
> +	depends on XEN && HAS_DMA
> +	help
> +	  Extends grant table module API to allow allocating DMA capable
> +	  buffers and mapping foreign grant references on top of it.
> +	  The resulting buffer is similar to one allocated by the balloon
> +	  driver in terms that proper memory reservation is made
> +	  ({increase|decrease}_reservation and VA mappings updated if needed).

I think you should drop the word "terms" and say "is made *by*" and "VA 
mappings *are* updated"

And similar change in the commit message.

-boris
