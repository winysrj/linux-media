Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59844 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbbFLG7C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 02:59:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Damiano Albani <damiano.albani@gmail.com>
Cc: linux-media@vger.kernel.org, Pawel Osciak <posciak@chromium.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Paulo Assis <pj.assis@gmail.com>
Subject: Re: Support for UVC 1.5 / H.264 SVC (to be used with Logitech C930e)
Date: Fri, 12 Jun 2015 09:59:41 +0300
Message-ID: <1482230.oVIzFu8F0x@avalon>
In-Reply-To: <CAKys950WOCXngQo1WX8wyi_oSuGzjZr8vSReODURj0N6byTN6g@mail.gmail.com>
References: <CAKys950WOCXngQo1WX8wyi_oSuGzjZr8vSReODURj0N6byTN6g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Damiano,

On Thursday 11 June 2015 14:28:55 Damiano Albani wrote:
> Hello,
> 
> I've recently got hold of a Logitech C930e webcam.
> AFAIK that's the only consumer webcam that support UVC 1.5 and H.264/SVC.
> Unfortunately, compared to its predecessor the C920, it is not very well
> supported on Linux.
> 
> For example, the H.264 capability doesn't appear in the list of formats:
> > v4l2-ctl -D --list-formats
> 
> Driver Info (not using libv4l2):
> Driver name   : uvcvideo
> Card type     : Logitech Webcam C930e
> Bus info      : usb-0000:00:1a.7-1.4
> Driver version: 3.13.11
> Capabilities  : 0x84000001
> Video Capture
> Streaming
> Device Capabilities
> Device Caps   : 0x04000001
> Video Capture
> Streaming
> ioctl: VIDIOC_ENUM_FMT
> Index       : 0
> Type        : Video Capture
> Pixel Format: 'YUYV'
> Name        : YUV 4:2:2 (YUYV)
> 
> Index       : 1
> Type        : Video Capture
> Pixel Format: 'MJPG' (compressed)
> Name        : MJPEG
> 
> 
> Back in August 2013, there was a discussion on adding support for UVC 1.5,
> among other things:
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg66203.html
> 
> If I'm not mistaken, this set of patches provided above haven't been
> integrated into the kernel.
> Is there a lot of work to do to "backport" the code into the current kernel?
> 2 years after the original was written, has there been changes in the API
> that requires to "revisit" the patches?

There's quite a lot of work to do, yes. The patches need to be rebased, but 
that shouldn't be too much of an issue. Then, the comments I've sent during 
review need to be addressed. Finally, I still need to review the last patch.

I've discussed this with Pawel Osciak last week, and we thought it would be 
good to take an incremental approach and merge basic UVC 1.5 support first, 
and then simulcast in a second step. The biggest problem now is to find time 
to work on it.

-- 
Regards,

Laurent Pinchart

