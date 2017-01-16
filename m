Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:53379 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751167AbdAPKKz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 05:10:55 -0500
Date: Mon, 16 Jan 2017 10:10:53 +0000
From: Sean Young <sean@mess.org>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Pavel Machek <pavel@ucw.cz>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 1/5] [media] ir-rx51: port to rc-core
Message-ID: <20170116101053.GA24265@gofer.mess.org>
References: <cover.1482255894.git.sean@mess.org>
 <f5262cc638a494f238ef96a80d8f45265ca2fd02.1482255894.git.sean@mess.org>
 <5878d916-6a60-d5c3-b912-948b5b970661@gmail.com>
 <20161230130752.GA7377@gofer.mess.org>
 <20161230133030.GA7861@gofer.mess.org>
 <1e4fa726-5dec-028e-9f0f-1c53d58df981@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e4fa726-5dec-028e-9f0f-1c53d58df981@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ivo,

On Fri, Dec 30, 2016 at 03:50:42PM +0200, Ivaylo Dimitrov wrote:
> On 30.12.2016 15:30, Sean Young wrote:
> >
> >On Fri, Dec 30, 2016 at 01:07:52PM +0000, Sean Young wrote:
> >>Hi Ivo,,
> >>
> >>On Fri, Dec 30, 2016 at 01:30:01PM +0200, Ivaylo Dimitrov wrote:
> >>>On 20.12.2016 19:50, Sean Young wrote:
> >>>>This driver was written using lirc since rc-core did not support
> >>>>transmitter-only hardware at that time. Now that it does, port
> >>>>this driver.
> >>>>
> >>>>Compile tested only.
> >>>>
> >>>
> >>>I guess after that change, there will be no more /dev/lircN device, right?
> >>>Neither will LIRC_XXX IOCTL codes be supported?
> >>
> >>Quite the opposite, /dev/lircN and all the LIRC_XXX ioctls will still be
> >>supported through ir-lirc-codec.c.
> >>
> >>By using rc-core, the driver will be more succinct, and some latent bugs
> >>will be fixed. For example, at the moment it is possible to write hours
> >>of IR data and keep the n900 from suspending.
> >>
> >>I'm working on lirc scancode sending and receiving using the IR encoders,
> >>and when that is in place, any rc-core driver will get it for free.
> >>
> >>>That looks to me as a completely new driver, not a port to new API.
> >>>
> >>>Right now there are applications using the current behaviour (pierogi for
> >>>example), which will be broken by the change.
> >>
> >>Nothing should break.
> >
> >Speaking of which, if you would please test this, that would be great. My
> >N900 died many years ago.
> >
> 
> Will do, but next year :) .

Have you had a chance to test the ir-rx51 changes?

Thanks
Sean
