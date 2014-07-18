Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2799 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbaGRNVh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 09:21:37 -0400
Message-ID: <53C91F58.2030000@xs4all.nl>
Date: Fri, 18 Jul 2014 15:21:28 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 01/23] v4l: Add ARGB and XRGB pixel formats
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1403567669-18539-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <53C845F0.2010409@xs4all.nl> <3481435.vQMt1BxCmT@avalon> <53C91DD2.7020107@xs4all.nl>
In-Reply-To: <53C91DD2.7020107@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/2014 03:14 PM, Hans Verkuil wrote:
> On 07/18/2014 02:31 PM, Laurent Pinchart wrote:
>> Hi Hans,
>>
>> On Thursday 17 July 2014 23:53:52 Hans Verkuil wrote:
>>> Hi Laurent,
>>>
>>> While implementing support for this in v4l-utils I discovered you missed
>>> one:
>>>
>>> On 06/24/2014 01:54 AM, Laurent Pinchart wrote:
>>>> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>
>>>> The existing RGB pixel formats are ill-defined in respect to their alpha
>>>> bits and their meaning is driver dependent. Create new standard ARGB and
>>>> XRGB variants with clearly defined meanings and make the existing
>>>> variants deprecated.
>>>>
>>>> The new pixel formats 4CC values have been selected to match the DRM
>>>> 4CCs for the same in-memory formats.
>>>>
>>>> Signed-off-by: Laurent Pinchart
>>>> <laurent.pinchart+renesas@ideasonboard.com>
>>>> ---
>>>>
>>>>  .../DocBook/media/v4l/pixfmt-packed-rgb.xml        | 415 +++++++++++++++-
>>>>  include/uapi/linux/videodev2.h                     |   8 +
>>>>  2 files changed, 403 insertions(+), 20 deletions(-)
>>>>
>>>> diff --git a/include/uapi/linux/videodev2.h
>>>> b/include/uapi/linux/videodev2.h index 168ff50..0125f4d 100644
>>>> --- a/include/uapi/linux/videodev2.h
>>>> +++ b/include/uapi/linux/videodev2.h
>>>> @@ -294,7 +294,11 @@ struct v4l2_pix_format {
>>>>
>>>>  /* RGB formats */
>>>>  #define V4L2_PIX_FMT_RGB332  v4l2_fourcc('R', 'G', 'B', '1') /*  8 
>>>>  RGB-3-3-2     */ #define V4L2_PIX_FMT_RGB444  v4l2_fourcc('R', '4', '4',
>>>>  '4') /* 16  xxxxrrrr ggggbbbb */> 
>>>> +#define V4L2_PIX_FMT_ARGB444 v4l2_fourcc('A', 'R', '1', '2') /* 16 
>>>> aaaarrrr ggggbbbb */ +#define V4L2_PIX_FMT_XRGB444 v4l2_fourcc('X', 'R',
>>>> '1', '2') /* 16  xxxxrrrr ggggbbbb */> 
>>>>  #define V4L2_PIX_FMT_RGB555  v4l2_fourcc('R', 'G', 'B', 'O') /* 16 
>>>>  RGB-5-5-5     */> 
>>>> +#define V4L2_PIX_FMT_ARGB555 v4l2_fourcc('A', 'R', '1', '5') /* 16 
>>>> ARGB-1-5-5-5  */ +#define V4L2_PIX_FMT_XRGB555 v4l2_fourcc('X', 'R', '1',
>>>> '5') /* 16  XRGB-1-5-5-5  */> 
>>>>  #define V4L2_PIX_FMT_RGB565  v4l2_fourcc('R', 'G', 'B', 'P') /* 16 
>>>>  RGB-5-6-5     */ #define V4L2_PIX_FMT_RGB555X v4l2_fourcc('R', 'G', 'B',
>>>>  'Q') /* 16  RGB-5-5-5 BE  */
>>>
>>> A+X variants should also be added for this RGB555X pix format.
>>
>> Agreed. The reason I've left it out is that I don't use it in my driver, and 
>> we have this policy of only adding FOURCCs for formats actively in use. Would 
>> you still like me to add it ?
> 
> Yes please, let's not leave the odd one out. It's supported by vivi for
> example, and qv4l2 supports it as well.

I see there is a BGR666 as well. But I suspect that is better defined and is
almost certainly without an alpha channel. The spec should be updated to
reflect that (by using '-' to signify that that bit is unused).

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
>>
>>>>  #define V4L2_PIX_FMT_RGB565X v4l2_fourcc('R', 'G', 'B', 'R') /* 16 
>>>>  RGB-5-6-5 BE  */> 
>>>> @@ -302,7 +306,11 @@ struct v4l2_pix_format {
>>>>
>>>>  #define V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24 
>>>>  BGR-8-8-8     */ #define V4L2_PIX_FMT_RGB24   v4l2_fourcc('R', 'G', 'B',
>>>>  '3') /* 24  RGB-8-8-8     */ #define V4L2_PIX_FMT_BGR32  
>>>>  v4l2_fourcc('B', 'G', 'R', '4') /* 32  BGR-8-8-8-8   */> 
>>>> +#define V4L2_PIX_FMT_ABGR32  v4l2_fourcc('A', 'R', '2', '4') /* 32 
>>>> BGRA-8-8-8-8  */ +#define V4L2_PIX_FMT_XBGR32  v4l2_fourcc('X', 'R', '2',
>>>> '4') /* 32  BGRX-8-8-8-8  */> 
>>>>  #define V4L2_PIX_FMT_RGB32   v4l2_fourcc('R', 'G', 'B', '4') /* 32 
>>>>  RGB-8-8-8-8   */> 
>>>> +#define V4L2_PIX_FMT_ARGB32  v4l2_fourcc('B', 'A', '2', '4') /* 32 
>>>> ARGB-8-8-8-8  */ +#define V4L2_PIX_FMT_XRGB32  v4l2_fourcc('B', 'X', '2',
>>>> '4') /* 32  XRGB-8-8-8-8  */> 
>>>>  /* Grey formats */
>>>>  #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8 
>>>>  Greyscale     */
>>
> 

