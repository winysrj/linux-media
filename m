Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40485 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab0GHVty (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jul 2010 17:49:54 -0400
Received: by eya25 with SMTP id 25so184954eya.19
        for <linux-media@vger.kernel.org>; Thu, 08 Jul 2010 14:49:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C364416.3000809@gmail.com>
References: <4C353039.4030202@gmail.com>
	<AANLkTikiCtPhE8uERNoYV_UF43MZU0YQgPWxyA4X0l5U@mail.gmail.com>
	<4C360E64.3020703@gmail.com>
	<AANLkTilNmBPU-YVXfo12MITtTJHwsMvZsxkkjCBz68H_@mail.gmail.com>
	<4C362C6E.5050104@gmail.com>
	<AANLkTikCrka3EyqhjP7z6wYQa4Z8exDa9Dwda60OLsVJ@mail.gmail.com>
	<4C363692.5000600@gmail.com>
	<4C364416.3000809@gmail.com>
Date: Thu, 8 Jul 2010 17:49:52 -0400
Message-ID: <AANLkTimRQaFDzKTXAIxIs2lT7ldrMwMNIFSJN4VzJOQQ@mail.gmail.com>
Subject: Re: em28xx: success report for KWORLD DVD Maker USB 2.0 (VS-USB2800)
	[eb1a:2860]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ivan <ivan.q.public@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 8, 2010 at 5:33 PM, Ivan <ivan.q.public@gmail.com> wrote:
> Ok, the horizontal shift disappears if I switch to 720x480 instead of
> 640x480.
>
> Does the card always output 720x480 (in NTSC mode anyway), then, and any
> scaling is done by V4L?

That card does have an onboard scaler, although it's not clear to me
why it isn't working.  Exactly what command line did you use?

> I also have a question about dropped frames. After running mplayer or
> mencoder, I see a line like:
>
> v4l2: 1199 frames successfully processed, -3 frames dropped.
>
> I can only guess that the negative number means that V4L received frames at
> a slightly faster rate than the expected 30000/1001 fps. In my case, it
> would seem that my SNES is producing something more like 30.05 fps, and so
> V4L reports a "negative" dropped frame every 12.5 seconds or so.

Yeah, I don't know.  You would have to ask the mplayer/mencoder people.

> It would also seem that V4L doesn't actually discard any frames, but still
> passes them on to mplayer/mencoder, because mencoder shows an encoding fps
> of 30.04 (and it will skip a frame every 12.5 seconds or so unless you pass
> it -noskip).
>
> Am I right about all this?

Again, this would be an mplayer/mencoder thing.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
