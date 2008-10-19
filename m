Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout1.informatik.tu-muenchen.de ([131.159.0.12])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <acher@acher.org>) id 1KreLw-0002q5-ON
	for linux-dvb@linuxtv.org; Sun, 19 Oct 2008 21:54:19 +0200
Received: from braindead1.acher.org (91-65-149-111-dynip.superkabel.de
	[91.65.149.111])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in.tum.de (Postfix) with ESMTP id E2E00AF42
	for <linux-dvb@linuxtv.org>; Sun, 19 Oct 2008 21:54:12 +0200 (CEST)
Date: Sun, 19 Oct 2008 21:54:10 +0200
From: Georg Acher <acher@in.tum.de>
To: Linux-dvb <linux-dvb@linuxtv.org>
Message-ID: <20081019195409.GW6792@braindead1.acher>
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
	<2207.1224273353@kewl.org>
	<412bdbff0810171306n5f8768a2g48255db266d16aa8@mail.gmail.com>
	<5905.1224308528@kewl.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5905.1224308528@kewl.org>
Subject: Re: [linux-dvb] [RFC] SNR units in tuners
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sat, Oct 18, 2008 at 06:42:08AM +0100, Darron Broad wrote:
<cx24116> 
> The trouble there is that the scaling for the cx24116 already works
> from an end-user perspective. The value derived in the code is
> a possible maximum of 160 from the chip. REELBOX decided on 176
> which may be more accurate.

The reelbox code was just a heuristic approach to scale the value so that
less than 30-40% is where the trouble starts... I've more or less matched it
to femon's colors. There was no intention to indicate dBs, as end users
don't understand dBs anyway ;-)

The docs for the 24116 say that the snr is measured in 0.1dB steps. The
absolute range of registers a3:d5 is 0 to 300, so full scale is 30dB. I
doubt we will see the 30dB in a real-world setup...

The signal strength in 9e/9d is the value of the AGC voltage. Register da
seems to contain the estimated power level (-25 to -70dBm), but there's no
further information about that (step size etc). I guess the firmware derives
it from the AGC settings.
-- 
         Georg Acher, acher@in.tum.de         
         http://www.lrr.in.tum.de/~acher
         "Oh no, not again !" The bowl of petunias          

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
