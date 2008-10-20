Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KrzWE-0003rI-Er
	for linux-dvb@linuxtv.org; Mon, 20 Oct 2008 20:30:19 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K91002IMVD6J3H0@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 20 Oct 2008 14:29:30 -0400 (EDT)
Date: Mon, 20 Oct 2008 14:29:29 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48FCC5FB.1030706@helmutauer.de>
To: Helmut Auer <vdr@helmutauer.de>
Message-id: <48FCCE09.10400@linuxtv.org>
MIME-version: 1.0
References: <48F9969D.90305@helmutauer.de> <48FCC5FB.1030706@helmutauer.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with conexant CX24123/CX24109
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

Helmut Auer wrote:
> Helmut Auer schrieb:
>> Hi,
>>
>> I have a Geniatech PCI DVB-s with CX24123/CX24109.
>> This card cannot zap to the german ARD transponder, all other channels 
>> are running fine.
>> The card runs fine under windows .
...

>> Any hints where I can tune some parameters ?
>>
>>   
> No one an idea whats wrong with the driver ?

What's special about the ARD transponder vs other transponders?

If you can show a difference I can try to replicate it with a generator 
and provide a patch.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
