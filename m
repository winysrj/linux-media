Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:26301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab0IVTDP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 15:03:15 -0400
Message-ID: <4C9A52D8.1090402@redhat.com>
Date: Wed, 22 Sep 2010 16:02:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Stefan Lippers-Hollmann <s.l-h@gmx.de>,
	linux-media@vger.kernel.org, TerraTux <terratux@terratec.de>,
	Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [GIT PULL FOR 2.6.37] new AF9015 devices
References: <4C894DB8.8080908@iki.fi>
In-Reply-To: <4C894DB8.8080908@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 09-09-2010 18:12, Antti Palosaari escreveu:
> Moikka Mauro!
> This patch series adds support for TerraTec Cinergy T Stick Dual RC and TerraTec Cinergy T Stick RC. Also MxL5007T devices with ref. design IDs should be working. Cinergy T Stick remote is most likely not working since it seems to use different remote as Cinergy T Dual... Stefan could you test and ensure T Stick is working?
> 
> and thanks to TerraTec!
> 
> t. Antti
> 
> 
> The following changes since commit c9889354c6d36d6278ed851c74ace02d72efdd59:
> 
>   V4L/DVB: rc-core: increase repeat time (2010-09-08 13:04:40 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/anttip/media_tree.git af9015
> 
> Antti Palosaari (6):
>       af9015: simple comment update

Hmm... dvb-usb.h defines it as:
	struct dvb_usb_device_description devices[12];

It took me some time to find the current limit ;)

IMO, instead of just comment it as: 
	.num_device_descs = 9, /* check max from dvb-usb.h */

The better would be to add a definition at dvb-usb.h header for the max limit, and properly pointing it
on your drivers, like:

on dvb-usb.h:

	#define MAX_DEVICES_PER_DEV_PROPS	12
...
	struct dvb_usb_device_description devices[MAX_DEVICES_PER_DEV_PROPS];

on af9015 (and others):
	.num_device_descs = 9, /* max is MAX_DEVICES_PER_DEV_PROPS as defined on dvb-usb.h */

I'll apply this patch to avoid breaking your series, but please provide me a fix.

>       af9015: fix bug introduced by commit 490ade7e3f4474f626a8f5d778ead4e599b94fbcas
>       af9013: add support for MaxLinear MxL5007T tuner
>       af9015: add support for TerraTec Cinergy T Stick Dual RC
>       af9015: add remote support for TerraTec Cinergy T Stick Dual RC
>       af9015: map TerraTec Cinergy T Stick Dual RC remote to device ID
> 
>  drivers/media/dvb/dvb-usb/Kconfig         |    1 +
>  drivers/media/dvb/dvb-usb/af9015.c        |   50 +++++++++++++----------
>  drivers/media/dvb/dvb-usb/af9015.h        |   63 +++++++++++++++++++++++++++++
>  drivers/media/dvb/dvb-usb/dvb-usb-ids.h   |    1 +
>  drivers/media/dvb/frontends/af9013.c      |    1 +
>  drivers/media/dvb/frontends/af9013.h      |    1 +
>  drivers/media/dvb/frontends/af9013_priv.h |    5 +-
>  7 files changed, 99 insertions(+), 23 deletions(-)
> 
> 
Cheers,
Mauro
