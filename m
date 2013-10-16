Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:39503 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934673Ab3JPRwU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 13:52:20 -0400
Date: Wed, 16 Oct 2013 19:52:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Antti Palosaari <crope@iki.fi>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH REVIEW] e4000: convert DVB tuner to I2C driver model
Message-ID: <20131016195205.11bf8418@endymion.delvare>
In-Reply-To: <525ED0C3.4010602@iki.fi>
References: <1381876264-20342-1-git-send-email-crope@iki.fi>
	<20131015203305.7dd5e55a.m.chehab@samsung.com>
	<CAOcJUby9LnEUVFm1HFxOE6mJaSPi-2DAyH16zNDvRHACqbOkPw@mail.gmail.com>
	<525EC23B.2020506@iki.fi>
	<CAOcJUbxEycDwYV56cb3gSPHcbFvXYUnvFe53DhOndEigwdD73Q@mail.gmail.com>
	<CAOcJUbxutEoBj56SCESPPyoHPkj3Z=VF-BtWsQdGYpsLGDX1zg@mail.gmail.com>
	<20131016190953.7b2070b4@endymion.delvare>
	<CAOcJUbxz2FT9vohNLoij97awmKgM8wFKx3Pfjom-e4t3ynNkUg@mail.gmail.com>
	<525ECB70.3000206@iki.fi>
	<CAOcJUbxfaO9oc7QN-vHQwg461FnPdTPqMkoksGsdgMWedgoJmA@mail.gmail.com>
	<525ED0C3.4010602@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 16 Oct 2013 20:45:39 +0300, Antti Palosaari wrote:
> On 16.10.2013 20:33, Michael Krufky wrote:
> > OK, I get it and it does seem OK.  I'm just curious what kind of
> > impact this refactoring would have over something like the
> > b2c2-flexcop-fe driver, who does not know which ic's to attach based
> > on device ids, but it does probe a few frontend combinations one after
> > another, in an order that the driver authors knew was safe.  I'd
> > imaging that we'd write some helper abstraction function to switch out
> > the info.type string as each driver gets probed?  I think that can get
> > quite ugly, but I know that the general population thinks dvb_attach()
> > is even uglier, so maybe this could be the right path...
> >
> > Wanna take a crack at b2c2-flexcop-fe?
> 
> heh, look the rtl28xxu driver in question, it does same. It probes maybe 
> total 10 tuners - checking their device ID too. Probing plain I2C device 
> address and making devision from that is simply dead idea. "Standard" 
> I2C address range for these silicon tuners are 0x60-0x64 => need to read 
> chip ID in order to detect => i2c_new_probed_device() is quite useless.

Please remember you can pass a custom probe function to
i2c_new_probed_device(). That probe function can read whatever chip ID
register exists to decide if the probe should be successful or not.

-- 
Jean Delvare
