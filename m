Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KD4ca-0005BG-2M
	for linux-dvb@linuxtv.org; Sun, 29 Jun 2008 23:39:45 +0200
Message-ID: <48680114.4030007@linuxtv.org>
Date: Sun, 29 Jun 2008 17:39:32 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Fabrizio Regalli <fabreg@gmail.com>
References: <43d295de0806291420w4b15c20cj25c05e79617d3371@mail.gmail.com>	
	<4867FE44.2000901@linuxtv.org>
	<43d295de0806291437i309164eodfc08c293a3237e1@mail.gmail.com>
In-Reply-To: <43d295de0806291437i309164eodfc08c293a3237e1@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Conexant Device 8852
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

2008/6/29 Michael Krufky <mkrufky@linuxtv.org>:
>> Fabrizio Regalli wrote:
>>     
>>> Hello.
>>>
>>> I've the follow tv card on my linux box:
>>>
>>> 03:00.0 Multimedia video controller: Conexant Device 8852 (rev 02)
>>>       Subsystem: Hauppauge computer works Inc. Device 71d1
>>>       
>> [snip]
>>     
>>> I try to use cx23885 driver (with card=<1,2,3,4,5,6> option) but doesn't works.
>>> Could someone please help me?
>>>       
>> Use the cx23885 driver from linuxtv.org master branch -- Hauppauge WinTV-HVR1200 will be supported with the 2.6.26 kernel.
>>
>> Regards,
>>
>> Mike
>>
>>     

Fabrizio Regalli wrote:
> Hi Michael
>
> thanks for your reply.
> Which extacly are the files needed? Maybe
>
> http://linuxtv.org/downloads/linuxtv-dvb-1.1.1.tar.bz2
>
> and
>
> http://linuxtv.org/downloads/linuxtv-dvb-apps-1.1.1.tar.bz2
>
> Thanks again.
> Fab
>   

Follow these instructions:

http://linuxtv.org/repo/#mercurial

Good luck!

-Mike



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
