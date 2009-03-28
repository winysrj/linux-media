Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4295 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbZC1PW5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 11:22:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Steven Toth <stoth@linuxtv.org>
Subject: Re: V4L2 Advanced Codec questions
Date: Sat, 28 Mar 2009 16:22:44 +0100
Cc: linux-media@vger.kernel.org
References: <49CBA64F.2080506@linuxtv.org>
In-Reply-To: <49CBA64F.2080506@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903281622.44690.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 26 March 2009 16:59:11 Steven Toth wrote:
> Hello!
>
> I want to open a couple of HVR22xx items up for discussion.
>
> The HVR-22xx analog encoder is capable of encoded to all kinds of video
> and audio codecs in various containers formats.
>
>  From memory, wm9, mpeg4, mpeg2, divx, AAC, AC3, Windows audio codecs in
> asf, ts, ps, avi containers, depending on various firmware license
> enablements and configuration options. Maybe more, maybe, I'll draw up a
> complete list when I begin to focus on analog.
>
> Any single encoder on the HVR22xx can produce (if licensed) any of the
> formats above. However, due to a lack of CPU horsepower in the RISC
> engine, the board is not completely symmetrical when the encoders are
> running concurrently. This is the main reason why Hauppauge have disabled
> these features in the windows driver.
>
> It's possible for example to get two concurrent MPEG2 PS streams but only
> if the bitrate is limited to 6Mbps, which we also do in the windows
> driver.
>
> Apart from the fact that we (the LinuxTV community) will need to
> determine what's possible concurrently, and what isn't, it does raise
> interesting issues for the V4L2 API.
>
> So, how do we expose this advanced codec and hardware encoder limitation
> information through v4l2 to the applications?
>
> Do we, don't we?

Hi Steve,

If I understand it correctly, then a single analog source can be encoded to 
multiple formats at the same time, right?

Or is it that multiple analog sources can each be encoded to some format? Or 
a combination of both?

Is there a limit to the number of concurrent encoders (except for CPU 
horsepower)?

Basically, since you can have multiple encoders, you also need multiple 
videoX nodes, once for each encoder. And I would expect that an application 
can just setup each encoder. Whenever you start an encoder the driver might 
either accept it or return -ENOSPC if there aren't enough resources.

You have to document the restrictions in a document, but otherwise I don't 
see any reason why implementing this would cause any problems.

Adding new containers and codecs is easy: just add the missing ones to enum 
v4l2_mpeg_stream_type, v4l2_mpeg_audio_encoding and 
v4l2_mpeg_video_encoding and add any additional controls that are needed to 
implement each codec/container.

In theory you can reduce the number of possible containers/codecs/bitrates 
in the controls according to the remaining resources. But I think that will 
be too complicated to do for too little gain, not only in the driver but 
also in the application.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
