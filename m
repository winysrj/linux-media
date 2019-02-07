Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D176C282C4
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 07:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB6C421900
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 07:33:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jccbRGRd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfBGHdr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 02:33:47 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38101 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbfBGHdp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 02:33:45 -0500
Received: by mail-ot1-f68.google.com with SMTP id e12so16677814otl.5
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 23:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vSUKBKl/Tf8DmzOVa470mD+o12FsuzjdLmZpv/qYgOQ=;
        b=jccbRGRdlpiKI+ibbgBNUiwbar2gkgub2YCzqJepTgyFPuMl/ZMMGcOmwUG2vril+O
         Rz46SGaIuSUaxK22Wkt1guUPC15GqqGD9Bobphvp5ZQyFms1bVcyBeiSfhtRmW0Bgc6k
         8qsp6qtkHCrGfOiE+7FmDcudh4tJOx+UH17rI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vSUKBKl/Tf8DmzOVa470mD+o12FsuzjdLmZpv/qYgOQ=;
        b=S3RqGvE2JQLelrWV4rDkmkdNrTmW+cDotQ3tjI3l8pgT6DURfoGXHchW1jZUq6sl59
         6Yp/VGnU68FNbtJpTH8COYYA23BtQLGZYohsNn7SbcnehqXsY7RSzxcx7hg1O9cqTE9C
         3eUaDEwFFsDTBRWx6aRRbQL1oxGb6/uLeNnsB+hresFNmo2YNPIU6XkhTujnoaM2V5fQ
         Xl/LWKezhOl2EMgsYHx+Wtxhlu1wCIxxd5/OUi+x9ecW6TB4XIzZHigkTnKe8QpG97S2
         YaKyPr4/TQltNlnrtc87XeB1au2PUgch95JmN3xdOXvb+uo5fFMhK+R2vU9cxfyFabH8
         KHGg==
X-Gm-Message-State: AHQUAuYQeP9UZpddDfuPeYe9Q8mqN/ggll1/ar77NIShj88P7MlvqEmp
        f7yyXPxHJGP3y/OdYMnOwPvhlfvIqPY=
X-Google-Smtp-Source: AHgI3IZ0bCInDdQ/iVAHOeV7CohOfkptRbp71GCkc16o8WQIWUvIa40wgJbPSShOV7/DMycFLHW2Dg==
X-Received: by 2002:aca:490c:: with SMTP id w12mr1902712oia.8.1549524823645;
        Wed, 06 Feb 2019 23:33:43 -0800 (PST)
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com. [209.85.210.41])
        by smtp.gmail.com with ESMTPSA id z7sm10365256otm.63.2019.02.06.23.33.40
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 23:33:41 -0800 (PST)
Received: by mail-ot1-f41.google.com with SMTP id k98so16720220otk.3
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 23:33:40 -0800 (PST)
X-Received: by 2002:a54:4d03:: with SMTP id v3mr1851551oix.173.1549524819832;
 Wed, 06 Feb 2019 23:33:39 -0800 (PST)
MIME-Version: 1.0
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-11-stanimir.varbanov@linaro.org> <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
 <28069a44-b188-6b89-2687-542fa762c00e@linaro.org> <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
 <affce842d4f015e13912b2c3941c9bf02e84d194.camel@ndufresne.ca>
 <CAAFQd5Ahg4Di+SBd+-kKo4PLVyvqLwcuG6MphU5Rz1PFXVuamQ@mail.gmail.com>
 <e8a90694c306fde24928a569b7bcb231b86ec73b.camel@ndufresne.ca>
 <CAAFQd5DFfQRd1VoN7itVXnWGKW_WBKU-sm6vo5CdgjkzjEEkFg@mail.gmail.com>
 <57419418d377f32d0e6978f4e4171c0da7357cbb.camel@ndufresne.ca>
 <1548938556.4585.1.camel@pengutronix.de> <CAAFQd5Aih7cWu-cfwBvNdwhHHYEaMF0SFebrYfdNXD9qKu8fxw@mail.gmail.com>
 <1f8485785a21c0b0e071a3a766ed2cbc727e47f6.camel@ndufresne.ca>
 <CAAFQd5CPKm1ES8c9Lab63Lr8ZfWRckHmJ99SVRYi6Hpe7hzy+g@mail.gmail.com>
 <f1e9dc99-4fcb-dee1-4279-ac0cf1d1fd6e@xs4all.nl> <CAAFQd5B+bt3SV_WRw1=2agZk=Q+Enbkv=nXCrbXX=+MNpeSpCg@mail.gmail.com>
 <cb8cda5d-e714-6019-4a76-3853ea49c4a6@xs4all.nl>
In-Reply-To: <cb8cda5d-e714-6019-4a76-3853ea49c4a6@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 7 Feb 2019 16:33:28 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BZhhX6Cjj7GhbaY_G7ERksyKne6hxKFCuTJoOnamoQ=A@mail.gmail.com>
Message-ID: <CAAFQd5BZhhX6Cjj7GhbaY_G7ERksyKne6hxKFCuTJoOnamoQ=A@mail.gmail.com>
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Feb 5, 2019 at 7:35 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 2/5/19 10:31 AM, Tomasz Figa wrote:
> > On Tue, Feb 5, 2019 at 6:00 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>
> >> On 2/5/19 7:26 AM, Tomasz Figa wrote:
> >>> On Fri, Feb 1, 2019 at 12:18 AM Nicolas Dufresne <nicolas@ndufresne.c=
a> wrote:
> >>>>
> >>>> Le jeudi 31 janvier 2019 =C3=A0 22:34 +0900, Tomasz Figa a =C3=A9cri=
t :
> >>>>> On Thu, Jan 31, 2019 at 9:42 PM Philipp Zabel <p.zabel@pengutronix.=
de> wrote:
> >>>>>> Hi Nicolas,
> >>>>>>
> >>>>>> On Wed, 2019-01-30 at 10:32 -0500, Nicolas Dufresne wrote:
> >>>>>>> Le mercredi 30 janvier 2019 =C3=A0 15:17 +0900, Tomasz Figa a =C3=
=A9crit :
> >>>>>>>>> I don't remember saying that, maybe I meant to say there might =
be a
> >>>>>>>>> workaround ?
> >>>>>>>>>
> >>>>>>>>> For the fact, here we queue the headers (or first frame):
> >>>>>>>>>
> >>>>>>>>> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/=
master/sys/v4l2/gstv4l2videodec.c#L624
> >>>>>>>>>
> >>>>>>>>> Then few line below this helper does G_FMT internally:
> >>>>>>>>>
> >>>>>>>>> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/=
master/sys/v4l2/gstv4l2videodec.c#L634
> >>>>>>>>> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/=
master/sys/v4l2/gstv4l2object.c#L3907
> >>>>>>>>>
> >>>>>>>>> And just plainly fails if G_FMT returns an error of any type. T=
his was
> >>>>>>>>> how Kamil designed it initially for MFC driver. There was no ot=
her
> >>>>>>>>> alternative back then (no EAGAIN yet either).
> >>>>>>>>
> >>>>>>>> Hmm, was that ffmpeg then?
> >>>>>>>>
> >>>>>>>> So would it just set the OUTPUT width and height to 0? Does it m=
ean
> >>>>>>>> that gstreamer doesn't work with coda and mtk-vcodec, which don'=
t have
> >>>>>>>> such wait in their g_fmt implementations?
> >>>>>>>
> >>>>>>> I don't know for MTK, I don't have the hardware and didn't integr=
ate
> >>>>>>> their vendor pixel format. For the CODA, I know it works, if ther=
e is
> >>>>>>> no wait in the G_FMT, then I suppose we are being really lucky wi=
th the
> >>>>>>> timing (it would be that the drivers process the SPS/PPS synchron=
ously,
> >>>>>>> and a simple lock in the G_FMT call is enough to wait). Adding Ph=
ilipp
> >>>>>>> in CC, he could explain how this works, I know they use GStreamer=
 in
> >>>>>>> production, and he would have fixed GStreamer already if that was
> >>>>>>> causing important issue.
> >>>>>>
> >>>>>> CODA predates the width/height=3D0 rule on the coded/OUTPUT queue.
> >>>>>> It currently behaves more like a traditional mem2mem device.
> >>>>>
> >>>>> The rule in the latest spec is that if width/height is 0 then CAPTU=
RE
> >>>>> format is determined only after the stream is parsed. Otherwise it'=
s
> >>>>> instantly deduced from the OUTPUT resolution.
> >>>>>
> >>>>>> When width/height is set via S_FMT(OUT) or output crop selection, =
the
> >>>>>> driver will believe it and set the same (rounded up to macroblock
> >>>>>> alignment) on the capture queue without ever having seen the SPS.
> >>>>>
> >>>>> That's why I asked whether gstreamer sets width and height of OUTPU=
T
> >>>>> to non-zero values. If so, there is no regression, as the specs mim=
ic
> >>>>> the coda behavior.
> >>>>
> >>>> I see, with Philipp's answer it explains why it works. Note that
> >>>> GStreamer sets the display size on the OUTPUT format (in fact we pas=
s
> >>>> as much information as we have, because a) it's generic code and b) =
it
> >>>> will be needed someday when we enable pre-allocation (REQBUFS before
> >>>> SPS/PPS is passed, to avoid the setup delay introduce by allocation,
> >>>> mostly seen with CMA base decoder). In any case, the driver reported
> >>>> display size should always be ignored in GStreamer, the only
> >>>> information we look at is the G_SELECTION for the case the x/y or th=
e
> >>>> cropping rectangle is non-zero.
> >>>>
> >>>> Note this can only work if the capture queue is not affected by the
> >>>> coded size, or if the round-up made by the driver is bigger or equal=
 to
> >>>> that coded size. I believe CODA falls into the first category, since
> >>>> the decoding happens in a separate set of buffers and are then de-ti=
led
> >>>> into the capture buffers (if understood correctly).
> >>>
> >>> Sounds like it would work only if coded size is equal to the visible
> >>> size (that GStreamer sets) rounded up to full macroblocks. Non-zero x
> >>> or y in the crop could be problematic too.
> >>>
> >>> Hans, what's your view on this? Should we require G_FMT(CAPTURE) to
> >>> wait until a format becomes available or the OUTPUT queue runs out of
> >>
> >> You mean CAPTURE queue? If not, then I don't understand that part.
> >
> > No, I exactly meant the OUTPUT queue. The behavior of s5p-mfc in case
> > of the format not being detected yet is to waits for any pending
> > bitstream buffers to be processed by the decoder before returning an
> > error.
> >
> > See https://elixir.bootlin.com/linux/v5.0-rc5/source/drivers/media/plat=
form/s5p-mfc/s5p_mfc_dec.c#L329
>
> It blocks?! That shouldn't happen. Totally against the spec.
>

Yeah and that's what this patch tries to implement in venus as well
and is seemingly required for compatibility with gstreamer...

> > .
> >
> >>
> >>> buffers?
> >>
> >> First see my comment here regarding G_FMT returning an error:
> >>
> >> https://www.spinics.net/lists/linux-media/msg146505.html
> >>
> >> In my view that is a bad idea.
> >
> > I don't like it either, but it seemed to be the most consistent and
> > compatible behavior, but I'm not sure anymore.
> >
> >>
> >> What G_FMT should return between the time a resolution change was
> >> detected and the CAPTURE queue being drained (i.e. the old or the new
> >> resolution?) is something I am not sure about.
> >
> > Note that we're talking here about the initial stream information
> > detection, when the driver doesn't have any information needed to
> > determine the CAPTURE format yet.
>
> IMHO the driver should just start off with some default format, it
> really doesn't matter what that is.
>

I guess that's fine indeed.

> This initial situation is really just a Seek operation: you have a format=
,
> you seek to a new position and when you find the resolution of the
> first frame in the bitstream it triggers a SOURCE_CHANGE event. Actually,
> to be really consistent with the Seek: you only need to trigger this even=
t
> if 1) the new resolution is different from the current format, or 2) the
> capture queue is empty. 2) will never happen during a normal Seek, so
> that's a little bit special to this initial situation.

Having the error returned allowed the applications to handle the
initial parsing without the event, though. It could have waited for
all the OUTPUT buffers to be dequeued and then call G_FMT to check if
that was enough data to obtain the format.

>
> The only open question is what should be done with any CAPTURE buffers
> that the application may have queued? Return one buffer with bytesused
> set to 0 and the LAST flag set? I think that would be consistent with
> the specification. I think this situation can happen during a regular
> seek operation as well.

Yes, that would be reasonably consistent.

>
> >
> >>
> >> On the one hand it is desirable to have the new resolution asap, on
> >> the other hand, returning the new resolution would mean that the
> >> returned format is inconsistent with the capture buffer sizes.
> >>
> >> I'm leaning towards either returning the new resolution.
> >
> > Is the "or ..." part of the sentence missing?
>
> Sorry, 'either' should be dropped from that sentence.
>

Got it, thanks for clarification.

> >
> > One of the major concerns was that we needed to completely stall the
> > pipeline in case of a resolution change, which made it hard to deliver
> > a seamless transition to the users. An idea that comes to my mind
> > would be extending the source change event to actually include the
> > v4l2_format struct describing the new format. Then the CAPTURE queue
> > could keep the old format until it is drained, which should work fine
> > for existing applications, while the new ones could use the new event
> > data to determine if the buffers need to be reallocated.
>
> In my opinion G_FMT should return the new resolution after the
> SOURCE_CHANGE event was sent. So you know the new resolution at that
> point even though there may still be capture buffers pending with the
> old resolution.

Agreed. That's how it's defined in current version.

>
> What would be nice to have though is that the resolution could be part
> of v4l2_buffer. So as long as the new resolution would still fit inside
> the allocated buffers, you could just continue decoding without having
> to send a SOURCE_CHANGE event.

Hmm, I'm not sure I follow. What we effectively care about when
deciding if we can continue decoding is whether the new sizeimage is
less or equal to the current buffer size. However we still need to
tell the application that the geometry changed. Otherwise it would
have to call G_FMT and G_SELECTION every frame and compare with
previous frame.

>
> > <pipe dream>Ideally we would have all the metadata, including formats,
> > unified into a single property (or control) -like interface and tied
> > to buffers using Request API...</pipe dream>
>
> We will very likely create replacement streaming I/O ioctls later this
> year using a new v4l2_ext_buffer struct. I already had plans to store
> things like the colorspace info and resolution into that struct.
>
> So a perfectly doable solution would be that when the application starts
> to use these new ioctls, then the SOURCE_CHANGE event would only have
> to be sent if the new resolution would no longer fit inside the buffers.
> I.e., they would need to be reallocated.
>
> But we're not there yet.

I know. Just trying to put some significance on this API redesign. :)

Best regards,
Tomasz
