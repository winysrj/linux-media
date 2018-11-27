Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36251 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbeK0TNb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 14:13:31 -0500
Received: by mail-oi1-f193.google.com with SMTP id x23so18533051oix.3
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2018 00:16:26 -0800 (PST)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com. [209.85.210.54])
        by smtp.gmail.com with ESMTPSA id t201sm883592oie.37.2018.11.27.00.16.24
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Nov 2018 00:16:25 -0800 (PST)
Received: by mail-ot1-f54.google.com with SMTP id g27so19324211oth.6
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2018 00:16:24 -0800 (PST)
MIME-Version: 1.0
References: <1543227173-2160-1-git-send-email-mgottam@codeaurora.org>
 <d74281c8-a177-12a3-9e72-7a7db3014943@xs4all.nl> <f6106d20-abee-979c-8ac1-6c9115e8373c@linaro.org>
 <57b28a7f-8c5c-22d2-2f89-e6d6ebdcb8a2@xs4all.nl> <CAAFQd5DJn-_y5dHySAB6_ed-syBOr3Ybo7KfsPLNd+0Z7X0N7g@mail.gmail.com>
 <2a8bbdf7-cec6-4bdf-5833-93d5014ddf89@xs4all.nl> <CAAFQd5BijN58EkxHmCPuJO1TnoTiB5CjoA5uuKHzi_1SD0iawQ@mail.gmail.com>
 <a7652127-a302-fdd8-a8d8-9d184e933988@xs4all.nl>
In-Reply-To: <a7652127-a302-fdd8-a8d8-9d184e933988@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 27 Nov 2018 17:16:12 +0900
Message-ID: <CAPBb6MXQoF06EzScSN2KTdnDCH018agbiaSiSdYzaSaqM5tHKg@mail.gmail.com>
Subject: Re: [PATCH v3] media: venus: amend buffer size for bitstream plane
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        mgottam@codeaurora.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Nov 27, 2018 at 1:41 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 11/26/2018 05:07 PM, Tomasz Figa wrote:
> > On Tue, Nov 27, 2018 at 1:00 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>
> >> On 11/26/2018 04:44 PM, Tomasz Figa wrote:
> >>> Hi Hans,
> >>>
> >>> On Tue, Nov 27, 2018 at 12:24 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>>>
> >>>> On 11/26/2018 03:57 PM, Stanimir Varbanov wrote:
> >>>>> Hi Hans,
> >>>>>
> >>>>> On 11/26/18 3:37 PM, Hans Verkuil wrote:
> >>>>>> On 11/26/2018 11:12 AM, Malathi Gottam wrote:
> >>>>>>> Accept the buffer size requested by client and compare it
> >>>>>>> against driver calculated size and set the maximum to
> >>>>>>> bitstream plane.
> >>>>>>>
> >>>>>>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> >>>>>>
> >>>>>> Sorry, this isn't allowed. It is the driver that sets the sizeimage value,
> >>>>>> never the other way around.
> >>>>>
> >>>>> I think for decoders (OUTPUT queue) and encoders (CAPTURE queue) we
> >>>>> allowed userspace to set sizeimage for buffers. See [1] Initialization
> >>>>> paragraph point 2:
> >>>>>
> >>>>>     ``sizeimage``
> >>>>>        desired size of ``CAPTURE`` buffers; the encoder may adjust it to
> >>>>>        match hardware requirements
> >>>>>
> >>>>> Similar patch we be needed for decoder as well.
> >>>>
> >>>> I may have missed that change since it wasn't present in v1 of the stateful
> >>>> encoder spec.
> >>>
> >>> It's been there from the very beginning, even before I started working
> >>> on it. Actually, even the early slides from Kamil mention the
> >>> application setting the buffer size for compressed streams:
> >>> https://events.static.linuxfound.org/images/stories/pdf/lceu2012_debski.pdf
> >>>
> >>>>
> >>>> Tomasz, what was the reason for this change? I vaguely remember some thread
> >>>> about this, but I forgot the details. Since this would be a departure of
> >>>> the current API this should be explained in more detail.
> >>>
> >>> The kernel is not the place to encode assumptions about optimal
> >>> bitstream chunk sizes. It depends on the use case and the application
> >>> should be able decide. It may for example want to use smaller buffers,
> >>> optimizing for the well compressible video streams and just reallocate
> >>> if bigger chunks are needed.
> >>>
> >>>>
> >>>> I don't really see the point of requiring userspace to fill this in. For
> >>>> stateful codecs it can just return some reasonable size. Possibly calculated
> >>>> using the provided width/height values or (if those are 0) some default value.
> >>>
> >>> How do we decide what's "reasonable"? Would it be reasonable for all
> >>> applications?
> >>
> >> In theory it should be the minimum size that the hardware supports. But it is
> >> silly to i.e. provide the size of one PAGE as the minimum. In practice you
> >> probably want to set sizeimage to something larger than that. Depending on
> >> the typical compression ratio perhaps 5 or 10% of what a raw YUV 4:2:0 frame
> >> would be.
> >>
> >>>
> >>>>
> >>>> Ditto for decoders.
> >>>>
> >>>> Stanimir, I certainly cannot merge this until this has been fully nailed down
> >>>> as it would be a departure from the current API.
> >>>
> >>> It would not be a departure, because I can see existing stateful
> >>> drivers behaving like that:
> >>> https://elixir.bootlin.com/linux/v4.20-rc4/source/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c#L1444
> >>> https://elixir.bootlin.com/linux/v4.20-rc4/source/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c#L469
> >>
> >> Yes, and that's out of spec. Clearly v4l2-compliance doesn't test for this.
> >> It should have been caught at least for the mtk driver.
> >>
> >
> > Perhaps we should make it a part of the spec then?
> >
> > Actually I'm not really sure if we can say that this is out of spec
> > There has been no clear spec for the stateful codecs for many years,
> > with drivers doing wildly whatever they like and applications ending
> > up relying on those quirks.
>
> The VIDIOC_S_FMT spec for v4l2_pix_format is quite clear that it is the
> driver that sets this value. The spec for v4l2_plane_pix_format is
> unfortunately not so clear.
>
> > My spec actually attempts to incorporate what was decided on the
> > earlier summits, including what's in Kamil's slides, the drivers are
> > already doing and existing applications rely on. The sizeimage
> > handling is just a part of it.
> >
> >>>
> >>> Also, Chromium has been setting the size on its own for long time
> >>> using its own heuristics.
> >>>
> >>>>
> >>>> And looking at the venus patch I do not see how it helps userspace.
> >>>>
> >>>> Regards,
> >>>>
> >>>>         Hans
> >>>>
> >>>>>
> >>>>>>
> >>>>>> If you need to allocate larger buffers, then use VIDIOC_CREATE_BUFS instead
> >>>>>> of VIDIOC_REQBUFS.
> >>>
> >>> CREATE_BUFS wouldn't work, because one needs to use TRY_FMT to obtain
> >>> a format for it and the format returned by it would have the sizeimage
> >>> as hardcoded in the driver...
> >>
> >> ???
> >>
> >> Userspace can change the sizeimage to whatever it wants before calling
> >> CREATE_BUFS as long as it is >= the sizeimage of the current format.
> >>
> >> If we want to allow smaller sizes, then I think that would not be
> >> unreasonable for stateful codecs. I actually think that drivers can
> >> already do this in queue_setup(), but the spec would have to be updated
> >> a bit.
> >
> > Existing applications rely on REQBUFS honoring the size they set in
> > sizeimage, though...
>
> REQBUFS, yes. But not CREATE_BUFS. Which is why that ioctl was added in the
> first place.
>
> However (and now I remember the real problem with CREATE_BUFS) the spec for
> CREATE_BUFS says that it will not change the provided sizeimage value. So
> any adjustments required due to specific alignment requirements won't be
> applied, all CREATE_BUFS can do is to reject it.
>
> So what this boils down to is a change to the spec:
>
> For compressed formats (and only those!) userspace can set sizeimage to a
> proposed value. The driver may either ignore it and just set its own value,
> or modify it to satisfy HW requirements. The returned value will be used
> by REQBUFS when it allocates buffers.
>
> I think this is reasonable, provided the spec is updated accordingly.
>
> As far as I can tell this shouldn't cause any backwards compatibility
> problems, and it should be easy to test in v4l2-compliance.

Do you mean that this patch is acceptable provided the stateful codec
specification is updated accordingly?

For our (Chromium) needs this seems to do the job, so:

Tested-by: Alexandre Courbot <acourbot@chromium.org>

Although I would like to also have the equivalent for the decoder's
OUTPUT queue, either as a v4 or a follow-up patch.
