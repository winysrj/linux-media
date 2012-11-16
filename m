Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab2KPN1B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 08:27:01 -0500
Message-ID: <50A63F1C.8010500@redhat.com>
Date: Fri, 16 Nov 2012 11:26:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: David Hagood <david.hagood@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: How to get the DVB drivers to stop spamming my logs?
References: <50A634B2.6010007@gmail.com>
In-Reply-To: <50A634B2.6010007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-11-2012 10:42, David Hagood escreveu:
> I have a MythTV box with 3 tuners: 2 USB and one PCI. One or more of the tuners' drivers keeps spamming syslog with the following (taken from the Logwatch summary):
>
>      lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -71) ...:  278497 Time(s)
>      lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x6e error (ret == -71) ...:  410252 Time(s)
>      lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x8b error (ret == -71) ...:  1278 Time(s)
>      lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00,  ...:  73945 Time(s)
>      lgdt330x: i2c_write_demod_bytes error (addr 4c <- 14,  ...:  1281 Time(s)
>      xc2028 1-0061: Error on line 1294: -71 ...:  1234 Time(s)
>
> Is there any way to get the drivers to stop spamming syslog, short of recompiling them with the error messages removed?

Error -71 is this one:

include/asm-generic/errno.h:#define       EPROTO          71      /* Protocol error */

It is generally due to some issue at USB level, like bad cabling
or bad contact.

Regards,
Mauro
