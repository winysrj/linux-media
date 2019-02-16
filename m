Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A568C43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 21:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1674621A49
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 21:14:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="wsaJ5Z3U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733022AbfBPVOF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 16:14:05 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43703 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbfBPVOF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 16:14:05 -0500
Received: by mail-wr1-f66.google.com with SMTP id r2so13972463wrv.10
        for <linux-media@vger.kernel.org>; Sat, 16 Feb 2019 13:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XLWwMa28dSSYr3MOTEObp8x0CcKw6O+pL5d0np32qwA=;
        b=wsaJ5Z3UTFOXUfoYZ6Q+PvbV25Zg3N0pO6CTS+ygsmOMlRDcUHuoQBsW1MISjKkBgb
         q0CpDlxJGS60Mzk5+D8H8W9d2fdasi9N1WWqNvhHiuRF1cQVdWIRoe1M5OReQtY6qA4Z
         8zADeb8qnSp1z7qN8gb+uYdu9slzahzqE6ogMIb3o2urhodvcEsyWFhUcLEebCz9dGle
         Ymu3UX6ToHgL7L8OVTGVxruOeA/4YC/GdkryQVm5+Y5/Zl+E52jeX+rnDkIxHpplc07r
         tY35cf+2NgYX9gDvyKcj5Xd/ysSkrYo2oaPr7FRayH+/gfljLK4m5kHoxdS7o7xfSTvv
         /VEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XLWwMa28dSSYr3MOTEObp8x0CcKw6O+pL5d0np32qwA=;
        b=IGo4nGENoSesdaZrg13HHcG3ES2xAA5Mk7c+KzyKbin9XR5FrWdB1KzSTWee2CLfhk
         xCxH376/dhYOJVNxlwqZKiEABD5esHIyVwfidka74uoGXj4G0kdoYEdM2d9ARUNxXICV
         F44qtIFnkAqG9tFI+1uu36vzfpnxRTrHcUmHCez3toJN5bbA1gA9Iyu2sjpuPm1rWk6s
         eOVOcNyilLhGWIJJsIOsVw5YlMRt8I/SmSNhPoZmUypkd6BY2/wRuPi23bmATo5W/lxu
         cFotSvWIgMp/Kl4pPGybbzenQ+WM14p1DSAW1gRA4qcdAYxBO0wkRet/VnxPOVKk+tD1
         1LJw==
X-Gm-Message-State: AHQUAub4sSj5ilc12+/LNmdglhNGX+4VWQGjarN+OKdYoVItVnJngBLd
        DAhGIz+VMx2pAg1YNe6wdo0CMcU16Py+T/I7kSXfHw==
X-Google-Smtp-Source: AHgI3IZki5BG2lCyzc58WBKqa7tfdYDJZ9NG0HMihMnALu6bxC3HbFK3rJsHgk4HgG8fmOtStd6AX900dQfV/wZkar4=
X-Received: by 2002:adf:ba8d:: with SMTP id p13mr11896485wrg.53.1550351642643;
 Sat, 16 Feb 2019 13:14:02 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU2aA-RrQbHrVa7eV4nZjUsbA9z42Dm0iVeOuWbgO=PtfQ@mail.gmail.com>
 <1417dde5-ecd5-354e-2ed1-9be4d26ce104@xs4all.nl> <5cbdf827-cc3c-4b22-a7ed-31c44419b7b9@xs4all.nl>
 <CAKQmDh-9NG50r2WsJYief4QKpW_sVcWs3oK0RSz+9MGKbPamxQ@mail.gmail.com> <70182eba-dd35-9ac3-b762-9a49ee017be9@xs4all.nl>
In-Reply-To: <70182eba-dd35-9ac3-b762-9a49ee017be9@xs4all.nl>
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
Date:   Sat, 16 Feb 2019 16:13:50 -0500
Message-ID: <CAKQmDh8H+qA2+69tDDbBiyh8_7EXjznbdh-pR8-zi0QzxOMHWw@mail.gmail.com>
Subject: Re: v4l2 mem2mem compose support?
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Carlos Rafael Giani <dv@pseudoterminal.org>,
        Discussion of the development of and with GStreamer 
        <gstreamer-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le sam. 16 f=C3=A9vr. 2019 =C3=A0 13:40, Hans Verkuil <hverkuil@xs4all.nl> =
a =C3=A9crit :
>
> On 2/16/19 4:42 PM, Nicolas Dufresne wrote:
> > Le sam. 16 f=C3=A9vr. 2019 =C3=A0 04:48, Hans Verkuil <hverkuil@xs4all.=
nl> a =C3=A9crit :
> >>
> >> On 2/16/19 10:42 AM, Hans Verkuil wrote:
> >>> On 2/16/19 1:16 AM, Tim Harvey wrote:
> >>>> Greetings,
> >>>>
> >>>> What is needed to be able to take advantage of hardware video
> >>>> composing capabilities and make them available in something like
> >>>> GStreamer?
> >>>
> >>> Are you talking about what is needed in a driver or what is needed in
> >>> gstreamer? Or both?
> >>>
> >>> In any case, the driver needs to support the V4L2 selection API, spec=
ifically
> >>> the compose target rectangle for the video capture.
> >>
> >> I forgot to mention that the driver should allow the compose rectangle=
 to
> >> be anywhere within the bounding rectangle as set by S_FMT(CAPTURE).
> >>
> >> In addition, this also means that the DMA has to be able to do scatter=
-gather,
> >> which I believe is not the case for the imx m2m hardware.
> >
> > I believe the 2D blitter can take an arbitrary source rectangle and
> > compose it to an arbitrary destination rectangle (a lot of these will
> > in fact use Q16 coordinate, allowing for subpixel rectangle, something
> > that V4L2 does not support).
>
> Not entirely true. I think this can be done through the selection API,
> although it would require some updating of the spec and perhaps the
> introduction of a field or flag. The original VIDIOC_CROPCAP and VIDIOC_C=
ROP
> ioctls actually could do this since with analog video (e.g. S-Video) you
> did not really have the concept of a 'pixel'. It's an analog waveform aft=
er
> all. In principle the selection API works in the same way, even though th=
e
> documentation always assumes that the selection rectangles map directly o=
n
> the digitized pixels. I'm not sure if there are still drivers that report
> different crop bounds in CROPCAP compared to actual number of digitized p=
ixels.
> The bttv driver is most likely to do that, but I haven't checked.
>
> Doing so made it very hard to understand, though.
>
>  I don't think this driver exist in any
> > form upstream on IMX side. The Rockchip dev tried to get one in
> > recently, but the discussion didn't go so well with  the rejection of
> > the proposed porter duff controls was probably devoting, as picking
> > the right blending algorithm is the basic of such driver.
>
> I tried to find the reason why the Porter Duff control was dropped in v8
> of the rockchip RGA patch series back in 2017.
>
> I can't find any discussion about it on the mailinglist, so perhaps it
> was discussed on irc.
>
> Do you remember why it was removed?

I'll try and retrace what happened, it was not a nack, and I realize
that "rejection" wasn't the right word, but if I remember, the focus
in the review went fully around this and the fact that it was doing
blending which such API, while the original intention with the driver
was to have CSC, so removing this was basically a way forward.

>
> >
> > I believe a better approach for upstreaming such driver would be to
> > write an M2M spec specific to that type of m2m drivers. That spec
> > would cover scalers and rotators, since unlike the IPUv3 (which I
> > believe you are referring too) a lot of the CSC and Scaler are
> > blitters.
>
> No, I was referring to the imx m2m driver that Phillip is working on.

I'll need  to check what driver Veolab was using, but if it's the
same, then maybe it only do source-over operations using SELECTION as
you described. If I remember their use case, they where doing simple
source-over blending of two video feeds.

Could it be this ?
https://gitlab.com/veo-labs/linux/tree/veobox/drivers/staging/media/imx6/m2=
m
Is it an ancester of Philipp's driver ?

>
> >
> > Why we need a spec, this is because unlike most of our current driver,
> > the buffers passed to CAPTURE aren't always empty buffers. This may
> > have implementation that are ambiguous in current spec. The second is
> > to avoid having to deal with legacy implementation, like we have with
> > decoders.
>
> Why would this be ambiguous? A driver that can do this can set the
> COMPOSE rectangle for the CAPTURE queue basically anywhere within the
> buffer and V4L2_SEL_TGT_COMPOSE_PADDED either does not exist or is
> equal to the COMPOSE rectangle.
>
> A driver that isn't able to do scatter-gather DMA will overwrite pixels,
> and so COMPOSE_PADDED will be larger than the COMPOSE rectangle and
> thus such a driver cannot be used for composing into a buffer that alread=
y
> contains video data.
>
> I might misunderstand you, though.

Slightly, I said that there MAY exist ambiguity, I haven't went
through everything to figure-out yet. But we can also consider that it
needs spec simply because of the lack of classification.

I'm not commenting about the technical aspect of the data transfer, as
I don't know too well these thing. What I'm guessing though is that
you aren't sure whether this can be done "in-place", which means that
the final image and the image we compose to can be the same memory
buffer. If not, I suppose we might not be able to do a blend operation
with the current API, at it would require 3 buffers (hence 3 queues),
with a full write into the final buffer.

I've seen tentative with passing two OUTPUT buffers and getting one
CAPTURE buffer that would be the composition, but that approach is too
inflexible, the source and destination buffers would need to have the
same size. This is a better fit for deinterlacing I suppose.

>
> Regards,
>
>         Hans
>
> >
> >>
> >> Regards,
> >>
> >>         Hans
> >>
> >>>
> >>> Regards,
> >>>
> >>>       Hans
> >>>
> >>>>
> >>>> Philipp's mem2mem driver [1] exposes the IMX IC and GStreamer's
> >>>> v4l2convert element uses this nicely for hardware accelerated
> >>>> scaling/csc/flip/rotate but what I'm looking for is something that
> >>>> extends that concept and allows for composing frames from multiple
> >>>> video capture devices into a single memory buffer which could then b=
e
> >>>> encoded as a single stream.
> >>>>
> >>>> This was made possible by Carlo's gstreamer-imx [2] GStreamer plugin=
s
> >>>> paired with the Freescale kernel that had some non-mainlined API's t=
o
> >>>> the IMX IPU and GPU. We have used this to take for example 8x analog
> >>>> capture inputs, compose them into a single frame then H264 encode an=
d
> >>>> stream it. The gstreamer-imx elements used fairly compatible
> >>>> properties as the GstCompositorPad element to provide a destination
> >>>> rect within the compose output buffer as well as rotation/flip, alph=
a
> >>>> blending and the ability to specify background fill.
> >>>>
> >>>> Is it possible that some of this capability might be available today
> >>>> with the opengl GStreamer elements?
> >>>>
> >>>> Best Regards,
> >>>>
> >>>> Tim
> >>>>
> >>>> [1] https://patchwork.kernel.org/patch/10768463/
> >>>> [2] https://github.com/Freescale/gstreamer-imx
> >>>>
> >>>
> >>
>
