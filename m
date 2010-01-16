Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.velocitynet.com.au ([203.17.154.21]:41791 "EHLO
	webmail2.velocitynet.com.au" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758982Ab0APDL5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 22:11:57 -0500
MIME-Version: 1.0
Date: Sat, 16 Jan 2010 03:11:55 +0000
From: <paul10@planar.id.au>
To: <paul10@planar.id.au>
Cc: "Igor M. Liplianin" <liplianin@me.by>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: DM1105: could not attach frontend 195d:1105
In-Reply-To: <3bf14d196e3bc8717d910d09a623f98e@mail.velocitynet.com.au>
References: <3bf14d196e3bc8717d910d09a623f98e@mail.velocitynet.com.au>
Message-ID: <fded4e7b5651846ee885157dff27bf5c@mail.velocitynet.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 16 Jan 2010 02:49:52 +0000, <paul10@planar.id.au> wrote:
> Ah, I see.   The whole thing is a tuner, and the label that I thought
said
> "ERIT" actually says "SERIT".  Yes, it does have a label on it, I should
> have given you that up front.  I had searched for it on the internet and
> decided that it didn't mean anything.  Thanks so much for your help.
> 
> The label reads SP1514LHb  D0943B
> 
> If I follow your decipher instructions that means:
> 
> 1: DVB-S
> 5: 16cc
> 1: Unsure, but it has an LNB in and an LNB out, so I guess it does have
> loop through?
> 4: Si2109
> L: Si labs
> H: Horizontal
> b: Lead free
> 
> So I'm looking for some code to enable an Si2109 tuner?
> 
> Thanks again,
> 
> Paul

I'm looking through the dm1105 code that I have in 2.6.33-rc4.  I have a
block that reads:
                dm1105dvb->fe = dvb_attach(
                        si21xx_attach, &serit_config,
                        &dm1105dvb->i2c_adap);
                if (dm1105dvb->fe)
                        dm1105dvb->fe->ops.set_voltage =
                                                dm1105dvb_set_voltage;

I have looked through the code for si21xx.c, and I see that you wrote that
as well.  You have been very busy!!  

I did rmmod si21xx, then insmod si21xx debug=1.

I then rmmod dm1105, insmod dm1105.

dmesg reports:
[191712.426735] dm1105 0000:06:00.0: PCI INT A -> GSI 20 (level, low) ->
IRQ 20
[191712.426898] DVB: registering new adapter (dm1105)
[191712.674945] dm1105 0000:06:00.0: MAC 00:00:00:00:00:00
[191714.072172] si21xx: si21xx_attach
[191714.320219] si21xx: si21_readreg: readreg error (reg == 0x01, ret ==
-1)
[191714.568266] si21xx: si21_writereg: writereg error (reg == 0x01, data
== 0x40, ret == -1)
[191715.020067] si21xx: si21_readreg: readreg error (reg == 0x00, ret ==
-1)
[191715.020125] dm1105 0000:06:00.0: could not attach frontend
[191715.020297] dm1105 0000:06:00.0: PCI INT A disabled

Does this shed any light on the matter for you?

Thanks,

Paul

