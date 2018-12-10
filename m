Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2DD4C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 08:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51D2320672
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 08:03:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TiRUVq2G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51D2320672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbeLJIDf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 03:03:35 -0500
Received: from mail-yw1-f53.google.com ([209.85.161.53]:38602 "EHLO
        mail-yw1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbeLJIDf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 03:03:35 -0500
Received: by mail-yw1-f53.google.com with SMTP id i20so3598536ywc.5
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 00:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t5ghT9WGOWnP3YAbhESE4oAEvgygwo6aboYSAaqw7bE=;
        b=TiRUVq2G2Fid7hyerJME1lfhePvDh1RJTOc9DnGkLKtyQFVhJ3fKf9Ohz0tV+91/hT
         0WKeiqy16wgLwqzKmGEAR8r/lzhRPdnPwGs1mBVucPWua2a1yd4UVUXy4NIgqKLFjhIe
         YvjT+L1lbeEtyd/Ue9efD0M4NaugP9Zg2Qf9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t5ghT9WGOWnP3YAbhESE4oAEvgygwo6aboYSAaqw7bE=;
        b=GvrSz0cGPggbXZKU+pJVP1kfgmmdFfDM7lWUBGzONKyAq1OnOHTw8o7YPn2FfRCesI
         GbV556KBW+AABD4PRKD/xJ0sJbP5l7XT8XlKuHHQxkI0tqC6uoUhCkoanHRfWKZgbsEQ
         F1At/dJ+wtV97vma8KfcHmia1twthvTZdiCl3Jl/ePtezijgGj5i4qfMRrTRhFh4k6al
         M6m6CsyG7yB4VnQc7RRcAyLg0AVXvn1YraQqerzSwOQ2i3ntikkAMGz68Se28dPjjKVI
         iI7e7XCqNOvHGYS+Hy9Pt3C87jg1dFTnxhXrQkE+1e6RgTpFgZwAkiDu7Ul1UOuxYRzw
         JvkA==
X-Gm-Message-State: AA+aEWYFR638tz2efdG5L6xZD1OXBzue/1WHc47UA6KH5W5JphfYryX+
        3pVy4xYyJjchY7J+LGOb8viEnkrfsgaFYg==
X-Google-Smtp-Source: AFSGD/WsxhnRpoxANGl8MTNUx43eukgJk5HqtRWvREZmm9onBQWF6HaumsRJMfeB652/vNpquEQvfA==
X-Received: by 2002:a81:c44d:: with SMTP id s13mr11701276ywj.411.1544429013940;
        Mon, 10 Dec 2018 00:03:33 -0800 (PST)
Received: from mail-yw1-f53.google.com (mail-yw1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id u81sm3471052ywf.6.2018.12.10.00.03.32
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Dec 2018 00:03:33 -0800 (PST)
Received: by mail-yw1-f53.google.com with SMTP id q11so3602627ywa.0
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 00:03:32 -0800 (PST)
X-Received: by 2002:a81:3d51:: with SMTP id k78mr11498364ywa.415.1544429012404;
 Mon, 10 Dec 2018 00:03:32 -0800 (PST)
MIME-Version: 1.0
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
 <20181205102040.11741-2-hverkuil-cisco@xs4all.nl> <dee778ea-89d5-ddaf-c5d9-6423b7dee005@xs4all.nl>
 <CAAFQd5Bshhc+npq8VgFWpOOvoc-ym8xytF4n49ZSe4iTGMnkAg@mail.gmail.com>
 <B8C205F2-A5EA-4502-B2D0-2B5A592C31FD@osg.samsung.com> <27D09D62-E6F0-4F22-94F4-E253FE5B45ED@kernel.org>
 <CAAFQd5BiL9EG5CgkSUhrSpCW+KGK4s2XZxTCnBw+RaE1sRf+vw@mail.gmail.com> <20181210055740.6563e8a0@coco.lan>
In-Reply-To: <20181210055740.6563e8a0@coco.lan>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Mon, 10 Dec 2018 17:03:21 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BAZ4k=VodY-3JO3FvUJ+7aarwQ6qEyruarKSnk6L+VeA@mail.gmail.com>
Message-ID: <CAAFQd5BAZ4k=VodY-3JO3FvUJ+7aarwQ6qEyruarKSnk6L+VeA@mail.gmail.com>
Subject: Re: Invite for IRC meeting: Re: [PATCHv4 01/10] videodev2.h: add tag support
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     hverkuil-cisco@xs4all.nl,
        Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        nicolas@ndufresne.ca, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 10, 2018 at 4:57 PM Mauro Carvalho Chehab
<mchehab@kernel.org> wrote:
>
> Hi Tomasz,
>
> I mean Wed morning on my TZ, with would be Wed late afternoon on your TZ :-)
>
> As Hans pointed, we are at UTC-2 (Brazil), UTC+1 (Europe CET)
> and UTC+9 (Japan). Hans is proposing to have it 9am UTC.
>
> E, g:
>
>         https://www.timeanddate.com/worldclock/meetingdetails.html?year=2018&month=12&day=12&hour=9&min=0&sec=0&p1=45&p2=101&p3=248
>

Okay, sorry, I got the time zones mixed up. Nevertheless, it works for me. :)

> Regards,
> Mauro
>
>
>
> Em Mon, 10 Dec 2018 15:11:26 +0900
> Tomasz Figa <tfiga@chromium.org> escreveu:
>
> > Hi Mauro,
> >
> > On Mon, Dec 10, 2018 at 1:31 PM Mauro Carvalho Chehab
> > <mchehab@kernel.org> wrote:
> > >
> > > In time: please reply to mchehab@kernel.org.
> > >
> > >
> > >
> > > Em 10 de dezembro de 2018 02:28:21 BRST, Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
> > >>
> > >> Let's do it on Wed.
> > >>
> > >> I'm very busy on Monday and Tuesday.
> >
> > Do you mean Wednesday in your time zone? If so, that would be Thursday
> > for Europe and Asia.
> >
> > Regardless of that, it should work for me.
> >
> > Best regards,
> > Tomasz
> >
> > >>
> > >> Regards,
> > >> Mauro
> > >>
> > >> Em 10 de dezembro de 2018 01:18:38 BRST, Tomasz Figa <tfiga@chromium.org> escreveu:
> > >>>
> > >>> Hi Hans,
> > >>>
> > >>> On Fri, Dec 7, 2018 at 12:08 AM Hans Verkuil <hverkuil-cisco@xs4all.nl> wrote:
> > >>>>
> > >>>>
> > >>>>  Mauro raised a number of objections on irc regarding tags:
> > >>>>
> > >>>>  https://linuxtv.org/irc/irclogger_log/media-maint?date=2018-12-06,Thu
> > >>>>
> > >>>>  I would like to setup an irc meeting to discuss this and come to a
> > >>>>  conclusion, since we need to decide this soon since this is critical
> > >>>>  for stateless codec support.
> > >>>>
> > >>>>  Unfortunately timezone-wise this is a bit of a nightmare. I think
> > >>>>  that at least Mauro, myself and Tomasz Figa should be there, so UTC-2,
> > >>>>  UTC+1 and UTC+9 (if I got that right).
> > >>>>
> > >>>>  I propose 9 AM UTC which I think will work for everyone except Nicolas.
> > >>>>  Any day next week works for me, and (for now) as well for Mauro. Let's pick
> > >>>>  Monday to start with, and if you want to join in, then let me know. If that
> > >>>>  day doesn't work for you, let me know what other days next week do work for
> > >>>>  you.
> > >>>
> > >>>
> > >>> 9am UTC (which should be 6pm JST)  works for me on any day this week.
> > >>>
> > >>> Best regards,
> > >>> Tomasz
> > >>>
> > >>>>
> > >>>>  Regards,
> > >>>>
> > >>>>          Hans
> > >>>>
> > >>>>  On 12/05/18 11:20, hverkuil-cisco@xs4all.nl wrote:
> > >>>>>
> > >>>>>  From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > >>>>>
> > >>>>>  Add support for 'tags' to struct v4l2_buffer. These can be used
> > >>>>>  by m2m devices so userspace can set a tag for an output buffer and
> > >>>>>  this value will then be copied to the capture buffer(s).
> > >>>>>
> > >>>>>  This tag can be used to refer to capture buffers, something that
> > >>>>>  is needed by stateless HW codecs.
> > >>>>>
> > >>>>>  The new V4L2_BUF_CAP_SUPPORTS_TAGS capability indicates whether
> > >>>>>  or not tags are supported.
> > >>>>>
> > >>>>>  Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > >>>>>  Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > >>>>>  Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
> > >>>>> ________________________________
> > >>>>>   include/uapi/linux/videodev2.h | 9 ++++++++-
> > >>>>>   1 file changed, 8 insertions(+), 1 deletion(-)
> > >>>>>
> > >>>>>  diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > >>>>>  index 2db1635de956..9095d7abe10d 100644
> > >>>>>  --- a/include/uapi/linux/videodev2.h
> > >>>>>  +++ b/include/uapi/linux/videodev2.h
> > >>>>>  @@ -881,6 +881,7 @@ struct v4l2_requestbuffers {
> > >>>>>   #define V4L2_BUF_CAP_SUPPORTS_DMABUF (1 << 2)
> > >>>>>   #define V4L2_BUF_CAP_SUPPORTS_REQUESTS       (1 << 3)
> > >>>>>   #define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
> > >>>>>  +#define V4L2_BUF_CAP_SUPPORTS_TAGS   (1 << 5)
> > >>>>>
> > >>>>>   /**
> > >>>>>    * struct v4l2_plane - plane info for multi-planar buffers
> > >>>>>  @@ -940,6 +941,7 @@ struct v4l2_plane {
> > >>>>>    * @length:  size in bytes of the buffer (NOT its payload) for single-plane
> > >>>>>    *           buffers (when type != *_MPLANE); number of elements in the
> > >>>>>    *           planes array for multi-plane buffers
> > >>>>>  + * @tag:     buffer tag
> > >>>>>    * @request_fd: fd of the request that this buffer should use
> > >>>>>    *
> > >>>>>    * Contains data exchanged by application and driver using one of the Streaming
> > >>>>>  @@ -964,7 +966,10 @@ struct v4l2_buffer {
> > >>>>>                __s32           fd;
> > >>>>>        } m;
> > >>>>>        __u32                   length;
> > >>>>>  -     __u32                   reserved2;
> > >>>>>  +     union {
> > >>>>>  +             __u32           reserved2;
> > >>>>>  +             __u32           tag;
> > >>>>>  +     };
> > >>>>>        union {
> > >>>>>                __s32           request_fd;
> > >>>>>                __u32           reserved;
> > >>>>>  @@ -990,6 +995,8 @@ struct v4l2_buffer {
> > >>>>>   #define V4L2_BUF_FLAG_IN_REQUEST             0x00000080
> > >>>>>   /* timecode field is valid */
> > >>>>>   #define V4L2_BUF_FLAG_TIMECODE                       0x00000100
> > >>>>>  +/* tag field is valid */
> > >>>>>  +#define V4L2_BUF_FLAG_TAG                    0x00000200
> > >>>>>   /* Buffer is prepared for queuing */
> > >>>>>   #define V4L2_BUF_FLAG_PREPARED                       0x00000400
> > >>>>>   /* Cache handling flags */
> > >>>>>
> > >>>>
> > >
> > > --
> > >
> > > Sent from my Android device with K-9 Mail. Please excuse my brevity.
>
>
>
> Thanks,
> Mauro
