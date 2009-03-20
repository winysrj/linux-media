Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:15699 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZCTF7E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 01:59:04 -0400
Received: by wf-out-1314.google.com with SMTP id 29so1049535wff.4
        for <linux-media@vger.kernel.org>; Thu, 19 Mar 2009 22:59:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C32A65.4050009@thedirks.org>
References: <5e9665e10903172132g2c433879j14b292d8f5c96268@mail.gmail.com>
	 <200903181129.52130.laurent.pinchart@skynet.be>
	 <5e9665e10903180417w2035de8bp2d4f7775035804e0@mail.gmail.com>
	 <49C32A65.4050009@thedirks.org>
Date: Fri, 20 Mar 2009 14:59:02 +0900
Message-ID: <5e9665e10903192259paf99870kf97d7013bbc657a0@mail.gmail.com>
Subject: Re: About white balance control.
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Bill Dirks <bill@thedirks.org>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, dongsoo45.kim@samsung.com,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bill,

Thank you for your explanation.
I think this one-shot white balance cal feature should be supported by H/W,
or we should implement this with AWB activation for short period and
lock immediately.
That should be hard to tune properly to make it work in every circumstances.
I'll do some research on it to make it work properly with my mobile
camera module devices.
Any technical advise appreciated.
Cheers,

Nate

2009/3/20 Bill Dirks <bill@thedirks.org>:
> DO_WHITE_BALANCE is intended to do a one-shot white balance calibration and
> then hold it. So you would hold up, for example, a white piece of paper in
> front of the camera and click the do white balance. Then the white balance
> should be correct as long as the lighting doesn't change. This can work
> better than auto white balance which can be fooled by colored walls, etc.
> Some video cameras used to have a button like this.
>
> Bill.
>
>
> Dongsoo, Nathaniel Kim wrote:
>>
>> Thank you Pingchart.
>>
>> So, V4L2_CID_DO_WHITE_BALANCE acts WB adjustment at every single time
>> it has issued when device is in manual WB mode like
>> V4L2_CID_WHITE_BALANCE_TEMPERATURE? Now I get it.
>> But CID still missing for white balance presets like "cloudy",
>> "sunny", "fluorescent"and so on.
>> I think some sort of menu type CID could be useful to handle them,
>> because WB presets differ for each devices.
>> Cheers,
>>
>> Nate
>>
>> 2009/3/18 Laurent Pinchart <laurent.pinchart@skynet.be>:
>>
>>>
>>> Hi Kim,
>>>
>>> On Wednesday 18 March 2009 05:32:08 Dongsoo, Nathaniel Kim wrote:
>>>
>>>>
>>>> Hello,
>>>>
>>>> I accidently realized today that I was using white balance control in
>>>> wrong
>>>> way.
>>>>
>>>> As far as I understand we've got
>>>>
>>>> V4L2_CID_AUTO_WHITE_BALANCE which activate auto white balance
>>>> adjustment in runtime, V4L2_CID_DO_WHITE_BALANCE_TEMPERATURE specifying
>>>> absolute kelvin value
>>>>
>>>
>>> I suppose you mean V4L2_CID_WHITE_BALANCE_TEMPERATURE here.
>>>
>>>
>>>>
>>>> but can't get what V4L2_CID_DO_WHITE_BALANCE is for.
>>>>
>>>> I think after issuing V4L2_CID_AUTO_WHITE_BALANCE and
>>>> V4L2_CID_WHITE_BALANCE_TEMPERATURE,
>>>> the white balance functionality works immediately. Isn't it right?
>>>>
>>>> What exactly is the button type V4L2_CID_DO_WHITE_BALANCE for? Because
>>>> the V4L2 API document says that "(the value is ignored)". Does that
>>>> mean that even we have issued V4L2_CID_AUTO_WHITE_BALANCE and
>>>> V4L2_CID_WHITE_BALANCE_TEMPERATURE, we can't see the white balance
>>>> working at that moment?
>>>>
>>>
>>> V4L2_CID_AUTO_WHITE_BALANCE to enables or disables automatic white
>>> balance
>>> adjustment. When automatic white balance is enabled the device adjusts
>>> the
>>> white balance continuously.
>>>
>>> V4L2_CID_WHITE_BALANCE_TEMPERATURE controls the white balance adjustment
>>> manually. The control is only effective when automatic white balance is
>>> disabled.
>>>
>>> V4L2_CID_DO_WHITE_BALANCE instructs the device to run the automatic white
>>> balance adjustment algorithm once and use the results for white balance
>>> correction. It only makes sense when automatic white balance is disabled.
>>>
>>>
>>>>
>>>> And one more thing. If I want to serve several white balance presets,
>>>> like cloudy, dawn, sunny and so on, what should I do?
>>>> I think it should be supported as menu type, but most of drivers are
>>>> using white balance CID with integer type...then what should I do?
>>>> Define preset names with kelvin number like this?
>>>>
>>>> #define WB_CLOUDY 8000
>>>>
>>>> Pretty confusing... anyone knows what should I do?
>>>>
>>>
>>> Best regards,
>>>
>>> Laurent Pinchart
>>>
>>>
>>>
>>
>>
>>
>>
>



-- 
========================================================
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
