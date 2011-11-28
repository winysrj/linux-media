Return-path: <linux-media-owner@vger.kernel.org>
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:35206
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223Ab1K1St7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 13:49:59 -0500
Message-ID: <4ED3D77C.2020109@studio.unibo.it>
Date: Mon, 28 Nov 2011 19:48:28 +0100
From: Luca Risolia <luca.risolia@studio.unibo.it>
Reply-To: <luca.risolia@studio.unibo.it>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC] JPEG encoders control class
References: <4EBECD11.8090709@gmail.com> <201111281320.30522.hverkuil@xs4all.nl>
In-Reply-To: <201111281320.30522.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hans Verkuil ha scritto:
> On Saturday 12 November 2011 20:46:25 Sylwester Nawrocki wrote:
>> Hi all,
>>
>> This RFC is discussing the current support of JPEG encoders in V4L2 and
>> a proposal of new JPEG control class.
>>
>>
>> Motivation
>> ==========
>>
>> JPEG encoder control is also required at the sub-device level, but
>> currently there are only defined ioctls in regular V4L2 device API. It
>> doesn't seem to make sense for these current ioctls to be inherited by
>> sub-device nodes, since they're not generic enough, incomplete and rather
>> not compliant with JFIF JPEG standard [2], [3].
>>
>>
>> Current implementation
>> ======================
>>
>> Currently two ioctls are available [4]:
>>
>> #define VIDIOC_G_JPEGCOMP	 _IOR('V', 61, struct v4l2_jpegcompression)
>> #define VIDIOC_S_JPEGCOMP	 _IOW('V', 62, struct v4l2_jpegcompression)
>>
>> And the corresponding data structure is defined as:
>>
>> struct v4l2_jpegcompression {
>> 	int quality;
>>
>> 	int  APPn;              /* Number of APP segment to be written,
>> 				 * must be 0..15 */
>> 	int  APP_len;           /* Length of data in JPEG APPn segment */
>> 	char APP_data[60];      /* Data in the JPEG APPn segment. */
>>
>> 	int  COM_len;           /* Length of data in JPEG COM segment */
>> 	char COM_data[60];      /* Data in JPEG COM segment */
>>
>> 	__u32 jpeg_markers;     /* Which markers should go into the JPEG
>> 				 * output. Unless you exactly know what
>> 				 * you do, leave them untouched.
>> 				 * Inluding less markers will make the
>> 				 * resulting code smaller, but there will
>> 				 * be fewer applications which can read it.
>> 				 * The presence of the APP and COM marker
>> 				 * is influenced by APP_len and COM_len
>> 				 * ONLY, not by this property! */
>>
>> #define V4L2_JPEG_MARKER_DHT (1<<3)    /* Define Huffman Tables */
>> #define V4L2_JPEG_MARKER_DQT (1<<4)    /* Define Quantization Tables */
>> #define V4L2_JPEG_MARKER_DRI (1<<5)    /* Define Restart Interval */
>> #define V4L2_JPEG_MARKER_COM (1<<6)    /* Comment segment */
>> #define V4L2_JPEG_MARKER_APP (1<<7)    /* App segment, driver will
>> 					* allways use APP0 */
>> };
>>
>>
>> What are the issues with such an implementation ?
>>
>> These ioctls don't allow to re-program the quantization and Huffman tables
>> (DQT, DHT). Additionally, the standard valid segment length for the
>> application defined APPn and the comment COM segment is 2...65535, while
>> currently this is limited to 60 bytes.
>>
>> Therefore APP_data and COM_data, rather than fixed size arrays, should be
>> pointers to a variable length buffer.
>>
>> Only two drivers upstream really use VIDIOC_[S/G]_JPEGCOMP ioctls for
>> anything more than compression quality query/control. It might make sense
>> to create separate control for image quality and to obsolete the
>> v4l2_jpegcompressin::quality field.
>>
>> Below is a brief review of usage of VIDIOC_[S/G]_JPEGCOMP ioctls in current
>> mainline drivers. Listed are parts of struct v4l2_jpegcompression used in
>> each case.
>>
>>
>> cpia2
>> -----
>>
>> vidioc_g_jpegcomp, vidioc_s_jpegcomp
>> - compression quality ignored, returns fixed value (80)
>> - uses APP_data/len, COM_data/len
>> - markers (only DHT can be disabled by the applications)
>>
>>
>> zoran
>> -----
>>
>> vidioc_g_jpegcomp, vidioc_s_jpegcomp
>> - compression quality, values 5...100, used only to calculate buffer size
>> - APP_data/len, COM_data/len
>> - markers field used to control inclusion of selected JPEG markers
>>   in the output buffer
>>
>>
>> et61x251, sn9c102, s2255drv.c
>> -----------------------------
> 
> Note that et61x251 and sn9c102 are going to be deprecated and removed at some
> time in the future (gspca will support these devices).

Has this been discussed yet? Also, last time I tried the gspca driver 
with a number of V4L2-compliant applications, it did not support at all 
or work well for all the sn9c1xx-based devices I have here, which are 
both controllers and sensors the manufacturer sent to me when developing 
the driver with their collaboration. I also don't understand why the 
gspca driver has been accepted in the mainline kernel in the first 
place, despite the fact the sn9c1xx has been present in the kernel since 
long time and already supported many devices at the time the gspca was 
submitted. Maybe it's better to remove the duplicate code form the gspca 
driver and add the different parts (if any) to the sn9c1xx.

Regards
Luca

