Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jyrki.n@telia.com>) id 1LDwOp-00007U-Nf
	for linux-dvb@linuxtv.org; Sat, 20 Dec 2008 08:37:24 +0100
Message-ID: <494CA097.9060501@telia.com>
Date: Sat, 20 Dec 2008 08:36:55 +0100
From: Jyrki Niskala <jyrki.n@telia.com>
MIME-Version: 1.0
To: Simon Kenyon <simon@koala.ie>
References: <494B9754.6000403@koala.ie> <494BE451.3080407@telia.com>
In-Reply-To: <494BE451.3080407@telia.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] can you confirm that the nova-td-500 is supported
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

Jyrki Niskala wrote:
> Simon Kenyon wrote:
>   
>> just bought what i though was a t-500 and when i opened the box it 
>> contained a td-500
>>
>> the wiki says (in bright bold colours) that it is not (and never would 
>> be) supported
>>
>> however, from looking at the mailing list it appear to be supported
>>
>> i can of course take it out of the sealed bag and try
>>
>> however, to preserve any change of swapping it i thought i would ask 
>> here first
>>
>> regards
>> --
>> simon
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>   
>>     
> Hi
>
> For me it's still kind of 80% working status, it works on 4 of 5 muxes 
> (read more about it here: 
> http://www.linuxtv.org/pipermail/linux-dvb/2008-November/030601.html).
> I been tracking the problem from time to time by comparing usbsnoop logs 
> from the windows driver. Windows driver works on all 5 muxes. For the 
> moment I have found some differences in demod driver (dib7000p) and the 
> tuner driver (dib0700). I will have some more time during Christmas 
> holiday to investigate it further.
>
> Regards, Jyrki
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   
Hi,

Your post got me working on my problems, and the good thing is that I 
finally got  it working by using "auto guard interval" instead of  
default "1/8 guard interval".

Merry  Christmas

/ Jyrki

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
