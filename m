Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51483 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab1LFQ1M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 11:27:12 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LVS00DYYJ1BLO70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Dec 2011 16:27:11 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVS003QEJ1AFN@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Dec 2011 16:27:10 +0000 (GMT)
Date: Tue, 06 Dec 2011 17:27:09 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC/PATCH 3/5] v4l: Add V4L2_CID_METERING_MODE camera control
In-reply-to: <201112061332.40168.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	sakari.ailus@iki.fi, hverkuil@xs4all.nl, riverful.kim@samsung.com
Message-id: <4EDE425D.6020502@samsung.com>
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
 <1323011776-15967-4-git-send-email-snjw23@gmail.com>
 <201112061332.40168.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

thanks for the comments.

On 12/06/2011 01:32 PM, Laurent Pinchart wrote:
> On Sunday 04 December 2011 16:16:14 Sylwester Nawrocki wrote:
>> The V4L2_CID_METERING_MODE control allows to determine what method
>> is used by the camera to measure the amount of light available for
>> automatic exposure control.
>>
>> Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
>> ---
>>  Documentation/DocBook/media/v4l/controls.xml |   31
>> ++++++++++++++++++++++++++ drivers/media/video/v4l2-ctrls.c             | 
>>   2 +
>>  include/linux/videodev2.h                    |    7 ++++++
>>  3 files changed, 40 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
>> b/Documentation/DocBook/media/v4l/controls.xml index 5ccb0b0..53d7c08
>> 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -2893,6 +2893,7 @@ mechanical obturation of the sensor and firmware
>> image processing, but the device is not restricted to these methods.
>> Devices that implement the privacy control must support read access and
>> may support write access.</entry> </row>
>> +	  <row><entry></entry></row>
>>
>>  	  <row>
>>  	    <entry
>> spanname="id"><constant>V4L2_CID_BAND_STOP_FILTER</constant>&nbsp;</entry>
>> @@ -2902,6 +2903,36 @@ camera sensor on or off, or specify its strength.
>> Such band-stop filters can be used, for example, to filter out the
>> fluorescent light component.</entry> </row>
>>  	  <row><entry></entry></row>
>> +
>> +	  <row id="v4l2-metering-mode">
>> +	    <entry
>> spanname="id"><constant>V4L2_CID_METERING_MODE</constant>&nbsp;</entry> +	
>>    <entry>enum&nbsp;v4l2_metering_mode</entry>
>> +	  </row><row><entry spanname="descr">Determines how the camera measures
>> +the amount of light available to expose a frame. Possible values
>> are:</entry> +	  </row>
>> +	  <row>
>> +	    <entrytbl spanname="descr" cols="2">
>> +	      <tbody valign="top">
>> +		<row>
>> +		  <entry><constant>V4L2_METERING_MODE_AVERAGE</constant>&nbsp;</entry>
>> +		  <entry>Use the light information coming from the entire scene
>> +and average giving no weighting to any particular portion of the metered
>> area. +		  </entry>
>> +		</row>
>> +		<row>
>> +		 
>> <entry><constant>V4L2_METERING_MODE_CENTER_WEIGHTED</constant>&nbsp;</entr
>> y> +		  <entry>Average the light information coming from the entire scene
>> +giving priority to the center of the metered area.</entry>
>> +		</row>
>> +		<row>
>> +		  <entry><constant>V4L2_METERING_MODE_SPOT</constant>&nbsp;</entry>
>> +		  <entry>Measure only very small area at the cent-re of the
>> scene.</entry> +		</row>
>> +	      </tbody>
> 
> For the last two cases, would it also make sense to specify the center of the 
> weighted area and the spot location ?

Yes, that's quite basic requirement as well.. A means to determine the 
location would be also needed for some auto focus algorithms.
 
Additionally for V4L2_METERING_MODE_CENTER_WEIGHTED it's also needed to
specify the size of the area (width/height).

What do you think about defining new control for passing pixel position,
i.e. modifying struct v4l2_ext_control to something like:

struct v4l2_ext_control {
	__u32 id;
	__u32 size;
	__u32 reserved2[1];
	union {
		__s32 value;
		__s64 value64;
		struct v4l2_point position;
		char *string;
	};
} __attribute__ ((packed));

where:

struct v4l2_point {
	__s32 x;
	__s32 y;
};


or should we rather use ioctls for things like that ?


-- 
Regards,
Sylwester
