Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZKISBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 13:01:32 -0500
Date: Mon, 9 Nov 2009 16:00:58 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Giacomo <delleceste@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: v4l-dvb status
Message-ID: <20091109160058.7ef4a0ea@pedra.chehab.org>
In-Reply-To: <885896af0911090019p6e0c784fq5b3e8f20e00d479c@mail.gmail.com>
References: <885896af0911090019p6e0c784fq5b3e8f20e00d479c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Giacomo,

Em Mon, 9 Nov 2009 09:19:05 +0100
Giacomo <delleceste@gmail.com> escreveu:

> good morning to all in the list.
> 
> I have a few questions, back trying to install v4l-dvb kernel drivers
> after some time.
> 
> 1. Is the project going to support kernel 2.6.31?

Huh? This project is for upstream kernel drivers. All drivers produced go to
kernel.

> 2. I used to use tvtime + sox for the usb audio, with big problems
> causing audio
>    desynchronization with large delay with respect to the video: do
> the (new) drivers
>    solve the issue?
>   -  I also remember that there was an integrated version of
> tvtime/usb audio in hg repositories,
>      is it still maintained? is there a particular version to download
> to correctly build it?

tvtime stopped being maintained on 2005. You may find a few patches for it on
some places, but there are some issues on those patches.

Currently, you'll find a good support for V4L2 with mplayer. It generally
synchronizes audio and video well.

> 3. It's two years since I first installed v4l-dvb drivers, and still I
> encounter problems to find all
>    the channels with tvtime.
>    Is there some module parameter to provide for the module em28xx for
> Pinnacle PCTV USB2,
>    for the Italian standards?

You should be sure to select the proper video standard used in Italy. Maybe your
device tuner is different than the one configured at the driver. Different tuners
generally have different cut-off frequencies between the 3 bands (low VHF, high VHF,
UHF). If you are using a different tuner, you may not be able to see the channels that
are close to the cut-off frequencies.

Currently, there are two variants of PCTV:

        [EM2820_BOARD_PINNACLE_USB_2] = {
                .name         = "Pinnacle PCTV USB 2",
                .tuner_type   = TUNER_LG_PAL_NEW_TAPC,

        [EM2820_BOARD_PINNACLE_USB_2_FM1216ME] = {
                .name         = "Pinnacle PCTV USB 2 (Philips FM1216ME)",
                .tuner_type   = TUNER_PHILIPS_FM1216ME_MK3,

Each with a different tuner. The better way is to open your device and see
what's labeled at the metal can inside it, to be sure what variant are you
using.

You may also play with the tuner by passing a parameter to the kernel driver specifying your
tuner model, based on the numbers at:

	linux/Documentation/video4linux/CARDLIST.tuner
> 
> Thanks in advance for any hint and the great work done on v4l-dvb project
> 
> Giacomo
> 




Cheers,
Mauro
