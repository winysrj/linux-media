Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51950 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbaEHJjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 05:39:12 -0400
Received: by mail-oa0-f46.google.com with SMTP id i4so2768880oah.33
        for <linux-media@vger.kernel.org>; Thu, 08 May 2014 02:39:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399462252-21821-1-git-send-email-arun.kk@samsung.com>
References: <1399462252-21821-1-git-send-email-arun.kk@samsung.com>
Date: Thu, 8 May 2014 15:09:12 +0530
Message-ID: <CAK9yfHz-YuC0pdqChK2=OFLxyf9zguGFS5275O9fG3DVB8YHsA@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-mfc: Dequeue sequence header after STREAMON
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <posciak@chromium.org>,
	Kiran Avnd <avnd.kiran@samsung.com>,
	Arun Kumar <arunkk.samsung@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

Just 2 small nits.

On 7 May 2014 17:00, Arun Kumar K <arun.kk@samsung.com> wrote:
> MFCv6 encoder needs specific minimum number of buffers to
> be queued in the CAPTURE plane. This minimum number will
> be known only when the sequence header is generated.
> So we used to allow STREAMON on the CAPTURE plane only after
> sequence header is generated and checked with the minimum
> buffer requirement.
>
> But this causes a problem that we call a vb2_buffer_done
> for the sequence header buffer before doing a STREAON on the
> CAPTURE plane. This used to still work fine until this patch
> was merged b3379c6201bb3555298cdbf0aa004af260f2a6a4.

Please provide the patch title too along with commit ID
(first 12 characters of ID is enough).

>
> This problem should also come in earlier MFC firmware versions
> if the application calls STREAMON on CAPTURE with some delay
> after doing STREAMON on OUTPUT.
>
> So this patch keeps the header buffer until the other frame
> buffers are ready and dequeues it just before the first frame
> is ready.
>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |    6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index d64b680..4fd1034 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -523,6 +523,7 @@ struct s5p_mfc_codec_ops {
>   * @output_state:      state of the output buffers queue
>   * @src_bufs:          information on allocated source buffers
>   * @dst_bufs:          information on allocated destination buffers
> + * @header_mb:         buf pointer of the encoded sequence header

s/buf/buffer

-- 
With warm regards,
Sachin
