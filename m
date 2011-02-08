Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55998 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab1BHWRW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Feb 2011 17:17:22 -0500
Received: by ewy5 with SMTP id 5so3334375ewy.19
        for <linux-media@vger.kernel.org>; Tue, 08 Feb 2011 14:17:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102082305.24897.martin@pibbs.de>
References: <201102082305.24897.martin@pibbs.de>
Date: Tue, 8 Feb 2011 17:17:20 -0500
Message-ID: <AANLkTinC7_-AXVq3eoo=G0rQBXzKqh-1tamVDY91BMsh@mail.gmail.com>
Subject: Re: em28xx: board id [eb1a:2863 eMPIA Technology, Inc] Silver Crest
 VG2000 "USB 2.0 Video Grabber"
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Martin Seekatz <martin@pibbs.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Feb 8, 2011 at 5:05 PM, Martin Seekatz <martin@pibbs.de> wrote:
> The vbi0 device is not working:
> ERROR: Couldn't attach to DCOP server!
> [0x10713a0] v4l2 demux error: device does not support mmap i/o
> [0x10713a0] v4l2 demux error: device does not support mmap i/o
> [0x1270260] v4l2 access error: device does not support mmap i/o
> [0x1270260] v4l2 access error: device does not support mmap i/o
> [0x7f91d000d660] main input error: open of `v4l2:///dev/vbi0' failed:
> (null)

VLC doesn't support VBI for any device (I have patches for VLC to add
the support, but they have not been submitted upstream yet).

> The audio device must be explicitly selected to watch video together
> with sound.

Correct.  This is how all V4L2 devices work.

> The snapshot buttom shows no effect on operating.

The snapshot button typically creates an input event associated with
KEY_CAMERA.  Your application has to explicitly support it in order
for it to be used.

> Other video applications as motv show the video graphic, but without
> sound.

This is not surprising.  Most of the older analog tv applications were
designed to have an audio output cable connecting the capture device
to speakers, such that the audio is not routed through the PC.

> I hope it helps to enhance the drivers for better support of this
> products, or to advice me how to handle it with the actual sytem.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
