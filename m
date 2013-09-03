Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:58349 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab3ICMuO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Sep 2013 08:50:14 -0400
Received: by mail-vb0-f41.google.com with SMTP id g17so4000195vbg.0
        for <linux-media@vger.kernel.org>; Tue, 03 Sep 2013 05:50:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <C40DBE54484849439FC5081A05AEF5F5979DEC6D@PLOXCHG23.cern.ch>
References: <a661e3d7ccefe3baa8134888a0471ce1e5463f47.1377861337.git.dinram@cisco.com>
	<1377862104-15429-1-git-send-email-dinram@cisco.com>
	<b1680e68e86967955634fab0d4054a8e8100d422.1377861337.git.dinram@cisco.com>
	<CAC-25o9OW1nmuzbmRX6dW4pLwaJHaFTxXTr_nzaGXk1HDzcdzA@mail.gmail.com>
	<52231DA0.20307@xs4all.nl>
	<CAC-25o-+u5u7yNiJ8PY40FQ9EMdLvga+NKXJaELJHT6oEBUzKg@mail.gmail.com>
	<52243A18.1010209@xs4all.nl>
	<C40DBE54484849439FC5081A05AEF5F5979DEC6D@PLOXCHG23.cern.ch>
Date: Tue, 3 Sep 2013 08:50:13 -0400
Message-ID: <CAC-25o-gC-oGDFFmd5D-1uqZMd5VpQqwyfsvwMVC6F9VVkH2cQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] si4713 : Modified i2c driver to handle cases where
 interrupts are not used
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Dinesh Ram <Dinesh.Ram@cern.ch>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Dinesh Ram <dinram@cisco.com>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dinesh and Hans,

On Mon, Sep 2, 2013 at 6:29 AM, Dinesh Ram <Dinesh.Ram@cern.ch> wrote:
> Hi Hans and Eduardo,
>
> Sorry for my radio silence. I was infact travelling and didn't have much opportunity to check my mails.
> I will go through the list of comments in the thread and try to fix / justify them in the next few days.
> Hans, probably at the end you might have to test it as I don't have the hardware anymore.


I have the board and gave a shot of your driver. Looks like there is
still some work to be done. Please have a look on my comment on the
patch that adds the USB driver. Besides reviewing I will be also
testing your patches.

All best,

>
> Regards,
> Dinesh
> ________________________________________
> From: Hans Verkuil [hverkuil@xs4all.nl]
> Sent: 02 September 2013 09:11
> To: edubezval@gmail.com
> Cc: Dinesh Ram; Linux-Media; Dinesh Ram
> Subject: Re: [PATCH 2/6] si4713 : Modified i2c driver to handle cases where interrupts are not used
>
> On 09/01/2013 04:45 PM, edubezval@gmail.com wrote:
>> Hello Hans,
>>
>>
>> On Sun, Sep 1, 2013 at 6:57 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>
>>> On 08/31/2013 01:31 PM, edubezval@gmail.com wrote:
>>>> Dinesh, Hi
>>>>
>>>>
>>>> On Fri, Aug 30, 2013 at 7:28 AM, Dinesh Ram <dinram@cisco.com> wrote:
>>>>>
>>>>> Checks have been introduced at several places in the code to test if an interrupt is set or not.
>>>>> For devices which do not use the interrupt, to get a valid response, within a specified timeout,
>>>>> the device is polled instead.
>>>>>
>>>>> Signed-off-by: Dinesh Ram <dinram@cisco.com>
>>>>> ---
>>>>>  drivers/media/radio/si4713/si4713.c | 110 ++++++++++++++++++++----------------
>>>>>  drivers/media/radio/si4713/si4713.h |   1 +
>>>>>  2 files changed, 63 insertions(+), 48 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
>>>>> index ac727e3..55c4d27 100644
>>>>> --- a/drivers/media/radio/si4713/si4713.c
>>>>> +++ b/drivers/media/radio/si4713/si4713.c
>>>>> @@ -27,7 +27,6 @@
>>>>>  #include <linux/i2c.h>
>>>>>  #include <linux/slab.h>
>>>>>  #include <linux/gpio.h>
>>>>> -#include <linux/regulator/consumer.h>
>>>>>  #include <linux/module.h>
>>>>>  #include <media/v4l2-device.h>
>>>>>  #include <media/v4l2-ioctl.h>
>>>>> @@ -213,6 +212,7 @@ static int si4713_send_command(struct si4713_device *sdev, const u8 command,
>>>>>                                 u8 response[], const int respn, const int usecs)
>>>>>  {
>>>>>         struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
>>>>> +       unsigned long until_jiffies;
>>>>>         u8 data1[MAX_ARGS + 1];
>>>>>         int err;
>>>>>
>>>>> @@ -228,30 +228,39 @@ static int si4713_send_command(struct si4713_device *sdev, const u8 command,
>>>>>         if (err != argn + 1) {
>>>>>                 v4l2_err(&sdev->sd, "Error while sending command 0x%02x\n",
>>>>>                         command);
>>>>> -               return (err > 0) ? -EIO : err;
>>>>> +               return err < 0 ? err : -EIO;
>>>>
>>>> Why did you change the semantics here?
>>>
>>> It's a bug fix: if i2c_master_send returns 0, then si4713_send_command() would
>>> return 0 as well instead of -EIO. Highly unlikely to ever happen, but it is a
>>> bug.
>>
>> I am not sure I follow your bug fix. The current code recognizes a
>> successful case only when it succeed to transfer all requested bytes
>> (err == argn + 1 or err == respn). I know there are better ways to
>> retransmit the remaining bytes in case the master fails to transfer
>> all at once, but I don't think it is worth the complication for this
>> driver. Anyways, the driver assumes when returned value is different
>> than expected bytes, but positive, as an error and return -EIO in that
>> case. In case the err response is negative, it just propagates the
>> error code.
>>
>> The assumption is also that for the case no bytes are transfered,
>> presumably when return code is zero, then this code expect that the
>> i2c layer return an error code. Zero bytes transfered is same as a
>> transfer error to me. I am not sure the i2c layer is returning 0. Have
>> you experienced this case in other scenarios (even other drivers)? If
>> yes, I don't think the semantic bug is in this driver, but in the i2c
>> layer. Unless you can explain a case where someone requests to
>> transfer N > 0 bytes, the function return 0 and that is not a transfer
>> error issue.
>
> Frankly, I have no idea if i2c_master_send can ever return 0 (actually, I
> think Dinesh encountered this during development), but if it does then the
> code is clearly wrong so it needs to be fixed. Under no circumstances
> should send_command return 0 when there really was an error of some kind.
>
> I don't see why you have a problem with this. It just improves driver
> robustness. Propagate negative values, and -EIO for all others.
>
>>
>>
>>>
>>>>
>>>>>         }
>>>>>
>>>>> +       until_jiffies = jiffies + usecs_to_jiffies(usecs) + 1;
>>>>> +
>>>>>         /* Wait response from interrupt */
>>>>> -       if (!wait_for_completion_timeout(&sdev->work,
>>>>> +       if (client->irq) {
>>>>> +               if (!wait_for_completion_timeout(&sdev->work,
>>>>>                                 usecs_to_jiffies(usecs) + 1))
>>>>> -               v4l2_warn(&sdev->sd,
>>>>> +                       v4l2_warn(&sdev->sd,
>>>>>                                 "(%s) Device took too much time to answer.\n",
>>>>>                                 __func__);
>>>>> -
>>>>> -       /* Then get the response */
>>>>> -       err = i2c_master_recv(client, response, respn);
>>>>> -       if (err != respn) {
>>>>> -               v4l2_err(&sdev->sd,
>>>>> -                       "Error while reading response for command 0x%02x\n",
>>>>> -                       command);
>>>>> -               return (err > 0) ? -EIO : err;
>>>>>         }
>>>>>
>>>>> -       DBG_BUFFER(&sdev->sd, "Response", response, respn);
>>>>> -       if (check_command_failed(response[0]))
>>>>> -               return -EBUSY;
>>>>> +       do {
>>>>> +               err = i2c_master_recv(client, response, respn);
>>>>> +               if (err != respn) {
>>>>> +                       v4l2_err(&sdev->sd,
>>>>> +                                       "Error %d while reading response for command 0x%02x\n",
>>>>> +                                       err, command);
>>>>> +                       return err < 0 ? err : -EIO;
>>>>
>>>> Again?
>>>>
>>>>> +               }
>>>>>
>>>>> -       return 0;
>>>>> +               DBG_BUFFER(&sdev->sd, "Response", response, respn);
>>>>> +               if (!check_command_failed(response[0]))
>>>>> +                       return 0;
>>>>> +
>>>>> +               if (client->irq)
>>>>> +                       return -EBUSY;
>>>>> +               msleep(1);
>>>>> +       } while (jiffies <= until_jiffies);
>>>>> +
>>>>> +       return -EBUSY;
>>>>>  }
>>>>>
>>>>>  /*
>>>>> @@ -344,14 +353,15 @@ static int si4713_write_property(struct si4713_device *sdev, u16 prop, u16 val)
>>>>>   */
>>>>>  static int si4713_powerup(struct si4713_device *sdev)
>>>>>  {
>>>>> +       struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
>>>>>         int err;
>>>>>         u8 resp[SI4713_PWUP_NRESP];
>>>>>         /*
>>>>>          *      .First byte = Enabled interrupts and boot function
>>>>>          *      .Second byte = Input operation mode
>>>>>          */
>>>>> -       const u8 args[SI4713_PWUP_NARGS] = {
>>>>> -               SI4713_PWUP_CTSIEN | SI4713_PWUP_GPO2OEN | SI4713_PWUP_FUNC_TX,
>>>>> +       u8 args[SI4713_PWUP_NARGS] = {
>>>>> +               SI4713_PWUP_GPO2OEN | SI4713_PWUP_FUNC_TX,
>>>>>                 SI4713_PWUP_OPMOD_ANALOG,
>>>>>         };
>>>>>
>>>>> @@ -369,18 +379,22 @@ static int si4713_powerup(struct si4713_device *sdev)
>>>>>                 gpio_set_value(sdev->gpio_reset, 1);
>>>>>         }
>>>>>
>>>>> +       if (client->irq)
>>>>> +               args[0] |= SI4713_PWUP_CTSIEN;
>>>>> +
>>>>>         err = si4713_send_command(sdev, SI4713_CMD_POWER_UP,
>>>>>                                         args, ARRAY_SIZE(args),
>>>>>                                         resp, ARRAY_SIZE(resp),
>>>>>                                         TIMEOUT_POWER_UP);
>>>>> -
>>>>> +
>>>>
>>>> Please, do not insert tabulation in blank lines.
>>>>
>>>>>         if (!err) {
>>>>>                 v4l2_dbg(1, debug, &sdev->sd, "Powerup response: 0x%02x\n",
>>>>>                                 resp[0]);
>>>>>                 v4l2_dbg(1, debug, &sdev->sd, "Device in power up mode\n");
>>>>>                 sdev->power_state = POWER_ON;
>>>>>
>>>>> -               err = si4713_write_property(sdev, SI4713_GPO_IEN,
>>>>> +               if (client->irq)
>>>>> +                       err = si4713_write_property(sdev, SI4713_GPO_IEN,
>>>>>                                                 SI4713_STC_INT | SI4713_CTS);
>>>>>         } else {
>>>>>                 if (gpio_is_valid(sdev->gpio_reset))
>>>>> @@ -447,7 +461,7 @@ static int si4713_checkrev(struct si4713_device *sdev)
>>>>>         if (rval < 0)
>>>>>                 return rval;
>>>>>
>>>>> -       if (resp[1] == SI4713_PRODUCT_NUMBER) {
>>>>> +       if (resp[1] == SI4713_PRODUCT_NUMBER) {
>>>>
>>>> Please, do not insert spaces in the end of the line.
>>>>
>>>>>                 v4l2_info(&sdev->sd, "chip found @ 0x%02x (%s)\n",
>>>>>                                 client->addr << 1, client->adapter->name);
>>>>>         } else {
>>>>> @@ -465,33 +479,34 @@ static int si4713_checkrev(struct si4713_device *sdev)
>>>>>   */
>>>>>  static int si4713_wait_stc(struct si4713_device *sdev, const int usecs)
>>>>>  {
>>>>> -       int err;
>>>>> +       struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
>>>>>         u8 resp[SI4713_GET_STATUS_NRESP];
>>>>> -
>>>>> -       /* Wait response from STC interrupt */
>>>>> -       if (!wait_for_completion_timeout(&sdev->work,
>>>>> -                       usecs_to_jiffies(usecs) + 1))
>>>>> -               v4l2_warn(&sdev->sd,
>>>>> -                       "%s: device took too much time to answer (%d usec).\n",
>>>>> -                               __func__, usecs);
>>>>> -
>>>>> -       /* Clear status bits */
>>>>> -       err = si4713_send_command(sdev, SI4713_CMD_GET_INT_STATUS,
>>>>> -                                       NULL, 0,
>>>>> -                                       resp, ARRAY_SIZE(resp),
>>>>> -                                       DEFAULT_TIMEOUT);
>>>>> -
>>>>> -       if (err < 0)
>>>>> -               goto exit;
>>>>> -
>>>>> -       v4l2_dbg(1, debug, &sdev->sd,
>>>>> -                       "%s: status bits: 0x%02x\n", __func__, resp[0]);
>>>>> -
>>>>> -       if (!(resp[0] & SI4713_STC_INT))
>>>>> -               err = -EIO;
>>>>> -
>>>>> -exit:
>>>>> -       return err;
>>>>> +       unsigned long start_jiffies = jiffies;
>>>>> +       int err;
>>>>> +
>>>>> +       if (client->irq &&
>>>>> +           !wait_for_completion_timeout(&sdev->work, usecs_to_jiffies(usecs) + 1))
>>>>> +               v4l2_warn(&sdev->sd,
>>>>> +                       "(%s) Device took too much time to answer.\n", __func__);
>>>>> +
>>>>> +       for (;;) {
>>>>> +               /* Clear status bits */
>>>>> +               err = si4713_send_command(sdev, SI4713_CMD_GET_INT_STATUS,
>>>>> +                               NULL, 0,
>>>>> +                               resp, ARRAY_SIZE(resp),
>>>>> +                               DEFAULT_TIMEOUT);
>>>>> +
>>>>> +               if (err >= 0) {
>>>>
>>>> Why are you polling while the command fails? If the command fails, you
>>>> need to stop, and propagate the error to upper layers. You shall keep
>>>> polling only while the command succeed and (resp[0] & SI4713_STC_INT)
>>>> == 0.
>>>
>>> This needs a comment. Dinesh, correct me if I am wrong but as I remember
>>> the usb device actually does return errors when it is waiting for STC.
>>> It seems the usb device just blocks new usb requests during that wait.
>>>
>>>>
>>>>> +                       v4l2_dbg(1, debug, &sdev->sd,
>>>>> +                                       "%s: status bits: 0x%02x\n", __func__, resp[0]);
>>>>> +
>>>>> +                       if (resp[0] & SI4713_STC_INT)
>>>>> +                               return 0;
>>>>> +               }
>>>>> +               if (jiffies_to_usecs(jiffies - start_jiffies) > usecs)
>>>>> +                       return -EIO;
>>>
>>> Although this should be replaced with:
>>>
>>>                         return err < 0 ? err : -EIO;
>>>
>>>>> +               msleep(3);
>>>>> +       }
>>>>
>>>> Can you please add a comment why you chose msleep(3)? For instance,
>>>> here you sleep for 3 ms, in send command you need only 1ms. Any
>>>> explanation?
>>>
>>> Experimentation. If you flood the USB device with USB requests it hangs.
>>
>>
>> Well, that it is experimentation I don't have doubts :-).
>>
>> I was just requesting you guys to add a comment there to explain the
>> magic number.
>>
>>>
>>>>
>>>> Besides could you please move this for to another function? Something
>>>> like si4713_poll_stc?
>>>
>>> Why? I see no compelling reason to split it. Some more comments would be
>>> useful, though.
>>
>> Just for better code readability, function starts to become confusing
>> with IRQ event check, polling loop, and even experimentation values
>> flying around.
>>
>>>
>>> Regards,
>>>
>>>         Hans
>>>
>>>>
>>>>>  }
>>>>>
>>>>>  /*
>>>>> @@ -1024,7 +1039,6 @@ static int si4713_initialize(struct si4713_device *sdev)
>>>>>         if (rval < 0)
>>>>>                 return rval;
>>>>>
>>>>> -
>>>>>         sdev->frequency = DEFAULT_FREQUENCY;
>>>>>         sdev->stereo = 1;
>>>>>         sdev->tune_rnl = DEFAULT_TUNE_RNL;
>>>>> diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
>>>>> index c274e1f..dc0ce66 100644
>>>>> --- a/drivers/media/radio/si4713/si4713.h
>>>>> +++ b/drivers/media/radio/si4713/si4713.h
>>>>> @@ -15,6 +15,7 @@
>>>>>  #ifndef SI4713_I2C_H
>>>>>  #define SI4713_I2C_H
>>>>>
>>>>> +#include <linux/regulator/consumer.h>
>>>>>  #include <media/v4l2-subdev.h>
>>>>>  #include <media/v4l2-ctrls.h>
>>>>>  #include <media/si4713.h>
>>>>> --
>>>>> 1.8.4.rc2
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>>
>>>>
>>>
>>
>>
>>
>
> Dinesh, do you have time to work on this? I might have time next week, but that's uncertain.
> Otherwise it will be three weeks from now before I can work on it. I know your internship
> has ended, so I understand if you want me to finish this.
>
> Regards,
>
>         Hans



-- 
Eduardo Bezerra Valentin
