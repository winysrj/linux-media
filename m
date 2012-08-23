Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34540 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932225Ab2HWSYQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 14:24:16 -0400
Message-ID: <5036754C.4040501@iki.fi>
Date: Thu, 23 Aug 2012 21:24:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 1/4] V4L: Add V4L2_CID_FRAMESIZE image source class
 control
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com> <1345715489-30158-2-git-send-email-s.nawrocki@samsung.com> <20120823121349.GI721@valkosipuli.retiisi.org.uk> <50363F19.5070607@samsung.com>
In-Reply-To: <50363F19.5070607@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> On 08/23/2012 02:13 PM, Sakari Ailus wrote:
>> Hi Sylwester,
>>
>> Thanks for the patch.
>
> Thanks for your review.
>
>> On Thu, Aug 23, 2012 at 11:51:26AM +0200, Sylwester Nawrocki wrote:
>>> The V4L2_CID_FRAMESIZE control determines maximum number
>>> of media bus samples transmitted within a single data frame.
>>> It is useful for determining size of data buffer at the
>>> receiver side.
>>>
>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>   Documentation/DocBook/media/v4l/controls.xml | 12 ++++++++++++
>>>   drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
>>>   include/linux/videodev2.h                    |  1 +
>>>   3 files changed, 15 insertions(+)
>>>
>>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>>> index 93b9c68..ad5d4e5 100644
>>> --- a/Documentation/DocBook/media/v4l/controls.xml
>>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>>> @@ -4184,6 +4184,18 @@ interface and may change in the future.</para>
>>>   	    conversion.
>>>   	    </entry>
>>>   	  </row>
>>> +	  <row>
>>> +	    <entry spanname="id"><constant>V4L2_CID_FRAMESIZE</constant></entry>
>>> +	    <entry>integer</entry>
>>> +	  </row>
>>> +	  <row>
>>> +	    <entry spanname="descr">Maximum size of a data frame in media bus
>>> +	      sample units. This control determines maximum number of samples
>>> +	      transmitted per single compressed data frame. For generic raw
>>> +	      pixel formats the value of this control is undefined. This is
>>> +	      a read-only control.
>>> +	    </entry>
>>> +	  </row>
>>>   	  <row><entry></entry></row>
>>>   	</tbody>
>>>         </tgroup>
>>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>>> index b6a2ee7..0043fd2 100644
>>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>>> @@ -727,6 +727,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>>>   	case V4L2_CID_VBLANK:			return "Vertical Blanking";
>>>   	case V4L2_CID_HBLANK:			return "Horizontal Blanking";
>>>   	case V4L2_CID_ANALOGUE_GAIN:		return "Analogue Gain";
>>> +	case V4L2_CID_FRAMESIZE:		return "Maximum Frame Size";
>>
>> I would put this to the image processing class, as the control isn't related
>> to image capture. Jpeg encoding (or image compression in general) after all
>> is related to image processing rather than capturing it.
>
> All right, might make more sense that way. Let me move it to the image
> processing class then. It probably also makes sense to name it
> V4L2_CID_FRAME_SIZE, rather than V4L2_CID_FRAMESIZE.

Hmm. While we're at it, as the size is maximum --- it can be lower --- 
how about V4L2_CID_MAX_FRAME_SIZE or V4L2_CID_MAX_FRAME_SAMPLES, as the 
unit is samples?

Does sample in this context mean pixels for uncompressed formats and 
bytes (octets) for compressed formats? It's important to define it as 
we're also using the term "sample" to refer to data units transferred 
over a parallel bus per a clock cycle.

On serial busses the former meaning is more obvious.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
