Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55747 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1LFRZr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 12:25:47 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LVS00DMZLQXMR80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Dec 2011 17:25:45 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVS00F1ULQWOC@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Dec 2011 17:25:45 +0000 (GMT)
Date: Tue, 06 Dec 2011 18:25:44 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC/PATCH 1/5] v4l: Convert V4L2_CID_FOCUS_AUTO control to a menu
 control
In-reply-to: <201112061331.14987.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	sakari.ailus@iki.fi, hverkuil@xs4all.nl, riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4EDE5018.30409@samsung.com>
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
 <1323011776-15967-2-git-send-email-snjw23@gmail.com>
 <201112061331.14987.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/06/2011 01:31 PM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> On Sunday 04 December 2011 16:16:12 Sylwester Nawrocki wrote:
>> Change the V4L2_CID_FOCUS_AUTO control type from boolean to a menu
>> type. In case of boolean control we had values 0 and 1 corresponding
>> to manual and automatic focus respectively.
>>
>> The V4L2_CID_FOCUS_AUTO menu control has currently following items:
>>   0 - V4L2_FOCUS_MANUAL,
>>   1 - V4L2_FOCUS_AUTO,
>>   2 - V4L2_FOCUS_AUTO_MACRO,
>>   3 - V4L2_FOCUS_AUTO_CONTINUOUS.
> 
> I think the mapping is wrong, please see my answer to 2/5.

Yes, agreed. Please see my answer to you answer to 2/5 :)

> 
>> To trigger single auto focus action in V4L2_FOCUS_AUTO mode the
>> V4L2_DO_AUTO_FOCUS control can be used, which is also added in this
>> patch.
>>
>> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
>> ---
>>  Documentation/DocBook/media/v4l/controls.xml |   52
>> +++++++++++++++++++++++-- drivers/media/video/v4l2-ctrls.c             |  
>> 13 ++++++-
>>  include/linux/videodev2.h                    |    8 ++++
>>  3 files changed, 67 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
>> b/Documentation/DocBook/media/v4l/controls.xml index 3bc5ee8..5ccb0b0
>> 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -2782,12 +2782,54 @@ negative values towards infinity. This is a
>> write-only control.</entry> </row>
>>  	  <row><entry></entry></row>
>>
>> -	  <row>
>> +	  <row id="v4l2-focus-auto-type">
>>  	    <entry
>> spanname="id"><constant>V4L2_CID_FOCUS_AUTO</constant>&nbsp;</entry> -	   
>> <entry>boolean</entry>
>> -	  </row><row><entry spanname="descr">Enables automatic focus
>> -adjustments. The effect of manual focus adjustments while this feature
>> -is enabled is undefined, drivers should ignore such requests.</entry>
>> +	    <entry>enum&nbsp;v4l2_focus_auto_type</entry>
>> +	  </row><row><entry spanname="descr">Determines the camera
>> +focus mode. The effect of manual focus adjustments while <constant>
>> +V4L2_CID_FOCUS_AUTO </constant> is not set to <constant>
>> +V4L2_FOCUS_MANUAL</constant> is undefined, drivers should ignore such
>> +requests.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entrytbl spanname="descr" cols="2">
>> +	      <tbody valign="top">
>> +		<row>
>> +		  <entry><constant>V4L2_FOCUS_MANUAL</constant>&nbsp;</entry>
>> +		  <entry>Manual focus.</entry>
>> +		</row>
>> +		<row>
>> +		  <entry><constant>V4L2_FOCUS_AUTO</constant>&nbsp;</entry>
>> +		  <entry>Single shot auto focus. When switched to
>> +this mode the camera focuses on a subject just once. <constant>
>> +V4L2_CID_DO_AUTO_FOCUS</constant> control can be used to manually
>> +invoke auto focusing.</entry>
>> +		</row>
> 
> Do we need this single-shot auto-focus menu entry ? We could just use 
> V4L2_CID_DO_AUTO_FOCUS in V4L2_FOCUS_MANUAL mode to do this. This is what 
> happens with one-shot white balance.

There might be various flavours of single-shot auto focus, there may be some
more focus modes than those in this patch.
If we have removed them from the menu entry then we would likely have to
come up with more V4L2_CID_DO_AUTO_FOCUS_* controls.

> 
>> +		<row>
>> +		  <entry><constant>V4L2_FOCUS_AUTO_MACRO</constant>&nbsp;</entry>
>> +		  <entry>Macro (close-up) auto focus. Usually camera
>> +auto focus algorithms do not attempt to focus on a subject that is
>> +closer than a given distance. This mode can be used to tell the camera
>> +to use minimum distance for focus that it is capable of.</entry>
>> +		</row>
>> +		<row>
>> +		  <entry><constant>V4L2_FOCUS_AUTO_CONTINUOUS</constant>&nbsp;</entry>
>> +		  <entry>Continuous auto focus. When switched to this
>> +mode the camera continually adjusts focus.</entry>
>> +		</row>
>> +	      </tbody>
>> +	    </entrytbl>
>> +	  </row>
>> +	  <row><entry></entry></row>
>> +
>> +	  <row>
>> +	    <entry
>> spanname="id"><constant>V4L2_CID_DO_AUTO_FOCUS</constant>&nbsp;</entry> +	
>>    <entry>button</entry>
>> +	  </row><row><entry spanname="descr">When this control is set
> 
> Wouldn't "written" be better than "set" here ? I understand "When this control 
> is set" as "while the control has a non-zero value" (but it might just be me).

Sure, I could change to that. However this is a button control, so "written"
doesn't quite match IMHO. And we do set/get controls, rather than read/write.

Originally I had (copied form V4L2_CID_DO_WHITE_BALANCE):

"This is an action control. When it is set (the value is ignored)..."

How about "When this control is applied.." ?

>
>> +the camera will perform one shot auto focus. The effect of using this
>> +control when <constant>V4L2_CID_FOCUS_AUTO</constant> is in mode
>> +different than <constant>V4L2_FOCUS_AUTO</constant> is undefined,
>> +drivers should ignore such requests. </entry>
>>  	  </row>

--

Thanks,
Sylwester
