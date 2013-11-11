Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1058 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3KKOii (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 09:38:38 -0500
Message-ID: <5280EBD4.5010505@xs4all.nl>
Date: Mon, 11 Nov 2013 15:38:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH RFC] libv4lconvert: SDR conversion from U8 to FLOAT
References: <1384103776-4788-1-git-send-email-crope@iki.fi> <1384179541.1949.24.camel@palomino.walls.org>
In-Reply-To: <1384179541.1949.24.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/2013 03:19 PM, Andy Walls wrote:
> On Sun, 2013-11-10 at 19:16 +0200, Antti Palosaari wrote:
>> Convert unsigned 8 to float 32 [-1 to +1], which is commonly
>> used format for baseband signals.
> 
> Hi Annti,
> 
> I don't think this a good idea.  Floating point representations are
> inherently non-portable.  Even though most everything now uses IEEE-754
> representation, things like denormaliazed numbers may be treated
> differently by different machines.  If someone saves the data to a file,
> endianess issues aside, there are no guarantees that a different machine
> reading is going to interpret all the floating point data from that file
> properly.
> 
> I really would recommend staying with scaled integer representations or
> explicit integer mantissa, exponent representations.

For what it's worth: ALSA does support float format as well (both LE and BE).

Regards,

	Hans

> 
> Two more comments below...
> 
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>  contrib/freebsd/include/linux/videodev2.h |  4 ++++
>>  include/linux/videodev2.h                 |  4 ++++
>>  lib/libv4lconvert/libv4lconvert.c         | 29 ++++++++++++++++++++++++++++-
>>  3 files changed, 36 insertions(+), 1 deletion(-)
>>
>> diff --git a/contrib/freebsd/include/linux/videodev2.h b/contrib/freebsd/include/linux/videodev2.h
>> index 1fcfaeb..8829400 100644
>> --- a/contrib/freebsd/include/linux/videodev2.h
>> +++ b/contrib/freebsd/include/linux/videodev2.h
>> @@ -465,6 +465,10 @@ struct v4l2_pix_format {
>>  #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
>>  #define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5', 'C', 'I') /* S5C73M3 interleaved UYVY/JPEG */
>>  
>> +/* SDR */
>> +#define V4L2_PIX_FMT_FLOAT    v4l2_fourcc('D', 'F', '3', '2') /* float 32-bit */
>> +#define V4L2_PIX_FMT_U8       v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
>> +
>>  /*
>>   *	F O R M A T   E N U M E R A T I O N
>>   */
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index 437f1b0..14299a6 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -431,6 +431,10 @@ struct v4l2_pix_format {
>>  #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
>>  #define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5', 'C', 'I') /* S5C73M3 interleaved UYVY/JPEG */
>>  
>> +/* SDR */
>> +#define V4L2_PIX_FMT_FLOAT    v4l2_fourcc('D', 'F', '3', '2') /* float 32-bit */
>> +#define V4L2_PIX_FMT_U8       v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
>> +
>>  /*
>>   *	F O R M A T   E N U M E R A T I O N
>>   */
>> diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
>> index e2afc27..38c9125 100644
>> --- a/lib/libv4lconvert/libv4lconvert.c
>> +++ b/lib/libv4lconvert/libv4lconvert.c
>> @@ -78,7 +78,8 @@ static void v4lconvert_get_framesizes(struct v4lconvert_data *data,
>>  	{ V4L2_PIX_FMT_RGB24,		24,	 1,	 5,	0 }, \
>>  	{ V4L2_PIX_FMT_BGR24,		24,	 1,	 5,	0 }, \
>>  	{ V4L2_PIX_FMT_YUV420,		12,	 6,	 1,	0 }, \
>> -	{ V4L2_PIX_FMT_YVU420,		12,	 6,	 1,	0 }
>> +	{ V4L2_PIX_FMT_YVU420,		12,	 6,	 1,	0 }, \
>> +	{ V4L2_PIX_FMT_FLOAT,		 0,	 0,	 0,	0 }
>>  
>>  static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
>>  	SUPPORTED_DST_PIXFMTS,
>> @@ -131,6 +132,8 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
>>  	{ V4L2_PIX_FMT_Y6,		 8,	20,	20,	0 },
>>  	{ V4L2_PIX_FMT_Y10BPACK,	10,	20,	20,	0 },
>>  	{ V4L2_PIX_FMT_Y16,		16,	20,	20,	0 },
>> +	/* SDR formats */
>> +	{ V4L2_PIX_FMT_U8,		0,	0,	0,	0 },
>>  };
>>  
>>  static const struct v4lconvert_pixfmt supported_dst_pixfmts[] = {
>> @@ -1281,6 +1284,25 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
>>  		}
>>  		break;
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
> 
> Replace the 4's with sizeof(float).
> 
> You have no guarantees that sizeof(float) == 4, but it is usally a safe
> assumption for 'float' on Unix.
> 
> sizeof(long double) is certainly different for IA32 machines (80 bits)
> vs. other 32 bit platforms.  I was burned by this many years ago on a
> RedHat 9.0 machine (the GNU Ada Translator's libm bindings made some bad
> assumptions about the size of float types).
> 
> 
>> +				}
>> +			}
>> +		}
>> +		break;
>> +
>>  	default:
>>  		V4LCONVERT_ERR("Unknown src format in conversion\n");
>>  		errno = EINVAL;
>> @@ -1349,6 +1371,11 @@ int v4lconvert_convert(struct v4lconvert_data *data,
>>  		temp_needed =
>>  			my_src_fmt.fmt.pix.width * my_src_fmt.fmt.pix.height * 3 / 2;
>>  		break;
>> +	/* SDR */
>> +	case V4L2_PIX_FMT_FLOAT:
>> +		dest_needed = src_size * 4; /* 8-bit to 32-bit */
> 
> Change the 4 to sizeof(float).
> 
>> +		temp_needed = dest_needed;
>> +		break;
>>  	default:
>>  		V4LCONVERT_ERR("Unknown dest format in conversion\n");
>>  		errno = EINVAL;
> 
> Regards,
> Andy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

