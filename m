Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34719 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdCQS0U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 14:26:20 -0400
Received: by mail-qk0-f178.google.com with SMTP id p64so71336700qke.1
        for <linux-media@vger.kernel.org>; Fri, 17 Mar 2017 11:25:14 -0700 (PDT)
Subject: Re: [RFC PATCH 08/12] cma: Store a name in the cma structure
To: Sumit Semwal <sumit.semwal@linaro.org>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
 <1488491084-17252-9-git-send-email-labbott@redhat.com>
 <CAO_48GEHxuMMwZO71ytaVhRkapMYaAWBWd1gW+ktspnQg=b8Sw@mail.gmail.com>
Cc: Riley Andrews <riandrews@android.com>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXY=?= =?UTF-8?B?77+9Zw==?=
        <arve@android.com>, Rom Lemarchand <romlem@google.com>,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <7c750fb1-d019-03c1-a682-3bc04c6730ac@redhat.com>
Date: Fri, 17 Mar 2017 11:02:34 -0700
MIME-Version: 1.0
In-Reply-To: <CAO_48GEHxuMMwZO71ytaVhRkapMYaAWBWd1gW+ktspnQg=b8Sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2017 12:53 AM, Sumit Semwal wrote:
> Hi Laura,
> 
> Thanks for the patch.
> 
> On 3 March 2017 at 03:14, Laura Abbott <labbott@redhat.com> wrote:
>>
>> Frameworks that may want to enumerate CMA heaps (e.g. Ion) will find it
>> useful to have an explicit name attached to each region. Store the name
>> in each CMA structure.
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>>  drivers/base/dma-contiguous.c |  5 +++--
>>  include/linux/cma.h           |  4 +++-
>>  mm/cma.c                      | 11 +++++++++--
>>  mm/cma.h                      |  1 +
>>  mm/cma_debug.c                |  2 +-
>>  5 files changed, 17 insertions(+), 6 deletions(-)
>>
> <snip>
>> +const char *cma_get_name(const struct cma *cma)
>> +{
>> +       return cma->name ? cma->name : "(undefined)";
>> +}
>> +
> Would it make sense to perhaps have the idx stored as the name,
> instead of 'undefined'? That would make sure that the various cma
> names are still unique.
> 

Good suggestion. I'll see about cleaning that up.

>>  static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
>>                                              int align_order)
>>  {
>> @@ -168,6 +173,7 @@ core_initcall(cma_init_reserved_areas);
>>   */
>>  int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
>>                                  unsigned int order_per_bit,
>> +                                const char *name,
>>                                  struct cma **res_cma)
>>  {
> 
> Best regards,
> Sumit.
> 
