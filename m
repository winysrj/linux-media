Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:45423 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370Ab2BGW1s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Feb 2012 17:27:48 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] tea575x-tuner improvements & use in maxiradio
Date: Tue, 7 Feb 2012 23:20:19 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1328447827-9842-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1328447827-9842-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202072320.30911.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 05 February 2012 14:17:05 Hans Verkuil wrote:
> These patches improve the tea575x-tuner module to make it up to date with
> the latest V4L2 frameworks.
>
> The maxiradio driver has also been converted to use the tea575x-tuner and
> I've used that card to test it.
>
> Unfortunately, this card can't read the data pin, so the new hardware seek
> functionality has been tested only partially (yes, it seeks, but when it
> finds a channel I can't read back the frequency).
>
> Ondrej, are you able to test these patches for the sound cards that use
> this tea575x tuner?
>
> Note that these two patches rely on other work that I did and that hasn't
> been merged yet. So it is best to pull from my git tree:
>
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/radio-pc
>i2
>
> You can use the v4l-utils repository (http://git.linuxtv.org/v4l-utils.git)
> to test the drivers: the v4l2-compliance test should succeed and with
> v4l2-ctl you can test the hardware seek:
>
> To seek down:
>
> v4l2-ctl -d /dev/radio0 --freq-seek=dir=0
>
> To seek up:
>
> v4l2-ctl -d /dev/radio0 --freq-seek=dir=1
>
> To do the compliance test:
>
> v4l2-compliance -r /dev/radio0

It seems to work (tested with SF64-PCR - snd_fm801) but the seek is severely 
broken. Reading the frequency immediately after seek does not work, it always 
returns the old value (haven't found a delay that works). Reading it later 
(copied back snd_tea575x_get_freq function) works. The chip seeks randomly up 
or down, ignoring UP/DOWN flag and often stops at wrong place (only noise) or 
even outside the FM range.

So I strongly suggest not to enable this (mis-)feature. The HW seems to be 
completely broken (unless there's some weird bug in the code).


-- 
Ondrej Zary
