Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:13449 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2F2I1H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 04:27:07 -0400
Date: Fri, 29 Jun 2012 10:26:56 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kay Sievers <kay@redhat.com>
Subject: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
Message-ID: <20120629102656.05f46e0d@endymion.delvare>
In-Reply-To: <4FE8C4C4.1050901@redhat.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
	<4FE37194.30407@redhat.com>
	<4FE8B8BC.3020702@iki.fi>
	<4FE8C4C4.1050901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, 25 Jun 2012 17:06:28 -0300, Mauro Carvalho Chehab wrote:
> That's said, IMO, the best approach is to do:
> 
> 1) add support for asynchronous probe at device core, for devices that requires firmware
> at probe(). The async_probe() will only be active if !usermodehelper_disabled.
> 
> 2) export the I2C i2c_lock_adapter()/i2c_unlock_adapter() interface.

Both functions are already exported since kernel 2.6.32. However these
functions were originally made public for the shared pin case, where
two pins can be used for either I2C or something else, and we have to
prevent I2C usage when the other function is used. This does not help
in your case. What you need additionally is that unlocked flavors of
some i2c transfer functions (at least i2c_transfer itself) are exported
as well.

This isn't necessarily trivial though, as the locking and unlocking are
taking place inside i2c_transfer(), not at its boundaries. I'm looking
into this now.

-- 
Jean Delvare
