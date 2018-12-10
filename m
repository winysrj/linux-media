Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3439C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 03:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 783582082D
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 03:18:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oVqngkcO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 783582082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbeLJDSx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 22:18:53 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:33129 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbeLJDSw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2018 22:18:52 -0500
Received: by mail-yb1-f195.google.com with SMTP id f125so4694034ybc.0
        for <linux-media@vger.kernel.org>; Sun, 09 Dec 2018 19:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CZDQchPwyoH2Gonu+kvB+HTT1ZDWm3OfGtHtPXwL9to=;
        b=oVqngkcOuj3IlR6+ert8NXW6broii7rIGDD9sup7pnzbZg8rNBg1PUycCC4smrsY3K
         N8GT/0GLvwaHyH8VWHUG6TI8xBeBFI8j9zagWAxkGU14nt04As/N6CP6IQEOJrwd+t5u
         IkTYkl/Ue+OFwnGIEOS3He+9/5m1AVEGrqHgo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CZDQchPwyoH2Gonu+kvB+HTT1ZDWm3OfGtHtPXwL9to=;
        b=JKlCwTMnbI614VyoliXFWlViN4oXvoahHVvLpk8QTl9MJ3tFyfCSmN897TbCG6BMB3
         t+FGuRLdirbKTr9eWn/kl/TNx8YEuda/N8/x10KTLg6ZtI0EzX0dvo8AFCTGGAXZFenZ
         6PTTAs30V7QROKxKy2bL3kACxKMTE4YW0xaSlF5BNj7UavrNJcPqNQi3XxvPS34Vzg3I
         wCcIC/T9zhg/aVKA+9gWUyeWwYsZJK5t1JG63xwvdp9//6WbrvX4vZw08cOK0xGnzuWJ
         P4MYur9hHxktZRb4wPfkOUkGTkUNUXCHeLh/HvzE6IRTHPq1lc/VLKQM6G5EGKLmHMn0
         ivfw==
X-Gm-Message-State: AA+aEWbNH/yIeIstR5cGS4JefcydoFvfGgyvz+xTlJcW51RIhZNp3Oqe
        knBjrmH9oEU63f81nJPE60r4JI9zzS4BQQ==
X-Google-Smtp-Source: AFSGD/XIr1Ba050uEld0qgkjqN39ADqJ37yo5RKb7pwF435ejHGtjcJA+CW+dhOlBp+7ugHabX1owg==
X-Received: by 2002:a25:b788:: with SMTP id n8mr10371379ybh.158.1544411931022;
        Sun, 09 Dec 2018 19:18:51 -0800 (PST)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id l35sm3558457ywh.48.2018.12.09.19.18.50
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Dec 2018 19:18:50 -0800 (PST)
Received: by mail-yw1-f49.google.com with SMTP id x2so3407934ywc.9
        for <linux-media@vger.kernel.org>; Sun, 09 Dec 2018 19:18:50 -0800 (PST)
X-Received: by 2002:a81:b341:: with SMTP id r62mr10966816ywh.65.1544411929660;
 Sun, 09 Dec 2018 19:18:49 -0800 (PST)
MIME-Version: 1.0
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
 <20181205102040.11741-2-hverkuil-cisco@xs4all.nl> <dee778ea-89d5-ddaf-c5d9-6423b7dee005@xs4all.nl>
In-Reply-To: <dee778ea-89d5-ddaf-c5d9-6423b7dee005@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Mon, 10 Dec 2018 12:18:38 +0900
X-Gmail-Original-Message-ID: <CAAFQd5Bshhc+npq8VgFWpOOvoc-ym8xytF4n49ZSe4iTGMnkAg@mail.gmail.com>
Message-ID: <CAAFQd5Bshhc+npq8VgFWpOOvoc-ym8xytF4n49ZSe4iTGMnkAg@mail.gmail.com>
Subject: Re: Invite for IRC meeting: Re: [PATCHv4 01/10] videodev2.h: add tag support
To:     hverkuil-cisco@xs4all.nl
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        nicolas@ndufresne.ca, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Fri, Dec 7, 2018 at 12:08 AM Hans Verkuil <hverkuil-cisco@xs4all.nl> wrote:
>
> Mauro raised a number of objections on irc regarding tags:
>
> https://linuxtv.org/irc/irclogger_log/media-maint?date=2018-12-06,Thu
>
> I would like to setup an irc meeting to discuss this and come to a
> conclusion, since we need to decide this soon since this is critical
> for stateless codec support.
>
> Unfortunately timezone-wise this is a bit of a nightmare. I think
> that at least Mauro, myself and Tomasz Figa should be there, so UTC-2,
> UTC+1 and UTC+9 (if I got that right).
>
> I propose 9 AM UTC which I think will work for everyone except Nicolas.
> Any day next week works for me, and (for now) as well for Mauro. Let's pick
> Monday to start with, and if you want to join in, then let me know. If that
> day doesn't work for you, let me know what other days next week do work for
> you.

9am UTC (which should be 6pm JST)  works for me on any day this week.

Best regards,
Tomasz

>
> Regards,
>
>         Hans
>
> On 12/05/18 11:20, hverkuil-cisco@xs4all.nl wrote:
> > From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >
> > Add support for 'tags' to struct v4l2_buffer. These can be used
> > by m2m devices so userspace can set a tag for an output buffer and
> > this value will then be copied to the capture buffer(s).
> >
> > This tag can be used to refer to capture buffers, something that
> > is needed by stateless HW codecs.
> >
> > The new V4L2_BUF_CAP_SUPPORTS_TAGS capability indicates whether
> > or not tags are supported.
> >
> > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
> > ---
> >  include/uapi/linux/videodev2.h | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index 2db1635de956..9095d7abe10d 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -881,6 +881,7 @@ struct v4l2_requestbuffers {
> >  #define V4L2_BUF_CAP_SUPPORTS_DMABUF (1 << 2)
> >  #define V4L2_BUF_CAP_SUPPORTS_REQUESTS       (1 << 3)
> >  #define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
> > +#define V4L2_BUF_CAP_SUPPORTS_TAGS   (1 << 5)
> >
> >  /**
> >   * struct v4l2_plane - plane info for multi-planar buffers
> > @@ -940,6 +941,7 @@ struct v4l2_plane {
> >   * @length:  size in bytes of the buffer (NOT its payload) for single-plane
> >   *           buffers (when type != *_MPLANE); number of elements in the
> >   *           planes array for multi-plane buffers
> > + * @tag:     buffer tag
> >   * @request_fd: fd of the request that this buffer should use
> >   *
> >   * Contains data exchanged by application and driver using one of the Streaming
> > @@ -964,7 +966,10 @@ struct v4l2_buffer {
> >               __s32           fd;
> >       } m;
> >       __u32                   length;
> > -     __u32                   reserved2;
> > +     union {
> > +             __u32           reserved2;
> > +             __u32           tag;
> > +     };
> >       union {
> >               __s32           request_fd;
> >               __u32           reserved;
> > @@ -990,6 +995,8 @@ struct v4l2_buffer {
> >  #define V4L2_BUF_FLAG_IN_REQUEST             0x00000080
> >  /* timecode field is valid */
> >  #define V4L2_BUF_FLAG_TIMECODE                       0x00000100
> > +/* tag field is valid */
> > +#define V4L2_BUF_FLAG_TAG                    0x00000200
> >  /* Buffer is prepared for queuing */
> >  #define V4L2_BUF_FLAG_PREPARED                       0x00000400
> >  /* Cache handling flags */
> >
>
