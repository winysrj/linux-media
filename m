Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58290 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbbKQTAS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 14:00:18 -0500
Date: Tue, 17 Nov 2015 17:00:12 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Antti Palosaari <crope@iki.fi>, linux-kernel@vger.kernel.org,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: [PATCH] [MEDIA] dvb: usb: fix dib3000mc dependencies
Message-ID: <20151117170012.24fe7f58@recife.lan>
In-Reply-To: <5525192.eyIcy1NRHy@wuerfel>
References: <3984729.n55BH9Zr8c@wuerfel>
	<5525192.eyIcy1NRHy@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 17 Nov 2015 17:24:23 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Tuesday 17 November 2015 17:17:39 Arnd Bergmann wrote:
> > The dibusb_read_eeprom_byte function is defined in dibusb-common.c,
> > but that file is not compiled for CONFIG_DVB_USB_DIBUSB_MB as it
> > is for the other driver using the common functions, so we can
> > get a link error:
> > 
> > drivers/built-in.o: In function `dibusb_dib3000mc_tuner_attach':
> > (.text+0x2c5124): undefined reference to `dibusb_read_eeprom_byte'
> > (.text+0x2c5134): undefined reference to `dibusb_read_eeprom_byte'
> > 
> > This changes the Makefile to treat the file like all the others
> > in this directory, and enforce building dvb-usb-dibusb-common.o
> > as a dependency.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > 
> 
> I just realized that this depends on another patch I've sent back
> in April, so that is probably no longer in the patch queue. Please
> disregard for now.

Hi Arnd,

The better way to fix it is to do a patch like this one:
	http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=8abe4a0a3f6d4217b16a1a3f68cd5c72ab5a058e

The problem with those dib drivers is that there's no way to latter
remove them with rmmod. Using the above techinique, not only ranconfig
compilation will work, but it will also allow module remove and having
drivers with some frontends disabled.

The drawback is that it is not a very trivial patch, so I did the
changes only for devices that I have (all based on dib0700).

Unfortunately, I don't have any device currently based on dib3000.
I could work on such patchset, but someone would need to test it ;)

Regards,
Mauro
