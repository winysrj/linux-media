Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45868 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbeGaSp5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 14:45:57 -0400
Subject: Re: [PATCH v5 0/8] xen: dma-buf support for grant device
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180720090150.24560-1-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <b321da31-24ea-7bfd-769c-0cdec85844c8@oracle.com>
Date: Tue, 31 Jul 2018 13:04:48 -0400
MIME-Version: 1.0
In-Reply-To: <20180720090150.24560-1-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2018 05:01 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>
> This work is in response to my previous attempt to introduce Xen/DRM
> zero-copy driver [1] to enable Linux dma-buf API [2] for Xen based
> frontends/backends. There is also an existing hyper_dmabuf approach
> available [3] which, if reworked to utilize the proposed solution,
> can greatly benefit as well.
>


Applied to for-linus-4.19.

-boris
