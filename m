Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46776 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab2BHSRP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2012 13:17:15 -0500
Received: by vbjk17 with SMTP id k17so522150vbj.19
        for <linux-media@vger.kernel.org>; Wed, 08 Feb 2012 10:17:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHAyoxw=t5CMQD2DPsZy9JV94fUXG=DNoNxvra9JYrLb_Jy5Fg@mail.gmail.com>
References: <CAHAyoxyo3uw3npFmCmYiOE0akPqJt2X_R1MqZJ6Dk7dbPhdFjg@mail.gmail.com>
	<CAHAyoxw=t5CMQD2DPsZy9JV94fUXG=DNoNxvra9JYrLb_Jy5Fg@mail.gmail.com>
Date: Wed, 8 Feb 2012 13:17:14 -0500
Message-ID: <CAHAyoxzHZUUTKDzYH=mr8iSW3WRs9u=zyR5ax_zwuXr04Yshsg@mail.gmail.com>
Subject: Re: [GIT PULL] adding support for Xceive XC5000C tuner... |
 git://linuxtv.org/mkrufky/tuners xc5000
From: Michael Krufky <mkrufky@kernellabs.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Steven Toth <stoth@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 7, 2012 at 12:56 AM, Michael Krufky <mkrufky@kernellabs.com> wrote:
> On Tue, Feb 7, 2012 at 12:06 AM, Michael Krufky <mkrufky@kernellabs.com> wrote:
>> Please review / ack / merge:
>>

After speaking to Devin briefly on irc, I decided to make a few
cleanups.  The drivers don't actually need to specify a firmware file
to the xc5000 driver at attach-time.  Rather, it should specify the
chip revision (if available)  If unspecified, default to the XC5000A

The following changes since commit 59b30294e14fa6a370fdd2bc2921cca1f977ef16:
  Mauro Carvalho Chehab (1):
        Merge branch 'v4l_for_linus' into staging/for_v3.4

are available in the git repository at:

  git://linuxtv.org/mkrufky/tuners xc5000

Michael Krufky (8):
      xc5000: allow drivers to set desired firmware in xc5000_attach
      xc5000: add XC5000C_DEFAULT_FIRMWARE: dvb-fe-xc5000c-41.024.5-31875.fw
      tuner: add support for Xceive XC5000C
      tveeprom: add support for Xceive XC5000C tuner
      remove unneeded #define's in xc5000.h
      xc5000: remove static dependencies on xc5000 created by previous
changesets
      xc5000: drivers should specify chip revision rather than firmware
      xc5000: declare firmware configuration structures as static const

 drivers/media/common/tuners/tuner-types.c |    4 ++
 drivers/media/common/tuners/xc5000.c      |   47 +++++++++++++++++++++++++----
 drivers/media/common/tuners/xc5000.h      |    5 +++
 drivers/media/video/tuner-core.c          |   15 +++++++++
 drivers/media/video/tveeprom.c            |    2 +-
 include/media/tuner.h                     |    1 +
 6 files changed, 67 insertions(+), 7 deletions(-)

Cheers,
-Mike
