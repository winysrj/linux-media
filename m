Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36225 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753895AbeEaFhg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 01:37:36 -0400
Subject: Re: [PATCH 1/8] xen/grant-table: Make set/clear page private code
 shared
To: Dongwon Kim <dongwon.kim@intel.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, daniel.vetter@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
 <20180525153331.31188-2-andr2000@gmail.com>
 <20180530213416.GA3159@downor-Z87X-UD5H>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <3830bb6c-62e8-199a-aef3-59ccc0e59017@gmail.com>
Date: Thu, 31 May 2018 08:37:32 +0300
MIME-Version: 1.0
In-Reply-To: <20180530213416.GA3159@downor-Z87X-UD5H>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/31/2018 12:34 AM, Dongwon Kim wrote:
> On Fri, May 25, 2018 at 06:33:24PM +0300, Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>> Make set/clear page private code shared and accessible to
>> other kernel modules which can re-use these instead of open-coding.
>>
>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>> ---
>>   drivers/xen/grant-table.c | 54 +++++++++++++++++++++++++--------------
>>   include/xen/grant_table.h |  3 +++
>>   2 files changed, 38 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
>> index 27be107d6480..d7488226e1f2 100644
>> --- a/drivers/xen/grant-table.c
>> +++ b/drivers/xen/grant-table.c
>> @@ -769,29 +769,18 @@ void gnttab_free_auto_xlat_frames(void)
>>   }
>>   EXPORT_SYMBOL_GPL(gnttab_free_auto_xlat_frames);
>>   
>> -/**
>> - * gnttab_alloc_pages - alloc pages suitable for grant mapping into
>> - * @nr_pages: number of pages to alloc
>> - * @pages: returns the pages
>> - */
>> -int gnttab_alloc_pages(int nr_pages, struct page **pages)
>> +int gnttab_pages_set_private(int nr_pages, struct page **pages)
>>   {
>>   	int i;
>> -	int ret;
>> -
>> -	ret = alloc_xenballooned_pages(nr_pages, pages);
>> -	if (ret < 0)
>> -		return ret;
>>   
>>   	for (i = 0; i < nr_pages; i++) {
>>   #if BITS_PER_LONG < 64
>>   		struct xen_page_foreign *foreign;
>>   
>>   		foreign = kzalloc(sizeof(*foreign), GFP_KERNEL);
>> -		if (!foreign) {
>> -			gnttab_free_pages(nr_pages, pages);
>> +		if (!foreign)
> Don't we have to free previously allocated "foreign"(s) if it fails in the middle
> (e.g. 0 < i && i < nr_pages - 1) before returning?
gnttab_free_pages(nr_pages, pages); will take care of it when called from
outside, see below. It can also handle partial allocations, so no problem
here
>>   			return -ENOMEM;
>> -		}
>> +
>>   		set_page_private(pages[i], (unsigned long)foreign);
>>   #endif
>>   		SetPagePrivate(pages[i]);
>> @@ -799,14 +788,30 @@ int gnttab_alloc_pages(int nr_pages, struct page **pages)
>>   
>>   	return 0;
>>   }
>> -EXPORT_SYMBOL(gnttab_alloc_pages);
>> +EXPORT_SYMBOL(gnttab_pages_set_private);
>>   
>>   /**
>> - * gnttab_free_pages - free pages allocated by gnttab_alloc_pages()
>> - * @nr_pages; number of pages to free
>> - * @pages: the pages
>> + * gnttab_alloc_pages - alloc pages suitable for grant mapping into
>> + * @nr_pages: number of pages to alloc
>> + * @pages: returns the pages
>>    */
>> -void gnttab_free_pages(int nr_pages, struct page **pages)
>> +int gnttab_alloc_pages(int nr_pages, struct page **pages)
>> +{
>> +	int ret;
>> +
>> +	ret = alloc_xenballooned_pages(nr_pages, pages);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = gnttab_pages_set_private(nr_pages, pages);
>> +	if (ret < 0)
>> +		gnttab_free_pages(nr_pages, pages);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(gnttab_alloc_pages);
>> +
>> +void gnttab_pages_clear_private(int nr_pages, struct page **pages)
>>   {
>>   	int i;
>>   
>> @@ -818,6 +823,17 @@ void gnttab_free_pages(int nr_pages, struct page **pages)
>>   			ClearPagePrivate(pages[i]);
>>   		}
>>   	}
>> +}
>> +EXPORT_SYMBOL(gnttab_pages_clear_private);
>> +
>> +/**
>> + * gnttab_free_pages - free pages allocated by gnttab_alloc_pages()
>> + * @nr_pages; number of pages to free
>> + * @pages: the pages
>> + */
>> +void gnttab_free_pages(int nr_pages, struct page **pages)
>> +{
>> +	gnttab_pages_clear_private(nr_pages, pages);
>>   	free_xenballooned_pages(nr_pages, pages);
>>   }
>>   EXPORT_SYMBOL(gnttab_free_pages);
>> diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
>> index 2e37741f6b8d..de03f2542bb7 100644
>> --- a/include/xen/grant_table.h
>> +++ b/include/xen/grant_table.h
>> @@ -198,6 +198,9 @@ void gnttab_free_auto_xlat_frames(void);
>>   int gnttab_alloc_pages(int nr_pages, struct page **pages);
>>   void gnttab_free_pages(int nr_pages, struct page **pages);
>>   
>> +int gnttab_pages_set_private(int nr_pages, struct page **pages);
>> +void gnttab_pages_clear_private(int nr_pages, struct page **pages);
>> +
>>   int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>>   		    struct gnttab_map_grant_ref *kmap_ops,
>>   		    struct page **pages, unsigned int count);
>> -- 
>> 2.17.0
>>
