Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2683 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZC1SEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 14:04:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Steven Toth <stoth@linuxtv.org>
Subject: Re: V4L2 Advanced Codec questions
Date: Sat, 28 Mar 2009 19:03:56 +0100
Cc: linux-media@vger.kernel.org
References: <49CBA64F.2080506@linuxtv.org> <200903281622.44690.hverkuil@xs4all.nl> <49CE5873.8000603@linuxtv.org>
In-Reply-To: <49CE5873.8000603@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903281903.56263.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 28 March 2009 18:03:47 Steven Toth wrote:
> Hans Verkuil wrote:
> > On Thursday 26 March 2009 16:59:11 Steven Toth wrote:
> >> Hello!
> >>
> >> I want to open a couple of HVR22xx items up for discussion.
> >>
> >> The HVR-22xx analog encoder is capable of encoded to all kinds of
> >> video and audio codecs in various containers formats.
> >>
> >>  From memory, wm9, mpeg4, mpeg2, divx, AAC, AC3, Windows audio codecs
> >> in asf, ts, ps, avi containers, depending on various firmware license
> >> enablements and configuration options. Maybe more, maybe, I'll draw up
> >> a complete list when I begin to focus on analog.
> >>
> >> Any single encoder on the HVR22xx can produce (if licensed) any of the
> >> formats above. However, due to a lack of CPU horsepower in the RISC
> >> engine, the board is not completely symmetrical when the encoders are
> >> running concurrently. This is the main reason why Hauppauge have
> >> disabled these features in the windows driver.
> >>
> >> It's possible for example to get two concurrent MPEG2 PS streams but
> >> only if the bitrate is limited to 6Mbps, which we also do in the
> >> windows driver.
> >>
> >> Apart from the fact that we (the LinuxTV community) will need to
> >> determine what's possible concurrently, and what isn't, it does raise
> >> interesting issues for the V4L2 API.
> >>
> >> So, how do we expose this advanced codec and hardware encoder
> >> limitation information through v4l2 to the applications?
> >>
> >> Do we, don't we?
> >
> > Hi Steve,
> >
> > If I understand it correctly, then a single analog source can be
> > encoded to multiple formats at the same time, right?
>
> No.
>
> > Or is it that multiple analog sources can each be encoded to some
> > format? Or a combination of both?
>
> Multiple analog sources can produce multiple formats, CPU power
> permitting.

So it is always: 'one source -> one encoder', right? Never 'one source -> 
multiple encoders'?

>
> > Is there a limit to the number of concurrent encoders (except for CPU
> > horsepower)?
>
> Not that I'm aware of, yet.

There must be a limit to the number of sources? Or can this device act as a 
codec as well: you present it with raw video from memory and it compresses 
it to e.g. mpeg?

>
> > Basically, since you can have multiple encoders, you also need multiple
> > videoX nodes, once for each encoder. And I would expect that an
> > application can just setup each encoder. Whenever you start an encoder
> > the driver might either accept it or return -ENOSPC if there aren't
> > enough resources.
>
> This is fine, and expected.
>
> > You have to document the restrictions in a document, but otherwise I
> > don't see any reason why implementing this would cause any problems.
> >
> > Adding new containers and codecs is easy: just add the missing ones to
> > enum v4l2_mpeg_stream_type, v4l2_mpeg_audio_encoding and
> > v4l2_mpeg_video_encoding and add any additional controls that are
> > needed to implement each codec/container.
>
> Ahh, this is the magic information I was looking for.
>
> > In theory you can reduce the number of possible
> > containers/codecs/bitrates in the controls according to the remaining
> > resources. But I think that will be too complicated to do for too
> > little gain, not only in the driver but also in the application.
>
> I think this is going to be the major issue and it will start to reflect
> itself through the API into the application. We'll see, maybe not.

The first step will be to get a single encoder going :-)

At this stage I don't know enough about the capabilities of the hardware to 
tell how important it is to have such info available. I suspect any 
solution to this might well need something like a media controller device 
about which I've written before, which can be used to present such meta 
information.

I'm ever more of the opinion that v4l needs such a top-level device as v4l 
hardware becomes more complex.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
