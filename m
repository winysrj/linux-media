Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37133 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183Ab1CCOeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 09:34:46 -0500
Received: by iyb26 with SMTP id 26so965220iyb.19
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2011 06:34:46 -0800 (PST)
Subject: Re: [RFC PATCH RESEND v2 3/3] v4l2-ctrls: document the changes about auto focus mode
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=euc-kr
From: Kim HeungJun <riverful@gmail.com>
In-Reply-To: <201103031424.41611.laurent.pinchart@ideasonboard.com>
Date: Thu, 3 Mar 2011 23:34:36 +0900
Cc: Kim HeungJun <riverful@gmail.com>, riverful.kim@samsung.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"???/Mobile S/W Platform Lab(DMC?)/E4(??)/????"
	<sw0312.kim@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C4036AEF-AD3A-44E3-A285-CAF7AAA20460@gmail.com>
References: <4D6EFA02.4080105@samsung.com> <201103031108.46219.laurent.pinchart@ideasonboard.com> <C35D1DB1-9F7A-42C2-9801-66B2BD8AA3CE@gmail.com> <201103031424.41611.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, 

2011. 3. 3., 오후 10:24, Laurent Pinchart 작성:

> Hi,
> 
> On Thursday 03 March 2011 14:17:10 Kim HeungJun wrote:
>> 2011. 3. 3., 오후 7:08, Laurent Pinchart 작성:
>>> On Thursday 03 March 2011 03:16:34 Kim, HeungJun wrote:
>>>> Document about the type changes and the enumeration of the auto focus
>>>> control.
>>>> 
>>>> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>> Documentation/DocBook/v4l/controls.xml    |   31
>>>> +++++++++++++++++++++++++--- Documentation/DocBook/v4l/videodev2.h.xml |
>>>> 6 +++++
>>>> 2 files changed, 33 insertions(+), 4 deletions(-)
>>>> 
>>>> diff --git a/Documentation/DocBook/v4l/controls.xml
>>>> b/Documentation/DocBook/v4l/controls.xml index 2fae3e8..889fa84 100644
>>>> --- a/Documentation/DocBook/v4l/controls.xml
>>>> +++ b/Documentation/DocBook/v4l/controls.xml
>>>> @@ -1801,12 +1801,35 @@ negative values towards infinity. This is a
>>>> write-only control.</entry> </row>
>>>> 
>>>> 	  <row><entry></entry></row>
>>>> 
>>>> -	  <row>
>>>> +	  <row id="v4l2-focus-auto-type">
>>>> 
>>>> 	    <entry
>>>> 
>>>> spanname="id"><constant>V4L2_CID_FOCUS_AUTO</constant>&nbsp;</entry> -
>>>> <entry>boolean</entry>
>>>> +	    <entry>enum&nbsp;v4l2_focus_auto_type</entry>
>>>> 
>>>> 	  </row><row><entry spanname="descr">Enables automatic focus
>>>> 
>>>> -adjustments. The effect of manual focus adjustments while this feature
>>>> -is enabled is undefined, drivers should ignore such requests.</entry>
>>>> +adjustments of the normal or macro or continuous(CAF) mode. The effect
>>>> of +manual focus adjustments while this feature is enabled is
>>>> undefined, +drivers should ignore such requests. Possible values
>>>> are:</entry> +	  </row>
>>>> +	  <row>
>>>> +	    <entrytbl spanname="descr" cols="2">
>>>> +	      <tbody valign="top">
>>>> +		<row>
>>>> +		  <entry><constant>V4L2_FOCUS_MANUAL</constant>&nbsp;</entry>
>>>> +		  <entry>Manual focus mode.</entry>
>>>> +		</row>
>>>> +		<row>
>>>> +		  <entry><constant>V4L2_FOCUS_AUTO</constant>&nbsp;</entry>
>>>> +		  <entry>Auto focus mode with normal operation.</entry>
>>>> +		</row>
>>>> +		<row>
>>>> +		  <entry><constant>V4L2_FOCUS_MACRO</constant>&nbsp;</entry>
>>>> +		  <entry>Auto focus mode with macro operation.</entry>
>>>> +		</row>
>>>> +		<row>
>>>> +		  <entry><constant>V4L2_FOCUS_CONTINUOUS</constant>&nbsp;</entry>
>>>> +		  <entry>Auto focus mode with continuous(CAF) operation.</entry>
>>> 
>>> I should have asked this sooner, but what's the difference between normal
>>> AF and continuous AF ?
>> 
>> Let's assume that the whole focus process(of course the sensor-internal
>> process automatically) is below : 1) pointing the object focussed
>> 
>>    : mostly this is possible to be a middle spot, or pre-given orient x &
>>    : y set from register.
>> 
>>    (The mode using given orient x & y, may be defined V4L2_FOCUS_TOUCH or
>> whatever, but I know touch auto focus suggestion is determined nothing so
>> far, because of that, after this I will suggest to discuss about it one
>> more.) 2) starting and completing the move of the motor to control lens,
>> using the focusing internal algorithm 3) check whether the lens position
>> is proper or not, using the focusing internal algorithm, too. (If the
>> position is not proper, the image may looks defocused)
>> 
>> In the Normal AF mode, the sensor do the whole focusing process once, and
>> after completing to move lens, even though the sensor failed focusing
>> process. On the other hand, the sensor repeats 1~3 in the Continuous AF
>> mode periodically, regardless of success of failure.
> 
> OK, that was my understanding as well. How will that work with the proposed 
> focus menu control ? Don't you need a button control for normal auto-focus ?

You mean that the normal auto-focus control type should be a button, right?
For now, in our case the user application assumes that such modes(normal, MACRO, CAF,
TOUCH or oriented mode, or something) are already ready in the driver.
So, I did't need the normal auto-focus is a button type.

But, IMHO, the focus control of camera is right to follow the next procedure, 
1) choosing the modes as I said upper. (because, the camera dose not have one more focus mode.)
2) adjusting the value of the mode set right before.
3) doing the action of the mode.

1) is the same call the control V4L2_AUTO_FOCUS of menu type.
2), 3) is the same call the control dedicated focus control. Currently, the focus control excepting manual
is not needed another control. If touch mode are needed, we can add another enum value, e.g. V4L2_FOCUS_ORIENT.
and add another dedicated control, e.g., V4L2_CID_FOCUS_ORIENT_X, V4L2_CID_FOCUS_ORIENT_Y.

I think this as I use digital camera. We normally follow such procedure, using the digital camera.

If I get your words wrongly, give me some clue :)

Thanks,
Heungjun Kim


