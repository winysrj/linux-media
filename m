Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1840 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaGUWSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 18:18:10 -0400
Message-ID: <53CD9197.1020307@xs4all.nl>
Date: Tue, 22 Jul 2014 00:17:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 03/23] v4l: Support extending the v4l2_pix_format structure
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1403567669-18539-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <53C83A49.7060501@xs4all.nl> <1941629.cBcif0Vq2p@avalon>
In-Reply-To: <1941629.cBcif0Vq2p@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/21/2014 10:56 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday 17 July 2014 23:04:09 Hans Verkuil wrote:
>> Hi Laurent,
>>
>> Something that just caught my eye:
>>
>> On 06/24/2014 01:54 AM, Laurent Pinchart wrote:
>>> The v4l2_pix_format structure has no reserved field. It is embedded in
>>> the v4l2_framebuffer structure which has no reserved fields either, and
>>> in the v4l2_format structure which has reserved fields that were not
>>> previously required to be zeroed out by applications.
>>>
>>> To allow extending v4l2_pix_format, inline it in the v4l2_framebuffer
>>> structure, and use the priv field as a magic value to indicate that the
>>> application has set all v4l2_pix_format extended fields and zeroed all
>>> reserved fields following the v4l2_pix_format field in the v4l2_format
>>> structure.
>>>
>>> The availability of this API extension is reported to userspace through
>>> the new V4L2_CAP_EXT_PIX_FORMAT capability flag. Just checking that the
>>> priv field is still set to the magic value at [GS]_FMT return wouldn't
>>> be enough, as older kernels don't zero the priv field on return.
>>>
>>> To simplify the internal API towards drivers zero the extended fields
>>> and set the priv field to the magic value for applications not aware of
>>> the extensions.
>>>
>>> Signed-off-by: Laurent Pinchart
>>> <laurent.pinchart+renesas@ideasonboard.com>
>>> ---
>>>
>>> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml
>>> b/Documentation/DocBook/media/v4l/pixfmt.xml index 91dcbc8..8c56cacd
>>> 100644
>>> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
>>> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> 
> [snip]
> 
>>> +<para>To use the extended fields, applications must set the
>>> +<structfield>priv</structfield> field to
>>> +<constant>V4L2_PIX_FMT_PRIV_MAGIC</constant>, initialize all the extended
>>> fields
>>> +and zero the unused bytes of the <structname>v4l2_format</structname>
>>> +<structfield>raw_data</structfield> field.</para>
>>
>> Easy to write, much harder to implement. You would end up with something
>> like:
>>
>> memset(&fmt.fmt.pix.flags + sizeof(fmt.fmt.pix.flags), 0,
>> 	sizeof(fmt.fmt.raw_data) - sizeof(fmt.fmt.pix));
>>
>> Not user-friendly and error-prone.
> 
> Or, rather, memset the whole v4l2_format structure to 0 and then fill it.
> 
>> I would suggest adding a reserved array to pix_format instead, of at least
>> size (10 + 2 * 7) / 4 = 6 __u32. So: __u32 reserved[6]. Better would be to
>> go with 10 + 17 = 27 elements (same as the number of reserved elements in
>> v4l2_pix_format_mplane and one struct v4l2_plane_pix_format).
> 
> Maybe it's a bit late, but I'm not sure to see where you got those values.

I'm making the assumption that anything we might want to add to pix_format, we
also want to add to pix_format_mplane. And the latter has 10 reserved bytes in
the pix_format_mplane struct and another 7 __u16's in each plane_pix_format.
So for a single plane format that means that there are 10 + 2 * 7 bytes reserved
space available in the multiplanar case (for the main struct + one plane struct).

We could add a __u8 reserved[24] to pix_format. Then the amount of reserved fields
in pix_format is identical to that in pix_format_mplane. That makes it easy to
keep in sync. The alignment looks to be OK too (no holes in the struct).
(BTW, when I wrote '10 + 17' in my earlier email I meant '10 + 14'. Sorry about
that confusion.)

But perhaps I am just over-analyzing and the real problem is the text in the spec
'initialize all the extended fields and zero the unused bytes of the v4l2_format
raw_data field.'. It might be better to add something along the lines of:

"It is good practice to either call VIDIOC_G_FMT first, and then modify any fields,
or to memset to 0 the whole v4l2_format structure before filling in fields."

> If we want to use a reserved array, it would make more sense to make it cover the 
> whole raw_data array, otherwise future extensions could require an API change. 
> On the other hand this would result in the v4l2_pix_format structure suddenly 
> consuming 200 bytes instead of 36 today. That wouldn't be good when allocated 
> on the stack.

I think the amount of available space in the multiplanar structs puts an upper
limit to what can be done with pix_format anyway. So reserving more space seems
unnecessary. It's not as if we'll see a huge number of new fields appearing.
I know of one flag that might be needed to signal alternate quantization ranges
to enhance the colorspace information, but that's all I know about.

Regards,

	Hans

> 
>> That will allow you to just say that the app should zero the reserved array.
> 

