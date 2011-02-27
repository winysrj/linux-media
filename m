Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35355 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab1B0U6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 15:58:04 -0500
Received: by wyg36 with SMTP id 36so3086487wyg.19
        for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 12:58:02 -0800 (PST)
Subject: Re: dw2102.c: quadratic increment intended?
From: Malcolm Priestley <tvboxspy@gmail.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201102272030.54781.liplianin@me.by>
References: <4D6A6253.8020201@gmail.com>
	 <201102272030.54781.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Feb 2011 20:57:50 +0000
Message-ID: <1298840270.20694.16.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-02-27 at 20:30 +0200, Igor M. Liplianin wrote:
> В сообщении от 27 февраля 2011 16:40:19 автор Török Edwin написал:
> > Hi,
> Hi
> 
> > 
> > Please see http://llvm.org/bugs/show_bug.cgi?id=9259#c5, is the code
> > intended to do a quadratic increment there?
> > 
> > While looking at this, I wonder if this isn't also a bug in the original
> > code:
> > 
> >         /* read stv0299 register */
> >         request = 0xb5;
> >         value = msg[0].buf[0];/* register */
> >         for (i = 0; i < msg[1].len; i++) {
> >             value = value + i;
> >             ret = dw2102_op_rw(d->udev, 0xb5,
> >                 value, buf6, 2, DW2102_READ_MSG);
> >             msg[1].buf[i] = buf6[0];
> > 
> >         }
> > 
> > I don't know anything about the hardware this driver is written for, but is
> > 'value' really intended to increment quadratically? That seems
> > suspicious. One
> > wonders if the following is what was intended:
> > 
> >         [...]
> >         for (i = 0; i < msg[1].len; i++) {
> >             ret = dw2102_op_rw(d->udev, 0xb5,
> >                 value + i, buf6, 2, DW2102_READ_MSG);
> >             msg[1].buf[i] = buf6[0];
> > 
> >         }
> > 
> Accidentally, this didn't affect driver, as it reads registers by one register at one time.
> But it should be corrected.

stv0299, along with other stv02xx family members can read and write the
entire register map from the start register.

However, there is a limitation, the buffer size of the I2C master
hardware.


