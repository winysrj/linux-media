Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1078 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaCGOba (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 09:31:30 -0500
Message-ID: <5319D835.4050004@xs4all.nl>
Date: Fri, 07 Mar 2014 15:31:17 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>
CC: linux-media@vger.kernel.org, marbugge@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv1 PATCH 5/5] DocBook v4l2: update the G/S_EDID documentation
References: <1394187679-7345-1-git-send-email-hverkuil@xs4all.nl> <1636382.IFSev3egjD@avalon> <5319D55B.6080202@cisco.com> <2043205.LIW4DDJa2A@avalon>
In-Reply-To: <2043205.LIW4DDJa2A@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for reviewing this series so quickly. I've added your nitpick to my
tree and I plan to post the pull request on Monday.

Regards,

	Hans

On 03/07/2014 03:25 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 07 March 2014 15:19:07 Hans Verkuil wrote:
>> On 03/07/2014 03:09 PM, Laurent Pinchart wrote:
>>> Hi Hans,
>>>
>>> Thank you for the patch.
>>>
>>> On Friday 07 March 2014 11:21:19 Hans Verkuil wrote:
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> Document that it is now possible to call G/S_EDID from video nodes, not
>>>> just sub-device nodes. Add a note that -EINVAL will be returned if
>>>> the pad does not support EDIDs.
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>
>>>>  Documentation/DocBook/media/v4l/v4l2.xml           |   2 +-
>>>>  .../DocBook/media/v4l/vidioc-subdev-g-edid.xml     | 152
>>>>  ------------------
>>>>  2 files changed, 1 insertion(+), 153 deletions(-)
>>>>  delete mode 100644
>>>>  Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
>>>
>>> The patch just removes the EDID ioctls documentation, I highly doubt that
>>> this is what you intended :-)
>>
>> Let's try again:
> 
> Much better :-)
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> with a minor nitpicking comment below.
> 
>> Document that it is now possible to call G/S_EDID from video nodes, not
>> just sub-device nodes. Add a note that -EINVAL will be returned if
>> the pad does not support EDIDs.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  Documentation/DocBook/media/v4l/v4l2.xml           |  2 +-
>>  ...{vidioc-subdev-g-edid.xml => vidioc-g-edid.xml} | 36 +++++++++++--------
>>  2 files changed, 24 insertions(+), 14 deletions(-)
>>  rename Documentation/DocBook/media/v4l/{vidioc-subdev-g-edid.xml =>
>>  vidioc-g-edid.xml} (77%)
> 
> [snip]
> 
>> diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
>> b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml similarity index 77%
>> rename from Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
>> rename to Documentation/DocBook/media/v4l/vidioc-g-edid.xml
>> index bbd18f0..becd7cb 100644
>> --- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
>> +++ b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
> 
> [snip]
> 
>> @@ -56,12 +56,20 @@
>>
>>    <refsect1>
>>      <title>Description</title>
>> -    <para>These ioctls can be used to get or set an EDID associated with an
>> input pad
>> -    from a receiver or an output pad of a transmitter subdevice.</para>
>> +    <para>These ioctls can be used to get or set an EDID associated with an
>> input
>> +    from a receiver or an output of a transmitter device. These ioctls can
> 
> I would s/These ioctls/They/ here to avoid repeating "These ioctls" at the 
> beginning of the two sentences.
> 
>> be
>> +    used with subdevice nodes (/dev/v4l-subdevX) or with video nodes
>> (/dev/videoX).</para>
>> +
> 

