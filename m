Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51153 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314Ab3KKNkQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 08:40:16 -0500
Message-ID: <5280DE3D.5040408@iki.fi>
Date: Mon, 11 Nov 2013 15:40:13 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RFC] libv4lconvert: SDR conversion from U8 to FLOAT
References: <1384103776-4788-1-git-send-email-crope@iki.fi> <5280D83C.5060809@xs4all.nl>
In-Reply-To: <5280D83C.5060809@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.11.2013 15:14, Hans Verkuil wrote:
> On 11/10/2013 06:16 PM, Antti Palosaari wrote:
>> Convert unsigned 8 to float 32 [-1 to +1], which is commonly
>> used format for baseband signals.
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   contrib/freebsd/include/linux/videodev2.h |  4 ++++
>>   include/linux/videodev2.h                 |  4 ++++
>>   lib/libv4lconvert/libv4lconvert.c         | 29 ++++++++++++++++++++++++++++-
>>   3 files changed, 36 insertions(+), 1 deletion(-)
>>
>> diff --git a/contrib/freebsd/include/linux/videodev2.h b/contrib/freebsd/include/linux/videodev2.h
>> index 1fcfaeb..8829400 100644
>> --- a/contrib/freebsd/include/linux/videodev2.h
>> +++ b/contrib/freebsd/include/linux/videodev2.h
>> @@ -465,6 +465,10 @@ struct v4l2_pix_format {
>>   #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
>>   #define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5', 'C', 'I') /* S5C73M3 interleaved UYVY/JPEG */
>>
>> +/* SDR */
>> +#define V4L2_PIX_FMT_FLOAT    v4l2_fourcc('D', 'F', '3', '2') /* float 32-bit */
>> +#define V4L2_PIX_FMT_U8       v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
>> +
>>   /*
>>    *	F O R M A T   E N U M E R A T I O N
>>    */
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index 437f1b0..14299a6 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -431,6 +431,10 @@ struct v4l2_pix_format {
>>   #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
>>   #define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5', 'C', 'I') /* S5C73M3 interleaved UYVY/JPEG */
>>
>> +/* SDR */
>> +#define V4L2_PIX_FMT_FLOAT    v4l2_fourcc('D', 'F', '3', '2') /* float 32-bit */
>> +#define V4L2_PIX_FMT_U8       v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
>
> I would prefer V4L2_PIX_FMT_SDR_FLOAT and _FMT_SDR_U8.
>
> That way it is clear that this format refers to - and should be interpreted as - an SDR format.
>
> Otherwise it looks fine to me (but it needs to be documented as well, of course).

Thanks for the comments!

What do you think is it OK to abuse/reuse pixelformat for radio signals? 
Basically the only one field needed is just that, whilst those image 
only fields (width/height) are not needed at all. Good point to reuse 
existing things as much as possible is that it does not bloat Kernel 
data structures etc.

I am also going to make some tests to find out if actual float 
conversion is faster against pre-calculated LUT, in Kernel or in 
libv4lconvert and so. Worst scenario I have currently is Mirics ADC with 
14-bit resolution => 16384 quantization levels => 32-bit float LUT will 
be 16384 * 4 = 65536 bytes. Wonder if that much big LUT is allowed to 
library - but maybe you could alloc() and populate LUT on the fly if 
needed. Or maybe native conversion is fast enough.

regards
Antti


>
> Regards,
>
> 	Hans
>
>> +
>>   /*
>>    *	F O R M A T   E N U M E R A T I O N
>>    */
>> diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
>> index e2afc27..38c9125 100644
>> --- a/lib/libv4lconvert/libv4lconvert.c
>> +++ b/lib/libv4lconvert/libv4lconvert.c
>> @@ -78,7 +78,8 @@ static void v4lconvert_get_framesizes(struct v4lconvert_data *data,
>>   	{ V4L2_PIX_FMT_RGB24,		24,	 1,	 5,	0 }, \
>>   	{ V4L2_PIX_FMT_BGR24,		24,	 1,	 5,	0 }, \
>>   	{ V4L2_PIX_FMT_YUV420,		12,	 6,	 1,	0 }, \
>> -	{ V4L2_PIX_FMT_YVU420,		12,	 6,	 1,	0 }
>> +	{ V4L2_PIX_FMT_YVU420,		12,	 6,	 1,	0 }, \
>> +	{ V4L2_PIX_FMT_FLOAT,		 0,	 0,	 0,	0 }
>>
>>   static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
>>   	SUPPORTED_DST_PIXFMTS,
>> @@ -131,6 +132,8 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
>>   	{ V4L2_PIX_FMT_Y6,		 8,	20,	20,	0 },
>>   	{ V4L2_PIX_FMT_Y10BPACK,	10,	20,	20,	0 },
>>   	{ V4L2_PIX_FMT_Y16,		16,	20,	20,	0 },
>> +	/* SDR formats */
>> +	{ V4L2_PIX_FMT_U8,		0,	0,	0,	0 },
>>   };
>>
>>   static const struct v4lconvert_pixfmt supported_dst_pixfmts[] = {
>> @@ -1281,6 +1284,25 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
>>   		}
>>   		break;
>>
>> +	/* SDR */
>> +	case V4L2_PIX_FMT_U8:
>> +		switch (dest_pix_fmt) {
>> +		case V4L2_PIX_FMT_FLOAT:
>> +			{
>> +				/* 8-bit unsigned to 32-bit float */
>> +				unsigned int i;
>> +				float ftmp;
>> +				for (i = 0; i < src_size; i++) {
>> +					ftmp = *src++;
>> +					ftmp -= 127.5;
>> +					ftmp /= 127.5;
>> +					memcpy(dest, &ftmp, 4);
>> +					dest += 4;
>> +				}
>> +			}
>> +		}
>> +		break;
>> +
>>   	default:
>>   		V4LCONVERT_ERR("Unknown src format in conversion\n");
>>   		errno = EINVAL;
>> @@ -1349,6 +1371,11 @@ int v4lconvert_convert(struct v4lconvert_data *data,
>>   		temp_needed =
>>   			my_src_fmt.fmt.pix.width * my_src_fmt.fmt.pix.height * 3 / 2;
>>   		break;
>> +	/* SDR */
>> +	case V4L2_PIX_FMT_FLOAT:
>> +		dest_needed = src_size * 4; /* 8-bit to 32-bit */
>> +		temp_needed = dest_needed;
>> +		break;
>>   	default:
>>   		V4LCONVERT_ERR("Unknown dest format in conversion\n");
>>   		errno = EINVAL;
>>
>


-- 
http://palosaari.fi/
