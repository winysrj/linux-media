Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FCBC10F03
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 04:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE89B20989
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 04:04:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lUtPNKeK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfCSEEO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 00:04:14 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43258 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfCSEEN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 00:04:13 -0400
Received: by mail-ot1-f65.google.com with SMTP id u15so6353578otq.10
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2019 21:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FxCVDx55J5+kHcmuGv45W+ZaMNUOkLZNHsAkDDnq18Y=;
        b=lUtPNKeKZSbonGnF8TWMGUP5R50nabnObsEyuWBm2wlpnICkYv1bxByYTQo1ni9g5L
         uT6pHpO4tfkpwVwJVzo5QW10t5sdhnz2fEPPoVZ47nhCWVgoHjKXiafM6Da/LajgJ6rv
         szrISKo2UA/FiqxWwFyMsx3vM7LIn+54RYES8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FxCVDx55J5+kHcmuGv45W+ZaMNUOkLZNHsAkDDnq18Y=;
        b=i4lRgSyWG/e6PSo+aRFd49CKF7NMPgk4RcCRgovChonsrz8e28k876eZ0DCV2KxX2A
         n+VE42YAWbnKZQ4ZEQ6FhWXRDJrFNccpNsbzU+TvyIsDa51WUJNcezRPen5HBGEqVhkA
         bFUH6kL7zqW+h2QbhDz8lrWJlFZpEkH+7qwSMyy71XOKzVxm3+JQqAnLreaeHViOYllA
         AxrYRJ0V40XhsciKo9zJEPUzHvc4nqccNQ04npprE/SubBOcUk+D/hcJY+5c1ThuuLqv
         PDNWT0+iXPFrWE2EPMla8/4XR70Wb/ZKTs9Tgphd4/yp0OZvX3yUDc/ujFk1y5A81z/b
         BCRQ==
X-Gm-Message-State: APjAAAVcG9Xgyh8YMoN68sTIp5tfA+3la2SjSXk0I8UEaZk7YECIAWz+
        NVwCHZ5j2HTmUo7CiAoQXcC8K8YQ1UA=
X-Google-Smtp-Source: APXvYqxkcAOkEuFoGLEv1EiCWtMu1PA02yJGomiV962bB19ZOviiizLRRd47z9whzeWHJQQQm82xhA==
X-Received: by 2002:a9d:6515:: with SMTP id i21mr247373otl.325.1552968252370;
        Mon, 18 Mar 2019 21:04:12 -0700 (PDT)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com. [209.85.210.47])
        by smtp.gmail.com with ESMTPSA id u25sm4583183otk.49.2019.03.18.21.04.10
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Mar 2019 21:04:10 -0700 (PDT)
Received: by mail-ot1-f47.google.com with SMTP id h7so8530000otm.2
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2019 21:04:10 -0700 (PDT)
X-Received: by 2002:a05:6830:11c9:: with SMTP id v9mr257310otq.288.1552968250036;
 Mon, 18 Mar 2019 21:04:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.f011581516bfe7650c9d4c6054bb828e6227e309.1551964740.git-series.maxime.ripard@bootlin.com>
 <1d374e71ffcc396b71461ea916cac3d957f8d86c.1551964740.git-series.maxime.ripard@bootlin.com>
 <CAAFQd5AKXz5QmqnSEkChf8DqPkhEuUQg--q9dZKPmB1kBR1hzA@mail.gmail.com>
 <20190313153130.hnp5eybcgjm34i4n@flea> <CAAFQd5BeiGVvDcZTFVYg_Qbw1NxRcWFybW2FcDGE=ohFWHFbYA@mail.gmail.com>
 <20190318154700.4qks2qfxown2frgk@flea>
In-Reply-To: <20190318154700.4qks2qfxown2frgk@flea>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 19 Mar 2019 13:03:58 +0900
X-Gmail-Original-Message-ID: <CAAFQd5D29vnxoX7Xd890_KYHdptL7NpMbhv1Jmbzibt1T4cx0g@mail.gmail.com>
Message-ID: <CAAFQd5D29vnxoX7Xd890_KYHdptL7NpMbhv1Jmbzibt1T4cx0g@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        jenskuske@gmail.com, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 19, 2019 at 12:47 AM Maxime Ripard
<maxime.ripard@bootlin.com> wrote:
>
> On Thu, Mar 14, 2019 at 01:13:33PM +0900, Tomasz Figa wrote:
> > On Thu, Mar 14, 2019 at 12:31 AM Maxime Ripard
> > <maxime.ripard@bootlin.com> wrote:
> > >
> > > Hi Tomasz,
> > >
> > > On Fri, Mar 08, 2019 at 03:12:18PM +0900, Tomasz Figa wrote:
> > > > > +.. _v4l2-mpeg-h264:
> > > > > +
> > > > > +``V4L2_CID_MPEG_VIDEO_H264_SPS (struct)``
> > > > > +    Specifies the sequence parameter set (as extracted from the
> > > > > +    bitstream) for the associated H264 slice data. This includes=
 the
> > > > > +    necessary parameters for configuring a stateless hardware de=
coding
> > > > > +    pipeline for H264.  The bitstream parameters are defined acc=
ording
> > > > > +    to :ref:`h264`. Unless there's a specific comment, refer to =
the
> > > > > +    specification for the documentation of these fields, section=
 7.4.2.1.1
> > > > > +    "Sequence Parameter Set Data Semantics".
> > > >
> > > > I don't see this section being added by this patch. Where does it c=
ome from?
> > >
> > > This is referring to the the H264 spec itself, as I was trying to
> > > point out with the reference in that paragraph. How would you write
> > > this down to make it more obvious?
> > >
> >
> > Aha, somehow it didn't come to my mind when reading it. How about
> > something like below?
> >
> > Unless there is a specific comment, refer to the ITU-T Rec. H.264
> > specification, section "7.4.2.1.1 Sequence parameter set data semantics=
"
> > (as of the 04/2017 edition).
>
> The :ref:`h264` currently expands to "ITU H.264", which means in the
> documentation, in the case above, it ends up as
>
>  The bitstream parameters are defined according to ITU H.264. Unless
>  there=E2=80=99s a specific comment, refer to the specification for the
>  documentation of these fields, section 7.4.2.1.1 =E2=80=9CSequence Param=
eter
>  Set Data Semantics=E2=80=9D.
>
> I could change the reference to have "ITU-T Rec. H.264 Specification
> (04/2017 Edition)". Would that work for you?
>

Sounds good to me.

How about tweaking the text a bit too?

The bitstream parameters are defined according to ITU-T Rec. H.264
Specification (04/2017 Edition), section 7.4.2.1.1 =E2=80=9CSequence Parame=
ter
Set Data Semantics=E2=80=9D. For further documentation, refer to the above
specification, unless there is an explicit comment stating otherwise.

Best regards,
Tomasz
