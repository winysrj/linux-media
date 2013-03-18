Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab3CRWnD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 18:43:03 -0400
Date: Mon, 18 Mar 2013 19:42:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] IT913X
Message-ID: <20130318194249.54402501@redhat.com>
In-Reply-To: <51478151.5070702@iki.fi>
References: <51477002.2000605@iki.fi>
	<51478151.5070702@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 18 Mar 2013 23:04:17 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> I rebased it as Mauro just committed some stuff that causes merge conflict!

Well, if the conflicts are trivial, there's no need to rebase. There are
several patches that I use rebase when merging. Of course, rebasing it
saves me some time ;)

Regards,
Mauro
> 
> Antti
> 
> On 03/18/2013 09:50 PM, Antti Palosaari wrote:
> > That patch serie adds new silicon RF-tuner driver named IT913X and
> > IT9135 support for existing AF9035/AF9033 drivers. IT913X driver is
> > split out from the existing IT9135 driver.
> >
> > IT913X serie is successor of AF903X serie. Difference is integrated
> > RF-tuner. Also those two letters has changed from AF to IT as Afatech
> > was bought by ITE Tech.
> >
> > Logically there is three "chips", as always in case of DTV USB device:
> > * USB-interface
> > * demodulator
> > * RF-tuner
> >
> > These are sold as following chip names and integrated combinations:
> > * AF9032 = demodulator ?
> > * AF9033 = demodulator
> > * AF9035 = USB-interface + demodulator
> > * IT9133 = demodulator + RF-tuner
> > * IT9135 = USB-interface + demodulator + RF-tuner
> > * IT9137 = IT9135 + MPEG TS input for connecting extra IT9133
> >
> >
> > regards
> > Antti
> >
> >
> > The following changes since commit
> > 4ca286610f664acf3153634f3930acd2de993a9f:
> >
> >    [media] radio-rtrack2: fix mute bug (2013-03-05 15:20:07 -0300)
> >
> > are available in the git repository at:
> >
> >    git://linuxtv.org/anttip/media_tree.git it9135_tuner
> >
> > for you to fetch changes up to 17f64e21efadad3da1744feec97a12d97df15765:
> >
> >    MAINTAINERS: add drivers/media/tuners/it913x* (2013-03-10 03:58:13
> > +0200)
> >
> > ----------------------------------------------------------------
> > Antti Palosaari (41):
> >        ITE IT913X silicon tuner driver
> >        af9033: support for it913x tuners
> >        af9035: add support for 1st gen it9135
> >        af9035: add auto configuration heuristic for it9135
> >        af9035: fix af9033 demod sampling frequency
> >        af9015: reject device TerraTec Cinergy T Stick Dual RC (rev. 2)
> >        af9035: [0ccd:0099] TerraTec Cinergy T Stick Dual RC (rev. 2)
> >        af9035: constify clock tables
> >        af9035: USB1.1 support (== PID filters)
> >        af9035: merge af9035 and it9135 eeprom read routines
> >        af9035: basic support for IT9135 v2 chips
> >        af9033: IT9135 v2 supported related changes
> >        af9035: IT9135 dual tuner related changes
> >        it913x: merge it913x_fe_start() to it913x_init_tuner()
> >        it913x: merge it913x_fe_suspend() to it913x_fe_sleep()
> >        it913x: rename functions and variables
> >        it913x: tuner power up routines
> >        it913x: get rid of it913x config struct
> >        it913x: remove unused variables
> >        it913x: include tuner IDs from af9033.h
> >        it913x: use dev_foo() logging
> >        af9033: add IT9135 demod reg init tables
> >        it913x: remove demod init reg tables
> >        af9035: select firmware loader according to firmware
> >        af9035: use already detected eeprom base addr
> >        af9035: set demod TS mode config in read_config()
> >        af9035: enable remote controller for IT9135 too
> >        af9035: change dual mode boolean to bit field
> >        af9033: add IT9135 tuner config "38" init table
> >        af9033: add IT9135 tuner config "51" init table
> >        af9033: add IT9135 tuner config "52" init table
> >        af9033: add IT9135 tuner config "60" init table
> >        af9033: add IT9135 tuner config "61" init table
> >        af9033: add IT9135 tuner config "62" init table
> >        it913x: remove unused af9033 demod tuner config inits
> >        af9033: move code from it913x to af9033
> >        af9033: sleep on attach()
> >        af9033: implement i/o optimized reg table writer
> >        af9035: check I/O errors on IR polling
> >        af9035: style changes for remote controller polling
> >        MAINTAINERS: add drivers/media/tuners/it913x*
> >
> >   MAINTAINERS                               |   10 +
> >   drivers/media/dvb-frontends/af9033.c      |  138 ++++++++++---
> >   drivers/media/dvb-frontends/af9033.h      |   15 ++
> >   drivers/media/dvb-frontends/af9033_priv.h | 1506
> > +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >
> >   drivers/media/tuners/Kconfig              |    7 +
> >   drivers/media/tuners/Makefile             |    1 +
> >   drivers/media/tuners/it913x.c             |  447
> > ++++++++++++++++++++++++++++++++++++++++
> >   drivers/media/tuners/it913x.h             |   45 ++++
> >   drivers/media/tuners/it913x_priv.h        |   78 +++++++
> >   drivers/media/usb/dvb-usb-v2/Kconfig      |    1 +
> >   drivers/media/usb/dvb-usb-v2/af9015.c     |   40 +++-
> >   drivers/media/usb/dvb-usb-v2/af9035.c     |  545
> > ++++++++++++++++++++++++++++++++-----------------
> >   drivers/media/usb/dvb-usb-v2/af9035.h     |   47 +++--
> >   13 files changed, 2654 insertions(+), 226 deletions(-)
> >   create mode 100644 drivers/media/tuners/it913x.c
> >   create mode 100644 drivers/media/tuners/it913x.h
> >   create mode 100644 drivers/media/tuners/it913x_priv.h
> >
> 
> 


-- 

Cheers,
Mauro
