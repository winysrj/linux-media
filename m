Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0770C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 13:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A41CE217D7
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 13:05:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CAjGqtRy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbfBSNF4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 08:05:56 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38439 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbfBSNFz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 08:05:55 -0500
Received: by mail-wm1-f66.google.com with SMTP id v26so2730956wmh.3
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2019 05:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/zPaoCavRyRUDDxrlSA+6Yq/3wEp2NA8meeh07bvZuM=;
        b=CAjGqtRymYbPL45a2osa5hRDMAkMd4+VmqPha+kg6ok3FCb8GeeX6sTEG6FxhJdbvU
         WrI8PkMl7IpBmV/sqxX/GDlCkrrqJAZ7PvfJ71L2qBsb+aBOYbBsLCNCqNG5GniOfXqQ
         Noqu4TD2sMo++TMmiCFQuFr8zesNUVvS7XR+KaOsMubqN+0cSKA21WoRZ2Y1iliu4+kp
         t/Dp5Z4ae5r5W8QC7DgeDgaFWd09YSJWSSBFB0JFlJPauBfuAjBVIzAcPQDy/3AH5wSb
         sYWQHWlF0Iv8dmAnAQZaiG/EhU9U9nKNK0A8+ElsZRun7hnoZIEbMx4J4qVcmuMx3IPL
         OkCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/zPaoCavRyRUDDxrlSA+6Yq/3wEp2NA8meeh07bvZuM=;
        b=kx7pJk59XBeir5VVxa+9DaZiBT4EN+ZfZMnUnqX8ZsJsJ8HeCASe8PxXHLpDPj6WeD
         /TdwaWolcIk3P3sDgJCBvMsikhRtSefMFVP/o5rt+Dmt/NqhUGChNftwvrdy75Xx/nED
         /lxLYB0NmyyyF6O4hQDayrJQpuzhqX/k3T9IaFycJ/Uqd+71gUME9AA82xCPIwGybFwl
         DeSL61AyP36SbMjFIxcnsUx32XqLCZkVDfW70WVy9ZIOwK8qSXx+YRBXPWEzPFPRqbFu
         XK6Nbo0XPsdjMZOY+zNPiHKA02UYq4tMx9UdBIFNExiQa5+D7ltxIEvs6lxCiQti9tBP
         FdHw==
X-Gm-Message-State: AHQUAubzrBa3IN8tV9UJaTKd4BZxRZ2butpspvacenRngX2WsmyeaIss
        RPngTg/F+9ViN60fCiNQiGsmgLgYHl8sTA1RpOw=
X-Google-Smtp-Source: AHgI3IYVSWEND/223DoSJl4tE5uWiT+ZkVrOh5DKI95pJVqo+RVCBSqi1sfVEd7gmFYT7ybg6tC+iLCEKLBUEJVDjOY=
X-Received: by 2002:a7b:cc93:: with SMTP id p19mr2859510wma.113.1550581552892;
 Tue, 19 Feb 2019 05:05:52 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU2aA-RrQbHrVa7eV4nZjUsbA9z42Dm0iVeOuWbgO=PtfQ@mail.gmail.com>
 <1417dde5-ecd5-354e-2ed1-9be4d26ce104@xs4all.nl> <5cbdf827-cc3c-4b22-a7ed-31c44419b7b9@xs4all.nl>
 <CAKQmDh-9NG50r2WsJYief4QKpW_sVcWs3oK0RSz+9MGKbPamxQ@mail.gmail.com>
 <70182eba-dd35-9ac3-b762-9a49ee017be9@xs4all.nl> <CAKQmDh8H+qA2+69tDDbBiyh8_7EXjznbdh-pR8-zi0QzxOMHWw@mail.gmail.com>
In-Reply-To: <CAKQmDh8H+qA2+69tDDbBiyh8_7EXjznbdh-pR8-zi0QzxOMHWw@mail.gmail.com>
From:   Jean-Michel Hautbois <jhautbois@gmail.com>
Date:   Tue, 19 Feb 2019 14:05:40 +0100
Message-ID: <CAL8zT=gb6JN6mCm5N0-gpU3aHG+-EsqKuji=QxS7o2u4CpxocA@mail.gmail.com>
Subject: Re: v4l2 mem2mem compose support?
To:     Discussion of the development of and with GStreamer 
        <gstreamer-devel@lists.freedesktop.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Carlos Rafael Giani <dv@pseudoterminal.org>,
        Tim Harvey <tharvey@gateworks.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        Jean-Michel Hautbois <jhautbois@gmail.com>,
        =?UTF-8?Q?S=C3=A9bastien_Matz?= <sebastien.matz@veo-labs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tim, Nicolas, all,

Le sam. 16 f=C3=A9vr. 2019 =C3=A0 22:14, Nicolas Dufresne <nicolas@ndufresn=
e.ca> a =C3=A9crit :
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

That's right. It is quite an old kernel, and I am confident it never
has been updated.
But the compositor based on this element is working fine.
I am not Veo-Labs anymore, but Sebastien in cc is, so if you want to
take the source code of the gstreamer elements created for the
occasion and give it a try, don't hesitate to get him in copy :).

This plugin should be upstreamable and as Nicolas said, it is not
i.MX6 related, but v4l2 m2m related. So it should be working with
every m2m element which has the SELECTION ops supported.
And it was tested with the basic v4l2m2m driver on a x86 laptop just
to validate the concept before getting it on an i.MX6.

Good luck !
JM
