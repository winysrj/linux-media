Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63813 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaEIEeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 00:34:18 -0400
Message-ID: <536C5AB0.4090007@gmail.com>
Date: Fri, 09 May 2014 10:03:52 +0530
From: Arun Kumar K <arunkk.samsung@gmail.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	'Arun Kumar K' <arun.kk@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>, posciak@chromium.org
Subject: Re: [PATCH] [media] s5p-mfc: Don't try to resubmit VP8 bitstream
 buffer for decode.
References: <1394180752-16348-1-git-send-email-arun.kk@samsung.com> <004b01cf6ad9$b5c83c80$2158b580$%debski@samsung.com>
In-Reply-To: <004b01cf6ad9$b5c83c80$2158b580$%debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On 05/08/14 21:52, Kamil Debski wrote:
> Hi,
> 
> 
>> From: Arun Kumar K [mailto:arunkk.samsung@gmail.com] On Behalf Of Arun
>> Kumar K
>> Sent: Friday, March 07, 2014 9:26 AM
>>
>> From: Pawel Osciak <posciak@chromium.org>
>>
>> Currently, for formats that are not H264, MFC driver will check the
>> consumed stream size returned by the firmware and, based on that, will
>> try to decide whether the bitstream buffer contained more than one
>> frame. If the size of the buffer is larger than the consumed stream, it
>> assumes that there are more frames in the buffer and that the buffer
>> should be resubmitted for decode. This rarely works though and actually
>> introduces problems, because:
>>
>> - v7 firmware will always return consumed stream size equal to whatever
>> the driver passed to it when running decode (which is the size of the
>> whole buffer), which means we will never try to resubmit, because the
>> firmware will always tell us that it consumed all the data we passed to
>> it;
>>
>> - v6 firmware will return the number of consumed bytes, but will not
>> include the padding ("stuffing") bytes that are allowed after the frame
>> in VP8. Since there is no way of figuring out how many of those bytes
>> follow the frame without getting the frame size from IVF headers (or
>> somewhere else, but not from the stream itself), the driver tries to
>> guess that padding size is not larger than 4 bytes, which is not always
>> true;
>>
>> The only way to make it work is to queue only one frame per buffer from
>> userspace and the check in the kernel is useless and wrong for VP8.
>> MPEG4 still seems to require it, so keep it only for that format.
>>
>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> index e2aac59..66c1775 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> @@ -360,7 +360,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx
>> *ctx,
>>  								list);
>>  		ctx->consumed_stream += s5p_mfc_hw_call(dev->mfc_ops,
>>  						get_consumed_stream, dev);
>> -		if (ctx->codec_mode != S5P_MFC_CODEC_H264_DEC &&
>> +		if (ctx->codec_mode == S5P_MFC_CODEC_MPEG4_DEC &&
>>  			ctx->consumed_stream + STUFF_BYTE <
>>  			src_buf->b->v4l2_planes[0].bytesused) {
>>  			/* Run MFC again on the same buffer */
> 
> I expressed my doubts to this patch in my previous email.
> I think that packed PB can also be found in other codecs such as H263.
> So please change to the following if this is a workaround for VP8 only.
> (The title says that it only changes behavior of VP8 decoding, so it is
> misleading).
> 

Yes it is seen as affecting only VP8 decoding.

> -		if (ctx->codec_mode != S5P_MFC_CODEC_H264_DEC &&
> +		if (ctx->codec_mode != S5P_MFC_CODEC_H264_DEC &&
> +		    ctx->codec_mode != S5P_MFC_CODEC_VP8_DEC &&
> 

Ok. I will change it this way.

> 
> Did you try to revert your patch https://patchwork.linuxtv.org/patch/15448/
> and checking if this fixes the problem for VP8?
> 

I am afraid it will not solve the VP8 issue as before that patch, it
used to check for ctx->codec_mode != S5P_MFC_CODEC_H264_DEC and frame
type is S5P_FIMV_DECODE_FRAME_P_FRAME, buffer was sent again to decode.
This condition can be triggered in VP8 case causing erroneous behaviour.

So I will make the change as you suggested above.

Regards
Arun

>> --
>> 1.7.9.5
> 
> Best wishes,
> 
