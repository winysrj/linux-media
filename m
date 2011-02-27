Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53189 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1B0RdN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 12:33:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: xinglp <xinglp@gmail.com>
Subject: Re: Fwd: v4l2 lost frame when use with epoll (uvc bug)
Date: Sun, 27 Feb 2011 18:33:15 +0100
Cc: linux-media@vger.kernel.org
References: <AANLkTinFa_YCcFh2CEyZy8uamnhTaS3rdLmBbzwcdK12@mail.gmail.com>
In-Reply-To: <AANLkTinFa_YCcFh2CEyZy8uamnhTaS3rdLmBbzwcdK12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb18030"
Content-Transfer-Encoding: 7bit
Message-Id: <201102271833.17017.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Monday 14 February 2011 01:25:49 xinglp wrote:
> On 2011/2/13 Hans Verkuil wrote:
> On Sunday, February 13, 2011 13:33:27 xinglp wrote:
> > 2011/2/13 Hans Verkuil <hverkuil@xs4all.nl>:
> > > On Sunday, February 13, 2011 09:18:41 xinglp wrote:
> > >> It seems like that epoll_wait() do not return as soon as possible when
> > >> one frame be captured, it only returns when 4(set by
> > >> ioctl(..VIDIOC_REQBUFS..).) frames be captured.
> > >> And v4l2_buffer::sequence indecates one lost per 4 frames.
> > > 
> > > What hardware/driver are you using?
> > 
> > I' using uvcvideo. I've tried two cheap usbcam at two PC.
> > 
> > lsusb
> > Bus 002 Device 002: ID 1871:01f0 Aveo Technology Corp.
> > 
> > lsmod
> > Module                  Size  Used by
> > uvcvideo               54924  -
> > videodev               65184  -
> > 
> > DG45ID mainboard and a hp2530p notebook.
> 
> A quick follow-up: I could reproduce this with uvc. It works fine with vivi
> and gspca, so this seems to be a uvc bug.
> 
> Please post this bug report to the linux-media mailinglist with a CC to
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> who is the uvc
> maintainer.

I'm not sure if the problem lies in uvcvideo or in the epoll implementation, 
but I'm working on using videobuf2 in uvcvideo, and that will fix the issue.

> > >> The source in attachment can reproducte it, run it with option --epoll
> > >> to make it use epoll.
> > >> 
> > >> The attachment is a modified version of the follow URL.
> > >> http://v4l2spec.bytesex.org/v4l2spec/capture.c
> > > 
> > > I can't reproduce this with the vivi driver. It's much more likely to
> > > be a driver issue.
> > 
> > On my machine, vivi even not work with epoll(). only capture one frame
> > and stop.(epoll_wait() never return again.)
> > 
> > > BTW, it's much better to mail the linux-media mailinglist. Also note
> > > that Bill is no longer involved in V4L.
> > 
> > I can't subscribe any kernel maillist successfully.

-- 
Regards,

Laurent Pinchart
