Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65378 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab1JTO4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 10:56:00 -0400
Received: by iaek3 with SMTP id k3so3501944iae.19
        for <linux-media@vger.kernel.org>; Thu, 20 Oct 2011 07:55:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHAyoxwJPpYbc06AB_S=JbqtCmmtYiCuxAuV_CBrmCHUJA_pLg@mail.gmail.com>
References: <CAHAyoxwJPpYbc06AB_S=JbqtCmmtYiCuxAuV_CBrmCHUJA_pLg@mail.gmail.com>
Date: Thu, 20 Oct 2011 10:55:59 -0400
Message-ID: <CAOcJUbzdf+B9yr39QKtoxnhKY53MqfSj9J4L1aT17YgZzBiqiw@mail.gmail.com>
Subject: Re: [PULL] git://linuxtv.org/mkrufky/mxl111sf aero-m-dvbt
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I had to push an additional patch to this tree, disabling some
calculations to avoid potential math errors and some build problems on
other architectures... Here is an updated pull request:

The following changes since commit a461e0ad3d27b6342140566909a80db30d151a91:
  Steven Toth (1):
        [media] cx23885: Stop the risc video fifo before reconfiguring it

are available in the git repository at:

  git://linuxtv.org/mkrufky/mxl111sf aero-m-dvbt

Michael Krufky (3):
      DVB: add MaxLinear MxL111SF DVB-T demodulator driver
      mxl111sf: add DVB-T support
      mxl111sf: disable snr / ber calculations for DVB-T

 drivers/media/dvb/dvb-usb/Makefile         |    1 +
 drivers/media/dvb/dvb-usb/mxl111sf-demod.c |  614 ++++++++++++++++++++++++++++
 drivers/media/dvb/dvb-usb/mxl111sf-demod.h |   55 +++
 drivers/media/dvb/dvb-usb/mxl111sf.c       |  228 ++++++++++-
 drivers/media/dvb/dvb-usb/mxl111sf.h       |    2 +-
 5 files changed, 896 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-demod.c
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-demod.h

Cheers,

Mike Krufky

On Tue, Oct 18, 2011 at 2:51 PM, Michael Krufky <mkrufky@kernellabs.com> wrote:
> Mauro,
>
> Please pull from the aero-m-dvbt branch of my mxl111sf git tree.  This
> adds DVB-T support to the WinTV Aero-M, which already supports ATSC.
> Once this is merged, the WinTV Aero-M will be the first USB device
> known to be supported under Linux that supports both ATSC and DVB-T.
> (I will have mine with me in Prague next week) ... Please pull asap so
> that we can play with the device next week using the merged
> repository.
>
> The following changes since commit a461e0ad3d27b6342140566909a80db30d151a91:
>  Steven Toth (1):
>        [media] cx23885: Stop the risc video fifo before reconfiguring it
>
> are available in the git repository at:
>
>  git://linuxtv.org/mkrufky/mxl111sf aero-m-dvbt
>
> Michael Krufky (2):
>      DVB: add MaxLinear MxL111SF DVB-T demodulator driver
>      mxl111sf: add DVB-T support
>
>  drivers/media/dvb/dvb-usb/Makefile         |    1 +
>  drivers/media/dvb/dvb-usb/mxl111sf-demod.c |  604 ++++++++++++++++++++++++++++
>  drivers/media/dvb/dvb-usb/mxl111sf-demod.h |   55 +++
>  drivers/media/dvb/dvb-usb/mxl111sf.c       |  228 +++++++++++-
>  drivers/media/dvb/dvb-usb/mxl111sf.h       |    2 +-
>  5 files changed, 886 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-demod.c
>  create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-demod.h
>
> Best Regards,
>
> Michael Krufky
>
