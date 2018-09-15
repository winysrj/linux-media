Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44272 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbeIPBzM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 21:55:12 -0400
Date: Sat, 15 Sep 2018 17:34:54 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Marco Felsch <m.felsch@pengutronix.de>
Subject: Re: [PATCH v2 00/14] Better handle pads for tuning/decoder part of
 the devices
Message-ID: <20180915173454.203afb43@coco.lan>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Sep 2018 17:14:15 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> At PC consumer devices, it is very common that the bridge same driver 
> to be attached to different types of tuners and demods. We need a way
> for the Kernel to properly identify what kind of signal is provided by each
> PAD, in order to properly setup the pipelines.
> 
> The previous approach were to hardcode a fixed number of PADs for all
> elements of the same type. This is not good, as different devices may 
> actually have a different number of pads.
> 
> It was acceptable in the past, as there were a promisse of adding "soon"
> a properties API that would allow to identify the type for each PADs, but
> this was never merged (or even a patchset got submitted).
> 
> So, replace this approach by another one: add a "taint" mark to pads that
> contain different types of signals.
> 
> I tried to minimize the number of signals, in order to make it simpler to
> convert from the past way.
> 
> For now, it is tested only with a simple grabber device. I intend to do
> more tests before merging it, but it would be interesting to have this
> merged for Kernel 4.19, as we'll now be exposing the pad index via
> the MC API version 2.
> 
> --
> 
> v2:
> 
> - Fix some issues noticed while testing with WinTV USB2. As result
> of such tests, I opted to use just one type for all analog signals.
> 
> - Added a patch to provide some info if something gets wrong while
>   creating the links.

In time:

1) The patches are at:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=pad-fix-4

2_ I have an experimental tree on the top of it with tvp5150 patches:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=tvp5150-4

I'll likely replace the last patch there by something else.

3) Except if I get any comments, my plan is to merge the patches
at pad-fix-4 together with tvp5150-4 branch on Monday;

4) There is a series of tvp5150-related patches that I'll keep out
of the Monday's merge:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=tvp5150-5

Those contain a patch series from Marco that are currently under
review, plus a reminder from me that some things are needed to be
changed after this series (the last patch is incomplete, but I intend
to wait for Marco's new patchset before working on a replacement).

Thanks,
Mauro
