Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:55992 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165Ab3JMMrQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 08:47:16 -0400
Message-ID: <1381668541.2209.14.camel@palomino.walls.org>
Subject: Re: ivtv 1.4.2/1.4.3 broken in recent kernels?
From: Andy Walls <awalls@md.metrocast.net>
To: Rajil Saraswat <rajil.s@gmail.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 13 Oct 2013 08:49:01 -0400
In-Reply-To: <1381620192.22245.18.camel@palomino.walls.org>
References: <CAFoaQoAK85BVE=eJG+JPrUT5wffnx4hD2N_xeG6cGbs-Vw6xOg@mail.gmail.com>
	 <1381371651.1889.21.camel@palomino.walls.org>
	 <CAFoaQoBiLUK=XeuW31RcSeaGaX3VB6LmAYdT9BoLsz9wxReYHQ@mail.gmail.com>
	 <1381620192.22245.18.camel@palomino.walls.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2013-10-12 at 19:23 -0400, Andy Walls wrote:
> On Thu, 2013-10-10 at 22:00 +0100, Rajil Saraswat wrote:
> > On 10 October 2013 03:20, Andy Walls <awalls@md.metrocast.net> wrote:
> > > On Wed, 2013-09-18 at 02:19 +0530, Rajil Saraswat wrote:
> > >> Hi,
> > >>
> > >>  I have a couple of PVR-500's which have additional tuners connected
> > >> to them (using daughter cards).
> > >
> > > The PVR-500's don't have daughter cards with additional tuners AFAIK.
> > >
> > > There is this however:
> > > http://www.hauppauge.com/site/webstore2/webstore_avcable-pci.asp
> > >
[snip]
> > >
> > >>  The audio is not usable on either
> > >> 1.4.2 or 1.4.3 ivtv drivers. The issue is described at
> > >> http://ivtvdriver.org/pipermail/ivtv-users/2013-September/010462.html
> > >
> > > With your previous working kernel and with the non-working kernel, what
> > > is the output of
> > >
> > > $ v4l2-ctl -d /dev/videoX --log-status
> > >
> > > after you have set up the inputs properly and have a known good signal
> > > going into the input in question?
> > >
> > > I'm speculating this is a problem with the cx25840 driver or the wm8775
> > > driver, since they change more often than the ivtv driver.
> > 
> > Yes, thats right it is a set of extra inputs and not a separate tuner
> > card. I played a video stream fro both kernels. Here are the logs
> > 
> > Working kernel 2.6.35
> >  v4l2-ctl -d /dev/video1 --log-status
> > 
> > Status Log:
> > 
> >    [50885.487963] ivtv1: =================  START STATUS CARD #1
> > =================
> >    [50885.487967] ivtv1: Version: 1.4.1 Card: WinTV PVR 500 (unit #2)
> [snip]
> >    [50885.545429] cx25840 2-0044: Video signal:              present
> >    [50885.545431] cx25840 2-0044: Detected format:           PAL-BDGHI
> >    [50885.545433] cx25840 2-0044: Specified standard:        PAL-BDGHI
> >    [50885.545435] cx25840 2-0044: Specified video input:     Composite 4
> >    [50885.545437] cx25840 2-0044: Specified audioclock freq: 48000 Hz
> [snip]
> >    [50885.553121] ivtv1: ==================  END STATUS CARD #1
> > ==================
> > 
> > For the non-working kernel 2.6.37
> > 
> >    [  212.730996] ivtv1: =================  START STATUS  =================
> >    [  212.731001] ivtv1: Version: 1.4.3 Card: WinTV PVR 500 (unit #2)
> [snip]
> >    [  212.787820] cx25840 2-0044: Video signal:              present
> >    [  212.787822] cx25840 2-0044: Detected format:           PAL-BDGHI
> >    [  212.787823] cx25840 2-0044: Specified standard:        PAL-BDGHI
> >    [  212.787824] cx25840 2-0044: Specified video input:     Composite 4
> [snip]
> 
> Hmm.  I have a PVR-500, with the extra input cable hooked up to unit #2
> of the PVR-500 and a DTV-to-CVBS converter box connected.
> 
> My CVBS signal shows up when I am set to PVR-500  'Input 2, Composite 1'
> which is cx25840 'Composite 3'.  This makes sense for unit #2 of a
> PVR-500. It must have the white connector wired differently from unit #1
> of the PVR-500 (and from the PVR-150), since the PVR-500 unit #2 doesn't
> have a CVBS input connector on the main card.
> 
> Are you sure you have the input like this and obtain good video from
> PVR-500 unit #2, when it is set to 'Input 4, Composite 2', cx25840
> 'Composite 4'?
> 
> Could you try recording with PVR unit #2 set to 'Input 2, Composite 1',
> cx25840 'Composite 3'?  
> 
> These are the questions in my mind:
> 
> Is your PVR-500 unit #2 wired differently than mine?
> Are the older kernels more forgiving when capturing audio with the wrong
> input set? (Try both Input 2 and Input 4 with both kernels.)


OK, I just tested with my Wii game console connected to the PVR-500 unit
#2, Fedora 17, kernel 3.6.10-2.fc17.x86_64.

1. With the unit set to 'Input 2, Composite 1', cx25840 'Composite 3':
Good video, good audio

2. With the unit set to 'Input 4, Composite 2', cx25840 'Composite 4':
No video, distorted audio.

AFAICT:
You're using the wrong input.
You weren't checking the video, only the audio.

I consider this problem resolved.


> > Unfortunately, i cannot do a git bisect since it is a remote system
> > with a slow internet connection.

Is this system for personal or professional use?  I don't know of any
home users who have remote sites.

If for professional use, I'd suggest your employer pay a consultant, if
the company/university/whatever can't do a git bisect on a development
system in house.

-Andy

