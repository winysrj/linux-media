Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:46181 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZICLHy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 07:07:54 -0400
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not working
	well together
From: Andy Walls <awalls@radix.net>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4A9EAF07.3040303@hhs.nl>
References: <4A9E9E08.7090104@onelan.com>  <4A9EAF07.3040303@hhs.nl>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 07:06:18 -0400
Message-Id: <1251975978.22279.8.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-09-02 at 19:44 +0200, Hans de Goede wrote: 
> Hi,
> 
> On 09/02/2009 06:32 PM, Simon Farnsworth wrote:
> > Hello,
> >
> > I'm in the process of reworking Xine's input_v4l to use libv4l2, so that
> >    it gets the benefit of all the work done on modern cards and webcams,
> > and I've hit a stumbling block.
> >
> > I have a Hauppauge HVR1600 for NTSC and ATSC support, and it appears to
> > simply not work with libv4l2, due to lack of mmap support. My code works
> > adequately (modulo a nice pile of bugs) with a HVR1110r3, so it appears
> > to be driver level.
> >
> > Which is the better route to handling this; adding code to input_v4l to
> > use libv4lconvert when mmap isn't available, or converting the cx18
> > driver to use mmap?
> >
> 
> Or modify libv4l2 to also handle devices which can only do read. There have
> been some changes to libv4l2 recently which would make doing that feasible.
> 
> > If it's a case of converting the cx18 driver, how would I go about doing
> > that? I have no experience of the driver, so I'm not sure what I'd have
> > to do - noting that if I break the existing read() support, other users
> > will get upset.

Modifying the cx18 driver to support mmap would be time consuming and
non-trivial.  Since cx18 is a rework of the ivtv driver, you will have
the same problem with ivtv and PVR-150's and PVR-500's.

Implementing mmap() in these drivers for MPEG PS and TS streams would be
interesting, because of the MPEG frames have variable length, not a
fixed length.  Since MPEG compressed video is the main format for which
people purchase a CX2341[568] based board for analog TV, mmap() mode
doesn't have a big payoff.

The CX2341[568] can output YUV video in the HM12 format, so mmap() may
make sense for that.  The challenges: implementing a {cx18,ivtv}-alsa
module to provide ALSA PCM nodes instead of /dev/video24 PCM audio; and
switching the primary stream handling and queuing used by the drivers
internally to be different for different stream types (YUV/mmap,
MPEG/read, and PCM/read but V4L2 and ALSA).

But I suspect no user pays for the extra cost of the CX2341[568]
hardware MPEG encoder, if the user primarily wants uncompressed YUV
video as their main format.


> I don't believe that modifying the driver is the answer, we need to either
> fix this at the libv4l or xine level.
> 
> I wonder though, doesn't the cx18 offer any format that xine can handle
> directly?

The CX2341[568] can output a DVD compatible MPEG-2 PS, if the default
MPEG-2 PS is something xine can't handle.


> As stated libv4l2 currently does not support devices that cannot do read,
> what this comes down to in practice (or should, if not that is a bug), is
> that it passes all calls directly to the driver. So if the driver has any
> pixfmt's xine can handle directly things should work fine.

The cx18 and ivtv drivers report 2 video capture pixel formats:

        static struct v4l2_fmtdesc formats[] = {
                { 0, V4L2_BUF_TYPE_VIDEO_CAPTURE, 0,
                  "HM12 (YUV 4:1:1)", V4L2_PIX_FMT_HM12, { 0, 0, 0, 0 }
                },
                { 1, V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FMT_FLAG_COMPRESSED,
                  "MPEG", V4L2_PIX_FMT_MPEG, { 0, 0, 0, 0 }
                }
        };


But MPEG controls can be used to select the exact format of the MPEG
stream, including an MPEG-2 TS in the case of the CX23418.


Regards,
Andy

> Regards,
> 
> Hans


