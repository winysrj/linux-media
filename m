Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:33236 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S969007AbdDSTPW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 15:15:22 -0400
Received: by mail-qk0-f177.google.com with SMTP id h67so28825986qke.0
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 12:15:21 -0700 (PDT)
MIME-Version: 1.0
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Wed, 19 Apr 2017 15:15:20 -0400
Message-ID: <CAGoCfixZhG+9WuHgk=zfqgGbJvoggf2FyZMfVS+ifYYR+nw9rQ@mail.gmail.com>
Subject: RFC: Power states and VIDIOC_STREAMON
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I'm in the process of putting together a bunch of long-standing fixes
for HVR-950q driver, and I ran into a regression related to the way
the video decoder is being managed.  Before we dig into the details
here's the general question:

Should a user be able to interrogate video decoder properties after
doing a tune without having first called VIDIOC_STREAMON?

A long-standing use case is to be able to use a command-line tool like
v4l2-ctl to set the input, set the standard, issue a tuning request,
poll for a lock status, and once you see a signal lock then start
streaming.  This means that prior to starting streaming the tuner,
analog demodulator, and video decoder are all running even though
you're not actually receiving video buffers.

The problem comes down to these two patches:

https://git.linuxtv.org/media_tree.git/commit/drivers/media/dvb-frontends/au8522_decoder.c?id=38fe3510fa8fb5e75ee3b196e44a7b717d167e5d
https://git.linuxtv.org/media_tree.git/commit/drivers/media/dvb-frontends/au8522_decoder.c?id=d289cdf022c5bebf09c73097404aa9faf2211381

Prior to these patches, I would power up the IP blocks for the analog
demodulator and decoder when the video routing was setup (typically
when setting the input).  However as a result of these patches
powering up of those IP blocks is deferred until STREAMON is called.
Hence if you just set the input and issue a tuning request, and poll
for lock then you will never see the tuner in a locked state
regardless of the actual signal state.

I can appreciate the motivation behind Mauro's change in wanting to
constrain the window that the analog decoder is powered up to reduce
the risk of having it powered up at the same time as the digital
demodulator, but if it breaks long-standing ABI behavior then that
probably isn't going to work.

I did take a look at the the VIDIOC_STREAMON docs, which state that
the "Capture hardware is disabled and no buffers are filled" prior to
calling STREAMON:

https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/vidioc-streamon.html

However that language would suggest that even the tuner would be
powered down prior to calling STREAMON, which we know is almost never
the case.

I suspect the ambiguity lies in what is defined by "capture hardware":

The DMA engine or other mechanism of transferring completed video
buffers to userland?
The DMA engine and the video decoder?
The DMA engine, video decoder, and analog demodulator?
The DMA engine, video decoder, analog demodulator, and tuner?

I had always interpreted it such that the STREAMON call just
controlled whether the DMA engine was running, and thus you could do
anything else with the decoder before calling STREAMON other than
actually receiving video buffers.

My instinct would be to revert the patch in question since it breaks
ABI behavior which has been present for over a decade, but I suspect
such a patch would be rejected since it was Mauro himself who
introduced the change in behavior.

I look forward to hearing from the V4L2 maintainers with regards to
what the expected ABI behavior should be, at which point I can figure
out how to adjust the driver code to accommodate such behavior (and if
that means I cannot query for a signal lock prior to calling STREAMON,
going back and changing a bunch of userland code which expects such).

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
