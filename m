Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45527 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab2HFMBA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 08:01:00 -0400
Message-ID: <501FB1EC.5070905@iki.fi>
Date: Mon, 06 Aug 2012 15:00:44 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/2] get rid of fe_ioctl_override()
References: <1344190590-10863-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344190590-10863-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/2012 09:16 PM, Mauro Carvalho Chehab wrote:
> There's just one driver using fe_ioctl_override(), and it can be
> replaced at tuner_attach call. This callback is evil, as only DVBv3
> calls are handled.
>
> Removing it is also a nice cleanup, as about 90 lines of code are
> removed.
>
> Get rid of it!

I totally agree that! Only mxl111sf.c uses it and it was overriding 
signal strength meter which could be overridden by simply replacing fe 
default demod callback by one from tuner.

Actually it was very near I removed support for it from dvb-usb-v2 
totally but still decided to leave as I converted mxl111sf driver. You 
likely saw my comments to avoid using it in dvb_usb.h :)

> Mauro Carvalho Chehab (2):
>    [media] dvb core: remove support for post FE legacy ioctl intercept
>    [media] dvb: get rid of fe_ioctl_override callback
>
>   drivers/media/dvb/dvb-core/dvb_frontend.c   | 20 +----------------
>   drivers/media/dvb/dvb-core/dvbdev.h         | 26 ----------------------
>   drivers/media/dvb/dvb-usb-v2/dvb_usb.h      |  3 ---
>   drivers/media/dvb/dvb-usb-v2/dvb_usb_core.c |  2 --
>   drivers/media/dvb/dvb-usb-v2/mxl111sf.c     | 34 +----------------------------
>   drivers/media/dvb/dvb-usb/dvb-usb-dvb.c     |  1 -
>   drivers/media/dvb/dvb-usb/dvb-usb.h         |  2 --
>   drivers/media/video/cx23885/cx23885-dvb.c   |  3 +--
>   drivers/media/video/cx88/cx88-dvb.c         |  2 +-
>   drivers/media/video/saa7134/saa7134-dvb.c   |  2 +-
>   drivers/media/video/videobuf-dvb.c          | 11 +++-------
>   include/media/videobuf-dvb.h                |  4 +---
>   12 files changed, 9 insertions(+), 101 deletions(-)

regards
Antti

-- 
http://palosaari.fi/
