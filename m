Return-path: <linux-media-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:39968 "EHLO
        bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932110AbcKONuj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 08:50:39 -0500
Subject: Re: [PATCH v4 2/2] Add support for OV5647 sensor
To: Pavel Machek <pavel@ucw.cz>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
References: <cover.1479129004.git.roliveir@synopsys.com>
 <36447f1f102f648057eb9038a693941794a6c344.1479129004.git.roliveir@synopsys.com>
 <20161115121032.GB7018@amd>
Cc: mchehab@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, geert+renesas@glider.be,
        akpm@linux-foundation.org, hverkuil@xs4all.nl,
        dheitmueller@kernellabs.com, slongerbeam@gmail.com,
        lars@metafoo.de, robert.jarzmik@free.fr, pali.rohar@gmail.com,
        sakari.ailus@linux.intel.com, mark.rutland@arm.com,
        CARLOS.PALMINHA@synopsys.com
From: Guenter Roeck <linux@roeck-us.net>
Message-ID: <3b6863c4-e239-7b66-1d96-7f0326f507c5@roeck-us.net>
Date: Tue, 15 Nov 2016 05:50:32 -0800
MIME-Version: 1.0
In-Reply-To: <20161115121032.GB7018@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/15/2016 04:10 AM, Pavel Machek wrote:
> Hi!
>
>> Add support for OV5647 sensor.
>>
>
>> +static int ov5647_write(struct v4l2_subdev *sd, u16 reg, u8 val)
>> +{
>> +	int ret;
>> +	unsigned char data[3] = { reg >> 8, reg & 0xff, val};
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	ret = i2c_master_send(client, data, 3);
>> +	if (ret != 3) {
>> +		dev_dbg(&client->dev, "%s: i2c write error, reg: %x\n",
>> +				__func__, reg);
>> +		return ret < 0 ? ret : -EIO;
>> +	}
>> +	return 0;
>> +}
>
> Sorry, this is wrong. It should something <0 any time error is detected.
>

It seems to me that it does return a value < 0 each time an error is detected.

Guenter

