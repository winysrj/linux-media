Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446Ab1LESft (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Dec 2011 13:35:49 -0500
Message-ID: <4EDD0F01.7040808@redhat.com>
Date: Mon, 05 Dec 2011 16:35:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, Eddi De Pieri <eddi@depieri.net>
Subject: Re: [PATCH 5/8] [media] em28xx: initial support for HAUPPAUGE HVR-930C
 again
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com> <1321800978-27912-2-git-send-email-mchehab@redhat.com> <1321800978-27912-3-git-send-email-mchehab@redhat.com> <1321800978-27912-4-git-send-email-mchehab@redhat.com> <1321800978-27912-5-git-send-email-mchehab@redhat.com> <CAGoCfiwv1MWnJc+3HL+9-E=o+HG09jjdGYOfpoXSoPd+wW3oHg@mail.gmail.com>
In-Reply-To: <CAGoCfiwv1MWnJc+3HL+9-E=o+HG09jjdGYOfpoXSoPd+wW3oHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05-12-2011 16:23, Devin Heitmueller wrote:
> On Sun, Nov 20, 2011 at 9:56 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com>  wrote:
>> diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
>> index ecd1f95..048f489 100644
>> --- a/drivers/media/common/tuners/xc5000.c
>> +++ b/drivers/media/common/tuners/xc5000.c
>> @@ -1004,6 +1004,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
>>         struct xc5000_priv *priv = fe->tuner_priv;
>>         int ret = 0;
>>
>> +       mutex_lock(&xc5000_list_mutex);
>> +
>>         if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
>>                 ret = xc5000_fwupload(fe);
>>                 if (ret != XC_RESULT_SUCCESS)
>> @@ -1023,6 +1025,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
>>         /* Default to "CABLE" mode */
>>         ret |= xc_write_reg(priv, XREG_SIGNALSOURCE, XC_RF_MODE_CABLE);
>>
>> +       mutex_unlock(&xc5000_list_mutex);
>> +
>>         return ret;
>>   }
>
> What's up with this change?  Is this a bugfix for some race condition?
>   Why is it jammed into a patch for some particular product?
>
> It seems like a change such as this could significantly change the
> timing of tuner initialization if you have multiple xc5000 based
> products that might have a slow i2c bus.  Was that intentional?
>
> This patch should be NACK'd and resubmitted as it's own bugfix where
> it's implications can be fully understood in the context of all the
> other products that use xc5000.

It is too late for nacking the patch, as there are several other patches
were already applied on the top of it, and we don't rebase the
linux-media.git tree.

Assuming that this is due to some bug that Eddi picked during xc5000
init, what it can be done now is to write a patch that would replace
this xc5000-global mutex lock into a some other per-device locking
schema.

Regards,
Mauro.
