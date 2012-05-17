Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:33310 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967208Ab2EQWhT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 18:37:19 -0400
Message-ID: <4FB57D97.6000509@iki.fi>
Date: Fri, 18 May 2012 01:37:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 03/23] V4L: Add an extended camera white balance control
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com> <1336645858-30366-4-git-send-email-s.nawrocki@samsung.com> <20120514000234.GG3373@valkosipuli.retiisi.org.uk> <4FB2CA63.2000605@gmail.com> <20120516065715.GK3373@valkosipuli.retiisi.org.uk> <4FB374A9.60901@samsung.com>
In-Reply-To: <4FB374A9.60901@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 05/16/2012 08:57 AM, Sakari Ailus wrote:
> ...
>>>>> +
>>>>> +	<row id="v4l2-auto-n-preset-white-balance">
>>>>> +	<entry spanname="id"><constant>V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE</constant>&nbsp;</entry>
>>>>> +	<entry>enum&nbsp;v4l2_auto_n_preset_white_balance</entry>
>>>>> +	</row><row><entry spanname="descr">Sets white balance to automatic,
>>>>> +manual or a preset. The presets determine color temperature of the light as
>>>>> +a hint to the camera for white balance adjustments resulting in most accurate
>>>>> +color representation. The following white balance presets are listed in order
>>>>> +of increasing color temperature.</entry>
>>>>> +	</row>
>>>>> +	<row>
>>>>> +	<entrytbl spanname="descr" cols="2">
>>>>> +	<tbody valign="top">
>>>>> +		<row>
>>>>> +		<entry><constant>V4L2_WHITE_BALANCE_MANUAL</constant>&nbsp;</entry>
>>>>> +		<entry>Manual white balance.</entry>
>>>>> +		</row>
>>>>> +		<row>
>>>>> +		<entry><constant>V4L2_WHITE_BALANCE_AUTO</constant>&nbsp;</entry>
>>>>> +		<entry>Automatic white balance adjustments.</entry>
>>>>> +		</row>
>>>>> +		<row>
>>>>> +		<entry><constant>V4L2_WHITE_BALANCE_INCANDESCENT</constant>&nbsp;</entry>
>>>>> +		<entry>White balance setting for incandescent (tungsten) lighting.
>>>>> +It generally cools down the colors and corresponds approximately to 2500...3500 K
>>>>> +color temperature range.</entry>
>>>>> +		</row>
>>>>> +		<row>
>>>>> +		<entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT</constant>&nbsp;</entry>
>>>>> +		<entry>White balance preset for fluorescent lighting.
>>>>> +It corresponds approximately to 4000...5000 K color temperature.</entry>
>>>>> +		</row>
>>>>> +		<row>
>>>>> +		<entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT_H</constant>&nbsp;</entry>
>>>>> +		<entry>With this setting the camera will compensate for
>>>>> +fluorescent H lighting.</entry>
>>>>> +		</row>
>>>>
>>>> I don't remember for quite sure if I replied to this already... what's the
>>>> diff between the above two?
>>>
>>> No, you didn't, otherwise I would certainly remember that ;)
>>>
>>> V4L2_WHITE_BALANCE_FLUORESCENT_H is for newer, daylight calibrated fluorescent
>>> lamps. So this preset will generally cool down the colours less than
>                                         ^^^^^^^^^   
> Sorry, I put it wrong. It should have been "warm up", since "cooling down"
> the colours happens only for V4L2_WHITE_BALANCE_INCANDESCENT, other presets
> just generally warm up colours, with various degree.
> 
>>> V4L2_WHITE_BALANCE_FLUORESCENT. I was even thinking about a separate control 
>>> for V4L2_WHITE_BALANCE_FLUORESCENT, since some ISPs have several presets for
>>> fluorescent lighting. I dropped that idea finally though.
>>
>> I don't know about the daylight calibrated ones, but the older ones often
>> tend to give colder light. Nevertheless, I think it'd be good to mention
>> this in the documentation. I couldn't have guessed it. :)
> 
> Do you think something like this would be OK:
> 
> +		<entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT_H</constant>&nbsp;</entry>
> +		<entry>Variant of <constant>V4L2_WHITE_BALANCE_FLUORESCENT</constant> 
> + for fluorescent lamp lighting with spectral power distribution more similar
> + to daylight.</entry>
> +		</row>
> 
> ?

Looks good to me!

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
