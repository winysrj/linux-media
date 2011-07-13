Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab1GMUxI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 16:53:08 -0400
Message-ID: <4E1E05AC.2070002@infradead.org>
Date: Wed, 13 Jul 2011 17:53:00 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru>
In-Reply-To: <4E19D2F7.6060803@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-07-2011 13:27, Stas Sergeev escreveu:
> Hi.
> 
> When pulseaudio enables the audio capturing, the
> driver unmutes the sound. But, if no app have properly
> tuned the tuner yet, you get the white noise.
> I think the capturing must not touch the mute state,
> because, without tuning the tuner first, you can't capture
> anything anyway.
> Without this patch I am getting the white noise on every
> xorg/pulseaudio startup, which made me to always think
> that pulseaudio is a joke and will soon be removed. :)

Nack. We shouldn't patch a kernel driver due to an userspace bad behavior.

I've pinged Lennart about that and he is suggesting that we should use
a non-standard name for the controls, in order to avoid pulseaudio to touch
on them. We need first to double check if applications like tvtime and xawtv
will work with a different name for the audio volumes. If the existing apps
are ok, then maybe all we need to do is to rename all media volumes as something
like "<foo> Grabber" or "<foo> V4L".

Cheers,
Mauro
