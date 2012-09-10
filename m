Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33542 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2IJU3o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 16:29:44 -0400
Received: by eaac11 with SMTP id c11so1121717eaa.19
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2012 13:29:43 -0700 (PDT)
Message-ID: <504E4DB3.8000404@gmail.com>
Date: Mon, 10 Sep 2012 22:29:39 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Francesco Lavra <francescolavra.fl@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sangwook Lee <sangwook.lee@linaro.org>,
	linux-media@vger.kernel.org, linaro-dev@lists.linaro.org,
	patches@linaro.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, 'Arnd Bergmann' <arnd@arndb.de>
Subject: Re: [RFC PATCH v6] media: add v4l2 subdev driver for S5K4ECGX sensor
References: <1346944114-17527-1-git-send-email-sangwook.lee@linaro.org> <504CBD47.5050802@gmail.com> <504E0175.80504@samsung.com> <504E36FE.60006@gmail.com>
In-Reply-To: <504E36FE.60006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/2012 08:52 PM, Francesco Lavra wrote:
> On 09/10/2012 05:04 PM, Sylwester Nawrocki wrote:
>> On 09/09/2012 06:01 PM, Francesco Lavra wrote:
>>>> +static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
>>>> +{
>>>> +	const struct firmware *fw;
>>>> +	int err, i, regs_num;
>>>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>>> +	u16 val;
>>>> +	u32 addr, crc, crc_file, addr_inc = 0;
>>>> +
>>>> +	err = request_firmware(&fw, S5K4ECGX_FIRMWARE, sd->v4l2_dev->dev);
>>>> +	if (err) {
>>>> +		v4l2_err(sd, "Failed to read firmware %s\n", S5K4ECGX_FIRMWARE);
>>>> +		return err;
>>>> +	}
>>>> +	regs_num = *(u32 *)(fw->data);
>>>> +	v4l2_dbg(3, debug, sd, "FW: %s size %d register sets %d\n",
>>>> +		 S5K4ECGX_FIRMWARE, fw->size, regs_num);
>>>> +	regs_num++; /* Add header */
>>>> +	if (fw->size != regs_num * FW_RECORD_SIZE + FW_CRC_SIZE) {
>>>> +		err = -EINVAL;
>>>> +		goto fw_out;
>>>> +	}
>>>> +	crc_file = *(u32 *)(fw->data + regs_num * FW_RECORD_SIZE);
>>>
>>> Depending on the value of regs_num, this may result in unaligned access
>>
>> Thanks for the catch. I think it is not the only place where unaligned
>> issues are possible. Since the data records are 4-byte address + 2-byte
>> value there is also an issue with reading the address entries. Assuming
>> fw->data is aligned to at least 2-bytes (not quite sure if we can assume
>> that) there should be no problem with reading 2-byte register values.
> 
> I'm not sure 2-byte alignment can be safely assumed, either.
> 
>> We could change the data types of the register values from u16 to u32,
>> wasting some memory (there is approximately 3 000 records), so there is
>> no other data types in the file structure than u32. Or use a patch as
>> below. Not sure what's better.
> 
> I prefer the approach of your patch below, but I would use get_unaligned
> to get the 2-byte values, too. Also there are another couple of
> glitches, see below.

OK, thanks for the feedback. It was also my preference. The performance
impact seems insignificant, given a write of each record takes time of
1 ms order.

>> 8<---------------------------------------------------------------------
>>  From a970480b99bdb74e2bf48e1a321724231e6516a0 Mon Sep 17 00:00:00 2001
>> From: Sylwester Nawrocki<sylvester.nawrocki@gmail.com>
>> Date: Sun, 9 Sep 2012 19:56:31 +0200
>> Subject: [PATCH] s5k4ecgx: Fix unaligned access issues
>>
>> Signed-off-by: Sylwester Nawrocki<sylvester.nawrocki@gmail.com>
>> ---
>>   drivers/media/i2c/s5k4ecgx.c |   16 ++++++++++++----
>>   1 files changed, 12 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
>> index 0ef0b7d..4c6439a 100644
>> --- a/drivers/media/i2c/s5k4ecgx.c
>> +++ b/drivers/media/i2c/s5k4ecgx.c
>> @@ -24,6 +24,7 @@
>>   #include<linux/module.h>
>>   #include<linux/regulator/consumer.h>
>>   #include<linux/slab.h>
>> +#include<asm/unaligned.h>
>>
>>   #include<media/media-entity.h>
>>   #include<media/s5k4ecgx.h>
>> @@ -331,6 +332,7 @@ static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
>>   	const struct firmware *fw;
>>   	int err, i, regs_num;
>>   	u32 addr, crc, crc_file, addr_inc = 0;
>> +	const u8 *ptr;
>>   	u16 val;
>>
>>   	err = request_firmware(&fw, S5K4ECGX_FIRMWARE, sd->v4l2_dev->dev);
>> @@ -338,7 +340,7 @@ static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
>>   		v4l2_err(sd, "Failed to read firmware %s\n", S5K4ECGX_FIRMWARE);
>>   		return err;
>>   	}
>> -	regs_num = le32_to_cpu(*(u32 *)fw->data);
>> +	regs_num = le32_to_cpu(get_unaligned((__le32 *)fw->data));
>>
>>   	v4l2_dbg(3, debug, sd, "FW: %s size %d register sets %d\n",
>>   		 S5K4ECGX_FIRMWARE, fw->size, regs_num);
>> @@ -349,7 +351,8 @@ static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
>>   		goto fw_out;
>>   	}
>>
>> -	crc_file = *(u32 *)(fw->data + regs_num * FW_RECORD_SIZE);
>> +	memcpy(&crc_file, fw->data + regs_num * FW_RECORD_SIZE, sizeof(u32));
> 
> crc_file should be converted from little endian to native endian.

Right, I should have verified that crc32_le() return value is in native
endianness.

>> +
>>   	crc = crc32_le(~0, fw->data, regs_num * FW_RECORD_SIZE);
>>   	if (crc != crc_file) {
>>   		v4l2_err(sd, "FW: invalid crc (%#x:%#x)\n", crc, crc_file);
>> @@ -357,9 +360,14 @@ static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
>>   		goto fw_out;
>>   	}
>>
>> +	ptr = fw->data + FW_RECORD_SIZE;
>> +
>>   	for (i = 1; i<  regs_num; i++) {
>> -		addr = le32_to_cpu(*(u32 *)(fw->data + i * FW_RECORD_SIZE));
>> -		val = le16_to_cpu(*(u16 *)(fw->data + i * FW_RECORD_SIZE + 4));
>> +		addr = le32_to_cpu(get_unaligned((__le32 *)ptr));
>> +		ptr += 4;
>> +		val = le16_to_cpu(*(__le16 *)ptr);
>> +		ptr += FW_RECORD_SIZE;
> 
> ptr is being incremented by (4 + FW_RECORD_SIZE) bytes at each iteration.

Oops, I was to quick in sending that patch out. Indeed, that's wrong.
Sangwook, FWIW, I just pushed the corrected patch to my tree
(http://git.linuxtv.org/snawrocki/media.git/commitdiff/4a0ecad6f08ccbba3)

--

Thanks,
Sylwester
