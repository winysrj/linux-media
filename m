Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58100 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaDHQyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 12:54:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Olivier Langlois <olivier@trillion01.com>
Cc: m.chehab@samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
	ffmpeg-devel@ffmpeg.com
Subject: Re: [PATCH] [media] uvcvideo: Fix clock param realtime setting
Date: Tue, 08 Apr 2014 18:57:04 +0200
Message-ID: <2912342.xkGF6kaQOW@avalon>
In-Reply-To: <1396412820.3383.111.camel@Wailaba2>
References: <1395985358-17047-1-git-send-email-olivier@trillion01.com> <1711768.4zHOjaJUg6@avalon> <1396412820.3383.111.camel@Wailaba2>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olivier,

On Wednesday 02 April 2014 00:31:59 Olivier Langlois wrote:
> On Tue, 2014-04-01 at 15:49 +0200, Laurent Pinchart wrote:
> > On Sunday 30 March 2014 00:23:01 Olivier Langlois wrote:
> > > > > Yes. ffmpeg uses wall clock time to create timestamps for audio
> > > > > packets from ALSA device.
> > > > 
> > > > OK. I suppose I shouldn't drop support for the realtime clock like I
> > > > wanted to then :-)
> > > > 
> > > > > There is a bug in ffmpeg describing problems to synchronize audio
> > > > > and the video from a v4l2 webcam.
> > > > > 
> > > > > https://trac.ffmpeg.org/ticket/692
> > > > > 
> > > > > To workaround this issue, ffmpeg devs added a switch to convert back
> > > > > 
> > > > > monotonic to realtime. From ffmpeg/libavdevice/v4l2.c:
> > > > >   -ts                <int>        .D.... set type of timestamps for
> > > > >                                          grabbed frames (from 0 to
> > > > >                                          2) (default 0)
> > > > >      default                      .D.... use timestamps from the
> > > > >                                          kernel
> > > > >      abs                          .D.... use absolute timestamps
> > > > >                                          (wall clock)
> > > > >      mono2abs                     .D.... force conversion from
> > > > >                                          monotonic to absolute
> > > > >                                          timestamps
> > > > > 
> > > > > If the v4l2 driver is able to send realtime ts, it is easier
> > > > > synchronize in userspace if all inputs use the same clock.
> > > > 
> > > > That might be a stupid question, but shouldn't ALSA use the monotonic
> > > > clock instead ?
> > > 
> > > I think that I have that answer why ffmpeg use realtime clock for ALSA
> > > data. In fact ffmpeg uses realtime clock for every data coming from
> > > capture devices and the purpose is to be able to seek into the recorded
> > > stream by using the date where the recording occured. Same principle
> > > than a camera recording dates when pictures are taken.
> > > 
> > > now a tougher question is whether or not it is up to the driver to
> > > provide these realtime ts.
> > 
> > It makes sense to associate a wall time with recorded streams for that
> > purpose, but synchronization should in my opinion be performed using the
> > monotonic clock, as the wall time can jump around. I believe drivers
> > should provide monotonic timestamps only. However, given that the uvcvideo
> > driver has the option of providing wall clock timestamps, that option
> > should work, so your patch makes sense. I'd still like to remove support
> > for the wall clock though, but I don't want to break userspace. ffmpeg
> > should be fixed, especially given that most V4L devices provide monotonic
> > timestamps only.
>
> Please do not stop yourself to remove realtime ts support in your driver
> because that would not break ffmpeg, IMHO. It is just me that have tried
> to leverage options offered by your driver to remove the need to use
> ffmpeg workaround for a sync issue. I apparently have been the first
> ffmpeg user to try out!

Then let's fix it first, and then I'll remove the option :-)

> I am currently in the process to contribute the introduction of using
> CLOCK_MONOTONIC inside ffmpeg. CCing their list because I think your
> reply is relevant to the discussion we have on the topic there at the
> moment.

Very nice. Please keep me informed of the progress.

-- 
Regards,

Laurent Pinchart

