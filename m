Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:55346 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaLSKeO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 05:34:14 -0500
Received: by mail-ob0-f182.google.com with SMTP id wo20so11785472obc.13
        for <linux-media@vger.kernel.org>; Fri, 19 Dec 2014 02:34:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418984906.3165.53.camel@pengutronix.de>
References: <54930468.6010007@vodalys.com> <1418921549.4212.57.camel@pengutronix.de>
 <CAL8zT=jjm9BXuUbk5RS-LZpC1EyyTwdGQRy-fQEUMdDfj4Ej7g@mail.gmail.com>
 <1418922570.4212.67.camel@pengutronix.de> <CAL8zT=jL3psKQ7+K4avQp=tr58m-KXvqGGhXzYrafEuRB5hkcw@mail.gmail.com>
 <1418984906.3165.53.camel@pengutronix.de>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Fri, 19 Dec 2014 11:33:58 +0100
Message-ID: <CAL8zT=iPJcFung7OpG5nwXTo3G3cJ2mg0GjM0-jGN+Zb-ZqnWA@mail.gmail.com>
Subject: Re: coda: Unable to use encoder video_bitrate
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: =?UTF-8?B?RnLDqWTDqXJpYyBTdXJlYXU=?= <frederic.sureau@vodalys.com>,
	Fabio Estevam <festevam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-12-19 11:28 GMT+01:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Hi Jean-Michel,
>
> Am Donnerstag, den 18.12.2014, 18:10 +0100 schrieb Jean-Michel Hautbois:
>> > Sorry, forgot to put all of you on Cc: for the "[media] coda: fix
>> > encoder rate control parameter masks" patch. The coda driver is in
>> > drivers/media/platform/coda, register definitions in coda_regs.h.
>> > The CODA_RATECONTROL_BITRATE_MASK is 0x7f, but it should be 0x7fff.
>> >
>>
>> Well, I meant, the datasheet of the CODA960 because we don't know,
>> just by reading the coda_regs.h which register is where and does what.
>
> I wish. If you search for "cnm-codadx6-datasheet-v2.9.pdf" with a search
> engine of your choice, on chipsnmedia.com you can get documentation for
> the very oldest coda version supported by the driver. That's all I have
> in addition to the old GPLed Freescale imx-vpu-lib for reference.

Uh, ok, didn't think about this. Thx a lot !
JM
