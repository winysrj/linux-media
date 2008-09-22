Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KhnWz-00070u-S6
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 17:40:59 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7L00FI9SV8G4M0@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 22 Sep 2008 11:40:23 -0400 (EDT)
Date: Mon, 22 Sep 2008 11:40:20 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <Pine.LNX.4.64.0809221254150.21880@shogun.pilppa.org>
To: Mika Laitio <lamikr@pilppa.org>
Message-id: <48D7BC64.2020002@linuxtv.org>
MIME-version: 1.0
References: <200808181427.36988.ajurik@quick.cz> <48A9BAFE.8020501@linuxtv.org>
	<Pine.LNX.4.64.0809221254150.21880@shogun.pilppa.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-4000 driver problems - i2c error
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

Mika Laitio wrote:
>>> - the firmware is loaded into the card at first time the card is 
>>> opened - it
>>> is okay?
>>>
>>> [  917.660620] cx24116_firmware_ondemand: Waiting for firmware upload
>>> (dvb-fe-cx24116.fw)...
>>> [  917.703010] cx24116_firmware_ondemand: Waiting for firmware 
>>> upload(2)...
>>> [  922.703870] cx24116_load_firmware: FW version 1.22.82.0
>>> [  922.703889] cx24116_firmware_ondemand: Firmware upload complete
>>>
>>> The result is that only for some channels it is possible to get lock 
>>> with
>>> szap2. VDR is hanging (or starting) when trying to tune to initial 
>>> channel,
>>> even when this channel is set to channel at which is szap2 
>>> successfull. I'm
>>> not able to say criteria which channels are possible to lock.
>>>
>>> Any hints are appreciated.
>>
>> I fixed an issue with cx88 sometime ago where a value of 0 (taken from
>> the cards struct) was being written to the GPIO register, resulting in
>> the same i2c issues.
>>
>> It looks a lot like this.
>>
>> - Steve
> 
> I am trying to get the dvb-t tuner working with my hvr-4000 (dvb-s is 
> working fine) and have tried both the latest S2 repository and the 
> latest version of liplianins multiproto repository with 2.6.26 kernels.
> 
> It seems that S2 repository does not yet support DVB-T at all, am I 
> correct?  At least the "options cx88-dvb frontend=1" option in 
> /etc/modprope.conf prevents adapters to be created at all under
> /dev/dvb. Without that option adapter is created but it can only be used 
> for scanning dvb-s.

The ~stoth/hg/s2 has no DVB-T support on the HVR4000 yet. Those patches 
will appear very shortly in ~stoth/hg/s2-mfe.

> 
> WIth liplianinis multiproto version the selection between DVB-S and 
> DVB-T works by using the "options cx88-dvb frontend=1" but I am seeing 
> the i2c
> errors described below.
> 
> Could you have any URL and changeset tag to patch in some repository 
> where this I2C thing has been fixed?

I'm speculating that your issue is the same issue I fixed sometime ago 
(2-3 months in the master repo). I'd suggest you wait for the 
~stoth/hg/s2-mfe patches to appear later tonight and test again.

That tree (and ~stoth/hg/s2 for that matter) have the i2c fix I'm 
referring to.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
