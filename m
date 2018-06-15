Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33994 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756455AbeFOVDf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 17:03:35 -0400
Subject: Re: [PATCH v4 9/9] xen/gntdev: Implement dma-buf import functionality
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180615062753.9229-1-andr2000@gmail.com>
 <20180615062753.9229-10-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <33f9ab75-4297-d4e0-4ad5-d432cbf3242d@oracle.com>
Date: Fri, 15 Jun 2018 17:03:10 -0400
MIME-Version: 1.0
In-Reply-To: <20180615062753.9229-10-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2018 02:27 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>
> 1. Import a dma-buf with the file descriptor provided and export
>    granted references to the pages of that dma-buf into the array
>    of grant references.
>
> 2. Add API to close all references to an imported buffer, so it can be
>    released by the owner. This is only valid for buffers created with
>    IOCTL_GNTDEV_DMABUF_IMP_TO_REFS.
>
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>


Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
