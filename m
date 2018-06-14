Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58494 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754718AbeFNRtS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 13:49:18 -0400
Subject: Re: [PATCH v3 0/9] xen: dma-buf support for grant device
To: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>,
        jgross@suse.com
Cc: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        konrad.wilk@oracle.com, daniel.vetter@intel.com,
        dongwon.kim@intel.com, matthew.d.roper@intel.com
References: <20180612134200.17456-1-andr2000@gmail.com>
 <1088db4b-cf75-817f-2112-41b96006cd3d@epam.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <d93c0ad8-75a2-3426-e5e3-0b13725ca19f@oracle.com>
Date: Thu, 14 Jun 2018 13:48:47 -0400
MIME-Version: 1.0
In-Reply-To: <1088db4b-cf75-817f-2112-41b96006cd3d@epam.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2018 02:47 AM, Oleksandr Andrushchenko wrote:
> Hi, Boris!
>
> It seems that I have resolved all the issues now which
> were mainly cleanup and code movement and 5 of 9 patches
> already have r-b's. Do you, as the primary reviewer of the
> series, think I can push (hopefully) the final version
> of the patches? Just in case you want to look at v4 it is at [1].
>
> Thank you,
> Oleksandr
>
> [1]
> https://github.com/andr2000/linux/commits/xen_tip_linux_next_xen_dma_buf_v4


Looks good to me.


-boris
