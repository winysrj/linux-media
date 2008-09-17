Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <handygewinnspiel@gmx.de>) id 1Kg0gZ-0000ZI-37
	for linux-dvb@linuxtv.org; Wed, 17 Sep 2008 19:19:29 +0200
Message-ID: <48D13BF6.8050500@gmx.de>
Date: Wed, 17 Sep 2008 19:18:46 +0200
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
References: <20080916173121.202250@gmx.net> <48CFF4FC.1000005@linuxtv.org>
In-Reply-To: <48CFF4FC.1000005@linuxtv.org>
Cc: linux-dvb@linuxtv.org
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

Andreas Oberritter wrote:
> handygewinnspiel@gmx.de wrote:
>   
>> What is the *real need* for giving applications the possibility of I-Q-Inversion? Why this strange one is included in next API's?
>>
>> If i understand this parameter correctly it swaps I and Q inputs of an qam capable receiver. But otherwise that means that somewhere in the reception chain some real mistake was made, either on hardware or driver side.
>>
>> And if some inversion is needed it should be corrected inside the dvb frontend, since for such piece of hardware *always* this inversion is needed. Correcting this later on application level is terrible, since somebody may use hardware with different inversion settings inside the same application with the very same channel definition.
>>     
>
> If you find two devices which need different inversion settings in the
> same network, then it's a driver bug, which can easily be corrected.
>
>   
How can this be a drivers bug, if in the dvb api documentation no 
*default value* for inversion was ever defined?
Seems to be a bug inside API (linux-dvb-api-1.0.0.pdf, see 
http://www.linuxtv.org/docs.php).

> Spectral inversion depends on the transmitter, too. It can change
> anytime a broadcaster decides to change it. It happens, although not
> very often.
>
> Specifying the inversion parameter can speed up the tuning process,
> especially for devices which don't support automatic swapping in
> hardware. But I would not recommend to store this parameter in a service
> list.
>
> If we decide to keep the parameter, we should probably use four options:
>  INVERSION_OFF, INVERSION_ON, INVERSION_AUTO_OFF_FIRST,
> INVERSION_AUTO_ON_FIRST, which matches the capabilities of most
> demodulators. A typical application would then probably use only the
> last two options, while the first two options would rather be used for
> diagnostics and to read back the detected inversion.
>
>
>   
May be. But since the application cannot get any information about 
transmitters inversion only AUTO makes sense here, neither ON or OFF.
No information field is reserved for inversion inside terrestrial 
delivery system descriptor and cable delivery system descriptor,
so applications are not able to figure out useful settings from NIT.
Please try to see this from the application side, not from hardware 
point of view.

Regards,
Winfried

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
