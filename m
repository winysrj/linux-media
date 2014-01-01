Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36789 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754657AbaAAWQJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jan 2014 17:16:09 -0500
Message-ID: <1388614684.2023.8.camel@palomino.walls.org>
Subject: Re: Fwd: v4l2: The device does not support the streaming I/O method.
From: Andy Walls <awalls@md.metrocast.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andy <dssnosher@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Wed, 01 Jan 2014 17:18:04 -0500
In-Reply-To: <CAGoCfixgun79tR_Nr+Qp9NdPPwYaUaX_HwqXj85rnOEXbEEH0w@mail.gmail.com>
References: <CAJghqepkKXth6_jqj5jU-HghAHxBBkaphCpR5MqfuRGXHXA4Sg@mail.gmail.com>
	 <CAJghqeopSEER-ExtW8LhXYkCNH99Mwj5W7JCZAEf65CTpBu94Q@mail.gmail.com>
	 <CAJghqerGcLUZCAT9LGP+5LzFLVCmHS1JUqNDTP1_Mj7b24fKhQ@mail.gmail.com>
	 <1388254550.2129.83.camel@palomino.walls.org>
	 <CAJghqeptMtc2OTUuCY8MUY14kj-d6KPpUAUCxjw8Nod6TNOMaA@mail.gmail.com>
	 <1388586278.1879.21.camel@palomino.walls.org>
	 <CAJghqerAVmCd_xcW9x2y=gKd4uq9-3P0CTmW_UpAjA42WQNNTw@mail.gmail.com>
	 <CAGoCfixgun79tR_Nr+Qp9NdPPwYaUaX_HwqXj85rnOEXbEEH0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2014-01-01 at 14:46 -0500, Devin Heitmueller wrote:
> On Wed, Jan 1, 2014 at 2:41 PM, Andy <dssnosher@gmail.com> wrote:
> > I am trying to stream /dev/video0 to http and encode it in h.264.
> 
> Last I checked, the ffmpeg v4l2 input interface is just for raw video.
>  What you probably want to do is just use v4l2-ctl to setup the tuner
> appropriately, and then pass in /dev/video0 as a standard filehandle
> to ffmpeg (i.e. "-i /dev/video0").

To obtain uncompressed video and audio from the ivtv driver and the
PVR-150:

uncompressed video is available from /dev/video32 in an odd Conexant
macroblock format that is called 'HM12' under linux.

raw PCM audio samples are available from /dev/video24


Note that /dev/video0 is always MPEG-2 compressed video.

I assume ffmpeg and mencoder can transcode from MPEG-2 PS to H.264 on
the fly, however, they will consume more CPU to do the decompression of
the MPEG-2 PS.  The advantage of working with the MPEG-2 PS as the
source is that one avoids the audio & video synchronization problem one
might encounter working with the separate uncompressed audio & video
streams. 

Regards,
Andy

