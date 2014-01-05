Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:27547 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaAENZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 08:25:58 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYX0030JJZ9M050@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sun, 05 Jan 2014 08:25:57 -0500 (EST)
Date: Sun, 05 Jan 2014 11:25:52 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 06/22] [media] em28xx: add warn messages for timeout
Message-id: <20140105112552.29d73485@samsung.com>
In-reply-to: <52C93940.5060402@googlemail.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
 <1388832951-11195-7-git-send-email-m.chehab@samsung.com>
 <52C93940.5060402@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 05 Jan 2014 11:51:44 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> > changeset 45f04e82d035 added a logic to check if em28xx got
> > a timeout on an I2C transfer.
> >
> > That patch started to produce a series of errors that is present
> > with HVR-950, like:
> >
> > [ 4032.218656] xc2028 19-0061: Error on line 1299: -19
> >
> > However, as there are several places where -ENODEV is produced,
> > there's no way to know what's happening.
> >
> > So, let's add a printk to report what error condition was reached:
> >
> > [ 4032.218652] em2882/3 #0: I2C transfer timeout on writing to addr 0xc2
> > [ 4032.218656] xc2028 19-0061: Error on line 1299: -19
> >
> > Interesting enough, when connected to an USB3 port, the number of
> > errors increase:
> >
> > [ 4249.941375] em2882/3 #0: I2C transfer timeout on writing to addr 0xb8
> > [ 4249.941378] tvp5150 19-005c: i2c i/o error: rc == -19 (should be 2)
> > [ 4250.023854] em2882/3 #0: I2C transfer timeout on writing to addr 0xc2
> > [ 4250.023857] xc2028 19-0061: Error on line 1299: -19
> >
> > Due to that, I suspect that the logic in the driver is wrong: instead
> > of just returning an error if 0x10 is returned, it should be waiting for
> > a while and read the I2C status register again.
> >
> > However, more tests are needed.
> The patch description isn't up-to-date.
> It turned out that the bug is in the xc2028 driver.
> 
> See
> http://www.spinics.net/lists/linux-media/msg71107.html

In time, I'll update the description.

I'll work on the xc2028 driver to fix it. It seems better than applying
a hack there. I prefer to not remove the code that puts it in power down
mode, as some em28xx devices are known to have power heat problems.

So, keeping xc3028 energized can reduce a lot its lifetime on such
devices.

Regards,
Mauro
