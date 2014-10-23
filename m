Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:37693 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaJWGCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 02:02:32 -0400
MIME-Version: 1.0
In-Reply-To: <3127348.3KALimKvms@avalon>
References: <1413991848-28495-1-git-send-email-jean-michel.hautbois@vodalys.com>
 <1413991848-28495-2-git-send-email-jean-michel.hautbois@vodalys.com> <3127348.3KALimKvms@avalon>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Thu, 23 Oct 2014 08:02:16 +0200
Message-ID: <CAL8zT=hD5J_pmkdV67Quoq3gzbZramRO4Kzav0OUYOEE_wQ4xw@mail.gmail.com>
Subject: Re: [PATCH 2/2] adv7604: Add support for i2c_new_secondary_device
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-i2c@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	wsa@the-dreams.de, Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for reviewing,

2014-10-23 1:44 GMT+02:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Jean-Michel,
>
> Thank you for the patch.
>
> On Wednesday 22 October 2014 17:30:48 Jean-Michel Hautbois wrote:
>> The ADV7604 has thirteen 256-byte maps that can be accessed via the main
>> I²C ports. Each map has it own I²C address and acts
>> as a standard slave device on the I²C bus.
>>
>> If nothing is defined, it uses default addresses.
>> The main purpose is using two adv76xx on the same i2c bus.
>>
>> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>> ---
>>  .../devicetree/bindings/media/i2c/adv7604.txt      | 16 +++++-
>>  drivers/media/i2c/adv7604.c                        | 59 ++++++++++++-------
>>  2 files changed, 53 insertions(+), 22 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>> b/Documentation/devicetree/bindings/media/i2c/adv7604.txt index
>> 5c8b3e6..8486b5c 100644
>> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>> @@ -12,7 +12,10 @@ Required Properties:
>>      - "adi,adv7611" for the ADV7611
>>      - "adi,adv7604" for the ADV7604
>
> Given that I'll have comment on the independent patch that adds support for
> the adv7604, you should rebase this series to remote that dependency if you
> want to get it merged now, otherwise it will get delayed.

Oh, you are right, of course, I forgot rebasing (as well as numbering
the patch as v2)...

>>
>> -  - reg: I2C slave address
>> +  - reg: I2C slave addresses
>> +    The ADV7604 has thirteen 256-byte maps that can be accessed via the
>> main
>> +    I²C ports. Each map has it own I²C address and acts
>> +    as a standard slave device on the I²C bus.
>>
>>    - hpd-gpios: References to the GPIOs that control the HDMI hot-plug
>>      detection pins, one per HDMI input. The active flag indicates the GPIO
>> @@ -33,6 +36,12 @@ The digital output port node must contain at least one
>> endpoint. Optional Properties:
>>
>>    - reset-gpios: Reference to the GPIO connected to the device's reset pin.
>> +  - reg-names : Names of maps with programmable addresses.
>> +             It can contain any map needing another address than default one.
>> +             Possible maps names are :
>> +ADV7604 : "main", "avlink", "cec", "infoframe", "esdp", "dpp", "afe",
>> "rep",
>> +             "edid", "hdmi", "test", "cp", "vdp"
>
> If you rebase the series in order to avoid depending on the adv7604 DT support
> patch this line should be moved to "adv7604: Add DT parsing support".
>
>> +ADV7611 : "main", "cec", "infoframe", "afe", "rep", "edid", "hdmi", "cp"
>>
>>  Optional Endpoint Properties:
>>
>> @@ -51,7 +60,10 @@ Example:
>>
>>       hdmi_receiver@4c {
>>               compatible = "adi,adv7611";
>> -             reg = <0x4c>;
>> +             /* edid page will be accessible @ 0x66 on i2c bus */
>> +             /* other maps keep their default addresses */
>> +             reg = <0x4c 0x66>;
>> +             reg-names = "main", "edid";
>>
>>               reset-gpios = <&ioexp 0 GPIO_ACTIVE_LOW>;
>>               hpd-gpios = <&ioexp 2 GPIO_ACTIVE_HIGH>;
>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>> index 421035f..e4e30a2 100644
>> --- a/drivers/media/i2c/adv7604.c
>> +++ b/drivers/media/i2c/adv7604.c
>> @@ -326,6 +326,27 @@ static const struct adv7604_video_standards
>> adv7604_prim_mode_hdmi_gr[] = { { },
>>  };
>>
>> +struct adv7604_register {
>> +     const char *name;
>> +     u8 default_addr;
>> +};
>> +
>> +static const struct adv7604_register adv7604_secondary_names[] = {
>> +     [ADV7604_PAGE_IO] = { "main", 0x4c },
>> +     [ADV7604_PAGE_AVLINK] = { "avlink", 0x42 },
>> +     [ADV7604_PAGE_CEC] = { "cec", 0x40 },
>> +     [ADV7604_PAGE_INFOFRAME] = { "infoframe", 0x3e },
>> +     [ADV7604_PAGE_ESDP] = { "esdp", 0x38 },
>> +     [ADV7604_PAGE_DPP] = { "dpp", 0x3c },
>> +     [ADV7604_PAGE_AFE] = { "afe", 0x26 },
>> +     [ADV7604_PAGE_REP] = { "rep", 0x32 },
>> +     [ADV7604_PAGE_EDID] = { "edid", 0x36 },
>> +     [ADV7604_PAGE_HDMI] = { "hdmi", 0x34 },
>> +     [ADV7604_PAGE_TEST] = { "test", 0x30 },
>> +     [ADV7604_PAGE_CP] = { "cp", 0x22 },
>> +     [ADV7604_PAGE_VDP] = { "vdp", 0x24 },
>> +};
>> +
>>  /* -----------------------------------------------------------------------
>> */
>>
>>  static inline struct adv7604_state *to_state(struct v4l2_subdev *sd)
>> @@ -2528,13 +2549,26 @@ static void adv7604_unregister_clients(struct
>> adv7604_state *state) }
>>
>>  static struct i2c_client *adv7604_dummy_client(struct v4l2_subdev *sd,
>> -                                                     u8 addr, u8 io_reg)
>> +                                             unsigned int i)
>>  {
>>       struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +     struct adv7604_platform_data *pdata = client->dev.platform_data;
>> +     unsigned int io_reg = 0xf2 + i;
>> +     unsigned int default_addr = io_read(sd, io_reg) >> 1;
>
> The variable isn't used.

Removed. Again, didn't check sufficiently my compiler warnings...

>> +     struct i2c_client *new_client;
>> +
>> +     if (pdata && pdata->i2c_addresses[i])
>> +             new_client = i2c_new_dummy(client->adapter,
>> +                                     pdata->i2c_addresses[i]);
>> +     else
>> +             new_client = i2c_new_secondary_device(client,
>> +                     adv7604_secondary_names[i].name,
>> +                     adv7604_secondary_names[i].default_addr);
>> +
>> +     if (new_client)
>> +             io_write(sd, io_reg, new_client->addr << 1);
>>
>> -     if (addr)
>> -             io_write(sd, io_reg, addr << 1);
>> -     return i2c_new_dummy(client->adapter, io_read(sd, io_reg) >> 1);
>> +     return new_client;
>>  }
>>
>>  static const struct adv7604_reg_seq adv7604_recommended_settings_afe[] = {
>> @@ -2718,20 +2752,6 @@ static int adv7604_parse_dt(struct adv7604_state
>> *state) /* Disable the interrupt for now as no DT-based board uses it. */
>> state->pdata.int1_config = ADV7604_INT1_CONFIG_DISABLED;
>>
>> -     /* Use the default I2C addresses. */
>> -     state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] = 0x42;
>> -     state->pdata.i2c_addresses[ADV7604_PAGE_CEC] = 0x40;
>> -     state->pdata.i2c_addresses[ADV7604_PAGE_INFOFRAME] = 0x3e;
>> -     state->pdata.i2c_addresses[ADV7604_PAGE_ESDP] = 0x38;
>> -     state->pdata.i2c_addresses[ADV7604_PAGE_DPP] = 0x3c;
>> -     state->pdata.i2c_addresses[ADV7604_PAGE_AFE] = 0x26;
>> -     state->pdata.i2c_addresses[ADV7604_PAGE_REP] = 0x32;
>> -     state->pdata.i2c_addresses[ADV7604_PAGE_EDID] = 0x36;
>> -     state->pdata.i2c_addresses[ADV7604_PAGE_HDMI] = 0x34;
>> -     state->pdata.i2c_addresses[ADV7604_PAGE_TEST] = 0x30;
>> -     state->pdata.i2c_addresses[ADV7604_PAGE_CP] = 0x22;
>> -     state->pdata.i2c_addresses[ADV7604_PAGE_VDP] = 0x24;
>> -
>>       /* Hardcode the remaining platform data fields. */
>>       state->pdata.disable_pwrdnb = 0;
>>       state->pdata.disable_cable_det_rst = 0;
>> @@ -2892,8 +2912,7 @@ static int adv7604_probe(struct i2c_client *client,
>>                       continue;
>>
>>               state->i2c_clients[i] =
>> -                     adv7604_dummy_client(sd, state->pdata.i2c_addresses[i],
>> -                                          0xf2 + i);
>> +                     adv7604_dummy_client(sd, i);
>>               if (state->i2c_clients[i] == NULL) {
>>                       err = -ENOMEM;
>>                       v4l2_err(sd, "failed to create i2c client %u\n", i);
>
> --
> Regards,
>
> Laurent Pinchart
>

Thanks,
JM
