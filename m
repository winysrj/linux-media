Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4617 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab3IAK5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Sep 2013 06:57:54 -0400
Message-ID: <52231DA0.20307@xs4all.nl>
Date: Sun, 01 Sep 2013 12:57:36 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "edubezval@gmail.com" <edubezval@gmail.com>
CC: Dinesh Ram <dinram@cisco.com>,
	Linux-Media <linux-media@vger.kernel.org>, dinesh.ram@cern.ch
Subject: Re: [PATCH 2/6] si4713 : Modified i2c driver to handle cases where
 interrupts are not used
References: <a661e3d7ccefe3baa8134888a0471ce1e5463f47.1377861337.git.dinram@cisco.com> <1377862104-15429-1-git-send-email-dinram@cisco.com> <b1680e68e86967955634fab0d4054a8e8100d422.1377861337.git.dinram@cisco.com> <CAC-25o9OW1nmuzbmRX6dW4pLwaJHaFTxXTr_nzaGXk1HDzcdzA@mail.gmail.com>
In-Reply-To: <CAC-25o9OW1nmuzbmRX6dW4pLwaJHaFTxXTr_nzaGXk1HDzcdzA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/31/2013 01:31 PM, edubezval@gmail.com wrote:
> Dinesh, Hi
> 
> 
> On Fri, Aug 30, 2013 at 7:28 AM, Dinesh Ram <dinram@cisco.com> wrote:
>>
>> Checks have been introduced at several places in the code to test if an interrupt is set or not.
>> For devices which do not use the interrupt, to get a valid response, within a specified timeout,
>> the device is polled instead.
>>
>> Signed-off-by: Dinesh Ram <dinram@cisco.com>
>> ---
>>  drivers/media/radio/si4713/si4713.c | 110 ++++++++++++++++++++----------------
>>  drivers/media/radio/si4713/si4713.h |   1 +
>>  2 files changed, 63 insertions(+), 48 deletions(-)
>>
>> diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
>> index ac727e3..55c4d27 100644
>> --- a/drivers/media/radio/si4713/si4713.c
>> +++ b/drivers/media/radio/si4713/si4713.c
>> @@ -27,7 +27,6 @@
>>  #include <linux/i2c.h>
>>  #include <linux/slab.h>
>>  #include <linux/gpio.h>
>> -#include <linux/regulator/consumer.h>
>>  #include <linux/module.h>
>>  #include <media/v4l2-device.h>
>>  #include <media/v4l2-ioctl.h>
>> @@ -213,6 +212,7 @@ static int si4713_send_command(struct si4713_device *sdev, const u8 command,
>>                                 u8 response[], const int respn, const int usecs)
>>  {
>>         struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
>> +       unsigned long until_jiffies;
>>         u8 data1[MAX_ARGS + 1];
>>         int err;
>>
>> @@ -228,30 +228,39 @@ static int si4713_send_command(struct si4713_device *sdev, const u8 command,
>>         if (err != argn + 1) {
>>                 v4l2_err(&sdev->sd, "Error while sending command 0x%02x\n",
>>                         command);
>> -               return (err > 0) ? -EIO : err;
>> +               return err < 0 ? err : -EIO;
> 
> Why did you change the semantics here?

It's a bug fix: if i2c_master_send returns 0, then si4713_send_command() would
return 0 as well instead of -EIO. Highly unlikely to ever happen, but it is a
bug.

> 
>>         }
>>
>> +       until_jiffies = jiffies + usecs_to_jiffies(usecs) + 1;
>> +
>>         /* Wait response from interrupt */
>> -       if (!wait_for_completion_timeout(&sdev->work,
>> +       if (client->irq) {
>> +               if (!wait_for_completion_timeout(&sdev->work,
>>                                 usecs_to_jiffies(usecs) + 1))
>> -               v4l2_warn(&sdev->sd,
>> +                       v4l2_warn(&sdev->sd,
>>                                 "(%s) Device took too much time to answer.\n",
>>                                 __func__);
>> -
>> -       /* Then get the response */
>> -       err = i2c_master_recv(client, response, respn);
>> -       if (err != respn) {
>> -               v4l2_err(&sdev->sd,
>> -                       "Error while reading response for command 0x%02x\n",
>> -                       command);
>> -               return (err > 0) ? -EIO : err;
>>         }
>>
>> -       DBG_BUFFER(&sdev->sd, "Response", response, respn);
>> -       if (check_command_failed(response[0]))
>> -               return -EBUSY;
>> +       do {
>> +               err = i2c_master_recv(client, response, respn);
>> +               if (err != respn) {
>> +                       v4l2_err(&sdev->sd,
>> +                                       "Error %d while reading response for command 0x%02x\n",
>> +                                       err, command);
>> +                       return err < 0 ? err : -EIO;
> 
> Again?
> 
>> +               }
>>
>> -       return 0;
>> +               DBG_BUFFER(&sdev->sd, "Response", response, respn);
>> +               if (!check_command_failed(response[0]))
>> +                       return 0;
>> +
>> +               if (client->irq)
>> +                       return -EBUSY;
>> +               msleep(1);
>> +       } while (jiffies <= until_jiffies);
>> +
>> +       return -EBUSY;
>>  }
>>
>>  /*
>> @@ -344,14 +353,15 @@ static int si4713_write_property(struct si4713_device *sdev, u16 prop, u16 val)
>>   */
>>  static int si4713_powerup(struct si4713_device *sdev)
>>  {
>> +       struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
>>         int err;
>>         u8 resp[SI4713_PWUP_NRESP];
>>         /*
>>          *      .First byte = Enabled interrupts and boot function
>>          *      .Second byte = Input operation mode
>>          */
>> -       const u8 args[SI4713_PWUP_NARGS] = {
>> -               SI4713_PWUP_CTSIEN | SI4713_PWUP_GPO2OEN | SI4713_PWUP_FUNC_TX,
>> +       u8 args[SI4713_PWUP_NARGS] = {
>> +               SI4713_PWUP_GPO2OEN | SI4713_PWUP_FUNC_TX,
>>                 SI4713_PWUP_OPMOD_ANALOG,
>>         };
>>
>> @@ -369,18 +379,22 @@ static int si4713_powerup(struct si4713_device *sdev)
>>                 gpio_set_value(sdev->gpio_reset, 1);
>>         }
>>
>> +       if (client->irq)
>> +               args[0] |= SI4713_PWUP_CTSIEN;
>> +
>>         err = si4713_send_command(sdev, SI4713_CMD_POWER_UP,
>>                                         args, ARRAY_SIZE(args),
>>                                         resp, ARRAY_SIZE(resp),
>>                                         TIMEOUT_POWER_UP);
>> -
>> +
> 
> Please, do not insert tabulation in blank lines.
> 
>>         if (!err) {
>>                 v4l2_dbg(1, debug, &sdev->sd, "Powerup response: 0x%02x\n",
>>                                 resp[0]);
>>                 v4l2_dbg(1, debug, &sdev->sd, "Device in power up mode\n");
>>                 sdev->power_state = POWER_ON;
>>
>> -               err = si4713_write_property(sdev, SI4713_GPO_IEN,
>> +               if (client->irq)
>> +                       err = si4713_write_property(sdev, SI4713_GPO_IEN,
>>                                                 SI4713_STC_INT | SI4713_CTS);
>>         } else {
>>                 if (gpio_is_valid(sdev->gpio_reset))
>> @@ -447,7 +461,7 @@ static int si4713_checkrev(struct si4713_device *sdev)
>>         if (rval < 0)
>>                 return rval;
>>
>> -       if (resp[1] == SI4713_PRODUCT_NUMBER) {
>> +       if (resp[1] == SI4713_PRODUCT_NUMBER) {
> 
> Please, do not insert spaces in the end of the line.
> 
>>                 v4l2_info(&sdev->sd, "chip found @ 0x%02x (%s)\n",
>>                                 client->addr << 1, client->adapter->name);
>>         } else {
>> @@ -465,33 +479,34 @@ static int si4713_checkrev(struct si4713_device *sdev)
>>   */
>>  static int si4713_wait_stc(struct si4713_device *sdev, const int usecs)
>>  {
>> -       int err;
>> +       struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
>>         u8 resp[SI4713_GET_STATUS_NRESP];
>> -
>> -       /* Wait response from STC interrupt */
>> -       if (!wait_for_completion_timeout(&sdev->work,
>> -                       usecs_to_jiffies(usecs) + 1))
>> -               v4l2_warn(&sdev->sd,
>> -                       "%s: device took too much time to answer (%d usec).\n",
>> -                               __func__, usecs);
>> -
>> -       /* Clear status bits */
>> -       err = si4713_send_command(sdev, SI4713_CMD_GET_INT_STATUS,
>> -                                       NULL, 0,
>> -                                       resp, ARRAY_SIZE(resp),
>> -                                       DEFAULT_TIMEOUT);
>> -
>> -       if (err < 0)
>> -               goto exit;
>> -
>> -       v4l2_dbg(1, debug, &sdev->sd,
>> -                       "%s: status bits: 0x%02x\n", __func__, resp[0]);
>> -
>> -       if (!(resp[0] & SI4713_STC_INT))
>> -               err = -EIO;
>> -
>> -exit:
>> -       return err;
>> +       unsigned long start_jiffies = jiffies;
>> +       int err;
>> +
>> +       if (client->irq &&
>> +           !wait_for_completion_timeout(&sdev->work, usecs_to_jiffies(usecs) + 1))
>> +               v4l2_warn(&sdev->sd,
>> +                       "(%s) Device took too much time to answer.\n", __func__);
>> +
>> +       for (;;) {
>> +               /* Clear status bits */
>> +               err = si4713_send_command(sdev, SI4713_CMD_GET_INT_STATUS,
>> +                               NULL, 0,
>> +                               resp, ARRAY_SIZE(resp),
>> +                               DEFAULT_TIMEOUT);
>> +
>> +               if (err >= 0) {
> 
> Why are you polling while the command fails? If the command fails, you
> need to stop, and propagate the error to upper layers. You shall keep
> polling only while the command succeed and (resp[0] & SI4713_STC_INT)
> == 0.

This needs a comment. Dinesh, correct me if I am wrong but as I remember
the usb device actually does return errors when it is waiting for STC.
It seems the usb device just blocks new usb requests during that wait.

> 
>> +                       v4l2_dbg(1, debug, &sdev->sd,
>> +                                       "%s: status bits: 0x%02x\n", __func__, resp[0]);
>> +
>> +                       if (resp[0] & SI4713_STC_INT)
>> +                               return 0;
>> +               }
>> +               if (jiffies_to_usecs(jiffies - start_jiffies) > usecs)
>> +                       return -EIO;

Although this should be replaced with:

			return err < 0 ? err : -EIO;

>> +               msleep(3);
>> +       }
> 
> Can you please add a comment why you chose msleep(3)? For instance,
> here you sleep for 3 ms, in send command you need only 1ms. Any
> explanation?

Experimentation. If you flood the USB device with USB requests it hangs.

> 
> Besides could you please move this for to another function? Something
> like si4713_poll_stc?

Why? I see no compelling reason to split it. Some more comments would be
useful, though.

Regards,

	Hans

> 
>>  }
>>
>>  /*
>> @@ -1024,7 +1039,6 @@ static int si4713_initialize(struct si4713_device *sdev)
>>         if (rval < 0)
>>                 return rval;
>>
>> -
>>         sdev->frequency = DEFAULT_FREQUENCY;
>>         sdev->stereo = 1;
>>         sdev->tune_rnl = DEFAULT_TUNE_RNL;
>> diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
>> index c274e1f..dc0ce66 100644
>> --- a/drivers/media/radio/si4713/si4713.h
>> +++ b/drivers/media/radio/si4713/si4713.h
>> @@ -15,6 +15,7 @@
>>  #ifndef SI4713_I2C_H
>>  #define SI4713_I2C_H
>>
>> +#include <linux/regulator/consumer.h>
>>  #include <media/v4l2-subdev.h>
>>  #include <media/v4l2-ctrls.h>
>>  #include <media/si4713.h>
>> --
>> 1.8.4.rc2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 

