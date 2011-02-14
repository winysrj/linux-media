Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59590 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab1BNAZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 19:25:51 -0500
Received: by iyj8 with SMTP id 8so4286605iyj.19
        for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 16:25:51 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 14 Feb 2011 08:25:49 +0800
Message-ID: <AANLkTinFa_YCcFh2CEyZy8uamnhTaS3rdLmBbzwcdK12@mail.gmail.com>
Subject: Fwd: v4l2 lost frame when use with epoll (uvc bug)
From: xinglp <xinglp@gmail.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

---------- Forwarded message ----------
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: 2011/2/13
Subject: Re: v4l2 lost frame when use with epoll
To: xinglp <xinglp@gmail.com>
³­ËÍ£º bill@thedirks.org


On Sunday, February 13, 2011 13:33:27 xinglp wrote:
> 2011/2/13 Hans Verkuil <hverkuil@xs4all.nl>:
> > On Sunday, February 13, 2011 09:18:41 xinglp wrote:
> >> It seems like that epoll_wait() do not return as soon as possible when one
> >> frame be captured, it only returns when 4(set by ioctl(..VIDIOC_REQBUFS..).)
> >> frames be captured.
> >> And v4l2_buffer::sequence indecates one lost per 4 frames.
> >
> > What hardware/driver are you using?
> I' using uvcvideo. I've tried two cheap usbcam at two PC.
>
> lsusb
> Bus 002 Device 002: ID 1871:01f0 Aveo Technology Corp.
>
> lsmod
> Module                  Size  Used by
> uvcvideo               54924  -
> videodev               65184  -
>
> DG45ID mainboard and a hp2530p notebook.

A quick follow-up: I could reproduce this with uvc. It works fine with vivi
and gspca, so this seems to be a uvc bug.

Please post this bug report to the linux-media mailinglist with a CC to
Laurent Pinchart <laurent.pinchart@ideasonboard.com> who is the uvc maintainer.

Regards,

       Hans

>
> >> The source in attachment can reproducte it, run it with option --epoll
> >> to make it use epoll.
> >>
> >> The attachment is a modified version of the follow URL.
> >> http://v4l2spec.bytesex.org/v4l2spec/capture.c
> >>
> >
> > I can't reproduce this with the vivi driver. It's much more likely to be a
> > driver issue.
> On my machine, vivi even not work with epoll(). only capture one frame
> and stop.(epoll_wait() never return again.)
>
> >
> > BTW, it's much better to mail the linux-media mailinglist. Also note that Bill
> > is no longer involved in V4L.
> I can't subscribe any kernel maillist successfully.
>
> > Regards,
> >
> >        Hans
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by Cisco
> >
>
>

--
Hans Verkuil - video4linux developer - sponsored by Cisco
