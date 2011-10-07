Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:2573 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab1JGJGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 05:06:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: libv4l2 misbehavior after calling S_STD or S_DV_PRESET
Date: Fri, 7 Oct 2011 11:06:31 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201110061313.56974.hverkuil@xs4all.nl> <4E8EB0F6.3060002@redhat.com>
In-Reply-To: <4E8EB0F6.3060002@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110071106.31515.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 07 October 2011 09:57:42 Hans de Goede wrote:
> Hi,
> 
> Hmm, nasty...
> 
> On 10/06/2011 01:13 PM, Hans Verkuil wrote:
> > Hi Hans!
> > 
> > I've been looking into a problem with libv4l2 that occurs when you change
> > TV standard or video preset using VIDIOC_S_STD or VIDIOC_S_DV_PRESET.
> > These calls will change the format implicitly (e.g. if the current
> > format is set for PAL at 720x576 and you select NTSC, then the format
> > will be reset to 720x480).
> > 
> > However, libv4l2 isn't taking this into account and will keep using the
> > cached dest_fmt value. It is easy to reproduce this using qv4l2.
> > 
> > The same problem is likely to occur with S_CROP (haven't tested that yet,
> > though): calling S_CROP can also change the format.
> > 
> > To be precise: S_STD and S_DV_PRESET can change both the crop rectangle
> > and the format, and S_CROP can change the format.
> 
> First of all it would be good to actually document this behavior of
> VIDIOC_S_STD or VIDIOC_S_DV_PRESET, the current docs don't mention this at
> all: http://linuxtv.org/downloads/v4l-dvb-apis/standard.html

Odd, I'd have sworn that it was in the docs.

The full list of ioctls that can change both the crop settings and the format 
is:

VIDIOC_S_STD
VIDIOC_S_DV_PRESET
VIDIOC_S_DV_TIMINGS
VIDIOC_S_INPUT (can implicitly change standard/preset)
VIDIOC_S_OUTPUT (ditto)
VIDIOC_S_CROP

Note that I suspect that there are quite a few drivers that do not handle this
correctly. After all, for normal SDTV capture cards you almost never change
the TV standard once it is set up at the start so I doubt if this has been
tested much. For DV_PRESET it is much more common to switch from e.g.
720p to 1080p. That is how I found this issue.

> I've attached 2 patches which should make libv4l2 deal with this correctly.
> I assume you've a reproducer for this and I would appreciate it if you
> could test if these patches actually fix the issue you are seeing.

Almost working. The second patch forgot to set src_fmt.type, so I got an error 
back. After initializing it to BUF_TYPE_VIDEO_CAPTURE it worked fine.

Regards,

	Hans
