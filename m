Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:46963 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbaEMLfT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 May 2014 07:35:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9yfHz-YuC0pdqChK2=OFLxyf9zguGFS5275O9fG3DVB8YHsA@mail.gmail.com>
References: <1399462252-21821-1-git-send-email-arun.kk@samsung.com>
	<CAK9yfHz-YuC0pdqChK2=OFLxyf9zguGFS5275O9fG3DVB8YHsA@mail.gmail.com>
Date: Tue, 13 May 2014 17:05:17 +0530
Message-ID: <CALt3h78STM9rLxZJ8cJZS=2hO9c=-aa+4Z40LHFydVLAq+jx5Q@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-mfc: Dequeue sequence header after STREAMON
From: Arun Kumar K <arun.kk@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <posciak@chromium.org>,
	Kiran Avnd <avnd.kiran@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thank you for the review.
Will address your comments and post updated version.

Regards
Arun

On Thu, May 8, 2014 at 3:09 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Arun,
>
> Just 2 small nits.
>
> On 7 May 2014 17:00, Arun Kumar K <arun.kk@samsung.com> wrote:
>> MFCv6 encoder needs specific minimum number of buffers to
>> be queued in the CAPTURE plane. This minimum number will
>> be known only when the sequence header is generated.
>> So we used to allow STREAMON on the CAPTURE plane only after
>> sequence header is generated and checked with the minimum
>> buffer requirement.
>>
>> But this causes a problem that we call a vb2_buffer_done
>> for the sequence header buffer before doing a STREAON on the
>> CAPTURE plane. This used to still work fine until this patch
>> was merged b3379c6201bb3555298cdbf0aa004af260f2a6a4.
>
> Please provide the patch title too along with commit ID
> (first 12 characters of ID is enough).
>
>>
>> This problem should also come in earlier MFC firmware versions
>> if the application calls STREAMON on CAPTURE with some delay
>> after doing STREAMON on OUTPUT.
>>
>> So this patch keeps the header buffer until the other frame
>> buffers are ready and dequeues it just before the first frame
>> is ready.
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
>>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |    6 +++++-
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> index d64b680..4fd1034 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> @@ -523,6 +523,7 @@ struct s5p_mfc_codec_ops {
>>   * @output_state:      state of the output buffers queue
>>   * @src_bufs:          information on allocated source buffers
>>   * @dst_bufs:          information on allocated destination buffers
>> + * @header_mb:         buf pointer of the encoded sequence header
>
> s/buf/buffer
>
> --
> With warm regards,
> Sachin
