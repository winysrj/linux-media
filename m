Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr00040.outbound.protection.outlook.com ([40.107.0.40]:2048
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387972AbeGWJjO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 05:39:14 -0400
Subject: Re: [PATCH v5 0/8] xen: dma-buf support for grant device
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com
References: <20180720090150.24560-1-andr2000@gmail.com>
 <019c0eb6-8185-d888-ae6f-305ea2d44124@oracle.com>
From: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
Message-ID: <df3e8c07-c8b4-cb12-32ad-119498be114b@epam.com>
Date: Mon, 23 Jul 2018 11:38:59 +0300
MIME-Version: 1.0
In-Reply-To: <019c0eb6-8185-d888-ae6f-305ea2d44124@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2018 05:08 PM, Boris Ostrovsky wrote:
> On 07/20/2018 05:01 AM, Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>> This work is in response to my previous attempt to introduce Xen/DRM
>> zero-copy driver [1] to enable Linux dma-buf API [2] for Xen based
>> frontends/backends. There is also an existing hyper_dmabuf approach
>> available [3] which, if reworked to utilize the proposed solution,
>> can greatly benefit as well.
>
> Lot of warnings on  i386 build:
>
> In file included from
> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.c:24:
> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.h: In
> function ‘xen_drm_front_fb_to_cookie’:
> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.h:129:9:
> warning: cast from pointer to integer of different size
> [-Wpointer-to-int-cast]
>    return (u64)fb;
>           ^
> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.h: In
> function ‘xen_drm_front_dbuf_to_cookie’:
> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.h:134:9:
> warning: cast from pointer to integer of different size
> [-Wpointer-to-int-cast]
>    return (u64)gem_obj;
>           ^
>    CC [M]  net/netfilter/ipset/ip_set_hash_ipport.o
>    CC      drivers/media/rc/keymaps/rc-tango.o
>    CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_fifo.o
>    AR      drivers/misc/built-in.a
> In file included from
> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front_kms.c:20:
> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.h: In
> function ‘xen_drm_front_fb_to_cookie’:
>    CC [M]  drivers/gpu/drm/xen/xen_drm_front_conn.o
> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.h:129:9:
> warning: cast from pointer to integer of different size
> [-Wpointer-to-int-cast]
>    return (u64)fb;
> (and more)
>
The above warnings already have a fix [1] which is expected in 4.19
>
> and then
>
> data/upstream/linux-xen/drivers/xen/gntdev-dmabuf.c: In function
> ‘gntdev_ioctl_dmabuf_exp_from_refs’:
> /data/upstream/linux-xen/drivers/xen/gntdev-dmabuf.c:503:6: warning:
> ‘args.fd’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>    *fd = args.fd;
>    ~~~~^~~~~~~~~
> /data/upstream/linux-xen/drivers/xen/gntdev-dmabuf.c:467:35: note:
> ‘args.fd’ was declared here
>    struct gntdev_dmabuf_export_args args;
>                                     ^~~~
Strangely, but my i386 build goes smooth.
Which version of gcc you use and could you please give me your
.config, so I can test the same?
>
> -boris
Thank you,
Oleksandr

[1] 
https://cgit.freedesktop.org/drm/drm-misc/commit/?id=9eece5d9c6e0316f17091e37ff3ec87331bdedf3
