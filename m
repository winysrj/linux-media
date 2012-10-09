Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23055 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2JIOzz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 10:55:55 -0400
Received: from eusync4.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBM00B2SS5SU2A0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Oct 2012 15:56:16 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MBM00EEMS54UZB0@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Oct 2012 15:55:53 +0100 (BST)
Message-id: <50743AF7.40802@samsung.com>
Date: Tue, 09 Oct 2012 16:55:51 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, a.hajda@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC] V4L: Add get/set_frame_desc subdev callbacks
References: <1348495217-32715-1-git-send-email-s.nawrocki@samsung.com>
 <507341CF.5000800@iki.fi>
In-reply-to: <507341CF.5000800@iki.fi>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

On 10/08/2012 11:12 PM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> Thanks for the patch. I noticed this is already in Mauro's tree and is there
> without my ack. I know it's partly my own fault since I haven't commented it
> earlier.
> 
> Sylwester Nawrocki wrote:
>> Add subdev callbacks for setting up and retrieving parameters of the frame
>> on media bus that are not exposed to user space directly.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>
>> Hi All,
>>
>> This patch is intended as an initial, mostly a stub, implementation of the
>> media bus frame format descriptors idea outlined in Sakari's RFC [1].
>> I included in this patch only what is necessary for the s5p-fimc driver to
>> capture JPEG and interleaved JPEG/YUV image data from M-5MOLS and S5C73M3
>> cameras. The union containing per media bus type structures describing
>> bus specific configuration is not included here, it likely needs much
>> discussions and I would like to get this patch merged for v3.7 if possible.
>>
>> To follow is a patch adding users of these new subdev operations.
>>
>> Comments are welcome.
>>
>> Thanks,
>> Sylwester
>>
>> [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg43530.html
>> ---
>>   include/media/v4l2-subdev.h | 42 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 42 insertions(+)
>>
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index 28067ed..f5d8441 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -21,6 +21,7 @@
>>   #ifndef _V4L2_SUBDEV_H
>>   #define _V4L2_SUBDEV_H
>>
>> +#include <linux/types.h>
> 
> What do you need types.h for?

I remember hitting a build error due to missing declarations 
of u32 and u16. But not sure how it happened, since linux/types.h
is included in linux/v4l2-subdev.h...

>>   #include <linux/v4l2-subdev.h>
>>   #include <media/media-entity.h>
>>   #include <media/v4l2-common.h>
>> @@ -45,6 +46,7 @@ struct v4l2_fh;
>>   struct v4l2_subdev;
>>   struct v4l2_subdev_fh;
>>   struct tuner_setup;
>> +struct v4l2_mbus_frame_desc;
>>
>>   /* decode_vbi_line */
>>   struct v4l2_decode_vbi_line {
>> @@ -226,6 +228,36 @@ struct v4l2_subdev_audio_ops {
>>       int (*s_stream)(struct v4l2_subdev *sd, int enable);
>>   };
>>
>> +/* Indicates the @length field specifies maximum data length. */
>> +#define V4L2_MBUS_FRAME_DESC_FL_LEN_MAX        (1U << 0)
>> +/* Indicates user defined data format, i.e. non standard frame format. */
>> +#define V4L2_MBUS_FRAME_DESC_FL_BLOB        (1U << 1)
>> +
>> +/**
>> + * struct v4l2_mbus_frame_desc_entry - media bus frame description structure
>> + * @flags: V4L2_MBUS_FRAME_DESC_FL_* flags
>> + * @pixelcode: media bus pixel code, valid if FRAME_DESC_FL_BLOB is not set
>> + * @length: number of octets per frame, valid for compressed or unspecified
>> + *          formats
>> + */
>> +struct v4l2_mbus_frame_desc_entry {
>> +    u16 flags;
>> +    u32 pixelcode;
>> +    u32 length;
>> +};
> 
> Do you think that the flags, pixelcode and length defines (a part of) the frame
> precisely enough? How about width and height; they are important for
> uncompressed formats?

Obviously not, nor it supposed to be precise enough yet and to make everyone 
happy right away. You proposed an union for width and height [1], and I assume
that could still be added. But there might be use cases where width, height
and length would be needed at the same time.

> Also, as stated above, "lenght of octets for frame" is only meaningful for
> compressed formats and for those with 8 bits per pixel. However, I think that
> limiting the frame descriptors for compressed formats only is simply not
> enough. The main use case I had in mind originally, and I still see it that
> way, involves uncompressed formats, especially metadata.

It's not only limited to compressed formats. I can't see how this is related
to 8-bits per pixel, number of bits per pixel is variable for compressed
streams.

> Currently I see that all this is serving is just one use case: providing the
> maximum frame length in octets for compressed formats to the CSI-2 receiver.
> There's nothing wrong in using frame descriptors for that --- I think it's
> valid use for them, but we also need to consider other use cases.

Mostly yes, we're also using it for retrieving from the sensor subdev driver
the information required for V4L2_PIX_FMT_S5C_UYVY_JPG format data capture,
i.e. the second entry in the array describes meta-data.

>> +#define V4L2_FRAME_DESC_ENTRY_MAX    4
>> +
>> +/**
>> + * struct v4l2_mbus_frame_desc - media bus data frame description
>> + * @entry: frame descriptors array
>> + * @num_entries: number of entries in @entry array
>> + */
>> +struct v4l2_mbus_frame_desc {
>> +    struct v4l2_mbus_frame_desc_entry entry[V4L2_FRAME_DESC_ENTRY_MAX];
>> +    unsigned short num_entries;
>> +};
>> +
>>   /*
>>      s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
>>       video input devices.
>> @@ -461,6 +493,12 @@ struct v4l2_subdev_ir_ops {
>>                   struct v4l2_subdev_ir_parameters *params);
>>   };
>>
>> +/**
>> + * struct v4l2_subdev_pad_ops - v4l2-subdev pad level operations
>> + * @get_frame_desc: get the current low level media bus frame parameters.
>> + * @get_frame_desc: set the low level media bus frame parameters, @fd array
>> + *                  may be adjusted by the subdev driver to device
>> capabilities.
>> + */
>>   struct v4l2_subdev_pad_ops {
>>       int (*enum_mbus_code)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>>                     struct v4l2_subdev_mbus_code_enum *code);
>> @@ -489,6 +527,10 @@ struct v4l2_subdev_pad_ops {
>>                    struct v4l2_subdev_format *source_fmt,
>>                    struct v4l2_subdev_format *sink_fmt);
>>   #endif /* CONFIG_MEDIA_CONTROLLER */
>> +    int (*get_frame_desc)(struct v4l2_subdev *sd, unsigned int pad,
>> +                  struct v4l2_mbus_frame_desc *fd);
>> +    int (*set_frame_desc)(struct v4l2_subdev *sd, unsigned int pad,
>> +                  struct v4l2_mbus_frame_desc *fd);
> 
> Is there a meaningful use case for setting the frame descriptor? I would assume
> that this is what the driver for the transmitting component (e.g. a sensor)
> defines pretty much independently and that's mostly hardware dependent and not
> freely changeable. At least I haven't seen such configurability, let alone to
> the extent it would make sense to express it with such a relatively generic
> interface.

There might be parameters that one would want to modify, so it could be done
with a get call, modifying required value(s) and a set call.

> Considering the above, I think this is going to mainline too early. At the very
> least I suggest that any further use of frame descriptors only comes after more
> people have had their say over the topic and a rough concensus is reached.

Yes, that was entirely my intention as well. If there is someone needing more
features further extensions could be made, after proper discussions and making 
sure it satisfies everyone.

--

Regards,
Sylwester

[1] http://www.spinics.net/lists/linux-media/msg44629.html
