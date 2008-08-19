Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KVR2N-0001Xh-Qx
	for linux-dvb@linuxtv.org; Tue, 19 Aug 2008 15:14:17 +0200
Message-ID: <48AAC720.3080101@linuxtv.org>
Date: Tue, 19 Aug 2008 09:14:08 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: stev391@email.com
References: <20080819065632.293BA11581F@ws1-7.us4.outblaze.com>
	<48AAC5E7.1050703@linuxtv.org>
In-Reply-To: <48AAC5E7.1050703@linuxtv.org>
Cc: Tim Lucas <lucastim@gmail.com>, linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DViCO Fusion HDTV7 Dual Express
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

Michael Krufky wrote:
>>> Tim,
>>>
>>> The support that I added in was for a the DViCO DVB-T Dual Express, not the
>>> FusionHDTV7.
>>>
>>> However there may be good news for you...
>>> If your card is the FusionHDTV7 Dual Express there is support for this card
>>> in the main tree (only one DVB tuner at the moment). This may not help you
>>> as you stated that you needed analog support.
>>>
>>> The easiest way for you to get the newest DVB drivers is to go to this
>>> webpage:
>>> http://martinpitt.wordpress.com/2008/06/10/packaged-dvb-t-drivers-for-ubuntu
>>> -804/

I just noticed this -- bad advice.  We have no control of that package, and no tracking of its state.

Its possible that this is the source of Tim's problem.  I don't think I added support for the new demodulator until way after June 10th.

Tim, please just follow the instructions that I gave you in my first email.

The driver for this card currently does _not_ support analog video, so you might not get what you want from it now.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
