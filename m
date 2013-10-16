Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:36748 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab3JPRKL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 13:10:11 -0400
Date: Wed, 16 Oct 2013 19:09:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH REVIEW] e4000: convert DVB tuner to I2C driver model
Message-ID: <20131016190953.7b2070b4@endymion.delvare>
In-Reply-To: <CAOcJUbxutEoBj56SCESPPyoHPkj3Z=VF-BtWsQdGYpsLGDX1zg@mail.gmail.com>
References: <1381876264-20342-1-git-send-email-crope@iki.fi>
	<20131015203305.7dd5e55a.m.chehab@samsung.com>
	<CAOcJUby9LnEUVFm1HFxOE6mJaSPi-2DAyH16zNDvRHACqbOkPw@mail.gmail.com>
	<525EC23B.2020506@iki.fi>
	<CAOcJUbxEycDwYV56cb3gSPHcbFvXYUnvFe53DhOndEigwdD73Q@mail.gmail.com>
	<CAOcJUbxutEoBj56SCESPPyoHPkj3Z=VF-BtWsQdGYpsLGDX1zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Wed, 16 Oct 2013 13:04:42 -0400, Michael Krufky wrote:
> YIKES!!  i2c_new_probed_device() does indeed probe the hardware --
> this is unacceptable, as such an action can damage the ic.
> 
> Is there some additional information that I'm missing that lets this
> perform an attach without probe?

Oh, i2c_new_probed_device() probes the device, what a surprise! :D

Try, I don't know, i2c_new_device() maybe if you don't want the
probe? ;)

-- 
Jean Delvare
