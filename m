Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62715 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab2D3WJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 18:09:13 -0400
Received: by qcro28 with SMTP id o28so1653658qcr.19
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 15:09:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F9014CD.1040005@redhat.com>
References: <CAOcJUbxHCo7xfGHJZdeEgReJrpCriweSb9s9+-_NfSODLz_NPQ@mail.gmail.com>
	<4F9014CD.1040005@redhat.com>
Date: Mon, 30 Apr 2012 18:01:13 -0400
Message-ID: <CAHAyoxx+Thhj+EwFbtJcXbkzks=0x+RfdudKOgQT=pqJzePcLw@mail.gmail.com>
Subject: Re: ATSC-MH driver support for the Hauppauge WinTV Aero-m
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 19, 2012 at 9:36 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> This patch is incomplete:
>        - It doesn't increment the version number;
>        - Docbook is untouched.
>
> Also, I didn't see any post of those patches at the ML. Please post the
> patches at the ML for review before sending a pull request, especially
> when API changes are there.

New pull request and patchbomb follows:


The following changes since commit 296da3cd14db9eb5606924962b2956c9c656dbb0:

  [media] pwc: poll(): Check that the device has not beem claimed for
streaming already (2012-03-27 11:42:04 -0300)

are available in the git repository at:
  git://git.linuxtv.org/mkrufky/mxl111sf aero-m

Michael Krufky (10):
      linux-dvb v5 API support for ATSC-MH
      DocBook: document new DTV Properties for ATSC-MH delivery system
      increment DVB API to version 5.6 for ATSC-MH frontend control
      mxl111sf-tuner: tune SYS_ATSCMH just like SYS_ATSC
      DVB: add support for the LG2160 ATSC-MH demodulator
      lg2160: update internal api interfaces and enable build
      dvb-demux: add functionality to send raw payload to the dvr device
      dvb-usb: add support for dvb-usb-adapters that deliver raw payload
      dvb-usb: increase MAX_NO_OF_FE_PER_ADAP from 2 to 3
      mxl111sf: add ATSC-MH support

 Documentation/DocBook/media/dvb/dvbproperty.xml |  178 +++
 drivers/media/dvb/dvb-core/dvb_demux.c          |   10 +
 drivers/media/dvb/dvb-core/dvb_demux.h          |    2 +
 drivers/media/dvb/dvb-core/dvb_frontend.c       |   92 ++-
 drivers/media/dvb/dvb-core/dvb_frontend.h       |   22 +
 drivers/media/dvb/dvb-usb/Kconfig               |    1 +
 drivers/media/dvb/dvb-usb/dvb-usb-urb.c         |   12 +
 drivers/media/dvb/dvb-usb/dvb-usb.h             |    3 +-
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c      |    1 +
 drivers/media/dvb/dvb-usb/mxl111sf.c            |  871 +++++++++++++-
 drivers/media/dvb/frontends/Kconfig             |    8 +
 drivers/media/dvb/frontends/Makefile            |    1 +
 drivers/media/dvb/frontends/lg2160.c            | 1461 +++++++++++++++++++++++
 drivers/media/dvb/frontends/lg2160.h            |   84 ++
 include/linux/dvb/frontend.h                    |   54 +-
 include/linux/dvb/version.h                     |    2 +-
 16 files changed, 2751 insertions(+), 51 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/lg2160.c
 create mode 100644 drivers/media/dvb/frontends/lg2160.h
