Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2B2C43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 15:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB2A5218D0
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 15:13:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kO1VMmZO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbeLSPNP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 10:13:15 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44213 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbeLSPNO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 10:13:14 -0500
Received: by mail-io1-f68.google.com with SMTP id r200so15839886iod.11
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2018 07:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=URlhHRdYm31zg5n1/ufG2xxVGWBH9VnczapWYR/uG/A=;
        b=kO1VMmZOTK9Pn6gMHGmDPcaUkq0XklAZIvXoe5SRlZN20GabTxruaW/B4SweWgydbS
         iF1FmAcX8xpavc+/VA3I0bs7Q8K2+MgDvpCO/SLBeUWnlRbBnt4Jr4IxVi6GINVgImbq
         CMCQ6RR8DVS8Bp9UuRgHcZpdSOJwePih03TxtjJRaIiGPeWb0jrzgSr+iXNwybFu1kK4
         yIsNcTGMr3+hZCeddjEWihiKPhITQ1jsO3tnYPePlSnJSbQ91LqisN4VAmLd+cmIBp1h
         cUzRoweNQH3HNYsubT6G3Qwk3tPQP2btsw/9jUQQ+P7ud2b8VzYhfIU7afm1bSDhLqTl
         cssQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=URlhHRdYm31zg5n1/ufG2xxVGWBH9VnczapWYR/uG/A=;
        b=Ro8mWj1SCHbDDNixA+fK7HUdE1AyYqdIBA8M0ki6HcYGK7DHzcS2/gOMyZNo5oLbys
         Z//5JRLGj20S6P0WldBJAnc/gn0x0KWNVmrPXRw+cGr1VDB9vyvHmSYsgYB4Cln3ecKH
         uMVFgmsO9w3YlbiPKc8T0TK4OaYXuiN9bp2C+oKvH1TRWV/FrP5i1BnfABuL8K+zSau9
         +9a5F1uJ1N7dSx+yoVtXGgBt3rObojVFA3DNjYJBdn3WZpKCG7G91zv4PB/JfFyjuBgp
         4p2My0+uVo+u8ioF5JdpVDPifxglYyPiAq8nxcHHoCy5DSQfCrz1DBbGAqiq1aBBwBDT
         H70A==
X-Gm-Message-State: AJcUukdOfCqzBUfMKgs8PwUMHKgzf/Sth1/fvr0liNaQARegnw0Wkh/H
        eI7EMJrxXmPf2HLk56k/4i9UXiJ6UnbOU1/2uuEgVA==
X-Google-Smtp-Source: AFSGD/V6jdNO2jB5vJbWyMOmrGDVW2GrFMZUCxwgvwKkOpcDB4pFODXhssQ941IT03vOOsA4OVr+Qq838iHyDK6hXqs=
X-Received: by 2002:a6b:e607:: with SMTP id g7mr1586979ioh.292.1545232393364;
 Wed, 19 Dec 2018 07:13:13 -0800 (PST)
MIME-Version: 1.0
References: <20181219013248.94850-1-astrachan@google.com> <7327024.PA5BtzYvEC@avalon>
In-Reply-To: <7327024.PA5BtzYvEC@avalon>
From:   Alistair Strachan <astrachan@google.com>
Date:   Wed, 19 Dec 2018 07:13:01 -0800
Message-ID: <CANDihLFgMSV09gdiPcTJPZpYQrpPk3kjD=R94hVif1V-YCChhw@mail.gmail.com>
Subject: Re: [PATCH v2] media: uvcvideo: Fix 'type' check leading to overflow
To:     laurent.pinchart@ideasonboard.com
Cc:     linux-kernel@vger.kernel.org, syzkaller@googlegroups.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Dec 19, 2018 at 12:16 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Alistair,
>
> Thank you for the patch.
>
> On Wednesday, 19 December 2018 03:32:48 EET Alistair Strachan wrote:
> > From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> Are you sure you don't want to keep authorship ? I've merely reviewed v1 and
> proposed an alternative implementation :-) Let me know what you would prefer
> and I'll apply this to my tree.

Whatever attribution you think is best works for me! Thank you for
picking up this patch.

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
> > Avoid this problem by checking for the MSB in the wTerminalType field.
> > If the bit is set, assume the descriptor is bad, and abort parsing it.
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
> > v2: Use an alternative fix suggested by Laurent
> >  drivers/media/usb/uvc/uvc_driver.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index bc369a0934a3..7fde3ce642c4
> > 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -1065,11 +1065,19 @@ static int uvc_parse_standard_control(struct
> > uvc_device *dev, return -EINVAL;
> >               }
> >
> > -             /* Make sure the terminal type MSB is not null, otherwise it
> > -              * could be confused with a unit.
> > +             /*
> > +              * Reject invalid terminal types that would cause issues:
> > +              *
> > +              * - The high byte must be non-zero, otherwise it would be
> > +              *   confused with a unit.
> > +              *
> > +              * - Bit 15 must be 0, as we use it internally as a terminal
> > +              *   direction flag.
> > +              *
> > +              * Other unknown types are accepted.
> >                */
> >               type = get_unaligned_le16(&buffer[4]);
> > -             if ((type & 0xff00) == 0) {
> > +             if ((type & 0x7f00) == 0 || (type & 0x8000) != 0) {
> >                       uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
> >                               "interface %d INPUT_TERMINAL %d has invalid "
> >                               "type 0x%04x, skipping\n", udev->devnum,
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>
