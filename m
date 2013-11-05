Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:22038 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3KEItB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 03:49:01 -0500
Message-ID: <5278AE7A.5010000@cisco.com>
Date: Tue, 05 Nov 2013 09:38:18 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: "edubezval@gmail.com" <edubezval@gmail.com>
CC: Dinesh Ram <dinesh.ram@cern.ch>,
	Linux-Media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	d ram <dinesh.ram086@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 8/9] si4713: move supply list to si4713_platform_data
References: <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch> <bffa203fea7b8724f7e92e8e835b80efbfd65eee.1381850640.git.dinesh.ram@cern.ch> <CAC-25o9YZjLnwUmt_q17V1Xiu8wubgrn=uLpX31Zu_H6PwF73A@mail.gmail.com>
In-Reply-To: <CAC-25o9YZjLnwUmt_q17V1Xiu8wubgrn=uLpX31Zu_H6PwF73A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/04/13 15:07, edubezval@gmail.com wrote:
> Hi,
> 
> On Tue, Oct 15, 2013 at 11:24 AM, Dinesh Ram <dinesh.ram@cern.ch> wrote:
>> The supply list is needed by the platform driver, but not by the usb driver.
>> So this information belongs to the platform data and should not be hardcoded
>> in the subdevice driver.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Dinesh, could you please sign this patch too?
> 
>> ---
>>  arch/arm/mach-omap2/board-rx51-peripherals.c |    7 ++++
>>  drivers/media/radio/si4713/si4713.c          |   52 +++++++++++++-------------
>>  drivers/media/radio/si4713/si4713.h          |    3 +-
>>  include/media/si4713.h                       |    2 +
>>  4 files changed, 37 insertions(+), 27 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
>> index f6fe388..eae73f7 100644
>> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
>> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
>> @@ -776,7 +776,14 @@ static struct regulator_init_data rx51_vintdig = {
>>         },
>>  };
>>
>> +static const char * const si4713_supply_names[SI4713_NUM_SUPPLIES] = {
> 
> This patch produces the following compilation error:
> arch/arm/mach-omap2/board-rx51-peripherals.c:779:47: error:
> 'SI4713_NUM_SUPPLIES' undeclared here (not in a function)

Hmm, I thought I had compile-tested this, apparently not. Does it compile if
you just remove SI4713_NUM_SUPPLIES? It's not necessary here.

Regards,

	Hans

> arch/arm/mach-omap2/board-rx51-peripherals.c:785:14: error: bit-field
> '<anonymous>' width not an integer constant
> arch/arm/mach-omap2/board-rx51-peripherals.c:779:27: warning:
> 'si4713_supply_names' defined but not used [-Wunused-variable]
> make[1]: *** [arch/arm/mach-omap2/board-rx51-peripherals.o] Error 1
> make: *** [arch/arm/mach-omap2] Error 2
> make: *** Waiting for unfinished jobs....
> 
> 
>> +       "vio",
>> +       "vdd",
>> +};
>> +
>>  static struct si4713_platform_data rx51_si4713_i2c_data __initdata_or_module = {
>> +       .supplies       = ARRAY_SIZE(si4713_supply_names),
>> +       .supply_names   = si4713_supply_names,
>>         .gpio_reset     = RX51_FMTX_RESET_GPIO,
>>  };
>>
>> diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
>> index d297a5b..920dfa5 100644
>> --- a/drivers/media/radio/si4713/si4713.c
>> +++ b/drivers/media/radio/si4713/si4713.c
>> @@ -44,11 +44,6 @@ MODULE_AUTHOR("Eduardo Valentin <eduardo.valentin@nokia.com>");
>>  MODULE_DESCRIPTION("I2C driver for Si4713 FM Radio Transmitter");
>>  MODULE_VERSION("0.0.1");
>>
>> -static const char *si4713_supply_names[SI4713_NUM_SUPPLIES] = {
>> -       "vio",
>> -       "vdd",
>> -};
>> -
>>  #define DEFAULT_RDS_PI                 0x00
>>  #define DEFAULT_RDS_PTY                        0x00
>>  #define DEFAULT_RDS_DEVIATION          0x00C8
>> @@ -368,11 +363,12 @@ static int si4713_powerup(struct si4713_device *sdev)
>>         if (sdev->power_state)
>>                 return 0;
>>
>> -       err = regulator_bulk_enable(ARRAY_SIZE(sdev->supplies),
>> -                                   sdev->supplies);
>> -       if (err) {
>> -               v4l2_err(&sdev->sd, "Failed to enable supplies: %d\n", err);
>> -               return err;
>> +       if (sdev->supplies) {
>> +               err = regulator_bulk_enable(sdev->supplies, sdev->supply_data);
>> +               if (err) {
>> +                       v4l2_err(&sdev->sd, "Failed to enable supplies: %d\n", err);
>> +                       return err;
>> +               }
>>         }
>>         if (gpio_is_valid(sdev->gpio_reset)) {
>>                 udelay(50);
>> @@ -396,11 +392,12 @@ static int si4713_powerup(struct si4713_device *sdev)
>>                 if (client->irq)
>>                         err = si4713_write_property(sdev, SI4713_GPO_IEN,
>>                                                 SI4713_STC_INT | SI4713_CTS);
>> -       } else {
>> -               if (gpio_is_valid(sdev->gpio_reset))
>> -                       gpio_set_value(sdev->gpio_reset, 0);
>> -               err = regulator_bulk_disable(ARRAY_SIZE(sdev->supplies),
>> -                                            sdev->supplies);
>> +               return err;
>> +       }
>> +       if (gpio_is_valid(sdev->gpio_reset))
>> +               gpio_set_value(sdev->gpio_reset, 0);
>> +       if (sdev->supplies) {
>> +               err = regulator_bulk_disable(sdev->supplies, sdev->supply_data);
>>                 if (err)
>>                         v4l2_err(&sdev->sd,
>>                                  "Failed to disable supplies: %d\n", err);
>> @@ -432,11 +429,13 @@ static int si4713_powerdown(struct si4713_device *sdev)
>>                 v4l2_dbg(1, debug, &sdev->sd, "Device in reset mode\n");
>>                 if (gpio_is_valid(sdev->gpio_reset))
>>                         gpio_set_value(sdev->gpio_reset, 0);
>> -               err = regulator_bulk_disable(ARRAY_SIZE(sdev->supplies),
>> -                                            sdev->supplies);
>> -               if (err)
>> -                       v4l2_err(&sdev->sd,
>> -                                "Failed to disable supplies: %d\n", err);
>> +               if (sdev->supplies) {
>> +                       err = regulator_bulk_disable(sdev->supplies,
>> +                                                    sdev->supply_data);
>> +                       if (err)
>> +                               v4l2_err(&sdev->sd,
>> +                                        "Failed to disable supplies: %d\n", err);
>> +               }
>>                 sdev->power_state = POWER_OFF;
>>         }
>>
>> @@ -1381,13 +1380,14 @@ static int si4713_probe(struct i2c_client *client,
>>                 }
>>                 sdev->gpio_reset = pdata->gpio_reset;
>>                 gpio_direction_output(sdev->gpio_reset, 0);
>> +               sdev->supplies = pdata->supplies;
>>         }
>>
>> -       for (i = 0; i < ARRAY_SIZE(sdev->supplies); i++)
>> -               sdev->supplies[i].supply = si4713_supply_names[i];
>> +       for (i = 0; i < sdev->supplies; i++)
>> +               sdev->supply_data[i].supply = pdata->supply_names[i];
>>
>> -       rval = regulator_bulk_get(&client->dev, ARRAY_SIZE(sdev->supplies),
>> -                                 sdev->supplies);
>> +       rval = regulator_bulk_get(&client->dev, sdev->supplies,
>> +                                 sdev->supply_data);
>>         if (rval) {
>>                 dev_err(&client->dev, "Cannot get regulators: %d\n", rval);
>>                 goto free_gpio;
>> @@ -1500,7 +1500,7 @@ free_irq:
>>  free_ctrls:
>>         v4l2_ctrl_handler_free(hdl);
>>  put_reg:
>> -       regulator_bulk_free(ARRAY_SIZE(sdev->supplies), sdev->supplies);
>> +       regulator_bulk_free(sdev->supplies, sdev->supply_data);
>>  free_gpio:
>>         if (gpio_is_valid(sdev->gpio_reset))
>>                 gpio_free(sdev->gpio_reset);
>> @@ -1524,7 +1524,7 @@ static int si4713_remove(struct i2c_client *client)
>>
>>         v4l2_device_unregister_subdev(sd);
>>         v4l2_ctrl_handler_free(sd->ctrl_handler);
>> -       regulator_bulk_free(ARRAY_SIZE(sdev->supplies), sdev->supplies);
>> +       regulator_bulk_free(sdev->supplies, sdev->supply_data);
>>         if (gpio_is_valid(sdev->gpio_reset))
>>                 gpio_free(sdev->gpio_reset);
>>         kfree(sdev);
>> diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
>> index dc0ce66..986e27b 100644
>> --- a/drivers/media/radio/si4713/si4713.h
>> +++ b/drivers/media/radio/si4713/si4713.h
>> @@ -227,7 +227,8 @@ struct si4713_device {
>>                 struct v4l2_ctrl *tune_ant_cap;
>>         };
>>         struct completion work;
>> -       struct regulator_bulk_data supplies[SI4713_NUM_SUPPLIES];
>> +       unsigned supplies;
>> +       struct regulator_bulk_data supply_data[SI4713_NUM_SUPPLIES];
>>         int gpio_reset;
>>         u32 power_state;
>>         u32 rds_enabled;
>> diff --git a/include/media/si4713.h b/include/media/si4713.h
>> index ed7353e..f98a0a7 100644
>> --- a/include/media/si4713.h
>> +++ b/include/media/si4713.h
>> @@ -23,6 +23,8 @@
>>   * Platform dependent definition
>>   */
>>  struct si4713_platform_data {
>> +       const char * const *supply_names;
>> +       unsigned supplies;
>>         int gpio_reset; /* < 0 if not used */
>>  };
>>
>> --
>> 1.7.9.5
>>
> 
> 
> 
