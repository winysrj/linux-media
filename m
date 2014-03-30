Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy12-pub.mail.unifiedlayer.com ([50.87.16.10]:41055 "HELO
	oproxy12-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750882AbaC3EXI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 00:23:08 -0400
Message-ID: <1396153381.3383.66.camel@Wailaba2>
Subject: Re: [PATCH] [media] uvcvideo: Fix clock param realtime setting
From: Olivier Langlois <olivier@trillion01.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: m.chehab@samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>
Date: Sun, 30 Mar 2014 00:23:01 -0400
In-Reply-To: <2051908.tTlcvVaa3D@avalon>
References: <1395985358-17047-1-git-send-email-olivier@trillion01.com>
	 <16236471.uFSjvbT2di@avalon> <1396042028.3383.34.camel@Wailaba2>
	 <2051908.tTlcvVaa3D@avalon>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> > Yes. ffmpeg uses wall clock time to create timestamps for audio packets from
> > ALSA device.
> 
> OK. I suppose I shouldn't drop support for the realtime clock like I wanted to 
> then :-)
>  
> > There is a bug in ffmpeg describing problems to synchronize audio and
> > the video from a v4l2 webcam.
> > 
> > https://trac.ffmpeg.org/ticket/692
> > 
> > To workaround this issue, ffmpeg devs added a switch to convert back
> > monotonic to realtime. From ffmpeg/libavdevice/v4l2.c:
> > 
> >   -ts                <int>        .D.... set type of timestamps for
> > grabbed frames (from 0 to 2) (default 0)
> >      default                      .D.... use timestamps from the kernel
> >      abs                          .D.... use absolute timestamps (wall
> > clock)
> >      mono2abs                     .D.... force conversion from monotonic
> > to absolute timestamps
> > 
> > If the v4l2 driver is able to send realtime ts, it is easier synchronize
> > in userspace if all inputs use the same clock.
> 
> That might be a stupid question, but shouldn't ALSA use the monotonic clock 
> instead ?
> 
I think that I have that answer why ffmpeg use realtime clock for ALSA
data. In fact ffmpeg uses realtime clock for every data coming from
capture devices and the purpose is to be able to seek into the recorded
stream by using the date where the recording occured. Same principle
than a camera recording dates when pictures are taken.

now a tougher question is whether or not it is up to the driver to
provide these realtime ts.

I'm looking forward your verdict.


