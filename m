Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40040 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932258Ab0CaQh2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 12:37:28 -0400
Message-ID: <4BB37A44.8020909@gmx.de>
Date: Wed, 31 Mar 2010 18:37:24 +0200
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: Sergey Mironov <ierton@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: stv0903bab i2c-repeater question
References: <h2iaa09d86e1003310314kb5c89ff6rc0d674197db538e9@mail.gmail.com>
In-Reply-To: <h2iaa09d86e1003310314kb5c89ff6rc0d674197db538e9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergey,

Am 31.03.2010 12:14, schrieb Sergey Mironov:
 > Hello maillist!
 > I am integrating frontend with dvb-demux driver of one device
 > called mdemux.
 >
 > The frontend includes following parts:
 > - stv0903bab demodulator
 > - stv6110a tuner
 > - lnbp21 power supply controller
 >
 > stv6110a is connected to i2c bus via stv0903's repeater.
 >
 > My question is about setting up i2c repeater frequency divider (I2CRPT
 > register).  stv0903 datasheet says that "the speed of the i2c repeater
 > obtained by
 > dividing the internal chip frequency (that is, 135 MHz)"
 >
 > budget.c driver uses value STV090x_RPTLEVEL_16 for this divider. But
 > 135*10^6/16 is still too high to be valid i2c freq.
 >
 > Please explain where I'm wrong. Does the base frequency really equals 
to 135
 > Mhz? Thanks.
 >

The frequency divider in I2CRPT controls the speed of the I2C repeater 
HW unit inside the STV0903. The I2C clock itself has the same speed as 
the one that is used to access the STV0903. The repeater basically just 
routes the signals from one bus to the other and needs a higher internal 
frequency to do that properly. That is the frequency you set up with I2CRPT.

Regards
Andreas
