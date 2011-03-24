Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:22210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1CXRe1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 13:34:27 -0400
Message-ID: <4D8B80A0.5040600@redhat.com>
Date: Thu, 24 Mar 2011 14:34:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] HVR-900 R2 and PCTV 330e DVB support
References: <AANLkTi=hppcpARY1DOOJwK7kyKPe+2Q415jt8dNh8Z=-@mail.gmail.com>
In-Reply-To: <AANLkTi=hppcpARY1DOOJwK7kyKPe+2Q415jt8dNh8Z=-@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 24-03-2011 14:05, Devin Heitmueller escreveu:
> This patch series finally merges in Ralph Metzler's drx-d driver and
> brings up the PCTV 330e and
> HVR-900R2.  The patches have been tested for quite some time by users
> on the Kernel Labs blog,
> and they have been quite happy with them.
> 
> The firmware required can be found here:
> 
> http://kernellabs.com/firmware/drxd/
> 
> The following changes since commit 41f3becb7bef489f9e8c35284dd88a1ff59b190c:
> 
>   [media] V4L DocBook: update V4L2 version (2011-03-11 18:09:02 -0300)
> 
> are available in the git repository at:
>   git://sol.kernellabs.com/dheitmueller/drx.git drxd

The pull request went fine. I'll be handling the series right now.

One quick note for your next pull requests: Please don't add:

Priority: normal

Meta-tag on git patches. All patches are handled by default as normal patches.
If you want to send me fixes, please use a separate pull request. Also, if
a patch is meant to be sent also to stable kernels, just add:

Cc: stable@kernel.org

And upstream stable team will take care on it, when the patch arrives Linus tree.

> 
> Devin Heitmueller (12):
>       drx: add initial drx-d driver
>       drxd: add driver to Makefile and Kconfig
>       drxd: provide ability to control rs byte
>       em28xx: enable support for the drx-d on the HVR-900 R2
>       drxd: provide ability to disable the i2c gate control function
>       em28xx: fix GPIO problem with HVR-900R2 getting out of sync with drx-d
>       em28xx: include model number for PCTV 330e
>       em28xx: add digital support for PCTV 330e
>       drxd: move firmware to binary blob
>       em28xx: remove "not validated" flag for PCTV 330e
>       em28xx: add remote control support for PCTV 330e
>       drxd: Run lindent across sources
> 
>  Documentation/video4linux/CARDLIST.em28xx   |    2 +-
>  drivers/media/dvb/frontends/Kconfig         |   11 +
>  drivers/media/dvb/frontends/Makefile        |    2 +
>  drivers/media/dvb/frontends/drxd.h          |   61 +
>  drivers/media/dvb/frontends/drxd_firm.c     |  929 ++
>  drivers/media/dvb/frontends/drxd_firm.h     |  118 +
>  drivers/media/dvb/frontends/drxd_hard.c     | 2806 ++++++
>  drivers/media/dvb/frontends/drxd_map_firm.h |12694 +++++++++++++++++++++++++++
>  drivers/media/video/em28xx/em28xx-cards.c   |   21 +-
>  drivers/media/video/em28xx/em28xx-dvb.c     |   22 +-
>  drivers/media/video/em28xx/em28xx.h         |    2 +-
>  11 files changed, 16649 insertions(+), 19 deletions(-)
>  create mode 100644 drivers/media/dvb/frontends/drxd.h
>  create mode 100644 drivers/media/dvb/frontends/drxd_firm.c
>  create mode 100644 drivers/media/dvb/frontends/drxd_firm.h
>  create mode 100644 drivers/media/dvb/frontends/drxd_hard.c
>  create mode 100644 drivers/media/dvb/frontends/drxd_map_firm.h
> 
> 

