Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48398 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1IUM22 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 08:28:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRV000Q0HBESD30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 13:28:26 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRV00IAJHBE2P@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 13:28:26 +0100 (BST)
Date: Wed, 21 Sep 2011 14:28:25 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v1 2/3] v4l: Add AUTO option for the
 V4L2_CID_POWER_LINE_FREQUENCY control
In-reply-to: <20110920221730.GP1845@valkosipuli.localdomain>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <4E79D869.80708@samsung.com>
References: <1316519939-22540-1-git-send-email-s.nawrocki@samsung.com>
 <1316519939-22540-3-git-send-email-s.nawrocki@samsung.com>
 <20110920205730.GN1845@valkosipuli.localdomain> <4E7904CB.3000006@gmail.com>
 <20110920221730.GP1845@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 09/21/2011 12:17 AM, Sakari Ailus wrote:
> On Tue, Sep 20, 2011 at 11:25:31PM +0200, Sylwester Nawrocki wrote:
>> On 09/20/2011 10:57 PM, Sakari Ailus wrote:
>>> On Tue, Sep 20, 2011 at 01:58:58PM +0200, Sylwester Nawrocki wrote:
>>>> V4L2_CID_POWER_LINE_FREQUENCY control allows applications to instruct
>>>> a driver what is the power line frequency so an appropriate filter
>>>> can be used by the device to cancel flicker by compensating the light
>>>> intensity ripple and thus. Currently in the menu we have entries for
>>>> 50 and 60 Hz and for entirely disabling the anti-flicker filter.
>>>> However some devices are capable of automatically detecting the
>>>> frequency, so add V4L2_CID_POWER_LINE_FREQUENCY_AUTO entry for them.
>>>>
>>>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>> Acked-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
>>>> ---
>>>>   Documentation/DocBook/media/v4l/controls.xml |    5 +++--
>>>>   drivers/media/video/v4l2-ctrls.c             |    1 +
>>>>   include/linux/videodev2.h                    |    1 +
>>>>   3 files changed, 5 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>>>> index 2420e4a..c6b3c46 100644
>>>> --- a/Documentation/DocBook/media/v4l/controls.xml
>>>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>>>> @@ -232,8 +232,9 @@ control is deprecated. New drivers and applications should use the
>>>>   	<entry>Enables a power line frequency filter to avoid
>>>>   flicker. Possible values for<constant>enum v4l2_power_line_frequency</constant>  are:
>>>>   <constant>V4L2_CID_POWER_LINE_FREQUENCY_DISABLED</constant>  (0),
>>>> -<constant>V4L2_CID_POWER_LINE_FREQUENCY_50HZ</constant>  (1) and
>>>> -<constant>V4L2_CID_POWER_LINE_FREQUENCY_60HZ</constant>  (2).</entry>
>>>> +<constant>V4L2_CID_POWER_LINE_FREQUENCY_50HZ</constant>  (1),
>>>> +<constant>V4L2_CID_POWER_LINE_FREQUENCY_60HZ</constant>  (2) and
>>>> +<constant>V4L2_CID_POWER_LINE_FREQUENCY_AUTO</constant>  (3).</entry>
>>>
>>> A stupid question: wouldn't this be a case for a new control for automatic
>>> power line frequency, in other words enabling or disabling it?
>>
>> IMO this would complicate things in kernel and user land, without any reasonable
>> positive effects. AUTO seems to fit well here, it's just another mode of operation
>> of a power line noise filter. Why make things more complicated than they need to be ? 
> 
> The advantage would be to be able to get the power line frquency if that's
> supported by the hardware. This implementation excludes that. Such
> information might be interesting to add e.g. to the image's exif data.

AFAIU, the power line frequency filter just modifies frame exposure time to be
multiple of half of the mains frequency period. So it's the exposure time that gets
finally affected. Maybe there is some hardware that supports retrieving of the detected
frequency, however I'm not aware of it. And it doesn't seem useful unless you want
to use camera as some non-standard measurement tool. It also takes some time until
the detection algorithm locks, during this time an undefined frequency value would
be read. 

I believe the filter settings do not really apply to still capture as it involves
periodic operation, like preview. Even if we had this as meta data tag, there are
more direct raw image parameters than the PL noise filter frequency.

I feel uncomfortable with having 2 controls, where one can disable the filter and
the other enable it with AUTO setting. 
Let's say the sensor supports 4 distinct settings of the filter: OFF, 50HZ, 60HZ, AUTO.
(there is already one sensor driver in mainline that support it - ov519).
How do we map this onto 2 controls ?

What do we return from the menu control that covers { OFF, 50HZ, 60HZ } when AUTO
mode is enabled through the other control and H/W doesn't allow to read the detected
frequency ?

I think, for the 2 controls we would need the DISABLED entry not to belong to
V4L2_CID_POWER_LINE_FREQUENCY at first place.

> 
> Not sure if that's important, though.

I would say no, but someone can prove me wrong. And who knows what kind of strange
H/W future brings.


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
