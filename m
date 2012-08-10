Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48090 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab2HJA5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 20:57:43 -0400
Received: by obbuo13 with SMTP id uo13so1442211obb.19
        for <linux-media@vger.kernel.org>; Thu, 09 Aug 2012 17:57:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50244C42.8070303@redhat.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
	<1344307634-11673-18-git-send-email-dheitmueller@kernellabs.com>
	<50244C42.8070303@redhat.com>
Date: Thu, 9 Aug 2012 20:57:42 -0400
Message-ID: <CAGoCfixzAbLDr3CA_UgvdS8t9ZzcODZTHu7J-FRm0BBQqzPP_Q@mail.gmail.com>
Subject: Re: [PATCH 17/24] au0828: fix possible race condition in usage of dev->ctrlmsg
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 9, 2012 at 7:48 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 06-08-2012 23:47, Devin Heitmueller escreveu:
>> The register read function is referencing the dev->ctrlmsg structure outside
>> of the dev->mutex lock, which can cause corruption of the value if multiple
>> callers are invoking au0828_readreg() simultaneously.
>>
>> Use a stack variable to hold the result, and copy the buffer returned by
>> usb_control_msg() to that variable.
>
> It is NOT OK to use stack to send and/or receive control messages. The USB core
> uses DMA transfers for sending/receiving data via USB; the memory used by stack
> is not warranted to be at the DMA-able area. This problem is more frequent on
> ARM-based machines, but even on Intel, the urb_control_msg() may fail.
>
>>
>> In reality, the whole recv_control_msg() function can probably be collapsed
>> into au0288_readreg() since it is the only caller.
>>
>> Also get rid of cmd_msg_dump() since the only case in which the function is
>> ever called only is ever passed a single byte for the response (and it is
>> already logged).
>>
>> Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
>> ---
>>   drivers/media/video/au0828/au0828-core.c |   40 +++++++++---------------------
>>   1 files changed, 12 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/media/video/au0828/au0828-core.c b/drivers/media/video/au0828/au0828-core.c
>> index 65914bc..745a80a 100644
>> --- a/drivers/media/video/au0828/au0828-core.c
>> +++ b/drivers/media/video/au0828/au0828-core.c
>> @@ -56,9 +56,12 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
>>
>>   u32 au0828_readreg(struct au0828_dev *dev, u16 reg)
>>   {
>> -     recv_control_msg(dev, CMD_REQUEST_IN, 0, reg, dev->ctrlmsg, 1);
>> -     dprintk(8, "%s(0x%04x) = 0x%02x\n", __func__, reg, dev->ctrlmsg[0]);
>> -     return dev->ctrlmsg[0];
>> +     u8 result = 0;
>> +
>> +     recv_control_msg(dev, CMD_REQUEST_IN, 0, reg, &result, 1);
>
> As explained above, this won't work, as result is at stack, not warranted to be at the
> DMA-able area. So, either you could lock this function, or you'll need to allocate
> it with kmalloc() and free it after using the data.
>
>> +     dprintk(8, "%s(0x%04x) = 0x%02x\n", __func__, reg, result);
>> +
>> +     return result;
>>   }
>>
>>   u32 au0828_writereg(struct au0828_dev *dev, u16 reg, u32 val)
>> @@ -67,24 +70,6 @@ u32 au0828_writereg(struct au0828_dev *dev, u16 reg, u32 val)
>>       return send_control_msg(dev, CMD_REQUEST_OUT, val, reg);
>>   }
>>
>> -static void cmd_msg_dump(struct au0828_dev *dev)
>> -{
>> -     int i;
>> -
>> -     for (i = 0; i < sizeof(dev->ctrlmsg); i += 16)
>> -             dprintk(2, "%s() %02x %02x %02x %02x %02x %02x %02x %02x "
>> -                             "%02x %02x %02x %02x %02x %02x %02x %02x\n",
>> -                     __func__,
>> -                     dev->ctrlmsg[i+0], dev->ctrlmsg[i+1],
>> -                     dev->ctrlmsg[i+2], dev->ctrlmsg[i+3],
>> -                     dev->ctrlmsg[i+4], dev->ctrlmsg[i+5],
>> -                     dev->ctrlmsg[i+6], dev->ctrlmsg[i+7],
>> -                     dev->ctrlmsg[i+8], dev->ctrlmsg[i+9],
>> -                     dev->ctrlmsg[i+10], dev->ctrlmsg[i+11],
>> -                     dev->ctrlmsg[i+12], dev->ctrlmsg[i+13],
>> -                     dev->ctrlmsg[i+14], dev->ctrlmsg[i+15]);
>> -}
>> -
>>   static int send_control_msg(struct au0828_dev *dev, u16 request, u32 value,
>>       u16 index)
>>   {
>> @@ -118,24 +103,23 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
>>       int status = -ENODEV;
>>       mutex_lock(&dev->mutex);
>>       if (dev->usbdev) {
>> -
>> -             memset(dev->ctrlmsg, 0, sizeof(dev->ctrlmsg));
>> -
>> -             /* cp must be memory that has been allocated by kmalloc */
>>               status = usb_control_msg(dev->usbdev,
>>                               usb_rcvctrlpipe(dev->usbdev, 0),
>>                               request,
>>                               USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>>                               value, index,
>> -                             cp, size, 1000);
>> +                             dev->ctrlmsg, size, 1000);
>>
>>               status = min(status, 0);
>>
>>               if (status < 0) {
>>                       printk(KERN_ERR "%s() Failed receiving control message, error %d.\n",
>>                               __func__, status);
>> -             } else
>> -                     cmd_msg_dump(dev);
>> +             }
>> +
>> +             /* the host controller requires heap allocated memory, which
>> +                is why we didn't just pass "cp" into usb_control_msg */
>> +             memcpy(cp, dev->ctrlmsg, size);
>>       }
>>       mutex_unlock(&dev->mutex);
>>       return status;
>>
>
> Regards,
> Mauro

Hi Mauro,

You seem to have misinterpreted the patch description.  The actual
call to usb_control_msg() does use a heap allocated memory region.
However we copy the result to a stack variable after the call to
usb_control_msg.  This is done so that dev->ctrlmsg[] is used
exclusively inside of the mutex (and not accessed after the mutex is
unlocked).

The change basically goes from:

au0828_readreg() -> recv_control_msg(heap) -> usb_control_msg(heap)

to:

au0828_readreg() -> recv_control_msg(stack) -> usb_control_msg(heap)

In both cases the call into the USB stack provides heap allocated memory.

Please review the implementation of the static recv_control_msg()
function, and if you have any further questions let me know.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
