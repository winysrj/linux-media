Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:40898 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaAaNee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 08:34:34 -0500
Received: by mail-qc0-f178.google.com with SMTP id m20so6922395qcx.23
        for <linux-media@vger.kernel.org>; Fri, 31 Jan 2014 05:34:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140130192405.GA22360@pequod.mess.org>
References: <1390773026-567-1-git-send-email-a.seppala@gmail.com>
	<1390773026-567-6-git-send-email-a.seppala@gmail.com>
	<20140130192405.GA22360@pequod.mess.org>
Date: Fri, 31 Jan 2014 15:34:34 +0200
Message-ID: <CAKv9HNYFaAJQwb_JC44PJMMwtbdSB4HN-XVmdhv=1qkWZY+ktg@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 5/5] winbond-cir: Add support for reading/writing
 wakeup scancodes via sysfs
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30 January 2014 21:24, Sean Young <sean@mess.org> wrote:
> On Sun, Jan 26, 2014 at 11:50:26PM +0200, Antti Seppälä wrote:
>> This patch adds support for reading/writing wakeup scancodes via sysfs
>> to nuvoton-cir hardware.
>>
>> The existing mechanism of setting wakeup scancodes by using module
>> parameters is left untouched. If set the module parameters function as
>> default values for sysfs files.
>>
>> Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
>> ---
>>  drivers/media/rc/winbond-cir.c | 66 ++++++++++++++++++++++++++++++------------
>>  1 file changed, 48 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
>> index 904baf4..c63a56e 100644
>> --- a/drivers/media/rc/winbond-cir.c
>> +++ b/drivers/media/rc/winbond-cir.c
>> @@ -683,6 +683,29 @@ wbcir_tx(struct rc_dev *dev, unsigned *b, unsigned count)
>>       return count;
>>  }
>>
>> +static int wbcir_wakeup_codes(struct rc_dev *dev,
>> +                           struct list_head *wakeup_code_list, int write)
>> +{
>> +     u32 value = 0x800F040C;
>> +     struct rc_wakeup_code *code;
>> +     if (write) {
>
> I think it would be better to have a read/write function rather passing it
> as an argument; they are distinct functions.
>

I modeled the wakeup code callback after other s_* callbacks found in rc-core
some of which have similar kind of enable/disable type flag.

I guess I can split the callback into a more readable version at the expense of
some added code lines in each driver.

>> +             code = list_first_entry_or_null(wakeup_code_list,
>> +                                             struct rc_wakeup_code,
>> +                                             list_item);
>> +             if (code)
>> +                     value = code->value;
>
> If more than one value is provided then that should be an error; if no
> value is provided then that is an error too. Sure the scancode can default
> to mce sleep/rc6 on startup.
>

I'll add stricter sanity checking here.

>> +
>> +             wake_sc = value;
>> +     } else {
>> +             code = kmalloc(sizeof(struct rc_wakeup_code), GFP_KERNEL);
>> +             if (!code)
>> +                     return -ENOMEM;
>> +             code->value = wake_sc;
>> +             list_add_tail(&code->list_item, wakeup_code_list);
>> +     }
>> +     return 0;
>> +}
>> +
>>  /*****************************************************************************
>>   *
>>   * SETUP/INIT/SUSPEND/RESUME FUNCTIONS
>> @@ -708,12 +731,11 @@ wbcir_shutdown(struct pnp_dev *device)
>>               goto finish;
>>       }
>>
>> -     switch (protocol) {
>> -     case IR_PROTOCOL_RC5:
>> +     if (data->dev->enabled_wake_protos & RC_BIT_RC5) {
>>               if (wake_sc > 0xFFF) {
>>                       do_wake = false;
>>                       dev_err(dev, "RC5 - Invalid wake scancode\n");
>> -                     break;
>> +                     goto finish;
>>               }
>>
>>               /* Mask = 13 bits, ex toggle */
>> @@ -726,13 +748,11 @@ wbcir_shutdown(struct pnp_dev *device)
>>               if (!(wake_sc & 0x0040))             /* 2nd start bit  */
>>                       match[1] |= 0x10;
>>
>> -             break;
>> -
>> -     case IR_PROTOCOL_NEC:
>> +     } else if (data->dev->enabled_wake_protos & RC_BIT_NEC) {
>>               if (wake_sc > 0xFFFFFF) {
>>                       do_wake = false;
>>                       dev_err(dev, "NEC - Invalid wake scancode\n");
>> -                     break;
>> +                     goto finish;
>>               }
>>
>>               mask[0] = mask[1] = mask[2] = mask[3] = 0xFF;
>> @@ -745,16 +765,12 @@ wbcir_shutdown(struct pnp_dev *device)
>>                       match[2] = bitrev8((wake_sc & 0xFF0000) >> 16);
>>               else
>>                       match[2] = ~match[3];
>> -
>> -             break;
>> -
>> -     case IR_PROTOCOL_RC6:
>> -
>> +     } else if (data->dev->enabled_wake_protos & RC_BIT_RC6_0) {
>>               if (wake_rc6mode == 0) {
>>                       if (wake_sc > 0xFFFF) {
>>                               do_wake = false;
>>                               dev_err(dev, "RC6 - Invalid wake scancode\n");
>> -                             break;
>> +                             goto finish;
>>                       }
>>
>>                       /* Command */
>> @@ -810,7 +826,7 @@ wbcir_shutdown(struct pnp_dev *device)
>>                       } else {
>>                               do_wake = false;
>>                               dev_err(dev, "RC6 - Invalid wake scancode\n");
>> -                             break;
>> +                             goto finish;
>>                       }
>>
>>                       /* Header */
>> @@ -824,11 +840,8 @@ wbcir_shutdown(struct pnp_dev *device)
>>                       dev_err(dev, "RC6 - Invalid wake mode\n");
>>               }
>>
>> -             break;
>> -
>> -     default:
>> +     } else {
>>               do_wake = false;
>> -             break;
>>       }
>>
>>  finish:
>> @@ -1077,12 +1090,29 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
>>       data->dev->s_carrier_report = wbcir_set_carrier_report;
>>       data->dev->s_tx_mask = wbcir_txmask;
>>       data->dev->s_tx_carrier = wbcir_txcarrier;
>> +     data->dev->s_wakeup_codes = wbcir_wakeup_codes;
>>       data->dev->tx_ir = wbcir_tx;
>>       data->dev->priv = data;
>>       data->dev->dev.parent = &device->dev;
>>       data->dev->timeout = MS_TO_NS(100);
>>       data->dev->rx_resolution = US_TO_NS(2);
>>       data->dev->allowed_protos = RC_BIT_ALL;
>> +     data->dev->allowed_wake_protos = RC_BIT_RC5 | RC_BIT_RC6_0 | RC_BIT_NEC;
>> +     /* Utilize default protocol from module parameter */
>> +     switch (protocol) {
>> +     case IR_PROTOCOL_RC5:
>> +             data->dev->enabled_wake_protos = RC_BIT_RC5;
>> +             break;
>> +     case IR_PROTOCOL_RC6:
>> +             data->dev->enabled_wake_protos = RC_BIT_RC6_0;
>> +             break;
>> +     case IR_PROTOCOL_NEC:
>> +             data->dev->enabled_wake_protos = RC_BIT_NEC;
>> +             break;
>> +     default:
>> +             data->dev->enabled_wake_protos = RC_BIT_NONE;
>> +             break;
>> +     }
>
> You might as well remove the module parameters, I'd say.
>

I can add a patch removing all the other wake_* parameters but it seems
that wake_rc6mode needs to stay.

This is because the wakeup_protocols file (or protocols for that matter) is not
able to differentiate between rc6 and rc6a and this distinction is needed for
wakeup in winbond-cir.

-Antti
