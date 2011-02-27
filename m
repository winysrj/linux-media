Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37954 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1B0VdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 16:33:14 -0500
Received: by bwz15 with SMTP id 15so3239334bwz.19
        for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 13:33:13 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Malcolm Priestley <tvboxspy@gmail.com>
Subject: Re: dw2102.c: quadratic increment intended?
Date: Sun, 27 Feb 2011 23:33:18 +0200
Cc: linux-media@vger.kernel.org
References: <4D6A6253.8020201@gmail.com> <201102272030.54781.liplianin@me.by> <1298840270.20694.16.camel@tvboxspy>
In-Reply-To: <1298840270.20694.16.camel@tvboxspy>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102272333.18193.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 27 февраля 2011 22:57:50 автор Malcolm Priestley написал:
> On Sun, 2011-02-27 at 20:30 +0200, Igor M. Liplianin wrote:
> > В сообщении от 27 февраля 2011 16:40:19 автор Török Edwin написал:
> > > Hi,
> > 
> > Hi
> > 
> > > Please see http://llvm.org/bugs/show_bug.cgi?id=9259#c5, is the code
> > > intended to do a quadratic increment there?
> > > 
> > > While looking at this, I wonder if this isn't also a bug in the
> > > original
> > > 
> > > code:
> > >         /* read stv0299 register */
> > >         request = 0xb5;
> > >         value = msg[0].buf[0];/* register */
> > >         for (i = 0; i < msg[1].len; i++) {
> > >         
> > >             value = value + i;
> > >             ret = dw2102_op_rw(d->udev, 0xb5,
> > >             
> > >                 value, buf6, 2, DW2102_READ_MSG);
> > >             
> > >             msg[1].buf[i] = buf6[0];
> > >         
> > >         }
> > > 
> > > I don't know anything about the hardware this driver is written for,
> > > but is 'value' really intended to increment quadratically? That seems
> > > suspicious. One
> > > 
> > > wonders if the following is what was intended:
> > >         [...]
> > >         for (i = 0; i < msg[1].len; i++) {
> > >         
> > >             ret = dw2102_op_rw(d->udev, 0xb5,
> > >             
> > >                 value + i, buf6, 2, DW2102_READ_MSG);
> > >             
> > >             msg[1].buf[i] = buf6[0];
> > >         
> > >         }
> > 
> > Accidentally, this didn't affect driver, as it reads registers by one
> > register at one time. But it should be corrected.
> 
> stv0299, along with other stv02xx family members can read and write the
> entire register map from the start register.
You misundestood me. I spoke about driver features, not about stv0299 features.
Except that, you are right.

> 
> However, there is a limitation, the buffer size of the I2C master
> hardware.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
