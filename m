Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56071 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab2HWOdC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 10:33:02 -0400
Received: from eusync3.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9700F8UPS1YA40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 15:33:37 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M97003SPPQY2L80@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 15:32:59 +0100 (BST)
Message-id: <50363F19.5070607@samsung.com>
Date: Thu, 23 Aug 2012 16:32:57 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 1/4] V4L: Add V4L2_CID_FRAMESIZE image source class
 control
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
 <1345715489-30158-2-git-send-email-s.nawrocki@samsung.com>
 <20120823121349.GI721@valkosipuli.retiisi.org.uk>
In-reply-to: <20120823121349.GI721@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 08/23/2012 02:13 PM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> Thanks for the patch.

Thanks for your review.

> On Thu, Aug 23, 2012 at 11:51:26AM +0200, Sylwester Nawrocki wrote:
>> The V4L2_CID_FRAMESIZE control determines maximum number
>> of media bus samples transmitted within a single data frame.
>> It is useful for determining size of data buffer at the
>> receiver side.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  Documentation/DocBook/media/v4l/controls.xml | 12 ++++++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
>>  include/linux/videodev2.h                    |  1 +
>>  3 files changed, 15 insertions(+)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index 93b9c68..ad5d4e5 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -4184,6 +4184,18 @@ interface and may change in the future.</para>
>>  	    conversion.
>>  	    </entry>
>>  	  </row>
>> +	  <row>
>> +	    <entry spanname="id"><constant>V4L2_CID_FRAMESIZE</constant></entry>
>> +	    <entry>integer</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry spanname="descr">Maximum size of a data frame in media bus
>> +	      sample units. This control determines maximum number of samples
>> +	      transmitted per single compressed data frame. For generic raw
>> +	      pixel formats the value of this control is undefined. This is
>> +	      a read-only control.
>> +	    </entry>
>> +	  </row>
>>  	  <row><entry></entry></row>
>>  	</tbody>
>>        </tgroup>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index b6a2ee7..0043fd2 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -727,6 +727,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>>  	case V4L2_CID_VBLANK:			return "Vertical Blanking";
>>  	case V4L2_CID_HBLANK:			return "Horizontal Blanking";
>>  	case V4L2_CID_ANALOGUE_GAIN:		return "Analogue Gain";
>> +	case V4L2_CID_FRAMESIZE:		return "Maximum Frame Size";
> 
> I would put this to the image processing class, as the control isn't related
> to image capture. Jpeg encoding (or image compression in general) after all
> is related to image processing rather than capturing it.

All right, might make more sense that way. Let me move it to the image
processing class then. It probably also makes sense to name it
V4L2_CID_FRAME_SIZE, rather than V4L2_CID_FRAMESIZE.

>>  	/* Image processing controls */
>>  	case V4L2_CID_IMAGE_PROC_CLASS:		return "Image Processing Controls";
>> @@ -933,6 +934,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>>  	case V4L2_CID_FLASH_STROBE_STATUS:
>>  	case V4L2_CID_AUTO_FOCUS_STATUS:
>>  	case V4L2_CID_FLASH_READY:
>> +	case V4L2_CID_FRAMESIZE:
>>  		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
>>  		break;
>>  	}
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index 7a147c8..d3fd19f 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -1985,6 +1985,7 @@ enum v4l2_jpeg_chroma_subsampling {
>>  #define V4L2_CID_VBLANK				(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 1)
>>  #define V4L2_CID_HBLANK				(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 2)
>>  #define V4L2_CID_ANALOGUE_GAIN			(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 3)
>> +#define V4L2_CID_FRAMESIZE			(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 4)
>>  
>>  /* Image processing controls */
>>  #define V4L2_CID_IMAGE_PROC_CLASS_BASE		(V4L2_CTRL_CLASS_IMAGE_PROC | 0x900)

--

Regards,
Sylwester
