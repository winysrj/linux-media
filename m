Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr40040.outbound.protection.outlook.com ([40.107.4.40]:46495
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387968AbeGWQxR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 12:53:17 -0400
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
 <df3e8c07-c8b4-cb12-32ad-119498be114b@epam.com>
 <80a074ac-91db-82db-d094-660d859cf903@epam.com>
 <9d2889f6-32d3-03d7-2a6d-341e691287b3@oracle.com>
From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Message-ID: <5fc34b4b-3587-791a-d17c-7da955b393bd@epam.com>
Date: Mon, 23 Jul 2018 18:50:56 +0300
MIME-Version: 1.0
In-Reply-To: <9d2889f6-32d3-03d7-2a6d-341e691287b3@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2018 06:22 PM, Boris Ostrovsky wrote:
> On 07/23/2018 09:26 AM, Oleksandr Andrushchenko wrote:
>> On 07/23/2018 11:38 AM, Oleksandr Andrushchenko wrote:
>>>> data/upstream/linux-xen/drivers/xen/gntdev-dmabuf.c: In function
>>>> ‘gntdev_ioctl_dmabuf_exp_from_refs’:
>>>> /data/upstream/linux-xen/drivers/xen/gntdev-dmabuf.c:503:6: warning:
>>>> ‘args.fd’ may be used uninitialized in this function
>>>> [-Wmaybe-uninitialized]
>>>>     *fd = args.fd;
>>>>     ~~~~^~~~~~~~~
>>>> /data/upstream/linux-xen/drivers/xen/gntdev-dmabuf.c:467:35: note:
>>>> ‘args.fd’ was declared here
>>>>     struct gntdev_dmabuf_export_args args;
>>>>                                      ^~~~
>>> Strangely, but my i386 build goes smooth.
>>> Which version of gcc you use and could you please give me your
>>> .config, so I can test the same?
>> Now I see this warning which seems to be a false positive.
>> Boris, could you please apply the following:
>>
>> diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
>> index e4c9f1f74476..0680dbcba616 100644
>> --- a/drivers/xen/gntdev-dmabuf.c
>> +++ b/drivers/xen/gntdev-dmabuf.c
>> @@ -495,6 +495,7 @@ static int dmabuf_exp_from_refs(struct gntdev_priv
>> *priv, int flags,
>>          args.dmabuf_priv = priv->dmabuf_priv;
>>          args.count = map->count;
>>          args.pages = map->pages;
>> +       args.fd = -1;
>>
>>          ret = dmabuf_exp_from_pages(&args);
>>          if (ret < 0)
>>
>> or please let me know if you want me to resend with this fix?
>
> Missed this message. Yes, this obviously fixes the problem. And it is
> due to the code fragment that I mentioned in the earlier response.
>
> Which patch is this for? I can add this when committing.
Thank you, this is for "[PATCH v5 7/8] xen/gntdev: Implement dma-buf 
export functionality"
> -boris
Thank you,
Oleksandr
