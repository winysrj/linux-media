Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39698 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933390AbeFMBIN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 21:08:13 -0400
Subject: Re: [PATCH v3 3/9] xen/balloon: Share common memory reservation
 routines
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-4-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <124f3832-63b4-021d-0c6f-470229c7a056@oracle.com>
Date: Tue, 12 Jun 2018 21:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <20180612134200.17456-4-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/12/2018 09:41 AM, Oleksandr Andrushchenko wrote:



One more thing: please add a comment here saying that frames array is 
array of PFNs (in Xen granularity), which is what 
XENMEM_populate_physmap requires. And remove (or update to name the 
actual call you are making) the corresponding comment in 
increase_reservation().


> +
> +int xenmem_reservation_increase(int count, xen_pfn_t *frames)
> +{
> +	struct xen_memory_reservation reservation = {
> +		.address_bits = 0,
> +		.extent_order = EXTENT_ORDER,
> +		.domid        = DOMID_SELF
> +	};
> +
> +	set_xen_guest_handle(reservation.extent_start, frames);
> +	reservation.nr_extents = count;
> +	return HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
> +}
> +EXPORT_SYMBOL_GPL(xenmem_reservation_increase);


And similarly, here we are requesting GFNs, and update 
decrease_reservation().


-boris

> +
> +int xenmem_reservation_decrease(int count, xen_pfn_t *frames)
> +{
> +	struct xen_memory_reservation reservation = {
> +		.address_bits = 0,
> +		.extent_order = EXTENT_ORDER,
> +		.domid        = DOMID_SELF
> +	};
> +
> +	set_xen_guest_handle(reservation.extent_start, frames);
> +	reservation.nr_extents = count;
> +	return HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
