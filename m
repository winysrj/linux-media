Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61667 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaDIHbU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 03:31:20 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3R006H06864U40@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 09 Apr 2014 08:31:18 +0100 (BST)
Message-id: <5344F747.6080103@samsung.com>
Date: Wed, 09 Apr 2014 09:31:19 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 7/8] [media] s5p_jpeg: Prevent JPEG 4:2:0 > YUV 4:2:0
 decompression
References: <1396876573-15811-1-git-send-email-j.anaszewski@samsung.com>
 <1396876573-15811-7-git-send-email-j.anaszewski@samsung.com>
 <CAK9yfHxXRXagZVAZhGjqH+qVGTAdP-=PnFw4O7HEU09UNB5Tsg@mail.gmail.com>
In-reply-to: <CAK9yfHxXRXagZVAZhGjqH+qVGTAdP-=PnFw4O7HEU09UNB5Tsg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/08/2014 09:49 AM, Sachin Kamat wrote:
> Hi Jacek,
>
> On 7 April 2014 18:46, Jacek Anaszewski <j.anaszewski@samsung.com> wrote:
>> Prevent decompression of a JPEG 4:2:0 with odd width to
>> the YUV 4:2:0 compliant formats for Exynos4x12 SoCs and
>> adjust capture format to RGB565 in such a case. This is
>> required because the configuration would produce a raw
>> image with broken luma component.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
> <snip>
>
>> +       if (ctx->subsampling == V4L2_JPEG_CHROMA_SUBSAMPLING_420 &&
>> +           (ctx->out_q.w & 1) &&
>> +           (pix->pixelformat == V4L2_PIX_FMT_NV12 ||
>> +            pix->pixelformat == V4L2_PIX_FMT_NV21 ||
>> +            pix->pixelformat == V4L2_PIX_FMT_YUV420)) {
>> +               pix->pixelformat = V4L2_PIX_FMT_RGB565;
>> +               fmt = s5p_jpeg_find_format(ctx, pix->pixelformat,
>> +                                                       FMT_TYPE_CAPTURE);
>> +               v4l2_info(&ctx->jpeg->v4l2_dev,
>> +                         "Adjusted capture fourcc to RGB565. Decompression\n"
>> +                         "of a JPEG file with 4:2:0 subsampling and odd\n"
>> +                         "width to the YUV 4:2:0 compliant formats produces\n"
>> +                         "a raw image with broken luma component.\n");
>
> This could be made a comment in the code rather than a info message.
>

Hello Sachin,

Thanks for the review. I put it into info message because this is
rather hard for the user to figure out why the adjustment occurred,
bearing in mind that JPEG with the same subsampling and even width
is decompressed properly. This is not a common adjustment like
alignment, and thus in my opinion it requires displaying the
information. Are there some rules that say what cases are relevant
for using the v4l2_info macro?

Regards,
Jacek Anaszewski
