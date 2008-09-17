Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1Kg39b-0008N9-E4
	for linux-dvb@linuxtv.org; Wed, 17 Sep 2008 21:57:38 +0200
Received: from localhost (localhost [127.0.0.1])
	by ffm.saftware.de (Postfix) with ESMTP id D58A1E6E39
	for <linux-dvb@linuxtv.org>; Wed, 17 Sep 2008 21:57:31 +0200 (CEST)
Received: from ffm.saftware.de ([83.141.3.46])
	by localhost (pinky.saftware.org [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id BjlHeF2gpesQ for <linux-dvb@linuxtv.org>;
	Wed, 17 Sep 2008 21:57:30 +0200 (CEST)
Received: from [172.22.22.60] (unknown [92.50.81.33])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ffm.saftware.de (Postfix) with ESMTPSA id E2A90E6E32
	for <linux-dvb@linuxtv.org>; Wed, 17 Sep 2008 21:57:30 +0200 (CEST)
Message-ID: <48D1612B.3000405@linuxtv.org>
Date: Wed, 17 Sep 2008 21:57:31 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20080916173121.202250@gmx.net> <48CFF4FC.1000005@linuxtv.org>
	<48D13BF6.8050500@gmx.de>
In-Reply-To: <48D13BF6.8050500@gmx.de>
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

wk wrote:
> Andreas Oberritter wrote:
>> If you find two devices which need different inversion settings in the
>> same network, then it's a driver bug, which can easily be corrected.
>>
>>   
> How can this be a drivers bug, if in the dvb api documentation no
> *default value* for inversion was ever defined?
> Seems to be a bug inside API (linux-dvb-api-1.0.0.pdf, see
> http://www.linuxtv.org/docs.php).

Common sense says that the default value is not inverted.

>> Spectral inversion depends on the transmitter, too. It can change
>> anytime a broadcaster decides to change it. It happens, although not
>> very often.
>>
>> Specifying the inversion parameter can speed up the tuning process,
>> especially for devices which don't support automatic swapping in
>> hardware. But I would not recommend to store this parameter in a service
>> list.
>>
>> If we decide to keep the parameter, we should probably use four options:
>>  INVERSION_OFF, INVERSION_ON, INVERSION_AUTO_OFF_FIRST,
>> INVERSION_AUTO_ON_FIRST, which matches the capabilities of most
>> demodulators. A typical application would then probably use only the
>> last two options, while the first two options would rather be used for
>> diagnostics and to read back the detected inversion.
>>
>>
>>   
> May be. But since the application cannot get any information about
> transmitters inversion only AUTO makes sense here, neither ON or OFF.
> No information field is reserved for inversion inside terrestrial
> delivery system descriptor and cable delivery system descriptor,
> so applications are not able to figure out useful settings from NIT.
> Please try to see this from the application side, not from hardware
> point of view.

Well, that's essentially what I wrote: Use AUTO in a typical
application. All frontend devices support it, either in software or in
hardware.

Regards,
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
