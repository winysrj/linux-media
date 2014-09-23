Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:57194 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755687AbaIWR7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 13:59:30 -0400
Message-ID: <1411495166.24045.7.camel@x220>
Subject: Re: randconfig build error with next-20140923, in
 drivers/media/mmc/siano/smssdio.c
From: Paul Bolle <pebolle@tiscali.nl>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>,
	"m.chehab" <m.chehab@samsung.com>
Date: Tue, 23 Sep 2014 19:59:26 +0200
In-Reply-To: <CA+r1ZhhmizMMUkAABL9xT=XstAwhP1O-bs=7YBLBvi_=8TZ9Ng@mail.gmail.com>
References: <CA+r1ZhhmizMMUkAABL9xT=XstAwhP1O-bs=7YBLBvi_=8TZ9Ng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2014-09-23 at 09:38 -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/built-in.o: In function `smssdio_remove':
> smssdio.c:(.text+0x14751c): undefined reference to `smscore_putbuffer'
> smssdio.c:(.text+0x147526): undefined reference to `smscore_unregister_device'
> drivers/built-in.o: In function `smssdio_interrupt':
> smssdio.c:(.text+0x1475aa): undefined reference to `smscore_getbuffer'
> smssdio.c:(.text+0x147695): undefined reference to `smscore_putbuffer'
> smssdio.c:(.text+0x1476f3): undefined reference to `smscore_putbuffer'
> smssdio.c:(.text+0x14772a): undefined reference to `smsendian_handle_rx_message'
> smssdio.c:(.text+0x147737): undefined reference to `smscore_onresponse'
> drivers/built-in.o: In function `smssdio_sendrequest':
> smssdio.c:(.text+0x14776c): undefined reference to `smsendian_handle_tx_message'
> drivers/built-in.o: In function `smssdio_probe':
> smssdio.c:(.text+0x14786c): undefined reference to `sms_get_board'
> smssdio.c:(.text+0x14788a): undefined reference to `smscore_register_device'
> smssdio.c:(.text+0x1478a1): undefined reference to `smscore_set_board_id'
> smssdio.c:(.text+0x1478fa): undefined reference to `smscore_start_device'
> smssdio.c:(.text+0x14792d): undefined reference to `smscore_unregister_device'
> make: *** [vmlinux] Error 1

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86 3.17.0-rc6 Kernel Configuration
#
[...]
CONFIG_SMS_SDIO_DRV=y
[...]
CONFIG_SMS_SIANO_MDTV=m
[...]

Should SMS_SDIO_DRV depend on SMS_SIANO_MDTV?


Paul Bolle

