Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:39762 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933168AbeF2GCh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 02:02:37 -0400
Received: by mail-yb0-f174.google.com with SMTP id k127-v6so2932684ybk.6
        for <linux-media@vger.kernel.org>; Thu, 28 Jun 2018 23:02:37 -0700 (PDT)
MIME-Version: 1.0
References: <20180620203838.GA13372@amd>
In-Reply-To: <20180620203838.GA13372@amd>
From: Tomasz Figa <tfiga@google.com>
Date: Fri, 29 Jun 2018 15:02:25 +0900
Message-ID: <CAAFQd5DpX2MbwQ484a1Jsk1Uok6eT=oduTYpqjE7AJcmpEs1UA@mail.gmail.com>
Subject: Re: Software-only image processing for Intel "complex" cameras
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        nicolas@ndufresne.ca,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>, mario.limonciello@dell.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Thu, Jun 21, 2018 at 5:38 AM Pavel Machek <pavel@ucw.cz> wrote:
>
> Hi!
>
> On Nokia N900, I have similar problems as Intel IPU3 hardware.
>
> Meeting notes say that pure software implementation is not fast
> enough, but that it may be useful for debugging. It would be also
> useful for me on N900, and probably useful for processing "raw" images
> from digital cameras.
>
> There is sensor part, and memory-to-memory part, right? What is
> the format of data from the sensor part? What operations would be
> expensive on the CPU? If we did everthing on the CPU, what would be
> maximum resolution where we could still manage it in real time?

We can still use the memory-to-memory part (IMGU), even without 3A. It
would just do demosaicing at default parameters and give us a YUV
(NV12) frame. We could use some software component to analyze the YUV
output and adjust sensor parameters accordingly. Possibly the part we
already have in libv4l2 could just work?

The expensive operation would be analyzing the frame itself. I suppose
you need to build some histogram representing brightness and white
balance of the frame and then infer necessary sensor adjustments from
that.

>
> Would it be possible to get access to machine with IPU3, or would
> there be someone willing to test libv4l2 patches?

I should be able to help with some basic testing, preferably limited
to command line tools (but I might be able to create a test
environment for X11 tools if really necessary).

Best regards,
Tomasz
