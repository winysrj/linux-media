Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:33912 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbeJWL2k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Oct 2018 07:28:40 -0400
Received: by mail-yb1-f196.google.com with SMTP id n140-v6so2217820yba.1
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2018 20:07:19 -0700 (PDT)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id z11-v6sm9395111ywl.36.2018.10.22.20.07.17
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Oct 2018 20:07:17 -0700 (PDT)
Received: by mail-yw1-f46.google.com with SMTP id v1-v6so16865766ywv.6
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2018 20:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <1539071634-1644-1-git-send-email-mgottam@codeaurora.org>
 <CAPBb6MUt_V4zEKGcRYXRXNRVdjF2uspOvEj0T-dH6dBZ9ya9CA@mail.gmail.com>
 <f1bb2ead-fe8e-af6a-1b96-9460a7b01f29@linaro.org> <CAPBb6MXxaGMCY43fXwWYZmYmiVwDA6kdJRwWZGqUHhWOGXSz7Q@mail.gmail.com>
 <40d15ea4-48e2-b2c7-1d70-68dcc1b08990@linaro.org> <CAPBb6MU9mV9_iq6cf-BzzhTFsed5vtjTui669jxq2uF8KenhQQ@mail.gmail.com>
In-Reply-To: <CAPBb6MU9mV9_iq6cf-BzzhTFsed5vtjTui669jxq2uF8KenhQQ@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 23 Oct 2018 12:07:05 +0900
Message-ID: <CAAFQd5BfNxBwEPaZvxbYpmvZw1WvynWV6NrUocm5vmXQNQf8uQ@mail.gmail.com>
Subject: Re: [PATCH] media: venus: add support for key frame
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        mgottam@codeaurora.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 22, 2018 at 3:15 PM Alexandre Courbot <acourbot@chromium.org> wrote:
>
> On Fri, Oct 12, 2018 at 5:10 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
> >
> >
> >
> > On 10/12/2018 11:06 AM, Alexandre Courbot wrote:
> > > On Fri, Oct 12, 2018 at 4:37 PM Stanimir Varbanov
> > > <stanimir.varbanov@linaro.org> wrote:
> > >>
> > >> Hi Alex,
> > >>
> > >> On 10/12/2018 08:26 AM, Alexandre Courbot wrote:
> > >>> On Tue, Oct 9, 2018 at 4:54 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
> > >>>>
> > >>>> When client requests for a keyframe, set the property
> > >>>> to hardware to generate the sync frame.
> > >>>>
> > >>>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> > >>>> ---
> > >>>>  drivers/media/platform/qcom/venus/venc_ctrls.c | 13 +++++++++++++
> > >>>>  1 file changed, 13 insertions(+)
> > >>>>
> > >>>> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
> > >>>> index 45910172..f332c8e 100644
> > >>>> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
> > >>>> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
> > >>>> @@ -81,6 +81,8 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
> > >>>>         struct venc_controls *ctr = &inst->controls.enc;
> > >>>>         u32 bframes;
> > >>>>         int ret;
> > >>>> +       void *ptr;
> > >>>> +       u32 ptype;
> > >>>>
> > >>>>         switch (ctrl->id) {
> > >>>>         case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
> > >>>> @@ -173,6 +175,14 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
> > >>>>
> > >>>>                 ctr->num_b_frames = bframes;
> > >>>>                 break;
> > >>>> +       case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
> > >>>> +               ptype = HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME;
> > >>>> +               ret = hfi_session_set_property(inst, ptype, ptr);
> > >>>
> > >>> The test bot already said it, but ptr is passed to
> > >>> hfi_session_set_property() uninitialized. And as can be expected the
> > >>> call returns -EINVAL on my board.
> > >>>
> > >>> Looking at other uses of HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME I
> > >>> see that the packet sent to the firmware does not have room for an
> > >>> argument, so I tried to pass NULL but got the same result.
> > >>
> > >> yes, because pdata cannot be NULL. I'd suggest to make a pointer to
> > >> struct hfi_enable and pass it to the set_property function.
> > >
> > > FWIW I also tried doing this and got the same error, strange...
> > >
> >
> > OK, when you calling the v4l control? It makes sense when you calling
> > it, because set_property checks does the session is on START state (i.e.
> > streamon on both queues).
>
> Do you mean that the property won't be actually applied unless both
> queues are streaming? In that case maybe it would make sense for the
> driver to save controls set before that and apply them when the
> conditions allow them to be effective?

Right. The driver cannot just drop a control setting on the floor if
it's not ready to apply it.

However, the V4L2 control framework already provides a tool to handle this:
 - the driver can ignore any .s_ctrl() calls when it can't apply the controls,
 - the driver must call v4l2_ctrl_handler_setup() when it initialized
the hardware, so that all the control values are applied in one go.

Best regards,
Tomasz
