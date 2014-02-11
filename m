Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2369 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaBKH57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 02:57:59 -0500
Message-ID: <52F9D7E2.9040607@xs4all.nl>
Date: Tue, 11 Feb 2014 08:57:22 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 00/16] SDR API - drivers
References: <1392084299-16549-1-git-send-email-crope@iki.fi>
In-Reply-To: <1392084299-16549-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

Thanks for reorganizing the patch series. This looks much nicer!

I plan on reviewing these series on Friday or in the weekend.

Regards,

	Hans

On 02/11/2014 03:04 AM, Antti Palosaari wrote:
> *** BLURB HERE ***
> 
> Antti Palosaari (16):
>   e4000: convert DVB tuner to I2C driver model
>   e4000: implement controls via v4l2 control framework
>   e4000: fix PLL calc to allow higher frequencies
>   e4000: implement PLL lock v4l control
>   e4000: get rid of DVB i2c_gate_ctrl()
>   e4000: convert to Regmap API
>   e4000: rename some variables
>   rtl2832_sdr: Realtek RTL2832 SDR driver module
>   rtl28xxu: constify demod config structs
>   rtl28xxu: attach SDR extension module
>   rtl28xxu: fix switch-case style issue
>   rtl28xxu: use muxed RTL2832 I2C adapters for E4000 and RTL2832_SDR
>   rtl2832_sdr: expose e4000 controls to user
>   r820t: add manual gain controls
>   rtl2832_sdr: expose R820T controls to user
>   MAINTAINERS: add rtl2832_sdr driver
> 
>  MAINTAINERS                                      |   10 +
>  drivers/media/tuners/Kconfig                     |    1 +
>  drivers/media/tuners/e4000.c                     |  598 +++++----
>  drivers/media/tuners/e4000.h                     |   21 +-
>  drivers/media/tuners/e4000_priv.h                |   86 +-
>  drivers/media/tuners/r820t.c                     |  137 +-
>  drivers/media/tuners/r820t.h                     |   10 +
>  drivers/media/usb/dvb-usb-v2/Makefile            |    1 +
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c          |   90 +-
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.h          |    2 +
>  drivers/staging/media/Kconfig                    |    2 +
>  drivers/staging/media/Makefile                   |    2 +
>  drivers/staging/media/rtl2832u_sdr/Kconfig       |    7 +
>  drivers/staging/media/rtl2832u_sdr/Makefile      |    6 +
>  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 1476 ++++++++++++++++++++++
>  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h |   51 +
>  16 files changed, 2234 insertions(+), 266 deletions(-)
>  create mode 100644 drivers/staging/media/rtl2832u_sdr/Kconfig
>  create mode 100644 drivers/staging/media/rtl2832u_sdr/Makefile
>  create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
>  create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h
> 

