Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56370 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1LJOO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 09:14:56 -0500
Received: by eekc4 with SMTP id c4so824244eek.19
        for <linux-media@vger.kernel.org>; Sat, 10 Dec 2011 06:14:55 -0800 (PST)
Message-ID: <4EE3695B.1010800@gmail.com>
Date: Sat, 10 Dec 2011 15:14:51 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	hverkuil@xs4all.nl, riverful.kim@samsung.com
Subject: Re: [RFC/PATCH 3/5] v4l: Add V4L2_CID_METERING_MODE camera control
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com> <1323011776-15967-4-git-send-email-snjw23@gmail.com> <201112061332.40168.laurent.pinchart@ideasonboard.com> <4EDE425D.6020502@samsung.com> <4EDF4955.9060101@samsung.com> <20111210104405.GG1967@valkosipuli.localdomain>
In-Reply-To: <20111210104405.GG1967@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 12/10/2011 11:44 AM, Sakari Ailus wrote:
> On Wed, Dec 07, 2011 at 12:09:09PM +0100, Sylwester Nawrocki wrote:
>> On 12/06/2011 05:27 PM, Sylwester Nawrocki wrote:
>>>>> +		 
>>>>> <entry><constant>V4L2_METERING_MODE_CENTER_WEIGHTED</constant>&nbsp;</entr
>>>>> y> +		  <entry>Average the light information coming from the entire scene
>>>>> +giving priority to the center of the metered area.</entry>
>>>>> +		</row>
>>>>> +		<row>
>>>>> +		  <entry><constant>V4L2_METERING_MODE_SPOT</constant>&nbsp;</entry>
>>>>> +		  <entry>Measure only very small area at the cent-re of the
>>>>> scene.</entry> +		</row>
>>>>> +	      </tbody>
>>>>
>>>> For the last two cases, would it also make sense to specify the center of the 
>>>> weighted area and the spot location ?
>>>
>>> Yes, that's quite basic requirement as well.. A means to determine the 
>>> location would be also needed for some auto focus algorithms.
>>>  
>>> Additionally for V4L2_METERING_MODE_CENTER_WEIGHTED it's also needed to
>>> specify the size of the area (width/height).
>>>
>>> What do you think about defining new control for passing pixel position,
>>> i.e. modifying struct v4l2_ext_control to something like:
>>>
>>> struct v4l2_ext_control {
>>> 	__u32 id;
>>> 	__u32 size;
>>> 	__u32 reserved2[1];
>>> 	union {
>>> 		__s32 value;
>>> 		__s64 value64;
>>> 		struct v4l2_point position;
>>> 		char *string;
>>> 	};
>>> } __attribute__ ((packed));
>>>
>>> where:
>>>
>>> struct v4l2_point {
>>> 	__s32 x;
>>> 	__s32 y;
>>> };
>>
>> Hmm, that won't work since there is no way to handle the min/max/step for
>> more than one value. Probably the selection API could be used for specifying
>> the metering rectangle, or just separate controls for x, y, width, height.
>> Since we need to specify only locations for some controls and a rectangle for
>> others, probably separate controls would be more suitable.
> 
> I prefer the use of the selection API over controls. Also consider you may
> have multiple areas for metering. Also the areas may well be different for
> focus, white balance and exxposure --- they often actually are.

Yes, AFAIR Laurent expressed similar opinion on that [1].

I talked to Tomasz and Marek about configuring of the metering areas and we came
to conclusion that we could designate a group of targets for exposure, auto-focus,
etc. Define a base and target pool size so it is possible to define multiple
rectangles. And single point (pixel) would be described by struct v4l2_rect with
width=1, height=1.
Then we would probably need to be able to enumerate the targets somehow.

[1] http://www.spinics.net/lists/linux-media/msg41215.html

-- 
Thanks,
Sylwester
