Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:40662 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbeEUFkf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 01:40:35 -0400
Subject: Re: [Xen-devel] [RFC 1/3] xen/balloon: Allow allocating DMA buffers
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, matthew.d.roper@intel.com,
        dongwon.kim@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180517082604.14828-1-andr2000@gmail.com>
 <20180517082604.14828-2-andr2000@gmail.com>
 <6a108876-19b7-49d0-3de2-9e10f984736c@oracle.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <9541926e-001a-e41e-317c-dbff6d687761@gmail.com>
Date: Mon, 21 May 2018 08:40:30 +0300
MIME-Version: 1.0
In-Reply-To: <6a108876-19b7-49d0-3de2-9e10f984736c@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/19/2018 01:04 AM, Boris Ostrovsky wrote:
> On 05/17/2018 04:26 AM, Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>
> A commit message would be useful.
Sure, v1 will have it
>
>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>>   	for (i = 0; i < nr_pages; i++) {
>> -		page = alloc_page(gfp);
>> -		if (page == NULL) {
>> -			nr_pages = i;
>> -			state = BP_EAGAIN;
>> -			break;
>> +		if (ext_pages) {
>> +			page = ext_pages[i];
>> +		} else {
>> +			page = alloc_page(gfp);
>> +			if (page == NULL) {
>> +				nr_pages = i;
>> +				state = BP_EAGAIN;
>> +				break;
>> +			}
>>   		}
>>   		scrub_page(page);
>>   		list_add(&page->lru, &pages);
>> @@ -529,7 +565,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>>   	i = 0;
>>   	list_for_each_entry_safe(page, tmp, &pages, lru) {
>>   		/* XENMEM_decrease_reservation requires a GFN */
>> -		frame_list[i++] = xen_page_to_gfn(page);
>> +		frames[i++] = xen_page_to_gfn(page);
>>   
>>   #ifdef CONFIG_XEN_HAVE_PVMMU
>>   		/*
>> @@ -552,18 +588,22 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>>   #endif
>>   		list_del(&page->lru);
>>   
>> -		balloon_append(page);
>> +		if (!ext_pages)
>> +			balloon_append(page);
>
> So what you are proposing is not really ballooning. You are just
> piggybacking on existing interfaces, aren't you?
Sort of. Basically I need to {increase|decrease}_reservation, not actually
allocating ballooned pages.
Do you think I can simply EXPORT_SYMBOL for {increase|decrease}_reservation?
Any other suggestion?
> -boris
>
>
Thank you,
Oleksandr
