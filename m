Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab2DSNg2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 09:36:28 -0400
Message-ID: <4F9014CD.1040005@redhat.com>
Date: Thu, 19 Apr 2012 10:36:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: ATSC-MH driver support for the Hauppauge WinTV Aero-m
References: <CAOcJUbxHCo7xfGHJZdeEgReJrpCriweSb9s9+-_NfSODLz_NPQ@mail.gmail.com>
In-Reply-To: <CAOcJUbxHCo7xfGHJZdeEgReJrpCriweSb9s9+-_NfSODLz_NPQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-04-2012 00:49, Michael Krufky escreveu:
> These patches have been around and tested for quite some time.  Every
> few weeks I have to regenerate them in order to stay in sync with the
> media tree.  I think it's time for some review and possibly merge into
> the master development repository.  This complies with what was
> discussed in at the media developer kernel summit in Prague, Oct 2011.
>  Once merged, I'll have time to work on some userspace utilities.  For
> now, I have created a very basic ATSC-MH scanning application that
> demonstrates the API additions.  The app can be found here:
> http://linuxtv.org/hg/~mkrufky/mhscan
> 
> Please review:
> 
> The following changes since commit 296da3cd14db9eb5606924962b2956c9c656dbb0:
> 
>   [media] pwc: poll(): Check that the device has not beem claimed for
> streaming already (2012-03-27 11:42:04 -0300)
> 
> are available in the git repository at:
>   git://git.linuxtv.org/mkrufky/mxl111sf mh_for_v3.5
> 
> Michael Krufky (8):
>       linux-dvb v5 API support for ATSC-MH

This patch is incomplete:
	- It doesn't increment the version number;
	- Docbook is untouched.

Also, I didn't see any post of those patches at the ML. Please post the
patches at the ML for review before sending a pull request, especially
when API changes are there.

>       mxl111sf-tuner: tune SYS_ATSCMH just like SYS_ATSC
>       DVB: add support for the LG2160 ATSC-MH demodulator
>       lg2160: update internal api interfaces and enable build
>       dvb-demux: add functionality to send raw payload to the dvr device
>       dvb-usb: add support for dvb-usb-adapters that deliver raw payload
>       dvb-usb: increase MAX_NO_OF_FE_PER_ADAP from 2 to 3
>       mxl111sf: add ATSC-MH support
> 
>  drivers/media/dvb/dvb-core/dvb_demux.c     |   10 +
>  drivers/media/dvb/dvb-core/dvb_demux.h     |    2 +
>  drivers/media/dvb/dvb-core/dvb_frontend.c  |   92 ++-
>  drivers/media/dvb/dvb-core/dvb_frontend.h  |   22 +
>  drivers/media/dvb/dvb-usb/Kconfig          |    1 +
>  drivers/media/dvb/dvb-usb/dvb-usb-urb.c    |   12 +
>  drivers/media/dvb/dvb-usb/dvb-usb.h        |    3 +-
>  drivers/media/dvb/dvb-usb/mxl111sf-tuner.c |    1 +
>  drivers/media/dvb/dvb-usb/mxl111sf.c       |  871 ++++++++++++++++-
>  drivers/media/dvb/frontends/Kconfig        |    8 +
>  drivers/media/dvb/frontends/Makefile       |    1 +
>  drivers/media/dvb/frontends/lg2160.c       | 1461 ++++++++++++++++++++++++++++
>  drivers/media/dvb/frontends/lg2160.h       |   84 ++
>  include/linux/dvb/frontend.h               |   54 +-
>  14 files changed, 2572 insertions(+), 50 deletions(-)
>  create mode 100644 drivers/media/dvb/frontends/lg2160.c
>  create mode 100644 drivers/media/dvb/frontends/lg2160.h




> 
> Cheers,
> 
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

