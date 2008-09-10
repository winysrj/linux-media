Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KdUXA-000160-SU
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 20:35:22 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6Z00EYXSXWWGD1@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 10 Sep 2008 14:34:46 -0400 (EDT)
Date: Wed, 10 Sep 2008 14:34:43 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48C7B362.8050603@magma.ca>
To: Patrick Boisvenue <patrbois@magma.ca>
Message-id: <48C81343.6030907@linuxtv.org>
MIME-version: 1.0
References: <48C659C5.8000902@magma.ca> <48C68DC5.1050400@linuxtv.org>
	<48C73161.7090405@magma.ca> <48C732DE.2030902@linuxtv.org>
	<48C7B362.8050603@magma.ca>
Cc: Steven Toth <stoth@hauppauge.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1500Q eeprom not being parsed correctly
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

>>> I have the firmware file located here:
>>>
>>> # ls -l /lib/firmware/dvb-fe-xc5000-1.1.fw
>>> -rw-r--r-- 1 root root 12332 Aug 31 12:56 
>>> /lib/firmware/dvb-fe-xc5000-1.1.fw
>>>
>>> If there is anything else I can provide (or try) to help debug, let 
>>> me know,
>>> ...Patrick
>>
>>  > kobject_add_internal failed for i2c-2 with -EEXIST, don't try to
>>  > register things with the same name in the same directory.
>>
>> Ooh, that's nasty problem, this is new - and looks like it's i2c related.
>>
>> Why does this sound familiar? Anyone?
>>
>> Just for the hell of it, copy the firmware to /lib/firmware/`uname -r` 
>> also, then re-run the test - it's unlikely to make any difference but 
>> it _is_ the scenario I always test under.
>>
>> - Steve
>>
> 
> You were right, no difference.  Is there any other debug messages I can 
> create?

No, it needs some of my time to try and repro.

I'll spend a few minutes tonight and see what I can find.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
