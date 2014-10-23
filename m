Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:39373 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaJWGAK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 02:00:10 -0400
MIME-Version: 1.0
In-Reply-To: <1923603.aWjhqbNgon@avalon>
References: <1413991848-28495-1-git-send-email-jean-michel.hautbois@vodalys.com>
 <1923603.aWjhqbNgon@avalon>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Thu, 23 Oct 2014 07:59:53 +0200
Message-ID: <CAL8zT=hM+ua3hdzVXAvQF9EcKbjou3HpHivfntJWYD1E+Ts8Xg@mail.gmail.com>
Subject: Re: [PATCH 1/2] i2c: Add generic support passing secondary devices addresses
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-i2c@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	wsa@the-dreams.de, Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for your review,

2014-10-23 1:37 GMT+02:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Jean-Michel,
>
> Thank you for the patch.
>
> On Wednesday 22 October 2014 17:30:47 Jean-Michel Hautbois wrote:
>> Some I2C devices have multiple addresses assigned, for example each address
>> corresponding to a different internal register map page of the device.
>> So far drivers which need support for this have handled this with a driver
>> specific and non-generic implementation, e.g. passing the additional address
>> via platform data.
>>
>> This patch provides a new helper function called i2c_new_secondary_device()
>> which is intended to provide a generic way to get the secondary address
>> as well as instantiate a struct i2c_client for the secondary address.
>>
>> The function expects a pointer to the primary i2c_client, a name
>> for the secondary address and an optional default address. The name is used
>> as a handle to specify which secondary address to get.
>>
>> The default address is used as a fallback in case no secondary address
>> was explicitly specified. In case no secondary address and no default
>> address were specified the function returns NULL.
>>
>> For now the function only supports look-up of the secondary address
>> from devicetree, but it can be extended in the future
>> to for example support board files and/or ACPI.
>
> As this is core code I believe the DT bindings should be documented somewhere
> in Documentation/devicetree/bindings/i2c/.

Mmh, probably yes, but I don't know where precisely, as all the
bindings are devices specific here...

>> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>> ---
>>  drivers/i2c/i2c-core.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>  include/linux/i2c.h    |  8 ++++++++
>>  2 files changed, 48 insertions(+)
>>
>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>> index 2f90ac6..fd3b07c 100644
>> --- a/drivers/i2c/i2c-core.c
>> +++ b/drivers/i2c/i2c-core.c
>> @@ -1166,6 +1166,46 @@ struct i2c_client *i2c_new_dummy(struct i2c_adapter
>> *adapter, u16 address) }
>>  EXPORT_SYMBOL_GPL(i2c_new_dummy);
>>
>> +/**
>> + * i2c_new_secondary_device - Helper to get the instantiated secondary
>> address
>
> It does more than that, it also creates the device.

Right, how about :
+ * i2c_new_secondary_device - Helper to get the instantiated secondary address
+ * and create the associated device

>> + * @client: Handle to the primary client
>> + * @name: Handle to specify which secondary address to get
>> + * @default_addr: Used as a fallback if no secondary address was specified
>> + * Context: can sleep
>> + *
>> + * This returns an I2C client bound to the "dummy" driver based on DT
>> parsing.
>
> Could you elaborate on that ? I would explain that the address is retrieved
> from the firmware based on the name, and that default_addr is used in case the
> firmware doesn't provide any information.

Something like that ?
+ * This returns an I2C client bound to the "dummy" driver based on DT parsing.
+ * It retrieves the address based on the name.
+ * It uses default_addr if no information is provided by firmware.


>> + *
>> + * This returns the new i2c client, which should be saved for later use
>> with
>> + * i2c_unregister_device(); or NULL to indicate an error.
>> + */
>> +struct i2c_client *i2c_new_secondary_device(struct i2c_client *client,
>> +                                             const char *name,
>> +                                             u16 default_addr)
>> +{
>> +     int i;
>> +     u32 addr;
>> +     struct device_node *np;
>> +
>> +     np = client->dev.of_node;
>> +
>> +     if (np) {
>> +             i = of_property_match_string(np, "reg-names", name);
>> +             if (i >= 0)
>> +                     of_property_read_u32_index(np, "reg", i, &addr);
>
> This call could fail in which case addr will be uninitialized.
>
>> +             else if (default_addr != 0)
>> +                     addr = default_addr;
>> +             else
>> +                     addr = NULL;
>
> addr isn't a pointer. I'm surprised the compiler hasn't warned you.
It has, just didn't notice it, sorry fir the noise.

>> +     } else {
>> +             addr = default_addr;
>> +     }
>
> The whole logic can be simplified to
>
>         struct device_node *np = client->dev.of_node;
>         u32 addr = default_addr;
>         int i;
>
>         if (np) {
>                 i = of_property_match_string(np, "reg-names", name);
>                 if (i >= 0)
>                         of_property_read_u32_index(np, "reg", i, &addr);
>         }
>

OK, applied on my side.

Thanks,
JM
