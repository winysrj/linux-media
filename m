Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr10045.outbound.protection.outlook.com ([40.107.1.45]:53664
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387986AbeGWO14 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:27:56 -0400
Subject: Re: [PATCH v5 0/8] xen: dma-buf support for grant device
From: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com
References: <20180720090150.24560-1-andr2000@gmail.com>
 <019c0eb6-8185-d888-ae6f-305ea2d44124@oracle.com>
 <df3e8c07-c8b4-cb12-32ad-119498be114b@epam.com>
Message-ID: <80a074ac-91db-82db-d094-660d859cf903@epam.com>
Date: Mon, 23 Jul 2018 16:26:30 +0300
MIME-Version: 1.0
In-Reply-To: <df3e8c07-c8b4-cb12-32ad-119498be114b@epam.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2018 11:38 AM, Oleksandr Andrushchenko wrote:
> On 07/20/2018 05:08 PM, Boris Ostrovsky wrote:
>> On 07/20/2018 05:01 AM, Oleksandr Andrushchenko wrote:
>>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>
>>> This work is in response to my previous attempt to introduce Xen/DRM
>>> zero-copy driver [1] to enable Linux dma-buf API [2] for Xen based
>>> frontends/backends. There is also an existing hyper_dmabuf approach
>>> available [3] which, if reworked to utilize the proposed solution,
>>> can greatly benefit as well.
>>
>> Lot of warnings on  i386 build:
>>
>> In file included from
>> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.c:24:
>> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.h: In
>> function ‘xen_drm_front_fb_to_cookie’:
>> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.h:129:9:
>> warning: cast from pointer to integer of different size
>> [-Wpointer-to-int-cast]
>>    return (u64)fb;
>>           ^
>> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.h: In
>> function ‘xen_drm_front_dbuf_to_cookie’:
>> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.h:134:9:
>> warning: cast from pointer to integer of different size
>> [-Wpointer-to-int-cast]
>>    return (u64)gem_obj;
>>           ^
>>    CC [M]  net/netfilter/ipset/ip_set_hash_ipport.o
>>    CC      drivers/media/rc/keymaps/rc-tango.o
>>    CC [M]  drivers/gpu/drm/vmwgfx/vmwgfx_fifo.o
>>    AR      drivers/misc/built-in.a
>> In file included from
>> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front_kms.c:20:
>> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.h: In
>> function ‘xen_drm_front_fb_to_cookie’:
>>    CC [M]  drivers/gpu/drm/xen/xen_drm_front_conn.o
>> /data/upstream/linux-xen/drivers/gpu/drm/xen/xen_drm_front.h:129:9:
>> warning: cast from pointer to integer of different size
>> [-Wpointer-to-int-cast]
>>    return (u64)fb;
>> (and more)
>>
> The above warnings already have a fix [1] which is expected in 4.19
>>
>> and then
>>
>> data/upstream/linux-xen/drivers/xen/gntdev-dmabuf.c: In function
>> ‘gntdev_ioctl_dmabuf_exp_from_refs’:
>> /data/upstream/linux-xen/drivers/xen/gntdev-dmabuf.c:503:6: warning:
>> ‘args.fd’ may be used uninitialized in this function 
>> [-Wmaybe-uninitialized]
>>    *fd = args.fd;
>>    ~~~~^~~~~~~~~
>> /data/upstream/linux-xen/drivers/xen/gntdev-dmabuf.c:467:35: note:
>> ‘args.fd’ was declared here
>>    struct gntdev_dmabuf_export_args args;
>>                                     ^~~~
> Strangely, but my i386 build goes smooth.
> Which version of gcc you use and could you please give me your
> .config, so I can test the same?
Now I see this warning which seems to be a false positive.
Boris, could you please apply the following:

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index e4c9f1f74476..0680dbcba616 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -495,6 +495,7 @@ static int dmabuf_exp_from_refs(struct gntdev_priv 
*priv, int flags,
         args.dmabuf_priv = priv->dmabuf_priv;
         args.count = map->count;
         args.pages = map->pages;
+       args.fd = -1;

         ret = dmabuf_exp_from_pages(&args);
         if (ret < 0)

or please let me know if you want me to resend with this fix?
>>
>> -boris
> Thank you,
> Oleksandr
>
> [1] 
> https://cgit.freedesktop.org/drm/drm-misc/commit/?id=9eece5d9c6e0316f17091e37ff3ec87331bdedf3

Thank you,
Oleksandr
