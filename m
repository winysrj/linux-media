Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:15315 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750723AbeFDGd2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 02:33:28 -0400
Subject: Re: [RESEND PATCH V2 2/2] media: ak7375: Add ak7375 lens voice coil
 driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>, bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        tian.shu.qiu@intel.com, rajmohan.mani@intel.com, tfiga@chromium.org
References: <1527242135-22866-1-git-send-email-bingbu.cao@intel.com>
 <1527242135-22866-2-git-send-email-bingbu.cao@intel.com>
 <20180601094207.355n2vzpscsgwyc6@paasikivi.fi.intel.com>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <e898d6bc-f9d3-3f0b-6e93-2e8dd99a047f@linux.intel.com>
Date: Mon, 4 Jun 2018 14:36:10 +0800
MIME-Version: 1.0
In-Reply-To: <20180601094207.355n2vzpscsgwyc6@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2018年06月01日 17:42, Sakari Ailus wrote:
> On Fri, May 25, 2018 at 05:55:35PM +0800, bingbu.cao@intel.com wrote:
>> +static int ak7375_i2c_write(struct ak7375_device *ak7375,
>> +	u8 addr, u16 data, int size)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(&ak7375->sd);
>> +	int ret;
>> +	u8 buf[3];
>> +
>> +	if (size != 1 && size != 2)
>> +		return -EINVAL;
>> +	buf[0] = addr;
>> +	buf[2] = data & 0xff;
>> +	if (size == 2)
>> +		buf[1] = data >> 8;
>> +	ret = i2c_master_send(client, (const char *)buf, size + 1);
> I don't have a data datasheet for this thing, but it looks like buf[1] will
> be undefined for writes the size of which is 1. And this what appears to be
> written to the device as well...
I check the datasheet once again and find out that the logic here for 
size==1 is
not correct, I will change it in next version. Thanks.
Here is the write section in datasheet:

------
After receiving the second byte (register address), AK7375 generates an 
acknowledge then receives the third
byte. The third and the following bytes represent control data. Control 
data consists of 8 bits and is based on
the MSB-first configuration.
AK7375 can write multiple bytes of data at a time. After reception of 
the third byte (control data), AK7375
generates an acknowledge then receives the next data. If additional data 
is received instead of the stop
condition after receiving one byte of data, the address counter inside 
the LSI chip is automatically
incremented and the data is written at the next address.
------

>
>> +	if (ret < 0)
>> +		return ret;
>> +	if (ret != size + 1)
>> +		return -EIO;
>> +	return 0;
>> +}
