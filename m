Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout1.informatik.tu-muenchen.de ([131.159.0.12])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <acher@acher.org>) id 1KrgCO-0001zt-QM
	for linux-dvb@linuxtv.org; Sun, 19 Oct 2008 23:52:36 +0200
Received: from braindead1.acher.org (91-65-149-111-dynip.superkabel.de
	[91.65.149.111])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in.tum.de (Postfix) with ESMTP id 15D3E669E
	for <linux-dvb@linuxtv.org>; Sun, 19 Oct 2008 23:52:29 +0200 (CEST)
Date: Sun, 19 Oct 2008 23:52:26 +0200
From: Georg Acher <acher@in.tum.de>
To: Linux-dvb <linux-dvb@linuxtv.org>
Message-ID: <20081019215225.GA11678@braindead1.acher>
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
	<2207.1224273353@kewl.org>
	<412bdbff0810171306n5f8768a2g48255db266d16aa8@mail.gmail.com>
	<5905.1224308528@kewl.org> <20081019195409.GW6792@braindead1.acher>
	<19262.1224449033@kewl.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19262.1224449033@kewl.org>
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

On Sun, Oct 19, 2008 at 09:43:53PM +0100, Darron Broad wrote:
 
> >The docs for the 24116 say that the snr is measured in 0.1dB steps. The
> >absolute range of registers a3:d5 is 0 to 300, so full scale is 30dB. I
> >doubt we will see the 30dB in a real-world setup...
> 
> Okay, so we know the step size of 0.1 per bit and that's measured
> within a range of 0 to 300 but that doesn't actually say what it's
> value is? Ie, is 50=5dB or something else?

I guess so.
 
> All the graphs I see for QPSK and 8PSK in use in the real-world
> suggest the theoretical limit of esn0 is a lot less than that available
> range. I don't know what is the accepted error rate to set this limit.
> Perhaps someone who has authority on this subject can chime in?
> 
> On the cx24116 testing observed that a register max of 160 from QPSK
> gave good approximation to that given by regular sat-kit sitting
> around 100%. If that really means 16dB then it doesn't look right
> compared to the graphs I see, what's wrong here?

I've looked at the IF output of the frontend (it should be always a CX24118)
with spectrum analyzer. The input was from Astra 19.2 with a 80cm dish. The
slope top above the noise floor indicates also a SNR of 16, maybe 18dB, but
not more. It's really that low...

-- 
         Georg Acher, acher@in.tum.de         
         http://www.lrr.in.tum.de/~acher
         "Oh no, not again !" The bowl of petunias          

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
