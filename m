Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:53457 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3DVU4A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 16:56:00 -0400
Received: by mail-lb0-f182.google.com with SMTP id v20so14003lbc.27
        for <linux-media@vger.kernel.org>; Mon, 22 Apr 2013 13:55:59 -0700 (PDT)
Message-ID: <5175A3C9.4050204@cogentembedded.com>
Date: Tue, 23 Apr 2013 00:55:37 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org, matsu@igel.co.jp
Subject: Re: [PATCH v2 1/5] V4L2: I2C: ML86V7667 video decoder driver
References: <201304212240.30949.sergei.shtylyov@cogentembedded.com> <201304220848.04870.hverkuil@xs4all.nl> <5174F74E.9030707@cogentembedded.com> <201304221106.20598.hverkuil@xs4all.nl>
In-Reply-To: <201304221106.20598.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
>>>> +	 */
>>>> +	val = i2c_smbus_read_byte_data(client, STATUS_REG);
>>>> +	if (val < 0)
>>>> +		return val;
>>>> +
>>>> +	priv->std = val & STATUS_NTSCPAL ? V4L2_STD_PAL : V4L2_STD_NTSC;
>>>>     
>>>>         
>>> Shouldn't this be 50 Hz vs 60 Hz formats? There are 60 Hz PAL standards
>>> and usually these devices detect 50 Hz vs 60 Hz, not NTSC vs PAL.
>>>   
>>>       
>> In the reference manual it is not mentioned about 50/60Hz input format 
>> selection/detection but it mentioned just PAL/NTSC.
>> The 50hz formats can be ether PAL and NTSC formats variants. The same is 
>> applied to 60Hz.
>>
>> In the ML86V7667 datasheet the description for STATUS register detection 
>> bit is just PAL/NTSC:
>> " $2C/STATUS [2] NTSC/PAL identification 0: NTSC /1: PAL "
>>
>> If you assure me that I must judge their description as 50 vs 60Hz 
>> formats and not PAL/NTSC then I will make the change.
>>     
>
> I can't judge that. Are there no status bits anywhere that tell you something
> about the number of lines per frame or the framerate?
>   
You are right. I've found a relationship table with description of 
number of total H/V pixels vs Video Modes mentioned in datasheet.
It's  "NTSC" has Odd/263 and Even/262 vertical lines. The "PAL" has 
Odd/312 and Even/313.
So I will change the standard per your suggestion.
> Are you able to test with a PAL-M or PAL-N(c) input?
>   
Unfortunately I cannot. I have a couple of different cameras and all of 
them mention PAL output with number of lines in the technical manual. 
All of them are 625 lines.
> Can you ask the manufacturer for more information?
>   
It can take a while for waiting their feedback since OKI was 
significantly reorganized.

Than you very much for your valuable feedback/review.

Regards,
Vladimir
