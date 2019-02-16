Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72506C43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 15:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36168222E0
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 15:42:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="CTgWm+3g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbfBPPmo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 10:42:44 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45615 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbfBPPmo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 10:42:44 -0500
Received: by mail-wr1-f66.google.com with SMTP id w17so13341190wrn.12
        for <linux-media@vger.kernel.org>; Sat, 16 Feb 2019 07:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/chJD2ZWh7C0eQoD5p9pcEQqTbeX6SiUCTjdiwUoi5A=;
        b=CTgWm+3gPGzc3vqYXGV/Zy7hI4MPfRpCcBFdMTfp28b/KP+7HQpqL+iR/S3J0F6eZ/
         TbjHOMMPMMtp5GCS23FmEW/pAIR97JoVGSgApZmdS9EQf/OcISFXZHa3oZR49HtljwFN
         RHxmN9GNBhHuF0ukpyjvWP6zVyvmdaIAe1vN7yIE27V/GsUdZPK2PWfL0Zv2MhqWXLpp
         XQyjvW1iX8E/zvwq4FZddXJKxiix2xHGFc3fFcRwSQbN/QlIyYH+GcxwIXRHVlSLHn1t
         VcMH4vY3Qcsi8/9/jno8goYDAfsOGlFROX0C8A0a3CWcu+IPwhlRalzXa0lYIuy+n/Rk
         8CyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/chJD2ZWh7C0eQoD5p9pcEQqTbeX6SiUCTjdiwUoi5A=;
        b=E/WcqcMZbBcUASuZGSt6qxuSY5GKqruHylAJ2lZReKdNk+RA4MDUdkSbGiLOlI4oPk
         broMt0y0nnij+niebrn6BEPvlMbiHRDvaOPQiFSFkm044MVyLciQhgBtDqzWMmYqaKaG
         WK4DPXrnYHyVU9S7ohuL24OHXhIqnytSaPOsAjVS0P+6QzarEb/+R+flnAKh0NwB3ibF
         jTP8rrHnwWx4KEBap/0jJNknN8YN9Dp0Syzu4Bxj9m7+EE1hoK72HGsnFqPFdXvSe8r7
         yi+ZRmfF1oDspNng0DLOg6VvQ29hB08I5T0erIIvPlDO6RPMp4TRCVHfWYDghzeKrS9z
         Ryow==
X-Gm-Message-State: AHQUAubRZeapXmn1RZVX55QCY9zULLUhxZoMRK0k5J2WaCZNLEBSg1Vd
        lrckyjr6C+X1QSZCzcTIogNy2z36+NM7hN/I/JsnRA==
X-Google-Smtp-Source: AHgI3IZwO27rpOldz1rIyxVAcjlVranMFixdVAvMDOXRUZNPqmfsptYQvomH458sn9+fyLgDO6+O23gK5GgIkbM3erc=
X-Received: by 2002:adf:face:: with SMTP id a14mr3152296wrs.320.1550331762242;
 Sat, 16 Feb 2019 07:42:42 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU2aA-RrQbHrVa7eV4nZjUsbA9z42Dm0iVeOuWbgO=PtfQ@mail.gmail.com>
 <1417dde5-ecd5-354e-2ed1-9be4d26ce104@xs4all.nl> <5cbdf827-cc3c-4b22-a7ed-31c44419b7b9@xs4all.nl>
In-Reply-To: <5cbdf827-cc3c-4b22-a7ed-31c44419b7b9@xs4all.nl>
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
Date:   Sat, 16 Feb 2019 10:42:30 -0500
Message-ID: <CAKQmDh-9NG50r2WsJYief4QKpW_sVcWs3oK0RSz+9MGKbPamxQ@mail.gmail.com>
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

Le sam. 16 f=C3=A9vr. 2019 =C3=A0 04:48, Hans Verkuil <hverkuil@xs4all.nl> =
a =C3=A9crit :
>
> On 2/16/19 10:42 AM, Hans Verkuil wrote:
> > On 2/16/19 1:16 AM, Tim Harvey wrote:
> >> Greetings,
> >>
> >> What is needed to be able to take advantage of hardware video
> >> composing capabilities and make them available in something like
> >> GStreamer?
> >
> > Are you talking about what is needed in a driver or what is needed in
> > gstreamer? Or both?
> >
> > In any case, the driver needs to support the V4L2 selection API, specif=
ically
> > the compose target rectangle for the video capture.
>
> I forgot to mention that the driver should allow the compose rectangle to
> be anywhere within the bounding rectangle as set by S_FMT(CAPTURE).
>
> In addition, this also means that the DMA has to be able to do scatter-ga=
ther,
> which I believe is not the case for the imx m2m hardware.

I believe the 2D blitter can take an arbitrary source rectangle and
compose it to an arbitrary destination rectangle (a lot of these will
in fact use Q16 coordinate, allowing for subpixel rectangle, something
that V4L2 does not support). I don't think this driver exist in any
form upstream on IMX side. The Rockchip dev tried to get one in
recently, but the discussion didn't go so well with  the rejection of
the proposed porter duff controls was probably devoting, as picking
the right blending algorithm is the basic of such driver.

I believe a better approach for upstreaming such driver would be to
write an M2M spec specific to that type of m2m drivers. That spec
would cover scalers and rotators, since unlike the IPUv3 (which I
believe you are referring too) a lot of the CSC and Scaler are
blitters.

Why we need a spec, this is because unlike most of our current driver,
the buffers passed to CAPTURE aren't always empty buffers. This may
have implementation that are ambiguous in current spec. The second is
to avoid having to deal with legacy implementation, like we have with
decoders.

>
> Regards,
>
>         Hans
>
> >
> > Regards,
> >
> >       Hans
> >
> >>
> >> Philipp's mem2mem driver [1] exposes the IMX IC and GStreamer's
> >> v4l2convert element uses this nicely for hardware accelerated
> >> scaling/csc/flip/rotate but what I'm looking for is something that
> >> extends that concept and allows for composing frames from multiple
> >> video capture devices into a single memory buffer which could then be
> >> encoded as a single stream.
> >>
> >> This was made possible by Carlo's gstreamer-imx [2] GStreamer plugins
> >> paired with the Freescale kernel that had some non-mainlined API's to
> >> the IMX IPU and GPU. We have used this to take for example 8x analog
> >> capture inputs, compose them into a single frame then H264 encode and
> >> stream it. The gstreamer-imx elements used fairly compatible
> >> properties as the GstCompositorPad element to provide a destination
> >> rect within the compose output buffer as well as rotation/flip, alpha
> >> blending and the ability to specify background fill.
> >>
> >> Is it possible that some of this capability might be available today
> >> with the opengl GStreamer elements?
> >>
> >> Best Regards,
> >>
> >> Tim
> >>
> >> [1] https://patchwork.kernel.org/patch/10768463/
> >> [2] https://github.com/Freescale/gstreamer-imx
> >>
> >
>
