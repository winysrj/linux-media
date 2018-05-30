Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35067 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751912AbeE3F1G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 01:27:06 -0400
Subject: Re: [PATCH 1/8] xen/grant-table: Make set/clear page private code
 shared
To: Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
 <20180525153331.31188-2-andr2000@gmail.com>
 <a43d9dd4-c826-1dab-e397-d60796de3a76@suse.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <089b3c85-cdc4-f8bd-0895-50b2b4aa4ca2@gmail.com>
Date: Wed, 30 May 2018 08:27:02 +0300
MIME-Version: 1.0
In-Reply-To: <a43d9dd4-c826-1dab-e397-d60796de3a76@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/2018 07:24 AM, Juergen Gross wrote:
> On 25/05/18 17:33, Oleksandr Andrushchenko wrote:
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
> EXPORT_SYMBOL_GPL()
Sure, I was confused by the fact that there are only 2 functions in the file
which are exported as:
  - EXPORT_SYMBOL(gnttab_alloc_pages);
  - EXPORT_SYMBOL(gnttab_free_pages);
and those were the base for the new 
gnttab_pages_set_private/gnttab_pages_clear_private
This made me think I have to retain the same EXPORT_SYMBOL for them.
Do you want me to add one more patch into this series and change
gnttab_alloc_pages/gnttab_free_pages to GPL as well?
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
> EXPORT_SYMBOL_GPL()
Will change
>
> Juergen
Thank you,
Oleksandr
