Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:46902 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZJOOKT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 10:10:19 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Jun Nie <niej0001@gmail.com>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Date: Thu, 15 Oct 2009 09:09:41 -0500
Subject: RE: Support on discontinuous planer buffer and stride
Message-ID: <A69FA2915331DC488A831521EAE36FE4015555EFD7@dlee06.ent.ti.com>
References: <7c34ac520909222330k73380177sbf103345f5d3d7ec@mail.gmail.com>
 <7c34ac520910082207i2beacffbhd89a38244370cf39@mail.gmail.com>
 <200910090817.20736.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE4015555EFBC@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4015555EFBC@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Forgot to mention that this may need a new memory type as well.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Karicheri, Muralidharan
>Sent: Thursday, October 15, 2009 10:00 AM
>To: Hans Verkuil; Jun Nie
>Cc: g.liakhovetski@gmx.de; linux-media
>Subject: RE: Support on discontinuous planer buffer and stride
>
>Hans,
>
>>
>>Well, it is definitely not possible to do it in this manner since changing
>>the size of struct v4l2_buffer will break the API. Furthermore, something
>>like
>>this will only work if the DMA engine can handle strides. Is that the case
>>for your hardware? I don't think you mentioned what the hardware is you
>use.
>>
>In fact I was planning to write an RFC for this as well. DM365 Resizer
>allows setting separate buffer address for Y and C plane (For _NV12 pixel
>format) as well as line offsets. Similarly on the display side, VPBE
>provides separate registers for configuring this. Currently we have
>proprietary IOCTL to configure the C-Plane buffer address and is not the
>right way to do it. For planar pixel format like NV12, NV16 etc, where the
>hardware is capable of configuring different address for individual plane,
>current v4l2 API has limitations. So I suggest that Jun Nie work on a RFC
>&implementation that allows application to set buffer addresses for
>individual planes of planar pixel formats. Something like below for userptr
>case (I feel only userptr case to be supported in this case)...
>
>+ struct v4l2_userptr_planar {
>+	/* Number of planes in the pixel format. 2 or 3,
>+	 * 2 - for Y & CbCr, 3 for Y, Cb, & Cr
>+	 */
>+	__u32	num_planes;
>+	/* Y or R */
>+	unsigned long   userptr_yr;
>+	/* Cb or G */
>+	unsigned long   userptr_cbg;
>+	/* Cr or B */
>+	unsigned long   userptr_crb;
>+ };
>
>struct v4l2_buffer {
>	__u32			index;
>	enum v4l2_buf_type      type;
>	__u32			bytesused;
>	__u32			flags;
>	enum v4l2_field		field;
>	struct timeval		timestamp;
>	struct v4l2_timecode	timecode;
>	__u32			sequence;
>
>	/* memory location */
>	enum v4l2_memory        memory;
>	union {
>		__u32           offset;
>		unsigned long   userptr;
>+		struct v4l2_userptr_planar userptr_p;
>	} m;
>	__u32			length;
>	__u32			input;
>	__u32			reserved;
>};
>
>-Murali
>>Regards,
>>
>>	Hans
>>
>>--
>>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>>¢éì¹»®&Þ~º&¶¬–+-±éÝ¶¥Šw®žË›±ÊâmébžìfyØšŠ{ayºÊ‡Ú™ë,j
>­¢f£¢·hš‹àz¹®w¥¢¸
>>
>>¢·¦j:+v‰¨ŠwèjØm¶Ÿÿ¾
>«‘êçzZ+ƒùšŽŠÝ¢j"ú!¶i
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

