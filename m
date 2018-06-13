Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve1eur01on0085.outbound.protection.outlook.com ([104.47.1.85]:18560
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754398AbeFMGvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 02:51:00 -0400
Subject: Re: [PATCH v3 3/9] xen/balloon: Share common memory reservation
 routines
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-4-andr2000@gmail.com>
 <124f3832-63b4-021d-0c6f-470229c7a056@oracle.com>
From: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
Message-ID: <1817fea9-36fe-b14b-f266-8e40a5ed6169@epam.com>
Date: Wed, 13 Jun 2018 09:50:52 +0300
MIME-Version: 1.0
In-Reply-To: <124f3832-63b4-021d-0c6f-470229c7a056@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2018 04:07 AM, Boris Ostrovsky wrote:
>
>
> On 06/12/2018 09:41 AM, Oleksandr Andrushchenko wrote:
>
>
>
> One more thing: please add a comment here saying that frames array is 
> array of PFNs (in Xen granularity), which is what 
> XENMEM_populate_physmap requires. And remove (or update to name the 
> actual call you are making) the corresponding comment in 
> increase_reservation().
>
I will remove corresponding comments from the balloon's 
{increase|decrease}_reservation
and move those into xenmem_reservation{increase|decrease} where they 
belong now.
I will also put a comment close to xenmem_reservation{increase|decrease}:

/* @frames is an array of PFNs */
int xenmem_reservation_increase(int count, xen_pfn_t *frames)
{
     [...]
}

/* @frames is an array of GFNs */
int xenmem_reservation_decrease(int count, xen_pfn_t *frames)
{
     [...]
}
>
>> +
>> +int xenmem_reservation_increase(int count, xen_pfn_t *frames)
>> +{
>> +    struct xen_memory_reservation reservation = {
>> +        .address_bits = 0,
>> +        .extent_order = EXTENT_ORDER,
>> +        .domid        = DOMID_SELF
>> +    };
>> +
>> +    set_xen_guest_handle(reservation.extent_start, frames);
>> +    reservation.nr_extents = count;
>> +    return HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
>> +}
>> +EXPORT_SYMBOL_GPL(xenmem_reservation_increase);
>
>
> And similarly, here we are requesting GFNs, and update 
> decrease_reservation().
>
Please see above
>
> -boris
>
Thank you,
Oleksandr
>> +
>> +int xenmem_reservation_decrease(int count, xen_pfn_t *frames)
>> +{
>> +    struct xen_memory_reservation reservation = {
>> +        .address_bits = 0,
>> +        .extent_order = EXTENT_ORDER,
>> +        .domid        = DOMID_SELF
>> +    };
>> +
>> +    set_xen_guest_handle(reservation.extent_start, frames);
>> +    reservation.nr_extents = count;
>> +    return HYPERVISOR_memory_op(XENMEM_decrease_reservation, 
>> &reservation);
