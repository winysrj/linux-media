Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33271 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755636AbeDWPzl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 11:55:41 -0400
MIME-Version: 1.0
In-Reply-To: <4036479.nT1QDtF4Ij@avalon>
References: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com>
 <1524412577-14419-3-git-send-email-akinobu.mita@gmail.com> <4036479.nT1QDtF4Ij@avalon>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Tue, 24 Apr 2018 00:55:20 +0900
Message-ID: <CAC5umyiBvBK3QpaszSx0XuMKyj66gCNyKfX8apEh2mk6xG5vtQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] media: ov772x: allow i2c controllers without I2C_FUNC_PROTOCOL_MANGLING
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-04-23 18:18 GMT+09:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Mita-san,
>
> On Sunday, 22 April 2018 18:56:08 EEST Akinobu Mita wrote:
>> The ov772x driver only works when the i2c controller have
>> I2C_FUNC_PROTOCOL_MANGLING.  However, many i2c controller drivers don't
>> support it.
>>
>> The reason that the ov772x requires I2C_FUNC_PROTOCOL_MANGLING is that
>> it doesn't support repeated starts.
>>
>> This changes the reading ov772x register method so that it doesn't
>> require I2C_FUNC_PROTOCOL_MANGLING by calling two separated i2c messages.
>
> As commented in a reply to v1, given that this implementation is in no way
> specific to the ov772x driver, I'd prefer implementing the fallback in the I2C
> core instead.

Do you have any ideas how to implement in the I2C core?
I wonder if I can modify i2c_smbus_read_byte_data() or i2c_transfer()
for I2C_CLIENT_SCCB.

>> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>> * v3
>> - Remove I2C_CLIENT_SCCB flag set as it isn't needed anymore
>>
>>  drivers/media/i2c/ov772x.c | 20 ++++++++++++++------
>>  1 file changed, 14 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
>> index b62860c..2ae730f 100644
>> --- a/drivers/media/i2c/ov772x.c
>> +++ b/drivers/media/i2c/ov772x.c
>> @@ -542,9 +542,19 @@ static struct ov772x_priv *to_ov772x(struct v4l2_subdev
>> *sd) return container_of(sd, struct ov772x_priv, subdev);
>>  }
>>
>> -static inline int ov772x_read(struct i2c_client *client, u8 addr)
>> +static int ov772x_read(struct i2c_client *client, u8 addr)
>>  {
>> -     return i2c_smbus_read_byte_data(client, addr);
>> +     int ret;
>> +     u8 val;
>> +
>> +     ret = i2c_master_send(client, &addr, 1);
>> +     if (ret < 0)
>> +             return ret;
>> +     ret = i2c_master_recv(client, &val, 1);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     return val;
>>  }
>>
>>  static inline int ov772x_write(struct i2c_client *client, u8 addr, u8
>> value) @@ -1255,13 +1265,11 @@ static int ov772x_probe(struct i2c_client
>> *client, return -EINVAL;
>>       }
>>
>> -     if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
>> -                                           I2C_FUNC_PROTOCOL_MANGLING)) {
>> +     if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
>>               dev_err(&adapter->dev,
>> -                     "I2C-Adapter doesn't support SMBUS_BYTE_DATA or PROTOCOL_MANGLING
> \n");
>> +                     "I2C-Adapter doesn't support SMBUS_BYTE_DATA\n");
>>               return -EIO;
>>       }
>> -     client->flags |= I2C_CLIENT_SCCB;
>>
>>       priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
>>       if (!priv)
>
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>
