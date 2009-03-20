Return-path: <linux-media-owner@vger.kernel.org>
Received: from gs8a.inmotionhosting.com ([216.193.219.253]:36091 "EHLO
	gs8.inmotionhosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751944AbZCTHj2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 03:39:28 -0400
Message-ID: <49C32A65.4050009@thedirks.org>
Date: Thu, 19 Mar 2009 22:32:21 -0700
From: Bill Dirks <bill@thedirks.org>
MIME-Version: 1.0
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@skynet.be>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, dongsoo45.kim@samsung.com,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?UTF-8?B?6rmA7ZiV7KSA?= <riverful.kim@samsung.com>
Subject: Re: About white balance control.
References: <5e9665e10903172132g2c433879j14b292d8f5c96268@mail.gmail.com>	 <200903181129.52130.laurent.pinchart@skynet.be> <5e9665e10903180417w2035de8bp2d4f7775035804e0@mail.gmail.com>
In-Reply-To: <5e9665e10903180417w2035de8bp2d4f7775035804e0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DO_WHITE_BALANCE is intended to do a one-shot white balance calibration 
and then hold it. So you would hold up, for example, a white piece of 
paper in front of the camera and click the do white balance. Then the 
white balance should be correct as long as the lighting doesn't change. 
This can work better than auto white balance which can be fooled by 
colored walls, etc. Some video cameras used to have a button like this.

Bill.


Dongsoo, Nathaniel Kim wrote:
> Thank you Pingchart.
>
> So, V4L2_CID_DO_WHITE_BALANCE acts WB adjustment at every single time
> it has issued when device is in manual WB mode like
> V4L2_CID_WHITE_BALANCE_TEMPERATURE? Now I get it.
> But CID still missing for white balance presets like "cloudy",
> "sunny", "fluorescent"and so on.
> I think some sort of menu type CID could be useful to handle them,
> because WB presets differ for each devices.
> Cheers,
>
> Nate
>
> 2009/3/18 Laurent Pinchart <laurent.pinchart@skynet.be>:
>   
>> Hi Kim,
>>
>> On Wednesday 18 March 2009 05:32:08 Dongsoo, Nathaniel Kim wrote:
>>     
>>> Hello,
>>>
>>> I accidently realized today that I was using white balance control in wrong
>>> way.
>>>
>>> As far as I understand we've got
>>>
>>> V4L2_CID_AUTO_WHITE_BALANCE which activate auto white balance
>>> adjustment in runtime, V4L2_CID_DO_WHITE_BALANCE_TEMPERATURE specifying
>>> absolute kelvin value
>>>       
>> I suppose you mean V4L2_CID_WHITE_BALANCE_TEMPERATURE here.
>>
>>     
>>> but can't get what V4L2_CID_DO_WHITE_BALANCE is for.
>>>
>>> I think after issuing V4L2_CID_AUTO_WHITE_BALANCE and
>>> V4L2_CID_WHITE_BALANCE_TEMPERATURE,
>>> the white balance functionality works immediately. Isn't it right?
>>>
>>> What exactly is the button type V4L2_CID_DO_WHITE_BALANCE for? Because
>>> the V4L2 API document says that "(the value is ignored)". Does that
>>> mean that even we have issued V4L2_CID_AUTO_WHITE_BALANCE and
>>> V4L2_CID_WHITE_BALANCE_TEMPERATURE, we can't see the white balance
>>> working at that moment?
>>>       
>> V4L2_CID_AUTO_WHITE_BALANCE to enables or disables automatic white balance
>> adjustment. When automatic white balance is enabled the device adjusts the
>> white balance continuously.
>>
>> V4L2_CID_WHITE_BALANCE_TEMPERATURE controls the white balance adjustment
>> manually. The control is only effective when automatic white balance is
>> disabled.
>>
>> V4L2_CID_DO_WHITE_BALANCE instructs the device to run the automatic white
>> balance adjustment algorithm once and use the results for white balance
>> correction. It only makes sense when automatic white balance is disabled.
>>
>>     
>>> And one more thing. If I want to serve several white balance presets,
>>> like cloudy, dawn, sunny and so on, what should I do?
>>> I think it should be supported as menu type, but most of drivers are
>>> using white balance CID with integer type...then what should I do?
>>> Define preset names with kelvin number like this?
>>>
>>> #define WB_CLOUDY 8000
>>>
>>> Pretty confusing... anyone knows what should I do?
>>>       
>> Best regards,
>>
>> Laurent Pinchart
>>
>>
>>     
>
>
>
>   
