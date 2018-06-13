Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56460 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935320AbeFMWTw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 18:19:52 -0400
Subject: Re: [PATCH v3 8/9] xen/gntdev: Implement dma-buf export functionality
To: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-9-andr2000@gmail.com>
 <bd5adb0e-af98-528f-d6f9-9d5888ff2412@oracle.com>
 <5c50f951-47db-782d-1ac2-162892f7ec91@epam.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <35fb3f9b-2817-f284-6318-588a72c71f98@oracle.com>
Date: Wed, 13 Jun 2018 18:19:26 -0400
MIME-Version: 1.0
In-Reply-To: <5c50f951-47db-782d-1ac2-162892f7ec91@epam.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2018 07:57 AM, Oleksandr Andrushchenko wrote:
> On 06/13/2018 05:58 AM, Boris Ostrovsky wrote:
>>
>>
>> On 06/12/2018 09:41 AM, Oleksandr Andrushchenko wrote:
>>>
>>> +
>>> +static struct gntdev_dmabuf *
>>> +dmabuf_exp_wait_obj_get_by_fd(struct gntdev_dmabuf_priv *priv, int fd)
>>
>>
>> The name of this routine implies (to me) that we are getting a wait
>> object but IIUIC we are getting a gntdev_dmabuf that we are going to
>> later associate with a wait object.
>>
> How about dmabuf_exp_wait_obj_get_dmabuf_by_fd?
> I would like to keep function prefixes, e.g. dmabuf_exp_wait_obj_
> just to show to which functionality a routine belongs.


That's too long IMO. If you really want to keep the prefix then let's
keep this the way it is. Maybe it's just me who read it that way.


>>
>>>
>>>   +#ifdef CONFIG_XEN_GNTDEV_DMABUF
>>> +void gntdev_remove_map(struct gntdev_priv *priv, struct
>>> gntdev_grant_map *map)
>>> +{
>>> +    mutex_lock(&priv->lock);
>>> +    list_del(&map->next);
>>> +    gntdev_put_map(NULL /* already removed */, map);
>>
>>
>> Why not pass call gntdev_put_map(priv, map) and then not have this
>> routine at all?
>>
> Well, I wish I could, but the main difference when calling
> gntdev_put_map(priv, map)
> with priv != NULL and my code is that:
>
> void gntdev_put_map(struct gntdev_priv *priv, struct gntdev_grant_map
> *map)
> {
>     [...]
>     if (populate_freeable_maps && priv) {
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>         mutex_lock(&priv->lock);
>         list_del(&map->next);
>         mutex_unlock(&priv->lock);
>     }
>     [...]
> }
>
> and
>
> #define populate_freeable_maps use_ptemod
>                                ^^^^^^^^^^
> which means the map will never be removed from the list in my case
> because use_ptemod == false for dma-buf.
> This is why I do that by hand, e.g. remove the item from the list
> and then pass NULL for priv.
>
> Also, I will remove gntdev_remove_map as I can now access
> priv->lock and gntdev_put_map directly form gntdev-dmabuf.c


Yes, that's a good idea.

>
>> I really dislike the fact that we are taking a lock here that
>> gntdev_put_map() takes as well, although not with NULL argument. (And
>> yes, I see that gntdev_release() does it too.)
>>
> This can be re-factored later I guess?

OK.

-boris
