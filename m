Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42796 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbeHBLaI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 07:30:08 -0400
Date: Thu, 2 Aug 2018 06:39:38 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Pravin Shedge <pravin.shedge4linux@gmail.com>,
        Brian Warner <brian.warner@samsung.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Antti Palosaari <crope@iki.fi>,
        Nasser Afshin <afshin.nasser@gmail.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 00/13] Better handle pads for tuning/decoder part of the
 devices
Message-ID: <20180802063938.3f29b1cf@coco.lan>
In-Reply-To: <2a14ce78-8a5d-be0d-1ff4-614fe128814f@xs4all.nl>
References: <cover.1533138685.git.mchehab+samsung@kernel.org>
        <2a14ce78-8a5d-be0d-1ff4-614fe128814f@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 2 Aug 2018 11:12:23 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/01/18 17:55, Mauro Carvalho Chehab wrote:
> > At PC consumer devices, it is very common that the bridge same driver 
> > to be attached to different types of tuners and demods. We need a way
> > for the Kernel to properly identify what kind of signal is provided by each
> > PAD, in order to properly setup the pipelines.
> > 
> > The previous approach were to hardcode a fixed number of PADs for all
> > elements of the same type. This is not good, as different devices may 
> > actually have a different number of pads.
> > 
> > It was acceptable in the past, as there were a promisse of adding "soon"
> > a properties API that would allow to identify the type for each PADs, but
> > this was never merged (or even a patchset got submitted).
> > 
> > So, replace this approach by another one: add a "taint" mark to pads that
> > contain different types of signals.
> > 
> > I tried to minimize the number of signals, in order to make it simpler to
> > convert from the past way.
> > 
> > For now, it is tested only with a simple grabber device. I intend to do
> > more tests before merging it, but it would be interesting to have this
> > merged for Kernel 4.19, as we'll now be exposing the pad index via
> > the MC API version 2.  
> 
> Other than a small comment for the last patch I didn't see anything
> problematical in this series. It doesn't touch on the public API or
> on any of the non-tuner drivers. So for patches 1-12:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> And after adding back the documentation for the enums in patch 13 you
> can add my Ack to that one as well.

Thank you! I changed patch 13 to keep the documentation and added your
ack:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=pad-fix-3

Thanks,
Mauro
