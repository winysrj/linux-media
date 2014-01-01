Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35206 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaAAWVf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jan 2014 17:21:35 -0500
Received: by mail-wi0-f181.google.com with SMTP id hq4so13438434wib.8
        for <linux-media@vger.kernel.org>; Wed, 01 Jan 2014 14:21:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1388614684.2023.8.camel@palomino.walls.org>
References: <CAJghqepkKXth6_jqj5jU-HghAHxBBkaphCpR5MqfuRGXHXA4Sg@mail.gmail.com>
	<CAJghqeopSEER-ExtW8LhXYkCNH99Mwj5W7JCZAEf65CTpBu94Q@mail.gmail.com>
	<CAJghqerGcLUZCAT9LGP+5LzFLVCmHS1JUqNDTP1_Mj7b24fKhQ@mail.gmail.com>
	<1388254550.2129.83.camel@palomino.walls.org>
	<CAJghqeptMtc2OTUuCY8MUY14kj-d6KPpUAUCxjw8Nod6TNOMaA@mail.gmail.com>
	<1388586278.1879.21.camel@palomino.walls.org>
	<CAJghqerAVmCd_xcW9x2y=gKd4uq9-3P0CTmW_UpAjA42WQNNTw@mail.gmail.com>
	<CAGoCfixgun79tR_Nr+Qp9NdPPwYaUaX_HwqXj85rnOEXbEEH0w@mail.gmail.com>
	<1388614684.2023.8.camel@palomino.walls.org>
Date: Wed, 1 Jan 2014 17:21:33 -0500
Message-ID: <CAGoCfiz1+7M4P7At7BrVZtVGM_4ntMZR6z4hTurhVzLNnG=Pcg@mail.gmail.com>
Subject: Re: Fwd: v4l2: The device does not support the streaming I/O method.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Andy <dssnosher@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 1, 2014 at 5:18 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> uncompressed video is available from /dev/video32 in an odd Conexant
> macroblock format that is called 'HM12' under linux.

I should have been more clear - last I checked it only supported raw
video in streaming mode (mmap).  So even though the driver has this
capability it won't really help.

> raw PCM audio samples are available from /dev/video24

Same basic issue, I think it will only acquire audio via ALSA.

> Note that /dev/video0 is always MPEG-2 compressed video.
>
> I assume ffmpeg and mencoder can transcode from MPEG-2 PS to H.264 on
> the fly, however, they will consume more CPU to do the decompression of
> the MPEG-2 PS.  The advantage of working with the MPEG-2 PS as the
> source is that one avoids the audio & video synchronization problem one
> might encounter working with the separate uncompressed audio & video
> streams.

Agreed that transcoding is more CPU expensive, but I suspect if he's
willing to transcode he can actually get something working today
without any modifications to the sources of either the driver or
ffmpeg.  And as you suggested, it does help avoid the A/V sync
problems associated with raw capture.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
