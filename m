Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:39775 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757576AbZKCBGn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Nov 2009 20:06:43 -0500
Subject: Re: [PATCH] Multifrontend support for saa7134
From: hermann pitton <hermann-pitton@arcor.de>
To: =?UTF-8?Q?Luk=C3=A1=C5=A1?= Karas <lukas.karas@centrum.cz>
Cc: linux-media@vger.kernel.org, Petr Fiala <petr.fiala@gmail.com>
In-Reply-To: <1257043250.16827.17.camel@pc07.localdom.local>
References: <200910312121.21926.lukas.karas@centrum.cz>
	 <1257043250.16827.17.camel@pc07.localdom.local>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Nov 2009 02:02:08 +0100
Message-Id: <1257210128.31771.17.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 01.11.2009, 03:40 +0100 schrieb hermann pitton:
> Hi Lukas, Petr and Eddi,
> 
> thanks for working on it.
> 
> Am Samstag, den 31.10.2009, 21:21 +0100 schrieb Lukáš Karas:
> > Hi all, 
> > here is patch for multifrontend support in saa7134 driver. It is derived from 
> > patches on page http://tux.dpeddi.com/lr319sta/
> > 
> > This patch has effect on these cards:
> >  * FlyDVB Trio
> >  * Medion MD8800 Quadro
> >  * ASUSTeK Tiger 3in1
> 
> The a little bit hidden low profile triple CTX948 is also involved, just
> to have it mentioned. We treat it like the Medion MD8800 Quadro, CTX944,
> with subsystem 16be:0007.
> 
> > It was tested with FlyDVB Trio card.
> > If you could, please test it with other cards too.
> 
> Some first tests on the CTX944 don't look such promising yet.
> On DVB-T only one transponder remains and even that one is heavily
> disturbed.

just some small updates on it, unfortunately I don't have the time
currently it deserves.

The triple CTX948 shows the same behaviour, not such surprising.

But, the Trio has two separate tuners for analog and DVB-T and the DVB-T
problem seems only to be with hybrid devices.

It is also on such silicon hybrid tuners without multiple frontends.

So, likely some bug for hybrid tuner initialization, unfortunately
i2c_debug and related tuner debug seem not to catch it and i2c gate
control reports as being operable.

Devices with FMD1216ME/I MK3 hybrid do still work for DVB-T!

> On DVB-S only about one third of the previous services is still
> available. Lots of such.
> 
> saa7133[1]/dvb: saa7134_dvb_bus_ctrl(acquire=0) returns 0
> saa7133[1]/dvb: saa7134_dvb_bus_ctrl(acquire=1)
> saa7133[1]/dvb: saa7134_dvb_bus_ctrl(acquire=1) returns 0
> tda10086_diseqc_wait: diseqc queue not ready, command may be lost.
> tda10086_diseqc_wait: diseqc queue not ready, command may be lost.
> tda10086_diseqc_wait: diseqc queue not ready, command may be lost.
> tda10086_diseqc_wait: diseqc queue not ready, command may be lost.
> saa7133[1]/dvb: saa7134_dvb_bus_ctrl(acquire=0)
> saa7133[1]/dvb: saa7134_dvb_bus_ctrl(acquire=0) returns 0
> saa7133[1]/dvb: saa7134_dvb_bus_ctrl(acquire=1)
> saa7133[1]/dvb: saa7134_dvb_bus_ctrl(acquire=1) returns 0
> saa7133[1]/dvb: saa7134_dvb_bus_ctrl(acquire=0)
> 
> I do have the Asus Tiger 3in1 and the triple CTX948 too, but can't
> promise when I get time to test on those less complicated devices.

If the above "diseqc queue not ready" appears, it fails, but a second
attempt almost always works. Might be some unsynced timing problems
between the different LNB supplies. (need to get the Tiger 3in1 up too)

However, it is very close to fully working already.

Cheers,
Hermann



