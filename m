Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36605 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753711AbdDJPKX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 11:10:23 -0400
Received: by mail-qk0-f175.google.com with SMTP id d131so2028795qkc.3
        for <linux-media@vger.kernel.org>; Mon, 10 Apr 2017 08:10:23 -0700 (PDT)
Subject: Re: [PATCHv3 17/22] staging: android: ion: Collapse internal header
 files
To: Emil Velikov <emil.l.velikov@gmail.com>
References: <1491245884-15852-1-git-send-email-labbott@redhat.com>
 <1491245884-15852-18-git-send-email-labbott@redhat.com>
 <CACvgo52qr=oBoiMnrww3cgoKozEMi3DwBV55c_GMi0mR_p0GcA@mail.gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>,
        =?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve@android.com>,
        devel@driverdev.osuosl.org, Rom Lemarchand <romlem@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        Mark Brown <broonie@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
From: Laura Abbott <labbott@redhat.com>
Message-ID: <8f94fbd9-6aa4-f7a0-c9f1-8da894fe1eb8@redhat.com>
Date: Mon, 10 Apr 2017 08:10:13 -0700
MIME-Version: 1.0
In-Reply-To: <CACvgo52qr=oBoiMnrww3cgoKozEMi3DwBV55c_GMi0mR_p0GcA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/08/2017 11:12 AM, Emil Velikov wrote:
> Hi Laura,
> 
> Couple of trivial nitpicks below.
> 
> On 3 April 2017 at 19:57, Laura Abbott <labbott@redhat.com> wrote:
> 
>> --- a/drivers/staging/android/ion/ion.h
>> +++ b/drivers/staging/android/ion/ion.h
>> @@ -1,5 +1,5 @@
>>  /*
>> - * drivers/staging/android/ion/ion.h
>> + * drivers/staging/android/ion/ion_priv.h
> Does not match the actual filename.
> 
>>   *
>>   * Copyright (C) 2011 Google, Inc.
>>   *
>> @@ -14,24 +14,26 @@
>>   *
>>   */
>>
>> -#ifndef _LINUX_ION_H
>> -#define _LINUX_ION_H
>> +#ifndef _ION_PRIV_H
>> +#define _ION_PRIV_H
>>
> Ditto.
> 
>> +#include <linux/device.h>
>> +#include <linux/dma-direction.h>
>> +#include <linux/kref.h>
>> +#include <linux/mm_types.h>
>> +#include <linux/mutex.h>
>> +#include <linux/rbtree.h>
>> +#include <linux/sched.h>
>> +#include <linux/shrinker.h>
>>  #include <linux/types.h>
>> +#include <linux/miscdevice.h>
>>
>>  #include "../uapi/ion.h"
>>
> You don't want to use "../" in includes. Perhaps address with another
> patch, if you haven't already ?
> 

There isn't a better option until this driver moves out of staging.
Once it moves out it can be fixed up.

Thanks,
Laura

> Regards,
> Emil
> 
