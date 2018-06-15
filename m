Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60162 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752884AbeFOVA5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 17:00:57 -0400
Subject: Re: [PATCH v4 7/9] xen/gntdev: Add initial support for dma-buf UAPI
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180615062753.9229-1-andr2000@gmail.com>
 <20180615062753.9229-8-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <48b11773-8d69-9386-b60c-c34a6b2803af@oracle.com>
Date: Fri, 15 Jun 2018 17:00:25 -0400
MIME-Version: 1.0
In-Reply-To: <20180615062753.9229-8-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2018 02:27 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>
> Add UAPI and IOCTLs for dma-buf grant device driver extension:
> the extension allows userspace processes and kernel modules to
> use Xen backed dma-buf implementation. With this extension grant
> references to the pages of an imported dma-buf can be exported
> for other domain use and grant references coming from a foreign
> domain can be converted into a local dma-buf for local export.
> Implement basic initialization and stubs for Xen DMA buffers'
> support.
>
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
