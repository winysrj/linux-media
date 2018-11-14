Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f194.google.com ([209.85.167.194]:37271 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbeKNOO1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 09:14:27 -0500
Received: by mail-oi1-f194.google.com with SMTP id y23so3343430oia.4
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2018 20:13:00 -0800 (PST)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com. [209.85.167.182])
        by smtp.gmail.com with ESMTPSA id e42sm25288444oth.36.2018.11.13.20.12.58
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 20:12:59 -0800 (PST)
Received: by mail-oi1-f182.google.com with SMTP id x63-v6so12439081oix.9
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2018 20:12:58 -0800 (PST)
MIME-Version: 1.0
References: <20181113093048.236201-1-acourbot@chromium.org> <CAKQmDh-91tHP1VxLisW1A3GR9G7du3F-Y2XrrgoFU=gvhGoP6w@mail.gmail.com>
In-Reply-To: <CAKQmDh-91tHP1VxLisW1A3GR9G7du3F-Y2XrrgoFU=gvhGoP6w@mail.gmail.com>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 14 Nov 2018 13:12:46 +0900
Message-ID: <CAPBb6MWJ1Qu9YoRRusOGiC7dioMkgvU=1dCF6XZ4xDUxp7ri9A@mail.gmail.com>
Subject: Re: [PATCH] media: venus: fix reported size of 0-length buffers
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2018 at 3:54 AM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
>
>
> Le mar. 13 nov. 2018 04 h 30, Alexandre Courbot <acourbot@chromium.org> a=
 =C3=A9crit :
>>
>> The last buffer is often signaled by an empty buffer with the
>> V4L2_BUF_FLAG_LAST flag set. Such buffers were returned with the
>> bytesused field set to the full size of the OPB, which leads
>> user-space to believe that the buffer actually contains useful data. Fix
>> this by passing the number of bytes reported used by the firmware.
>
>
> That means the driver does not know on time which one is last. Why not ju=
st returned EPIPE to userspace on DQBUF and ovoid this useless roundtrip ?

Sorry, I don't understand what you mean. EPIPE is supposed to be
returned after a buffer with V4L2_BUF_FLAG_LAST is made available for
dequeue. This patch amends the code that prepares this LAST-flagged
buffer. How could we avoid a roundtrip in this case?

>
>>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> ---
>>  drivers/media/platform/qcom/venus/vdec.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/pl=
atform/qcom/venus/vdec.c
>> index 189ec975c6bb..282de21cf2e1 100644
>> --- a/drivers/media/platform/qcom/venus/vdec.c
>> +++ b/drivers/media/platform/qcom/venus/vdec.c
>> @@ -885,10 +885,8 @@ static void vdec_buf_done(struct venus_inst *inst, =
unsigned int buf_type,
>>         vbuf->field =3D V4L2_FIELD_NONE;
>>
>>         if (type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> -               unsigned int opb_sz =3D venus_helper_get_opb_size(inst);
>> -
>>                 vb =3D &vbuf->vb2_buf;
>> -               vb2_set_plane_payload(vb, 0, bytesused ? : opb_sz);
>> +               vb2_set_plane_payload(vb, 0, bytesused);
>>                 vb->planes[0].data_offset =3D data_offset;
>>                 vb->timestamp =3D timestamp_us * NSEC_PER_USEC;
>>                 vbuf->sequence =3D inst->sequence_cap++;
>> --
>> 2.19.1.930.g4563a0d9d0-goog
>>
