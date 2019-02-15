Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB5AC43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 23:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 963332192D
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 23:37:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="RWsFeC1r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388724AbfBOXhK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 18:37:10 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39287 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388691AbfBOXhK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 18:37:10 -0500
Received: by mail-wr1-f67.google.com with SMTP id l5so10914239wrw.6
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 15:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/Nb/93c1oYNaWFxPVo98U5t09OQu4evkihQTv5QnY64=;
        b=RWsFeC1rangayjB5gfyBp5Z4KvylIlCbMm2RabP70GQDtwI5207+xCRx+Yawiaw+mX
         MGKBaWnzRiU/E1lqwHJCMZhMvJ3l9ykNM6UJAYNJsGmZFWUNBlPNvt4fgS9gRccxzR/E
         L1f5Y0vHLS7+kDTjhEOhK/GwlWiri98NdpLcpdUV5v4GaF6uZn5vP175vY6qeIH9/gmT
         LFQJMBCuu8fyD/KszSfwhj+1K1qFbSIPIxJ/e0q4IQdbFSVRup2DztOit//+bl2yEZLj
         1rUrpxSIZoIsu/VZ8ZLEU3o8gxz6nVfOIAKrBw5oS0/EdTEiDP4MNa1HNAU3ohD/+Ug1
         XZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/Nb/93c1oYNaWFxPVo98U5t09OQu4evkihQTv5QnY64=;
        b=Ay2i5J8K3MTA9BBfZ2L1X1tV4W6FGdvZbi2yJWMd8rz5472sP6gnYnrH0YHRL51vWF
         1Tk+J1FNz5QGarqo8lOoyp/QJs2c5DeAAXdjamo8Zb3d8d6xYr9Ak6lOpwjoM2bxRl7p
         NU3q9tJiSgiEF7D46X0yEasx4gTVKfnHflbonUkATxMC+1b5BlRB56F/pNuNCgJ/ETIb
         9j+ihLpQraTEh7CS+vANKelMXvG+knxG80DUjS2bTYwOxNqevRKHpb0BftUU4IOgXWkt
         ei3C0JHh/x70m28NuwCud8eBmGfrau2Z/c5yzH8LSednh8NLXlk0rBc616JpGoLuNWY1
         bMjg==
X-Gm-Message-State: AHQUAuYg4Go44dktq/itKX7JsI1raXTRFBTi79ydKX1ps9+9Suw+WXbR
        N/79Xvv2Krv6V5ghtEm9MZjM095lN7noDezimbTzkuW9Avc=
X-Google-Smtp-Source: AHgI3IYclxfQp/uCFyiIdjxYBiknkFsJOEOmY3+UAscLog4Fn/RZegtHg5ncd4vJu7L5nUQFK5CpTw/WNC+I23pORW8=
X-Received: by 2002:adf:f3d0:: with SMTP id g16mr8360439wrp.29.1550273828633;
 Fri, 15 Feb 2019 15:37:08 -0800 (PST)
MIME-Version: 1.0
References: <20190117155032.3317-1-p.zabel@pengutronix.de> <CAJ+vNU0HCBr2vz-D=Z8zC+JAmZ6bhsi7TCRhB827uPQj-8esDQ@mail.gmail.com>
 <1550229020.4531.12.camel@pengutronix.de> <04f7cf49df32b39f88b14a84df4fa38b1c7d24f6.camel@ndufresne.ca>
In-Reply-To: <04f7cf49df32b39f88b14a84df4fa38b1c7d24f6.camel@ndufresne.ca>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 15 Feb 2019 15:36:57 -0800
Message-ID: <CAJ+vNU2185akWh72cwh8G_zYqAG0KtPwN8KvbKQJ=v6GJpcaSQ@mail.gmail.com>
Subject: Re: [PATCH v7] media: imx: add mem2mem device
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Feb 15, 2019 at 8:24 AM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
> Le vendredi 15 f=C3=A9vrier 2019 =C3=A0 12:10 +0100, Philipp Zabel a =C3=
=A9crit :
> > > I'm also not sure how to specify hflip/vflip... I don't think
> > > extra-controls parses 'hflip', 'vflip' as ipu_csc_scaler_s_ctrl gets
> > > called with V4L2_CID_HFLIP/V4L2_CID_VFLIP but ctrl->val is always 0.
> >
> > You can use v4l2-ctl -L to list the CID names, they are horizontal_flip
> > and vertical_flip, respectively. Again, the input and output formats
> > must be different because GStreamer doesn't know about the flipping yet=
:
> >
> > gst-launch-1.0 videotestsrc ! video/x-raw,width=3D320,height=3D240 ! v4=
l2video10convert extra-controls=3Dcid,horizontal_flip=3D1 ! video/x-raw,wid=
th=3D640,height=3D480 ! kmssink can-scale=3Dfalse
> >
> > We'd have to add actual properties for rotate/flip to v4l2convert,
> > instead of using theextra-controls workaround, probable something
> > similar to the video-direction property of the software videoflip
> > element.
>
> Note that we have a disable-passthrough property in master, a trivial
> patch to backport if you need it.
>
> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/commit/fe5236be=
8771ea82c850ebebe19cf1064d112bf0

Nicolas,

Yes, this works great on gstreamer-master:

gst-launch-1.0 videotestsrc ! v4l2convert
extra-controls=3Dcid,vertical_flip=3D1 ! kmssink
^^^ fails to flip b/c gstreamer bypases the conversion as input and
output formats are the same

gst-launch-1.0 videotestsrc ! v4l2convert
extra-controls=3Dcid,vertical_flip=3D1 disable-passthrough=3D1 ! kmssink
^^^ flips as expected

Tim
