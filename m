Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:37231 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbeITInw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 04:43:52 -0400
Received: by mail-yb1-f196.google.com with SMTP id b3-v6so2277120yba.4
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 20:02:46 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id g205-v6sm3071871ywb.23.2018.09.19.20.02.44
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Sep 2018 20:02:44 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id p206-v6so3171118ywg.12
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 20:02:44 -0700 (PDT)
MIME-Version: 1.0
References: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
 <01451f8e-aea3-b276-cb01-b0666a837d62@linaro.org> <4ce55726d810e308a2cae3f84bca7140bed48c7d.camel@ndufresne.ca>
 <92f6f79a-02ae-d23e-1b97-fc41fd921c89@linaro.org> <33e8d8e3-138e-0031-5b75-4bef114ac75e@xs4all.nl>
 <36b42952-982c-9048-77fb-72ca45cc7476@linaro.org> <051af6fb-e0e8-4008-99c5-9685ac24e454@xs4all.nl>
 <CAPBb6MVupMsdhF6Rtk4fm8JeVurrK+ZsuxAQ-BwrTzdSP1xP0Q@mail.gmail.com>
 <6d65ac0d-80a0-88fe-ed19-4785f2675e36@linaro.org> <bec2edfda26ecbac928871ad14d768790e3175a8.camel@ndufresne.ca>
In-Reply-To: <bec2edfda26ecbac928871ad14d768790e3175a8.camel@ndufresne.ca>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 20 Sep 2018 12:02:32 +0900
Message-ID: <CAAFQd5DoabbMiiDKOeAuwOztxamFUAoMD3_9Harpvd5O935WvQ@mail.gmail.com>
Subject: Re: [PATCH] venus: vdec: fix decoded data size
To: nicolas@ndufresne.ca,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, vgarodia@codeaurora.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 20, 2018 at 12:53 AM Nicolas Dufresne <nicolas@ndufresne.ca> wr=
ote:
>
> Le mercredi 19 septembre 2018 =C3=A0 18:02 +0300, Stanimir Varbanov a
> =C3=A9crit :
> > > --- a/drivers/media/platform/qcom/venus/vdec.c
> > > +++ b/drivers/media/platform/qcom/venus/vdec.c
> > > @@ -943,8 +943,7 @@ static void vdec_buf_done(struct venus_inst
> > > *inst,
> > > unsigned int buf_type,
> > >                 unsigned int opb_sz =3D
> > > venus_helper_get_opb_size(inst);
> > >
> > >                 vb =3D &vbuf->vb2_buf;
> > > -               vb->planes[0].bytesused =3D
> > > -                       max_t(unsigned int, opb_sz, bytesused);
> > > +                vb2_set_plane_payload(vb, 0, bytesused ? :
> > > opb_sz);
> > >                 vb->planes[0].data_offset =3D data_offset;
> > >                 vb->timestamp =3D timestamp_us * NSEC_PER_USEC;
> > >                 vbuf->sequence =3D inst->sequence_cap++;
> > >
> > > It works fine for me, and should not return 0 more often than it
> > > did
> > > before (i.e. never). In practice I also never see the firmware
> > > reporting a payload of zero on SDM845, but maybe older chips
> > > differ?
> >
> > yes, it looks fine. Let me test it with older versions.
>
> What about removing the allow_zero_bytesused flag on this specific
> queue ? Then you can leave it to 0, and the framework will change it to
> the buffer size.

First of all, why we would ever have 0 in bytesused?

That should never happen normally in the middle of decoding and if it
happens, then perhaps such buffer should be returned by the driver
with ERROR state or maybe just silently reused for further decoding.

The only cases where the value of 0 could happen could be EOS or end
of the drain sequence (explicit by STOP command or by resolution
change). In both cases, having 0 bytesused returned from the driver to
vb2 is perfectly fine, because such buffer would have the
V4L2_BUF_FLAG_LAST flag set anyway.

Best regards,
Tomasz
