Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:51088 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758079AbcKCUyu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 16:54:50 -0400
Subject: Re: [PATCH 10/34] [media] DaVinci-VPBE: Check return value of a
 setup_if_config() call in vpbe_set_output()
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
 <47590f2e-1cfa-582d-769e-502802171b66@users.sourceforge.net>
 <bc306a0e-d4ff-d90a-e07a-246ead409471@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <680a0feb-3748-da16-9b79-297e1ab9044d@users.sourceforge.net>
Date: Thu, 3 Nov 2016 21:54:34 +0100
MIME-Version: 1.0
In-Reply-To: <bc306a0e-d4ff-d90a-e07a-246ead409471@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> From: Markus Elfring <elfring@users.sourceforge.net>
>> Date: Wed, 12 Oct 2016 09:56:56 +0200
>>
>> * A function was called over the pointer "setup_if_config" in the data
>>   structure "venc_platform_data". But the return value was not used so far.
>>   Thus assign it to the local variable "ret" which will be checked with
>>   the next statement.
>>
>>   Fixes: 9a7f95ad1c946efdd7a7a72df27db738260a0fd8 ("[media] davinci vpbe: add dm365 VPBE display driver changes")
>>
>> * Pass a value to this function call without storing it in an intermediate
>>   variable before.
>>
>> * Delete the local variable "if_params" which became unnecessary with
>>   this refactoring.
>>
>> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
>> ---
>>  drivers/media/platform/davinci/vpbe.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
>> index 19611a2..6e7b0df 100644
>> --- a/drivers/media/platform/davinci/vpbe.c
>> +++ b/drivers/media/platform/davinci/vpbe.c
>> @@ -227,7 +227,6 @@ static int vpbe_set_output(struct vpbe_device *vpbe_dev, int index)
>>              vpbe_current_encoder_info(vpbe_dev);
>>      struct vpbe_config *cfg = vpbe_dev->cfg;
>>      struct venc_platform_data *venc_device = vpbe_dev->venc_device;
>> -    u32 if_params;
>>      int enc_out_index;
>>      int sd_index;
>>      int ret = 0;
>> @@ -257,8 +256,8 @@ static int vpbe_set_output(struct vpbe_device *vpbe_dev, int index)
>>              goto out;
>>          }
>>
>> -        if_params = cfg->outputs[index].if_params;
>> -        venc_device->setup_if_config(if_params);
>> +        ret = venc_device->setup_if_config(cfg
>> +                           ->outputs[index].if_params);
> 
> Either keep this as one line

Will you tolerate a line length of 82 characters then?


> or keep the if_params temp variable.

My proposal was to get rid of it.


> This odd linebreak is ugly.

I am curious on how the desired changes can be integrated after a couple of update
suggestions were accepted from this patch series.

Regards,
Markus
