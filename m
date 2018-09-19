Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:52404 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731127AbeISQKS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 12:10:18 -0400
Received: by mail-it0-f66.google.com with SMTP id h3-v6so7566163ita.2
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 03:33:01 -0700 (PDT)
Received: from mail-it0-f42.google.com (mail-it0-f42.google.com. [209.85.214.42])
        by smtp.gmail.com with ESMTPSA id o82-v6sm5488735itg.4.2018.09.19.03.32.59
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Sep 2018 03:32:59 -0700 (PDT)
Received: by mail-it0-f42.google.com with SMTP id h1-v6so7041008itj.4
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 03:32:59 -0700 (PDT)
MIME-Version: 1.0
References: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
 <01451f8e-aea3-b276-cb01-b0666a837d62@linaro.org> <4ce55726d810e308a2cae3f84bca7140bed48c7d.camel@ndufresne.ca>
 <92f6f79a-02ae-d23e-1b97-fc41fd921c89@linaro.org> <33e8d8e3-138e-0031-5b75-4bef114ac75e@xs4all.nl>
 <36b42952-982c-9048-77fb-72ca45cc7476@linaro.org> <051af6fb-e0e8-4008-99c5-9685ac24e454@xs4all.nl>
In-Reply-To: <051af6fb-e0e8-4008-99c5-9685ac24e454@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 19 Sep 2018 19:32:46 +0900
Message-ID: <CAPBb6MVupMsdhF6Rtk4fm8JeVurrK+ZsuxAQ-BwrTzdSP1xP0Q@mail.gmail.com>
Subject: Re: [PATCH] venus: vdec: fix decoded data size
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        vgarodia@codeaurora.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 17, 2018 at 11:33 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 09/17/2018 04:30 PM, Stanimir Varbanov wrote:
> > Hi Hans,
> >
> > On 09/17/2018 01:00 PM, Hans Verkuil wrote:
> >> On 07/18/2018 04:37 PM, Stanimir Varbanov wrote:
> >>> Hi,
> >>>
> >>> On 07/18/2018 04:26 PM, Nicolas Dufresne wrote:
> >>>> Le mercredi 18 juillet 2018 =C3=A0 14:31 +0300, Stanimir Varbanov a =
=C3=A9crit :
> >>>>> Hi Vikash,
> >>>>>
> >>>>> On 07/02/2018 10:44 AM, Vikash Garodia wrote:
> >>>>>> Exisiting code returns the max of the decoded
> >>>>>> size and buffer size. It turns out that buffer
> >>>>>> size is always greater due to hardware alignment
> >>>>>> requirement. As a result, payload size given to
> >>>>>> client is incorrect. This change ensures that
> >>>>>> the bytesused is assigned to actual payload size.
> >>>>>>
> >>>>>> Change-Id: Ie6f3429c0cb23f682544748d181fa4fa63ca2e28
> >>>>>> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> >>>>>> ---
> >>>>>>  drivers/media/platform/qcom/venus/vdec.c | 2 +-
> >>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>>
> >>>>>> diff --git a/drivers/media/platform/qcom/venus/vdec.c
> >>>>>> b/drivers/media/platform/qcom/venus/vdec.c
> >>>>>> index d079aeb..ada1d2f 100644
> >>>>>> --- a/drivers/media/platform/qcom/venus/vdec.c
> >>>>>> +++ b/drivers/media/platform/qcom/venus/vdec.c
> >>>>>> @@ -890,7 +890,7 @@ static void vdec_buf_done(struct venus_inst
> >>>>>> *inst, unsigned int buf_type,
> >>>>>>
> >>>>>>                  vb =3D &vbuf->vb2_buf;
> >>>>>>                  vb->planes[0].bytesused =3D
> >>>>>> -                        max_t(unsigned int, opb_sz, bytesused);
> >>>>>> +                        min_t(unsigned int, opb_sz, bytesused);
> >>>>>
> >>>>> Most probably my intension was to avoid bytesused =3D=3D 0, but tha=
t is
> >>>>> allowed from v4l2 driver -> userspace direction
> >>>>
> >>>> It remains bad practice since it was used by decoders to indicate th=
e
> >>>> last buffer. Some userspace (some GStreamer versions) will stop work=
ing
> >>>> if you start returning 0.
> >>>
> >>> I think it is legal v4l2 driver to return bytesused =3D 0 when usersp=
ace
> >>> issues streamoff on both queues before EOS, no? Simply because the
> >>> capture buffers are empty.
> >>>
> >>
> >> Going through some of the older pending patches I found this one:
> >>
> >> So is this patch right or wrong?
> >
> > I'm not sure either, let's not applying it for now (if Nicolas is right
> > this will break gstreamer plugin).
> >
>
> OK, I marked this as Rejected. If you change your mind it can be reposted=
 :-)

Mmm I'm not saying it has to be done in the current form, but at the
moment the returned bytesused seems to be wrong (at least Chrome is
not happy). We are returning the total size of the buffer instead of
the actually useful payload.

If the intent is to avoid returning bytesused =3D=3D 0 except for the
special case of the last buffer, how about the following?

--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -943,8 +943,7 @@ static void vdec_buf_done(struct venus_inst *inst,
unsigned int buf_type,
               unsigned int opb_sz =3D venus_helper_get_opb_size(inst);

               vb =3D &vbuf->vb2_buf;
-               vb->planes[0].bytesused =3D
-                       max_t(unsigned int, opb_sz, bytesused);
+                vb2_set_plane_payload(vb, 0, bytesused ? : opb_sz);
               vb->planes[0].data_offset =3D data_offset;
               vb->timestamp =3D timestamp_us * NSEC_PER_USEC;
               vbuf->sequence =3D inst->sequence_cap++;

It works fine for me, and should not return 0 more often than it did
before (i.e. never). In practice I also never see the firmware
reporting a payload of zero on SDM845, but maybe older chips differ?
