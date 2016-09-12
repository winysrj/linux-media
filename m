Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51316 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755611AbcILS52 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 14:57:28 -0400
Date: Mon, 12 Sep 2016 13:57:09 -0500
From: Bin Liu <b-liu@ti.com>
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
CC: Alan Stern <stern@rowland.harvard.edu>, <hdegoede@redhat.com>,
        <linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: musb: isoc pkt loss with pwc
Message-ID: <20160912185709.GL18340@uda0271908>
References: <CAJs94EYkgXtr7P+HLsBnu6=j==g=wWRVFy91vofcdDziSfw60w@mail.gmail.com>
 <20160830183039.GA20056@uda0271908>
 <CAJs94EZbTT7TyEyc5QjKvybDdR1hORd-z1sD=yyYNj=kzPQ6tw@mail.gmail.com>
 <20160912032826.GB18340@uda0271908>
 <CAJs94EbNjkjN4eMY03eH3o=xVe+CGB95GQ+a5PsmsNUrDzi8mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAJs94EbNjkjN4eMY03eH3o=xVe+CGB95GQ+a5PsmsNUrDzi8mQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Sep 12, 2016 at 11:52:46AM +0300, Matwey V. Kornilov wrote:
> 2016-09-12 6:28 GMT+03:00 Bin Liu <b-liu@ti.com>:
> > Hi,
> >
> > On Tue, Aug 30, 2016 at 11:44:33PM +0300, Matwey V. Kornilov wrote:
> >> 2016-08-30 21:30 GMT+03:00 Bin Liu <b-liu@ti.com>:
> >> > Hi,
> >> >
> >> > On Sun, Aug 28, 2016 at 01:13:55PM +0300, Matwey V. Kornilov wrote:
> >> >> Hello Bin,
> >> >>
> >> >> I would like to start new thread on my issue. Let me recall where the issue is:
> >> >> There is 100% frame lost in pwc webcam driver due to lots of
> >> >> zero-length packages coming from musb driver.
> >> >
> >> > What is the video resolution and fps?
> >>
> >> 640x480 YUV420 10 frames per second.
> >> pwc uses proprietary compression during device-host transmission, but
> >> I don't know how effective it is.
> >
> > The data rate for VGA YUV420 @10fps is 640x480*1.5*10 = 4.6MB/s, which
> > is much higher than full-speed 12Mbps.  So the video data on the bus is
> > compressed, not YUV420, I believe.
> >
> >>
> >> >
> >> >> The issue is present in all kernels (including 4.8) starting from the commit:
> >> >>
> >> >> f551e13529833e052f75ec628a8af7b034af20f9 ("Revert "usb: musb:
> >> >> musb_host: Enable HCD_BH flag to handle urb return in bottom half"")
> >> >
> >> > What is the behavior without this commit?
> >>
> >> Without this commit all frames are being received correctly. Single
> >
> > Which means without this commit your camera has been working without
> > issues, and this is a regression with this commit, right?
> >
> 
> Right

Okay, thanks for confirming.

But we cannot just simply add this flag, as it breaks many other use
cases. I will continue work on this to find a solution which works on
all use cases.

Regards,
-Bin.
