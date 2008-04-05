Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Ji8tM-0002nQ-1f
	for linux-dvb@linuxtv.org; Sat, 05 Apr 2008 15:57:12 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JYU00BSVUQD7YT0@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sat, 05 Apr 2008 09:56:38 -0400 (EDT)
Date: Sat, 05 Apr 2008 09:56:37 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <47F782D7.1070606@dupondje.be>
To: Jean-Louis Dupond <info@dupondje.be>
Message-id: <47F78515.7020209@linuxtv.org>
MIME-version: 1.0
References: <47F54E4E.5050608@dupondje.be> <47F6A089.7030504@dupondje.be>
	<47F782D7.1070606@dupondje.be>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1300 not working
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

Jean-Louis Dupond wrote:
> Seems like stopping HAL & reloading the modules fixxes it ...
> 
> Jean-Louis Dupond schreef:
>> Hello,
>>
>> I tried tons of different kernel versions, latest v4l hg etc ... nothing 
>> works ... all are giving me more or less the same error:
>>
>> http://pastebin.com/f10c1160b here is another dmesg output (2.6.25-rc8 
>> with latest hg).
>>
>> I hope this is getting fixxed soon :)

I know what's broken, but I don't know why. I also don't know why it's 
platform specific.

I'm looking at possible solutions now.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
