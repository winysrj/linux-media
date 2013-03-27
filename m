Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:39253 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3C0OJ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 10:09:57 -0400
Received: by mail-ea0-f182.google.com with SMTP id q15so3381217ead.27
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 07:09:56 -0700 (PDT)
Date: Wed, 27 Mar 2013 16:10:49 +0200
From: Timo Teras <timo.teras@iki.fi>
To: Timo Teras <timo.teras@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: Terratec Grabby hwrev 2
Message-ID: <20130327161049.683483f8@vostro>
In-Reply-To: <20130326102056.63b55916@vostro>
References: <20130325190846.3250fe98@vostro>
	<20130325143647.3da1360f@redhat.com>
	<20130325194820.7c122834@vostro>
	<20130325153220.3e6dbfe5@redhat.com>
	<20130325211238.7c325d5e@vostro>
	<20130326102056.63b55916@vostro>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 26 Mar 2013 10:20:56 +0200
Timo Teras <timo.teras@iki.fi> wrote:

> I did manage to get decent traces with USBlyzer evaluation version.

Nothing _that_ exciting there. Though, there's quite a bit of
differences on certain register writes. I tried copying the changed
parts, but did not really help.

Turning on saa7115 debug gave:

saa7115 1-0025: chip found @ 0x4a (ID 000000000000000) does not match a
known saa711x chip.

Which does not look good.

i2c_scan=1 on modprobe gives:

em2860 #0: found i2c device @ 0x4a [saa7113h]
em2860 #0: found i2c device @ 0xa0 [eeprom]
em2860 #0: found i2c device @ 0xa2 [???]
em2860 #0: found i2c device @ 0xa4 [???]
em2860 #0: found i2c device @ 0xa6 [???]
em2860 #0: found i2c device @ 0xa8 [???]
em2860 #0: found i2c device @ 0xaa [???]
em2860 #0: found i2c device @ 0xac [???]
em2860 #0: found i2c device @ 0xae [???]


- Timo
