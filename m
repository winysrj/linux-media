Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:33669 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966494AbeF2J2y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 05:28:54 -0400
Received: by mail-yw0-f169.google.com with SMTP id c135-v6so1321417ywa.0
        for <linux-media@vger.kernel.org>; Fri, 29 Jun 2018 02:28:54 -0700 (PDT)
MIME-Version: 1.0
References: <20180620203838.GA13372@amd> <CAAFQd5DpX2MbwQ484a1Jsk1Uok6eT=oduTYpqjE7AJcmpEs1UA@mail.gmail.com>
 <20180629091838.GA31718@amd>
In-Reply-To: <20180629091838.GA31718@amd>
From: Tomasz Figa <tfiga@google.com>
Date: Fri, 29 Jun 2018 18:28:41 +0900
Message-ID: <CAAFQd5BNXs3gaMpenD8C=+Jwxcrn3KQgKHKydpdeH1S5cWDFzQ@mail.gmail.com>
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

On Fri, Jun 29, 2018 at 6:18 PM Pavel Machek <pavel@ucw.cz> wrote:
>
> Hi!
>
> > > On Nokia N900, I have similar problems as Intel IPU3 hardware.
> > >
> > > Meeting notes say that pure software implementation is not fast
> > > enough, but that it may be useful for debugging. It would be also
> > > useful for me on N900, and probably useful for processing "raw" images
> > > from digital cameras.
> > >
> > > There is sensor part, and memory-to-memory part, right? What is
> > > the format of data from the sensor part? What operations would be
> > > expensive on the CPU? If we did everthing on the CPU, what would be
> > > maximum resolution where we could still manage it in real time?
> >
> > We can still use the memory-to-memory part (IMGU), even without 3A. It
> > would just do demosaicing at default parameters and give us a YUV
> > (NV12) frame. We could use some software component to analyze the YUV
> > output and adjust sensor parameters accordingly. Possibly the part we
> > already have in libv4l2 could just work?
>
> As soon as you get YUV, yes, libv4l2 should be able to work with that.
>
> OTOH using the memory-to-memory part is going to be tricky.

Why? I don't see any reason why it would be tricky. You just feed the
right CAPTURE node with YUV buffers and the right OUTPUT node with raw
buffers and that should work.

> What
> format is the data before demosaicing? Something common like BGGR10?

It's documented in detail in V4L2 documentation:
https://www.kernel.org/doc/html/latest/media/uapi/v4l/pixfmt-srggb10-ipu3.html

>
> > The expensive operation would be analyzing the frame itself. I suppose
> > you need to build some histogram representing brightness and white
> > balance of the frame and then infer necessary sensor adjustments from
> > that.
>
> That does not really have to be expensive. You can sample ... say
> 10000 pixels from the image, and get good-enough data for 3A.

Yes, but you need to do it relatively frequently to react for scene
changes and also even 10000 pixels (depending on distribution
) might mean fetching 10000*cacheline bytes of data.

> > > Would it be possible to get access to machine with IPU3, or would
> > > there be someone willing to test libv4l2 patches?
> >
> > I should be able to help with some basic testing, preferably limited
> > to command line tools (but I might be able to create a test
> > environment for X11 tools if really necessary).
>
> Could you just compile libv4l2 with sdlcam demo on the target, and
> then ssh -X there from some sort of reasonable system?

Yes, that should work I guess. That would be a Chrome OS device (which
doesn't include X11), so that would mean compiling some X11 libs (and
probably some more dependencies) as well, but that's not impossible.

Best regards,
Tomasz
