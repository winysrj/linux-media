Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45239 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934528Ab3DIUFA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 16:05:00 -0400
Message-ID: <51647443.5090301@iki.fi>
Date: Tue, 09 Apr 2013 23:04:19 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] rtl28xxu: add experimental support for r820t
References: <1365351031-22079-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1365351031-22079-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I tested it and it didn't work at all. Latest commit was:
rtl820t: Add a debug msg when PLL gets locked

I used your git tree and rebased it top of master. There was some merge 
conflicts, but I was naturally able to fix.

regards
Antti

On 04/07/2013 07:10 PM, Mauro Carvalho Chehab wrote:
> Several rtl28xxu are currently shipped with a r820t tuner.
> Add experimental suppor for it.
>
> NOTE: I don't have DVB-T signal here, so I couldn't fully test the
> driver. By sniffing the USB traffic from rtl-sdr and comparing with
> this driver's traffic, it seems to be working fine, at least up to
> tuner callibration. After that, I would need a DVB-T lock to test
> the rest of the driver.
>
> Mauro Carvalho Chehab (2):
>    r820t: Add a tuner driver for Rafael Micro R820T silicon tuner
>    rtl28xxu: add support for Rafael Micro r820t
>
>   drivers/media/tuners/Kconfig            |    7 +
>   drivers/media/tuners/Makefile           |    1 +
>   drivers/media/tuners/r820t.c            | 1486 +++++++++++++++++++++++++++++++
>   drivers/media/tuners/r820t.h            |   55 ++
>   drivers/media/usb/dvb-usb-v2/Kconfig    |    1 +
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c |   30 +
>   drivers/media/usb/dvb-usb-v2/rtl28xxu.h |    1 +
>   7 files changed, 1581 insertions(+)
>   create mode 100644 drivers/media/tuners/r820t.c
>   create mode 100644 drivers/media/tuners/r820t.h
>


-- 
http://palosaari.fi/
