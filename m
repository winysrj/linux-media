Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50445 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1KLSKS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 13:10:18 -0500
Received: by wyh15 with SMTP id 15so4751669wyh.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 10:10:17 -0800 (PST)
Message-ID: <4ebeb688.aa6db40a.5f99.ffffb173@mx.google.com>
Subject: Re: [PATCH 1/7] af9015 Slow down download firmware
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Date: Sat, 12 Nov 2011 18:10:11 +0000
In-Reply-To: <4EBE9B54.9050202@iki.fi>
References: <4ebe96cb.85c7e30a.27d9.ffff9098@mx.google.com>
	 <4EBE9B54.9050202@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2011-11-12 at 18:14 +0200, Antti Palosaari wrote:
> On 11/12/2011 05:54 PM, Malcolm Priestley wrote:
> > It is noticed that sometimes the device fails to download parts of the firmware.
> >
> > Since there is no ack from firmware write a 250u second delay has been added.
> >
> > Signed-off-by: Malcolm Priestley<tvboxspy@gmail.com>
> > ---
> >   drivers/media/dvb/dvb-usb/af9015.c |    1 +
> >   1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
> > index c6c275b..dc6e4ec 100644
> > --- a/drivers/media/dvb/dvb-usb/af9015.c
> > +++ b/drivers/media/dvb/dvb-usb/af9015.c
> > @@ -698,6 +698,7 @@ static int af9015_download_firmware(struct usb_device *udev,
> >   			err("firmware download failed:%d", ret);
> >   			goto error;
> >   		}
> > +		udelay(250);
> >   	}
> >
> >   	/* firmware loaded, request boot */
> 
> That sleep is not critical as all, so defining it as udelay() is wrong 
> in my understanding. Refer Kernel documentation about delays.

So we just go faster and faster, without acknowledgements and  due
respect for the hardware?

Typical download time is about 100ms, download on some systems was less
than 50ms and failing.

A 250uS wait brought the time back up to arround 100ms.

Regards

Malcolm

