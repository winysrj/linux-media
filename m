Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <handygewinnspiel@gmx.de>) id 1LLiTD-0005kb-HA
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 19:22:04 +0100
Message-ID: <4968E723.3090705@gmx.de>
Date: Sat, 10 Jan 2009 19:21:23 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Hans Werner <HWerner4@gmx.de>,
	Linux DVB Mailing List <linux-dvb@linuxtv.org>
References: <20090110102705.129600@gmx.net> <20090110103700.107530@gmx.net>
	<49688176.5030603@gmx.de>
In-Reply-To: <49688176.5030603@gmx.de>
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
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

wk schrieb:
> Hans Werner schrieb:
>   
>>> Hi all,
>>>
>>> Compiling on 2.6.28 seems to be broken (v4l-dvb-985ecd81d993,
>>> linux-2.6.28, gcc-3.4.1), is this known or already some patch around?
>>>     
>>>       
>> I can compile fine with 2.6.28, x86_64, gcc 4.2.4. Did you do 'make distclean' first?
>>
>>   
>>     
> Well, i did not start with distclean, since i expect a freshly 
> downloaded package to be distclean.
> Nevertheless make distclean and/or make clean also doesnt work properly:
>
> -bash-3.00# make distclean
> make -C /usr/src/v4l-dvb-985ecd81d993/v4l distclean
> make[1]: Entering directory `/usr/src/v4l-dvb-985ecd81d993/v4l'
> find: .: Value too large for defined data type
> make[1]: *** [clean] Fehler 1
> make[1]: Leaving directory `/usr/src/v4l-dvb-985ecd81d993/v4l'
> make: *** [distclean] Fehler 2
>
> Note the very same error: 'value too large..' Looks like Makefile or 
> script failure.
>
> This is a 32bit machine running LinuxFromScratch btw. and not the first 
> time compiling the dvb driver.
>
>   
Update: after some hours of tests:

- with 2.6.28 some symbolic links from v4l directory to the *.{c,h} in 
../drivers/media subdirs are not created.
- 2.6.26.3 = OK
- 2.6.27.9 = OK
- 2.6.28 = failure

if i try to compile after a previous run with 2.6.26.3 or 2.6.27.9 
compiling runs (but still the error message of find after creating 
symbolic links),
because the symbolic links are already created from previous run. I'm 
wondering wether i'm the only one with that problem..

-Winfried

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
