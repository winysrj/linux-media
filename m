Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:34914 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab3D2MZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 08:25:08 -0400
Received: by mail-ee0-f50.google.com with SMTP id b15so1553037eek.9
        for <linux-media@vger.kernel.org>; Mon, 29 Apr 2013 05:25:07 -0700 (PDT)
Date: Mon, 29 Apr 2013 15:26:18 +0300
From: Timo Teras <timo.teras@iki.fi>
To: Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Grabby hwrev 2
Message-ID: <20130429152618.6795bae7@vostro>
In-Reply-To: <515EEEB3.2080100@googlemail.com>
References: <20130325190846.3250fe98@vostro>
	<20130325143647.3da1360f@redhat.com>
	<20130325194820.7c122834@vostro>
	<20130325153220.3e6dbfe5@redhat.com>
	<20130325211238.7c325d5e@vostro>
	<20130326102056.63b55916@vostro>
	<20130327161049.683483f8@vostro>
	<20130328105201.7bcc7388@vostro>
	<20130328094052.26b7f3f5@redhat.com>
	<20130328153556.0b58d1aa@vostro>
	<20130328122252.19769614@redhat.com>
	<20130330115455.56c34b5f@vostro>
	<5159C35D.7080901@googlemail.com>
	<20130402084305.0f623e6e@vostro>
	<515B09BD.2040104@googlemail.com>
	<20130403112750.0bc79874@vostro>
	<515EEEB3.2080100@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 05 Apr 2013 17:33:07 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> wrote:

> Am 03.04.2013 10:27, schrieb Timo Teras:
> > I did not test VBI, so I'm unsure if it works or not.
> 
> The em2860 supports VBI, so VBI mode is used.
> You can force the normal mode with module parameter disable_vbi=1

Right. Tested that now.

> Except the green line at the bottom which I'm seeing, too.
> Try the module parameter disable_vbi=1 and the
> distortion/artifacts/offset should change a bit.
> I wouldn't wonder if we encounter multiple issues here which are
> interfering with each other... :(

The green line goes away with disable_vbi=1. However, I will then see
the top first line having some "morse code like" garbage on it.

So yes, sounds like R1D_VSTART setting needs fixing.

> > When comparing these two picture, you see that the frame is offset
> > with one or two pixels in x-direction. Perhaps this is a byte
> > offset, and in RGB format causes color values to be connected to
> > wrong pixel.
> >
> > As final note, now I hooked the device on faster machine, and the
> > AC97 detection seems random. It seemed to work with the slower
> > machine reliably after I had it do the saa7113 initialization. So
> > sounds like some sort of timing issue.
> 
> More details please. ;)
> Do you mean that "Config register raw data" (see dmesg output) value
> varies ?

I traced the USB init sequence that windows does. It is as follows
(simplified by removing some other register / eeprom reads):
	em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xff);
	msleep(20);
	em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
	msleep(100);
	em28xx_write_reg(dev, EM28XX_R08_GPIO, 0x7d);
	msleep(60);
	em28xx_write_reg(dev, EM28XX_R12_VINENABLE, 0x24);
	em28xx_write_reg(dev, 0x0d, 0x42);

Will test if it makes the detection of the audio chip more reliable.

- Timo
