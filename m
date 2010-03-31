Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47305 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab0CaKPD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 06:15:03 -0400
Received: by bwz1 with SMTP id 1so5063104bwz.21
        for <linux-media@vger.kernel.org>; Wed, 31 Mar 2010 03:15:00 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 31 Mar 2010 14:14:59 +0400
Message-ID: <h2iaa09d86e1003310314kb5c89ff6rc0d674197db538e9@mail.gmail.com>
Subject: stv0903bab i2c-repeater question
From: Sergey Mironov <ierton@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello maillist!
I am integrating frontend with dvb-demux driver of one device
called mdemux.

The frontend includes following parts:
- stv0903bab demodulator
- stv6110a tuner
- lnbp21 power supply controller

stv6110a is connected to i2c bus via stv0903's repeater.

My question is about setting up i2c repeater frequency divider (I2CRPT
register).  stv0903 datasheet says that "the speed of the i2c repeater
obtained by
dividing the internal chip frequency (that is, 135 MHz)"

budget.c driver uses value STV090x_RPTLEVEL_16 for this divider. But
135*10^6/16 is still too high to be valid i2c freq.

Please explain where I'm wrong. Does the base frequency really equals to 135
Mhz? Thanks.

-- 
Sergey
