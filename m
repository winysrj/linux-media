Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:43211 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934115AbeFMHIC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 03:08:02 -0400
Subject: Re: [PATCH v3 4/9] xen/grant-table: Allow allocating buffers suitable
 for DMA
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-5-andr2000@gmail.com>
 <4ab26c9a-155a-cd04-fbf6-c38c6429959b@oracle.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <ffd6eb5a-b057-8cca-c8cb-75fd97b63a45@gmail.com>
Date: Wed, 13 Jun 2018 10:07:58 +0300
MIME-Version: 1.0
In-Reply-To: <4ab26c9a-155a-cd04-fbf6-c38c6429959b@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2018 04:12 AM, Boris Ostrovsky wrote:
>
>
> On 06/12/2018 09:41 AM, Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>> Extend grant table module API to allow allocating buffers that can
>> be used for DMA operations and mapping foreign grant references
>> on top of those.
>> The resulting buffer is similar to the one allocated by the balloon
>> driver in terms that proper memory reservation is made
>> ({increase|decrease}_reservation and VA mappings updated if needed).
>> This is useful for sharing foreign buffers with HW drivers which
>> cannot work with scattered buffers provided by the balloon driver,
>> but require DMAable memory instead.
>>
>> Signed-off-by: Oleksandr Andrushchenko 
>> <oleksandr_andrushchenko@epam.com>
>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>
> with a small nit below
>
>
>> ---
>>   drivers/xen/Kconfig       | 13 ++++++
>>   drivers/xen/grant-table.c | 97 +++++++++++++++++++++++++++++++++++++++
>>   include/xen/grant_table.h | 18 ++++++++
>>   3 files changed, 128 insertions(+)
>>
>> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
>> index e5d0c28372ea..39536ddfbce4 100644
>> --- a/drivers/xen/Kconfig
>> +++ b/drivers/xen/Kconfig
>> @@ -161,6 +161,19 @@ config XEN_GRANT_DEV_ALLOC
>>         to other domains. This can be used to implement frontend drivers
>>         or as part of an inter-domain shared memory channel.
>>   +config XEN_GRANT_DMA_ALLOC
>> +    bool "Allow allocating DMA capable buffers with grant reference 
>> module"
>> +    depends on XEN && HAS_DMA
>> +    help
>> +      Extends grant table module API to allow allocating DMA capable
>> +      buffers and mapping foreign grant references on top of it.
>> +      The resulting buffer is similar to one allocated by the balloon
>> +      driver in terms that proper memory reservation is made
>> +      ({increase|decrease}_reservation and VA mappings updated if 
>> needed).
>
> I think you should drop the word "terms" and say "is made *by*" and 
> "VA mappings *are* updated"
>
> And similar change in the commit message.
>
Will, change, thank you
> -boris
>
