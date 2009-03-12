Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4307 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZCLXiz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 19:38:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: disable v4l2-ctl logging --log-status in /var/log/messages
Date: Fri, 13 Mar 2009 00:39:08 +0100
Cc: Gregor Fuis <gujs.lists@gmail.com>, linux-media@vger.kernel.org
References: <50906.62.70.2.252.1236850101.squirrel@webmail.xs4all.nl> <23be820f0903120249n70778ddbh28c04286099cfc5b@mail.gmail.com> <1236900883.3715.9.camel@palomino.walls.org>
In-Reply-To: <1236900883.3715.9.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903130039.09075.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 13 March 2009 00:34:43 Andy Walls wrote:
> On Thu, 2009-03-12 at 10:49 +0100, Gregor Fuis wrote:
> > On Thu, Mar 12, 2009 at 10:28 AM, Hans Verkuil <hverkuil@xs4all.nl> 
wrote:
> > >> Hello,
> > >>
> > >> Is it possible to disable v4l2-ctl aplication logging into
> > >> /var/log/messages.
> > >> I am using it to control and monitor my PVR 150 cards and every time
> > >> I run v4l2-ctl -d /dev/video0 --log-status all output is logged into
> > >> /var/log/messages and some other linux log files.
> > >
> > > All --log-status does is to tell the driver to show it's status in
> > > the kernel log for debugging purposes. It cannot and should not be
> > > relied upon for monitoring/controlling a driver.
> > >
> > > What do you need it for anyway?
> >
> > I am just monitoring if signal is present on tuner, and what signal
> > format is detected.
> > These two lines:
> > cx25840 1-0044: Video signal:              not present
> > cx25840 1-0044: Detected format:           PAL-Nc
> > I run this every minute and it is really annoying to have all this in
> > my system logs.
> > Is it possible to modify v4l2-ctl source to disable system logging?
>
> $ v4l2-ctl -d /dev/video0 -T
>
> which calls the VIDIOC_G_TUNER ioctl(), can be used to tell you if a
> signal is present:
>
> Tuner:
> 	Name                 : cx18 TV Tuner
> 	Capabilities         : 62.5 kHz multi-standard stereo lang1 lang2
> 	Frequency range      : 44.0 MHz - 958.0 MHz
> 	Signal strength/AFC  : 0%/-187500
> 	Current audio mode   : lang1
> 	Available subchannels: mono
>
> Signal strength will be 0% or 100% - both the cx18 driver and the
> cx25840 driver behave the same in this regard.
>
> AFAICT, other than --log-status (the VIDIOC_LOG_STATUS ioctl()) which
> always writes to the system logs, there is no way for a non-root user to
> read out the Video standard detected by the CX25843 hardware.  That
> would require a change to the driver(s) and maybe an API change (I'm not
> sure).

There is a VIDIOC_QUERYSTD ioctl. However, neither ivtv nor cx25840 supports 
that. I've always thought that that would be a useful addition, but never 
got around to implementing it. You are the first one for whom such an ioctl 
would actually be useful, Gregor :-)

It should be fairly easy to add this, but I really don't have the time for 
this I'm afraid.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
