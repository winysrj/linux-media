Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50856 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbeFDWck (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 18:32:40 -0400
Subject: Re: [PATCH v2 9/9] xen/gntdev: Expose gntdev's dma-buf API for
 in-kernel use
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-10-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <86f5b340-856c-204f-4ba7-dd51f1e92639@oracle.com>
Date: Mon, 4 Jun 2018 18:36:11 -0400
MIME-Version: 1.0
In-Reply-To: <20180601114132.22596-10-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/01/2018 07:41 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>
> Allow creating grant device context for use by kernel modules which
> require functionality, provided by gntdev. Export symbols for dma-buf
> API provided by the module.

Can you give an example of who'd be using these interfaces?


-boris
