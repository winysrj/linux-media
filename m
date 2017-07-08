Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35925 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdGHWzt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Jul 2017 18:55:49 -0400
MIME-Version: 1.0
In-Reply-To: <1499504311.3472.13.camel@petrovitsch.priv.at>
References: <20170708004102.GA27161@amitoj-Inspiron-3542> <1499504311.3472.13.camel@petrovitsch.priv.at>
From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Date: Sat, 8 Jul 2017 18:55:48 -0400
Message-ID: <CA+5yK5FA3hLctjv-ysEspMveg+_M+JqvsM+UuEj88NTwX=4Sjg@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: media: atomisp2: Replace kfree()/vfree()
 with kvfree()
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: mchehab@kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 8, 2017 at 4:58 AM, Bernd Petrovitsch
<bernd@petrovitsch.priv.at> wrote:
> On Fri, 2017-07-07 at 20:41 -0400, Amitoj Kaur Chawla wrote:
> [...]
>> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
>> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
>> @@ -117,11 +117,7 @@ void *atomisp_kernel_zalloc(size_t bytes, bool
>> zero_mem)
>>   */
>>  void atomisp_kernel_free(void *ptr)
>>  {
>> -     /* Verify if buffer was allocated by vmalloc() or kmalloc()
>> */
>> -     if (is_vmalloc_addr(ptr))
>> -             vfree(ptr);
>> -     else
>> -             kfree(ptr);
>> +     kvfree(ptr);
>>  }
>>
>>  /*
>
> Why not get rid of the trivial wrapper function completely?
>

Oh yes, i'll send a v2.

Amitoj
