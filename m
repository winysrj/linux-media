Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1Kfets-0005Zp-A6
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 20:03:45 +0200
Received: from localhost (localhost [127.0.0.1])
	by ffm.saftware.de (Postfix) with ESMTP id D8367E6DAC
	for <linux-dvb@linuxtv.org>; Tue, 16 Sep 2008 20:03:40 +0200 (CEST)
Received: from ffm.saftware.de ([83.141.3.46])
	by localhost (pinky.saftware.org [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 39pbAx-3UE-S for <linux-dvb@linuxtv.org>;
	Tue, 16 Sep 2008 20:03:40 +0200 (CEST)
Received: from [172.22.22.60] (unknown [92.50.81.33])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ffm.saftware.de (Postfix) with ESMTPSA id 3028CE6DA8
	for <linux-dvb@linuxtv.org>; Tue, 16 Sep 2008 20:03:39 +0200 (CEST)
Message-ID: <48CFF4FC.1000005@linuxtv.org>
Date: Tue, 16 Sep 2008 20:03:40 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20080916173121.202250@gmx.net>
In-Reply-To: <20080916173121.202250@gmx.net>
Subject: Re: [linux-dvb] Why Parameter 'INVERSION' is really needed?
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

handygewinnspiel@gmx.de wrote:
> What is the *real need* for giving applications the possibility of I-Q-Inversion? Why this strange one is included in next API's?
> 
> If i understand this parameter correctly it swaps I and Q inputs of an qam capable receiver. But otherwise that means that somewhere in the reception chain some real mistake was made, either on hardware or driver side.
> 
> And if some inversion is needed it should be corrected inside the dvb frontend, since for such piece of hardware *always* this inversion is needed. Correcting this later on application level is terrible, since somebody may use hardware with different inversion settings inside the same application with the very same channel definition.

If you find two devices which need different inversion settings in the
same network, then it's a driver bug, which can easily be corrected.

Spectral inversion depends on the transmitter, too. It can change
anytime a broadcaster decides to change it. It happens, although not
very often.

Specifying the inversion parameter can speed up the tuning process,
especially for devices which don't support automatic swapping in
hardware. But I would not recommend to store this parameter in a service
list.

If we decide to keep the parameter, we should probably use four options:
 INVERSION_OFF, INVERSION_ON, INVERSION_AUTO_OFF_FIRST,
INVERSION_AUTO_ON_FIRST, which matches the capabilities of most
demodulators. A typical application would then probably use only the
last two options, while the first two options would rather be used for
diagnostics and to read back the detected inversion.

Regards,
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
