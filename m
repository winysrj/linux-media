Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54417 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab1LGLJM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 06:09:12 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LVT003D5YZA0440@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Dec 2011 11:09:10 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVT00KC9YZ9SX@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Dec 2011 11:09:09 +0000 (GMT)
Date: Wed, 07 Dec 2011 12:09:09 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC/PATCH 3/5] v4l: Add V4L2_CID_METERING_MODE camera control
In-reply-to: <4EDE425D.6020502@samsung.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, riverful.kim@samsung.com
Message-id: <4EDF4955.9060101@samsung.com>
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
 <1323011776-15967-4-git-send-email-snjw23@gmail.com>
 <201112061332.40168.laurent.pinchart@ideasonboard.com>
 <4EDE425D.6020502@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/2011 05:27 PM, Sylwester Nawrocki wrote:
>>> +		 
>>> <entry><constant>V4L2_METERING_MODE_CENTER_WEIGHTED</constant>&nbsp;</entr
>>> y> +		  <entry>Average the light information coming from the entire scene
>>> +giving priority to the center of the metered area.</entry>
>>> +		</row>
>>> +		<row>
>>> +		  <entry><constant>V4L2_METERING_MODE_SPOT</constant>&nbsp;</entry>
>>> +		  <entry>Measure only very small area at the cent-re of the
>>> scene.</entry> +		</row>
>>> +	      </tbody>
>>
>> For the last two cases, would it also make sense to specify the center of the 
>> weighted area and the spot location ?
> 
> Yes, that's quite basic requirement as well.. A means to determine the 
> location would be also needed for some auto focus algorithms.
>  
> Additionally for V4L2_METERING_MODE_CENTER_WEIGHTED it's also needed to
> specify the size of the area (width/height).
> 
> What do you think about defining new control for passing pixel position,
> i.e. modifying struct v4l2_ext_control to something like:
> 
> struct v4l2_ext_control {
> 	__u32 id;
> 	__u32 size;
> 	__u32 reserved2[1];
> 	union {
> 		__s32 value;
> 		__s64 value64;
> 		struct v4l2_point position;
> 		char *string;
> 	};
> } __attribute__ ((packed));
> 
> where:
> 
> struct v4l2_point {
> 	__s32 x;
> 	__s32 y;
> };

Hmm, that won't work since there is no way to handle the min/max/step for
more than one value. Probably the selection API could be used for specifying
the metering rectangle, or just separate controls for x, y, width, height.
Since we need to specify only locations for some controls and a rectangle for
others, probably separate controls would be more suitable.

-- 
Regards,
Sylwester
