Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:46211 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675AbbALNso (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 08:48:44 -0500
Message-ID: <54B3D0AE.500@xs4all.nl>
Date: Mon, 12 Jan 2015 14:48:30 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jean-Marc VOLLE <jean-marc.volle@st.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Divneil Rai WADHAWAN <divneil.wadhawan@st.com>
Subject: Re: Supporting 3D formats in V4L2
References: <AA2199356A71B94AB89255F7B8F9414202295BEF43@SAFEX1MAIL4.st.com>
In-Reply-To: <AA2199356A71B94AB89255F7B8F9414202295BEF43@SAFEX1MAIL4.st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Marc,

On 01/09/2015 05:38 PM, Jean-Marc VOLLE wrote:
> Hello Hans!
> Best wishes!

You too.

> 
> In reply to the below mail (sorry I do not know how to reply to mails I did not get but only found on the mail archive).
> I think (reading the HDMI spec 1.4b) that in fact any of the V4L2_FIELD_3D_FRAME_PACK, V4L2_FIELD_3D_SBS_HALF, V4L2_FIELD_3D_TAB
> may all be passed with interlaced or progressive content.
> 
> Figure 8-5 3D structure (Side-by-Side (Half) ) states: "For interlaced formats, Vactive is number of active lines per field"
> 
> p148 also lists primary 3D video format timings that show eg 1920 x 1080i @50Hz Side by Side
> 
> Since you proposed initially to pass all 3D information in the enum
> v4l2_field I think that at least SbS, TAB and FP shall be duplicated
> with TB or BT attributes or a dedicated 3D only enum would have to be
> created to reused interlaced/progressive information from enum
> v4l2_field. What is your view on this?
> Thanks for your comments.
> JM

A second field just for 3D information is not a good idea for two reasons:

1) The v4l2_buffer struct is very full, and adding another field there should
   only be done if there is no alternative.
2) I think it makes sense to extend v4l2_field: after all it describes how fields
   are stored in a buffer, and that fits very well with the 3D extension.

In practice the FIELD_INTERLACED, FIELD_SEQ_TB/BT and FIELD_INTERLACED_TB/BT values
will never be used with 3D formats. Those field values are specific to SDTV.

For the new 3D field values you need to add two sets: one for progressive 3D (the
equivalent to FIELD_NONE for normal 2D) and one for interlaced 3D (the equivalent
to FIELD_ALTERNATE for normal 2D).

Regards,

	Hans

>  
> 
> 
> 
> 
> 
> Hi Soby!
> 
> On Thu 19 July 2012 14:18:13 Soby Mathew wrote:
>> Hi everyone,
>>     Currently there is limitation in v4l2 for specifying the 3D
>> formats . In HDMI 1.4 standard, the following 3D formats are
>> specified:
> 
> 
> I think that this is ideal for adding to enum v4l2_field.
> I've made some proposals below:
> 
>>
>>       1. FRAME_PACK,
> 
> V4L2_FIELD_3D_FRAME_PACK        (progressive)
> V4L2_FIELD_3D_FRAME_PACK_TB     (interlaced, odd == top comes first)
> 
>>       2. FIELD_ALTERNATIVE,
> 
> V4L2_FIELD_3D_FIELD_ALTERNATIVE
> 
>>       3. LINE_ALTERNATIVE,
> 
> V4L2_FIELD_3D_LINE_ALTERNATIVE
> 
>>       4. SIDE BY SIDE FULL,
> 
> V4L2_FIELD_3D_SBS_FULL
> 
>>       5. SIDE BY SIDE HALF,
> 
> V4L2_FIELD_3D_SBS_HALF
> 
>>       6. LEFT + DEPTH,
> 
> V4L2_FIELD_3D_L_DEPTH
> 
>>       7. LEFT + DEPTH + GRAPHICS + GRAPHICS-DEPTH,
> 
> V4L2_FIELD_3D_L_DEPTH_GFX_DEPTH
> 
>>       8. TOP AND BOTTOM
> 
> V4L2_FIELD_3D_TAB
> 
> You would also need defines that describe which field is received for the field
> alternative mode (it's put in struct v4l2_buffer):
> 
> V4L2_FIELD_3D_LEFT_TOP
> V4L2_FIELD_3D_LEFT_BOTTOM
> V4L2_FIELD_3D_RIGHT_TOP
> V4L2_FIELD_3D_RIGHT_BOTTOM
> 
>>
>>
>> In addition for some of the formats like Side-by-side-half there are
>> some additional metadata (like type of horizontal sub-sampling)
> 
> A control seems to be the most appropriate method of exposing the
> horizontal subsampling.
> 
>> and
>> parallax information which may be required for programming the display
>> processing pipeline properly.
> 
> This would be a new ioctl, but I think this should only be implemented if
> someone can actually test it with real hardware. The same is true for the
> more exotic 3D formats above.
> 
> It seems SBS is by far the most common format.
> 
>>
>> I am not very sure on how to expose this to the userspace. This is an
>> inherent property of video signal  , hence it would be appropriate to
>> have an additional field in v4l_format to specify 3D format. Currently
>> this is a requirement for HDMI 1.4 Rx / Tx but in the future it would
>> be applicable to broadcast sources also.
>>
>> In our implementation we have temporarily defined a Private Control to
>> expose this .
>>
>> Please let me know of your suggestions .
> 
> I hope this helps!
> 
> Regards,
> 
>         Hans
> 
> 
> 

