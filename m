Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:48623 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3FZMyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 08:54:52 -0400
Received: by mail-ve0-f178.google.com with SMTP id pb11so11326602veb.37
        for <linux-media@vger.kernel.org>; Wed, 26 Jun 2013 05:54:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <009c01ce71ac$cc88e400$659aac00$%debski@samsung.com>
References: <1372157835-27663-1-git-send-email-arun.kk@samsung.com>
	<1372157835-27663-6-git-send-email-arun.kk@samsung.com>
	<009c01ce71ac$cc88e400$659aac00$%debski@samsung.com>
Date: Wed, 26 Jun 2013 18:24:51 +0530
Message-ID: <CALt3h7-xP5MFeazmw8J5ZPXHbfMOAH+ewEerWiqbMsg8fg9vaw@mail.gmail.com>
Subject: Re: [PATCH v3 5/8] [media] s5p-mfc: Update driver for v7 firmware
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>, jtp.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, avnd.kiran@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Tue, Jun 25, 2013 at 7:33 PM, Kamil Debski <k.debski@samsung.com> wrote:
> Hi Arun,
>
> This patch sets looks very good.
> Please check my comments below.
>
>> From: Arun Kumar K [mailto:arun.kk@samsung.com]
>>
>> Firmware version v7 is mostly similar to v6 in terms of hardware
>> specific controls and commands. So the hardware specific opr_v6 and
>> cmd_v6 are re-used for v7 also. This patch updates the v6 files to
>> handle v7 version also.
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   11 ++++-
>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   53
>> +++++++++++++++++++----
>>  2 files changed, 53 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> index f734ccc..dd57b06 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> @@ -1663,8 +1663,15 @@ static int s5p_mfc_queue_setup(struct vb2_queue
>> *vq,
>>               if (*buf_count > MFC_MAX_BUFFERS)
>>                       *buf_count = MFC_MAX_BUFFERS;
>>
>> -             psize[0] = ctx->luma_size;
>> -             psize[1] = ctx->chroma_size;
>> +             if (IS_MFCV7(dev)) {
>> +                     /* MFCv7 needs pad bytes for input YUV */
>> +                     psize[0] = ctx->luma_size + 256;
>> +                     psize[1] = ctx->chroma_size + 128;
>
> Here, I would add some define name to avoid magic number.
> Secondly, why wasn't this padding added in s5p_mfc_enc_calc_src_size_v6/v7?
> enc_calc_src_size is called in s_fmt, so it seems the best place to adjust
> buffer/plane sizes.
>

Yes that seems to be the right place to make this change. Will change it
in next version.

Regards
Arun
