Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from magma.bpweb.net ([83.223.106.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <chris@simmons.titandsl.co.uk>) id 1Jeznm-0000r7-6z
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 22:38:28 +0100
Received: from [127.0.0.1] (78-32-193-31.no-dns-yet.enta.net [78.32.193.31])
	(authenticated bits=0)
	by magma.bpweb.net (8.13.1/8.13.1) with ESMTP id m2RLcBW2004411
	for <linux-dvb@linuxtv.org>; Thu, 27 Mar 2008 21:38:17 GMT
Message-ID: <47EC13BE.6020600@simmons.titandsl.co.uk>
Date: Thu, 27 Mar 2008 21:38:06 +0000
From: Chris Simmons <chris@simmons.titandsl.co.uk>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <1206139910.12138.34.camel@youkaida>	<1206190455.6285.20.camel@youkaida>
	<1206270834.4521.11.camel@shuttle>	<1206348478.6370.27.camel@youkaida>	<1206546831.8967.13.camel@acropora>	<af2e95fa0803261142r33a0cdb1u31f9b8abc2193265@mail.gmail.com>	<1206563002.8947.2.camel@youkaida>	<8ad9209c0803261352s664d40fdud2fcbf877b10484b@mail.gmail.com>	<1206566255.8947.5.camel@youkaida>
	<1206605144.8947.18.camel@youkaida>
	<af2e95fa0803271044lda4ac30yb242d7c9920c2051@mail.gmail.com>
In-Reply-To: <af2e95fa0803271044lda4ac30yb242d7c9920c2051@mail.gmail.com>
Subject: Re: [linux-dvb] Now with debug info - Nova-T-500 disconnects - They
 are back!
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

I hope this isn't too off topic but I wanted to add that I've found 
disconnects less problematic using myth-tv if I turn active EIT. It will 
still collect EIT when you watch/record TV but I find thats sufficient.

Before I did this I was getting an awful lot of disconnects, I switched 
to 2.6.24.3-12.fc8 when I upgraded to myth 0.21, using v4l repo.  Now 
they are fewer and if it does happen then it will recover as soon as the 
tuners are no longer in use because myth releases them.  Eg live tv -> 
disconnect -> quite live tv -> go back, it works.  dmesg shows that the 
card has been restarted.  Beats a script to restart the backend (which I 
used to use) when it disconnects.

Perhaps that information will make someone else's life less painful :)

On an somewhat unrelated note, I was wondering about the firmware.  Am I 
right in thinking this is closed-source (from Hauppauge)?  Could this 
mess be caused by the firmware falling over -> device dies -> usb 
disconnect or other symptoms (like losing a tuner) depending on how the 
USB layer responds?  Not that I have a clue..

Chris.

PS I might have got passive/active muddle up, you want the setting that 
*doesn't* cause the card to be perpetually in use.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
