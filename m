Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.epfl.ch ([128.178.224.226]:56991 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752321Ab0AUI1X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 03:27:23 -0500
Message-ID: <4B580FE8.8080203@epfl.ch>
Date: Thu, 21 Jan 2010 09:27:20 +0100
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] MT9T031: write xskip and yskip at each set_params call
References: <1264013696-11315-1-git-send-email-valentin.longchamp@epfl.ch> <Pine.LNX.4.64.1001202010190.4151@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1001202010190.4151@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Wed, 20 Jan 2010, Valentin Longchamp wrote:
> 
>> This prevents the registers to be different to the computed values
>> the second time you open the same camera with the sames parameters.
>>
>> The images were different between the first device open and the
>> second one with the same parameters.
> 
> But why they were different? Weren't xskip and yskip preserved from the 
> previous S_CROP / S_FMT configuration? If so, then, I am afraid, this is 
> the behaviour, mandated by the API, and as such shall not be changed. Or 
> have I misunderstood you?

Here are more details about what I debugged:

First more details about what I do with the camera: I open the device, 
issue the S_CROP / S_FMT calls and read images, the behaviour is fine, 
then close the device.

Then if I reopen the device, reissue the S_CROP / S_FMT calls with the 
same params, but the images is not the sames because of different xskip 
and yskip. From what I have debugged in the driver at the second S_CROP 
/S_FMT, xskip and yskip are computed by mt9t031_skip (and have the same 
value that the one stored in the mt9t031 struct) and thus with the 
current code are not rewritten.

However, if I read the register values containing bin and skip values on 
the camera chip they have been reset (does a open/close do some reset to 
the cam ?) and thus different than the ones that should be written.

I hope this clarifies the problem that I am experiencing. I don't think 
that the API wants you to get two different images when you open the 
device and issue the same parameters twice.

Best Regards

Val

> 
> Thanks
> Guennadi
> 
>> Signed-off-by: Valentin Longchamp <valentin.longchamp@epfl.ch>
>> ---
>>  drivers/media/video/mt9t031.c |   17 ++++++++---------
>>  1 files changed, 8 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
>> index a9061bf..e4a9095 100644
>> --- a/drivers/media/video/mt9t031.c
>> +++ b/drivers/media/video/mt9t031.c
>> @@ -17,6 +17,7 @@
>>  #include <media/v4l2-chip-ident.h>
>>  #include <media/soc_camera.h>
>>  
>> +
>>  /*
>>   * mt9t031 i2c address 0x5d
>>   * The platform has to define i2c_board_info and link to it from
>> @@ -337,15 +338,13 @@ static int mt9t031_set_params(struct i2c_client *client,
>>  	if (ret >= 0)
>>  		ret = reg_write(client, MT9T031_VERTICAL_BLANKING, vblank);
>>  
>> -	if (yskip != mt9t031->yskip || xskip != mt9t031->xskip) {
>> -		/* Binning, skipping */
>> -		if (ret >= 0)
>> -			ret = reg_write(client, MT9T031_COLUMN_ADDRESS_MODE,
>> -					((xbin - 1) << 4) | (xskip - 1));
>> -		if (ret >= 0)
>> -			ret = reg_write(client, MT9T031_ROW_ADDRESS_MODE,
>> -					((ybin - 1) << 4) | (yskip - 1));
>> -	}
>> +	/* Binning, skipping */
>> +	if (ret >= 0)
>> +		ret = reg_write(client, MT9T031_COLUMN_ADDRESS_MODE,
>> +				((xbin - 1) << 4) | (xskip - 1));
>> +	if (ret >= 0)
>> +		ret = reg_write(client, MT9T031_ROW_ADDRESS_MODE,
>> +				((ybin - 1) << 4) | (yskip - 1));
>>  	dev_dbg(&client->dev, "new physical left %u, top %u\n",
>>  		rect->left, rect->top);
>>  
>> -- 
>> 1.6.3.3
>>
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/


-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEB3494, Station 9, CH-1015 Lausanne
