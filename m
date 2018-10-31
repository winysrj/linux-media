Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46454 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730360AbeKADju (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 23:39:50 -0400
Date: Wed, 31 Oct 2018 15:40:30 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.20-rc1] new experimental media request API
Message-ID: <20181031154030.3fab5a00@coco.lan>
In-Reply-To: <CAHk-=whQKCA18MEi7FT=10c0HVa=kxSyYBJeAQH-C2mA5gBhbg@mail.gmail.com>
References: <20181030105328.0667ec68@coco.lan>
        <CAHk-=whQKCA18MEi7FT=10c0HVa=kxSyYBJeAQH-C2mA5gBhbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Em Wed, 31 Oct 2018 11:05:09 -0700
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Tue, Oct 30, 2018 at 6:53 AM Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org> wrote:
> >
> > For a new media API: the request API  
> 
> Ugh. I don't know how much being in staging matters - if people start
> using it, they start using it.
> 
> "Staging" does not mean "regressions don't matter".

Yes, I know.

This shouldn't affect normal cameras and generic V4L2 apps, as this
is for very advanced use cases. So, we hope that people won't start
using it for a while. 

The main interested party on this is Google CromeOS. We're working 
together with them in order to do upstream first. They are well aware
that the API may change. So, I don't expect any complaints from their
side if the API would require further changes.

The point is that this API is complex and ensuring that it will
work properly is not easy. We've been thinking about a solution for
the Camera HAL 2 for a long time (I guess the first discussions were
done back in 2008).

The big problem is that V4L2 API was designed to work with a stream,
while Google HAL API expects to have control for each individual
frame.

The Google API allows, for example that, inside a stream, the
first frame would have a VGA resolution, the next one a 4K resolution
(for example, when the user clicks on a camera button) and then returning
back to VGA (it actually allows full control for every single frame). 

This is something that it is not possible to do with the "standard" 
V4L2 API without stopping and restarting a stream (with increases
a lot the latency).

Solving it is so complex that we decided to start with a completely
new type of Linux media drivers (stateless decoders). In long term, 
the same API should be used by not only by decoders, but also for 
encoders and complex cameras (those with an image signal processor 
inside a SoC chipset).

In order to be sure that it is possible to implement the way we did,
We need to be able to add it to the Kernel somehow and to have
enough drivers that will let us test all possible scenarios.

That will allow to adapt a version of the camera HAL for testing
and see if it behaves as expected.

> But pulled,

Thanks! Anyway, we'll try to rush the tests for this API in order to
try sending any fixes that might be disruptive before the final
release.

Regards,
Mauro
