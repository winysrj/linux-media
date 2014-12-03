Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45861 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbaLCH2d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Dec 2014 02:28:33 -0500
Message-ID: <547EBB8E.6060708@xs4all.nl>
Date: Wed, 03 Dec 2014 08:28:14 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 2/9] v4l2-mediabus: improve colorspace support
References: <1417424633-15781-1-git-send-email-hverkuil@xs4all.nl> <1417424633-15781-3-git-send-email-hverkuil@xs4all.nl> <20141203001637.GC14746@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141203001637.GC14746@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/2014 01:16 AM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Dec 01, 2014 at 10:03:46AM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add and copy the new ycbcr_enc and quantization fields.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  include/media/v4l2-mediabus.h      | 4 ++++
>>  include/uapi/linux/v4l2-mediabus.h | 6 +++++-
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
>> index 59d7397..38d960d 100644
>> --- a/include/media/v4l2-mediabus.h
>> +++ b/include/media/v4l2-mediabus.h
>> @@ -94,6 +94,8 @@ static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
>>  	pix_fmt->height = mbus_fmt->height;
>>  	pix_fmt->field = mbus_fmt->field;
>>  	pix_fmt->colorspace = mbus_fmt->colorspace;
>> +	pix_fmt->ycbcr_enc = mbus_fmt->ycbcr_enc;
>> +	pix_fmt->quantization = mbus_fmt->quantization;
>>  }
>>  
>>  static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
>> @@ -104,6 +106,8 @@ static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
>>  	mbus_fmt->height = pix_fmt->height;
>>  	mbus_fmt->field = pix_fmt->field;
>>  	mbus_fmt->colorspace = pix_fmt->colorspace;
>> +	mbus_fmt->ycbcr_enc = pix_fmt->ycbcr_enc;
>> +	mbus_fmt->quantization = pix_fmt->quantization;
>>  	mbus_fmt->code = code;
>>  }
>>  
>> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
>> index b1934a3..5a86d8e 100644
>> --- a/include/uapi/linux/v4l2-mediabus.h
>> +++ b/include/uapi/linux/v4l2-mediabus.h
>> @@ -22,6 +22,8 @@
>>   * @code:	data format code (from enum v4l2_mbus_pixelcode)
>>   * @field:	used interlacing type (from enum v4l2_field)
>>   * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
>> + * @ycbcr_enc:	YCbCr encoding of the data (from enum v4l2_ycbcr_encoding)
>> + * @quantization: quantization of the data (from enum v4l2_quantization)
>>   */
>>  struct v4l2_mbus_framefmt {
>>  	__u32			width;
>> @@ -29,7 +31,9 @@ struct v4l2_mbus_framefmt {
>>  	__u32			code;
>>  	__u32			field;
>>  	__u32			colorspace;
>> -	__u32			reserved[7];
>> +	__u32			ycbcr_enc;
>> +	__u32			quantization;
>> +	__u32			reserved[5];
> 
> If you feel these can fit to 8 bits in planes, I would consider to use 8
> bits here as well. Adding frame descriptor support later on might eat some
> fields from here as well.

You can do this in a number of ways:

	__u8 ycbcr_enc;
	__u8 quantization;
	__u32 reserved[6];

This would leave a hole before the reserved field. That's hard to zero.

	__u8 ycbcr_enc;
	__u8 quantization;
	__u8 reserved[2 + 6 * 4];

This will work for now, but if a __u32 needs to be added later, then I get
a hole again.

	__u16 ycbcr_enc;
	__u16 quantization;
	__u32 reserved[6];

This is the only alternative that doesn't leave a hole. Would this be OK?
I have no problem changing the API to this.

Regards,

	Hans
