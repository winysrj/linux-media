Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:32931 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab3JMTOQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 15:14:16 -0400
Received: by mail-la0-f49.google.com with SMTP id ev20so5001690lab.36
        for <linux-media@vger.kernel.org>; Sun, 13 Oct 2013 12:14:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381668541.2209.14.camel@palomino.walls.org>
References: <CAFoaQoAK85BVE=eJG+JPrUT5wffnx4hD2N_xeG6cGbs-Vw6xOg@mail.gmail.com>
	<1381371651.1889.21.camel@palomino.walls.org>
	<CAFoaQoBiLUK=XeuW31RcSeaGaX3VB6LmAYdT9BoLsz9wxReYHQ@mail.gmail.com>
	<1381620192.22245.18.camel@palomino.walls.org>
	<1381668541.2209.14.camel@palomino.walls.org>
Date: Sun, 13 Oct 2013 20:14:14 +0100
Message-ID: <CAFoaQoAaGhDycKfGhD2m-OSsbhxtxjbbWfj5uidJ0zMpEWQNtw@mail.gmail.com>
Subject: Re: ivtv 1.4.2/1.4.3 broken in recent kernels?
From: Rajil Saraswat <rajil.s@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> OK, I just tested with my Wii game console connected to the PVR-500 unit
> #2, Fedora 17, kernel 3.6.10-2.fc17.x86_64.
>
> 1. With the unit set to 'Input 2, Composite 1', cx25840 'Composite 3':
> Good video, good audio
>
> 2. With the unit set to 'Input 4, Composite 2', cx25840 'Composite 4':
> No video, distorted audio.
>

This is what i used to changed the input

v4l2-ctl -d /dev/video1 --set-input 4

With this 2.6.35 gives me perfect video/audio. Kernel 3.10.7 on the
other hand gives good video but distorted audio. On this cards primary
input (/dev/video0), i use the radio so i cant use input 2 of this
card. My composite cable is connected to the 'extra-input' card which
should be composite 2.

My understanding is input 4 is #2 composite, and input 2 is #1
composite. Is that not right?

This is what i tried in kernel 2.6.35:

1. v4l2-ctl -d /dev/video1 --set-input 2
Video input set to 2 (Composite 1: ok)
No video

2. v4l2-ctl -d /dev/video1 --set-input 4
Video input set to 4 (Composite 2: ok)
Good video

As i mentioned in kernel 2.6.35, mythtv/mplayer give me both good
video/audio if i use 2 above.

> AFAICT:
> You're using the wrong input.
> You weren't checking the video, only the audio.

What inputs do you think i should use with v4l2-ctl?


>> > Unfortunately, i cannot do a git bisect since it is a remote system
>> > with a slow internet connection.
>
> Is this system for personal or professional use?  I don't know of any
> home users who have remote sites.

Your know one user now!. Yes it is for personal use. It was for my old
folks who live in another country and i manage their mythtv/htpc
remotely.

-Rajil
