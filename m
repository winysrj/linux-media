Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93DCC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 19:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E3972070D
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 19:49:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="tBhomDmA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfBVTth (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 14:49:37 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32993 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfBVTth (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 14:49:37 -0500
Received: by mail-wr1-f68.google.com with SMTP id i12so3650288wrw.0
        for <linux-media@vger.kernel.org>; Fri, 22 Feb 2019 11:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7AEHg+hLf6VIfrJXlM+ACCprR+a2MooY5VybCSgH4LY=;
        b=tBhomDmAyeMYnn6DVOGcEX9Ivu3/eIXOvLYrQlgX9+7hADL2B4vMu69b4dp4fYxP+u
         al1a0wZt9AruOL1pfT4x/pJkd8hI8VzXyhtpdEVchoJshERHx3LObktIeRuFDhphD4WT
         p/XcrwVlNtqI1DK5mcPIryuzzwmGnoQ8zvbIC01H0FhC7PzRGY+tJMVKV67gFahc+n4Y
         R/dnXslP+Y3w1bz+d9EYSWwHxIZDiOJGhToGqtEdu13jHC6UKLI6IWWaAt6Lb5RjYXg7
         Uud/dBc2ydvCZcnqkEH6uHKf5luWVH1AydrefGU++GF68gvCnhPJFknPEWkgxsJrHadz
         pjVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7AEHg+hLf6VIfrJXlM+ACCprR+a2MooY5VybCSgH4LY=;
        b=Kio36KDxI6Z1szkRGXd0rl/xD1lOGPQkQ9D0nZFanyn+0AjidCcJU0KoeLYpHIrNAC
         H1MeBSxnyMm9INFvN8LflZNDqdYjuRWD+tW3N9oNt6C+jakUUtDbu8l0+drrbUpYwm4w
         U3vRIKiUQTqzDu+X25Nbj0BR6i9t3uqu26DOMpcnCwRrPX0K/73yvVfj+EoM21X3Gsii
         Toxhp3+vFUefhb568Gc6oT7OapbuYfe6MGxFDoq33AeLihLqNdtdWra0ugh/GfsA310v
         P1eahZN6lD0I5q4sFO6ue5HQd8jThCEEZmvQpeBnMptKUlHb8lvCSZTlFQH5Ho86PYho
         SpJQ==
X-Gm-Message-State: AHQUAuaUGGiur9FoEzi8nFTkPX2R33A4RpbAoK/gogXQmjZaHs4Vq0j1
        ZMKg4d5Q3+qGvnncnnBeBSKwWlE/fOpmxvcvjAiQbg==
X-Google-Smtp-Source: AHgI3IbvaeGncvWZW3xrjedN9O+bFHrTpfE761K47mLqBy2M063Wa/PUzOWkDINQntL/6xaGxb7xfQdKhT6xlivNp0o=
X-Received: by 2002:adf:9b11:: with SMTP id b17mr4241394wrc.168.1550864974636;
 Fri, 22 Feb 2019 11:49:34 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU2aA-RrQbHrVa7eV4nZjUsbA9z42Dm0iVeOuWbgO=PtfQ@mail.gmail.com>
 <1417dde5-ecd5-354e-2ed1-9be4d26ce104@xs4all.nl> <5cbdf827-cc3c-4b22-a7ed-31c44419b7b9@xs4all.nl>
 <CAKQmDh-9NG50r2WsJYief4QKpW_sVcWs3oK0RSz+9MGKbPamxQ@mail.gmail.com>
 <70182eba-dd35-9ac3-b762-9a49ee017be9@xs4all.nl> <CAKQmDh8H+qA2+69tDDbBiyh8_7EXjznbdh-pR8-zi0QzxOMHWw@mail.gmail.com>
In-Reply-To: <CAKQmDh8H+qA2+69tDDbBiyh8_7EXjznbdh-pR8-zi0QzxOMHWw@mail.gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 22 Feb 2019 11:49:23 -0800
Message-ID: <CAJ+vNU3bs3zw_WSVLTuW3Wt6VzDOcDdPgbJJZQ6WRxUo+rbxdg@mail.gmail.com>
Subject: Re: v4l2 mem2mem compose support?
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media <linux-media@vger.kernel.org>,
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

On Sat, Feb 16, 2019 at 1:14 PM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
> Le sam. 16 f=C3=A9vr. 2019 =C3=A0 13:40, Hans Verkuil <hverkuil@xs4all.nl=
> a =C3=A9crit :
> >
> > On 2/16/19 4:42 PM, Nicolas Dufresne wrote:
> > > Le sam. 16 f=C3=A9vr. 2019 =C3=A0 04:48, Hans Verkuil <hverkuil@xs4al=
l.nl> a =C3=A9crit :
> > >>
> > >> On 2/16/19 10:42 AM, Hans Verkuil wrote:
> > >>> On 2/16/19 1:16 AM, Tim Harvey wrote:
> > >>>> Greetings,
> > >>>>
> > >>>> What is needed to be able to take advantage of hardware video
> > >>>> composing capabilities and make them available in something like
> > >>>> GStreamer?
> > >>>
> > >>> Are you talking about what is needed in a driver or what is needed =
in
> > >>> gstreamer? Or both?
> > >>>
> > >>> In any case, the driver needs to support the V4L2 selection API, sp=
ecifically
> > >>> the compose target rectangle for the video capture.
> > >>
> > >> I forgot to mention that the driver should allow the compose rectang=
le to
> > >> be anywhere within the bounding rectangle as set by S_FMT(CAPTURE).
> > >>
> > >> In addition, this also means that the DMA has to be able to do scatt=
er-gather,
> > >> which I believe is not the case for the imx m2m hardware.
> > >
> > > I believe the 2D blitter can take an arbitrary source rectangle and
> > > compose it to an arbitrary destination rectangle (a lot of these will
> > > in fact use Q16 coordinate, allowing for subpixel rectangle, somethin=
g
> > > that V4L2 does not support).
> >
> > Not entirely true. I think this can be done through the selection API,
> > although it would require some updating of the spec and perhaps the
> > introduction of a field or flag. The original VIDIOC_CROPCAP and VIDIOC=
_CROP
> > ioctls actually could do this since with analog video (e.g. S-Video) yo=
u
> > did not really have the concept of a 'pixel'. It's an analog waveform a=
fter
> > all. In principle the selection API works in the same way, even though =
the
> > documentation always assumes that the selection rectangles map directly=
 on
> > the digitized pixels. I'm not sure if there are still drivers that repo=
rt
> > different crop bounds in CROPCAP compared to actual number of digitized=
 pixels.
> > The bttv driver is most likely to do that, but I haven't checked.
> >
> > Doing so made it very hard to understand, though.
> >
> >  I don't think this driver exist in any
> > > form upstream on IMX side. The Rockchip dev tried to get one in
> > > recently, but the discussion didn't go so well with  the rejection of
> > > the proposed porter duff controls was probably devoting, as picking
> > > the right blending algorithm is the basic of such driver.
> >
> > I tried to find the reason why the Porter Duff control was dropped in v=
8
> > of the rockchip RGA patch series back in 2017.
> >
> > I can't find any discussion about it on the mailinglist, so perhaps it
> > was discussed on irc.
> >
> > Do you remember why it was removed?
>
> I'll try and retrace what happened, it was not a nack, and I realize
> that "rejection" wasn't the right word, but if I remember, the focus
> in the review went fully around this and the fact that it was doing
> blending which such API, while the original intention with the driver
> was to have CSC, so removing this was basically a way forward.
>
> >
> > >
> > > I believe a better approach for upstreaming such driver would be to
> > > write an M2M spec specific to that type of m2m drivers. That spec
> > > would cover scalers and rotators, since unlike the IPUv3 (which I
> > > believe you are referring too) a lot of the CSC and Scaler are
> > > blitters.
> >
> > No, I was referring to the imx m2m driver that Phillip is working on.
>
> I'll need  to check what driver Veolab was using, but if it's the
> same, then maybe it only do source-over operations using SELECTION as
> you described. If I remember their use case, they where doing simple
> source-over blending of two video feeds.
>
> Could it be this ?
> https://gitlab.com/veo-labs/linux/tree/veobox/drivers/staging/media/imx6/=
m2m
> Is it an ancester of Philipp's driver ?
>

It does look like this was an ancestor of Philipp's mem2mem driver
which is currently under review
(https://patchwork.kernel.org/project/linux-media/list/?series=3D67977)

Hans, can you give me a little more detail about what would be needed
in Phillipp's mem2mem driver to do this (or if its already there). I
imagine what we are talking about is being able to specify the
destination buffer and a rect within it.

I will take a look at the gstreamer plugin at
https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/issues/308
and see if I can get that building on top of master.

It sounds like that's a good path towards hardware accelerated composing.

Thanks!

Tim
