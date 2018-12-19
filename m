Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF32C43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 01:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A35CF2133F
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 01:31:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XFaBu7FS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbeLSBbi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 20:31:38 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:37281 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbeLSBbi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 20:31:38 -0500
Received: by mail-it1-f196.google.com with SMTP id b5so7094165iti.2
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 17:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/4yDNBZTIy2tRSn0bKWJ18GcP8pwPtiBgbpTAtQrQCM=;
        b=XFaBu7FSydMUnEKK/Nz/IHUknKFJjHA1mNujJ7/HCwRUQcvX5+7TRdl3ll5ZwIwQ2t
         X+1ooaeaIjza8gmAqM9Xu0SvH+AoSY4r9eJaYeLAwlsIYSxy8Q9FcQT7bDcew2a+r7fC
         e95+RfF5ewxAAOSrg2LmKvIYTtYJxoD1I+bvq7Nc34l92rDR+9AqvNog60iBfAgkR47u
         A91xkbLproBOySXJVt3zFkbidANRQh/p027wFVjjeMoxqyFaYxKfeuLBvy/vc7MiSyCe
         ZfyPSX/FoRz3Yf+rO4eLg7CdLHXfTAjra/kl19TNOTGuD4cLRvrBMG5/aZ+L6WgQEDvv
         +sHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/4yDNBZTIy2tRSn0bKWJ18GcP8pwPtiBgbpTAtQrQCM=;
        b=BjNUAo2zz12IyWWOyw9JU/N4WpSp0UXYFoO9uzdubhDsqaEGWvWd1dbCuD9gOg51lV
         L6bvdLa+gfS7oOIu35hhfMCCArG5cZ16IjzL0pYOPj4EqritwJ/oGnDoeAXfYXP0HFVG
         /+maA8WKqKDPtGrRP3giF2xsfWLs4l4e49tDmmrbb5+zxtZjVLYOmrxsb6s7i2vFXxVK
         odorWUsiLyqbJH9kmgpVh+ZblRwKyPwFBQCOuT/KkwU7xiEL6mbkw+h2Ti2YpHVsLuHW
         XyOz+g5y6j/9Mie4kz4pMXFhmdgRnNPliAZH0I/arySgllSu6n5avreltw8fm9QT+XPo
         K63Q==
X-Gm-Message-State: AA+aEWaS/Dy6V3VNYnKnsHxqc04wxX/OWhBEUNB7jm/29qxN7GlLcws7
        HKFjlNqbV35dgUszw6htJxt4Va0YFTHQcIckUeZUnw==
X-Google-Smtp-Source: AFSGD/Xj/JlFmjheDTm5/o3W86vMODlJtWb5xf6Hme9hBuJ8oJS9v8g0YCXH0FWVpRPcUvya6bX02v2neJBASgTjTiI=
X-Received: by 2002:a24:5989:: with SMTP id p131mr4996671itb.6.1545183096400;
 Tue, 18 Dec 2018 17:31:36 -0800 (PST)
MIME-Version: 1.0
References: <20181217210222.115419-1-astrachan@google.com> <45456214.XvNNoR8qLh@avalon>
In-Reply-To: <45456214.XvNNoR8qLh@avalon>
From:   Alistair Strachan <astrachan@google.com>
Date:   Tue, 18 Dec 2018 17:31:25 -0800
Message-ID: <CANDihLEy2BRgm5o2tQJQc_cQpbKxUgH8CWjK51qwXr67-CMn4g@mail.gmail.com>
Subject: Re: [PATCH] media: uvcvideo: Fix 'type' check leading to overflow
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-kernel@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Tue, Dec 18, 2018 at 1:42 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Alistair,
>
> Thank you for the patch.
>
> On Monday, 17 December 2018 23:02:22 EET Alistair Strachan wrote:
> > When initially testing the Camera Terminal Descriptor wTerminalType
> > field (buffer[4]), no mask is used. Later in the function, the MSB is
> > overloaded to store the descriptor subtype, and so a mask of 0x7fff
> > is used to check the type.
> >
> > If a descriptor is specially crafted to set this overloaded bit in the
> > original wTerminalType field, the initial type check will fail (falling
> > through, without adjusting the buffer size), but the later type checks
> > will pass, assuming the buffer has been made suitably large, causing an
> > overflow.
> >
> > This problem could be resolved in a few different ways, but this fix
> > applies the same initial type check as used by UVC_ENTITY_TYPE (once we
> > have a 'term' structure.) Such crafted wTerminalType fields will then be
> > treated as *generic* Input Terminals, not as CAMERA or
> > MEDIA_TRANSPORT_INPUT, avoiding an overflow.
> >
> > Originally reported here:
> > https://groups.google.com/forum/#!topic/syzkaller/Ot1fOE6v1d8
> > A similar (non-compiling) patch was provided at that time.
> >
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Signed-off-by: Alistair Strachan <astrachan@google.com>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Cc: linux-media@vger.kernel.org
> > Cc: kernel-team@android.com
> > ---
> >  drivers/media/usb/uvc/uvc_driver.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index bc369a0934a3..279a967b8264
> > 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -1082,11 +1082,11 @@ static int uvc_parse_standard_control(struct
> > uvc_device *dev, p = 0;
> >               len = 8;
> >
> > -             if (type == UVC_ITT_CAMERA) {
> > +             if ((type & 0x7fff) == UVC_ITT_CAMERA) {
> >                       n = buflen >= 15 ? buffer[14] : 0;
> >                       len = 15;
> >
> > -             } else if (type == UVC_ITT_MEDIA_TRANSPORT_INPUT) {
> > +             } else if ((type & 0x7fff) == UVC_ITT_MEDIA_TRANSPORT_INPUT) {
> >                       n = buflen >= 9 ? buffer[8] : 0;
> >                       p = buflen >= 10 + n ? buffer[9+n] : 0;
> >                       len = 10;
>
> How about rejecting invalid types instead ? Something along the lines of

This looks simpler/better to me. I just re-sent your version of the
change (build + runtime tested.) Thanks for reviewing.

> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index b62cbd800111..33a22c016456 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1106,11 +1106,19 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
>                         return -EINVAL;
>                 }
>
> -               /* Make sure the terminal type MSB is not null, otherwise it
> -                * could be confused with a unit.
> +               /*
> +                * Reject invalid terminal types that would cause issues:
> +                *
> +                * - The high byte must be non-zero, otherwise it would be
> +                *   confused with a unit.
> +                *
> +                * - Bit 15 must be 0, as we use it internally as a terminal
> +                *   direction flag.
> +                *
> +                * Other unknown types are accepted.
>                  */
>                 type = get_unaligned_le16(&buffer[4]);
> -               if ((type & 0xff00) == 0) {
> +               if ((type & 0x7f00) == 0 || (type & 0x8000) != 0) {
>                         uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
>                                 "interface %d INPUT_TERMINAL %d has invalid "
>                                 "type 0x%04x, skipping\n", udev->devnum,
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>
