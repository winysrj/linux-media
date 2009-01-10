Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx03.syneticon.net ([78.111.66.105])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mangoo@wpkg.org>) id 1LLbj3-0008SB-18
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 12:09:57 +0100
Received: from localhost (filter1.syneticon.net [192.168.113.83])
	by mx03.syneticon.net (Postfix) with ESMTP id C8F25361A0
	for <linux-dvb@linuxtv.org>; Sat, 10 Jan 2009 12:09:52 +0100 (CET)
Received: from mx03.syneticon.net ([192.168.113.84])
	by localhost (mx03.syneticon.net [192.168.113.83]) (amavisd-new,
	port 10025) with ESMTP id J-I4f8zYj4wj for <linux-dvb@linuxtv.org>;
	Sat, 10 Jan 2009 12:09:40 +0100 (CET)
Received: from [192.168.10.145] (koln-4db407be.pool.einsundeins.de
	[77.180.7.190]) by mx03.syneticon.net (Postfix) with ESMTP
	for <linux-dvb@linuxtv.org>; Sat, 10 Jan 2009 12:09:40 +0100 (CET)
Message-ID: <496881DD.2080405@wpkg.org>
Date: Sat, 10 Jan 2009 12:09:17 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <4963A330.3090903@wpkg.org> <4963B4AF.3040301@gmail.com>
	<4965D821.4090304@wpkg.org>
In-Reply-To: <4965D821.4090304@wpkg.org>
Subject: Re: [linux-dvb] random "no frontend was attached"
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

Tomasz Chmielewski schrieb:
                                                           
>>> dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'                                                            
>>> input: IR-receiver inside an USB DVB receiver as /class/input/input6                                                         
>>> dvb-usb: schedule remote query interval to 150 msecs.                                                                        
>>> dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully initialized and connected.
>>>
>>>
>>> As a result, using DVB is impossible until I plug the device out 
>>> and plug it in again.
>> Does not work here.
> 
> It does not work always for me as well. Sometimes, I have to replug the 
> device 2-3-4 times until it's eventually properly detected.
> Most of the time, it's not detected initially.
> 
> Did it work for you properly with earlier kernels?

I noticed that after I do (without device unplugging/replugging):

# rmmod dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common ehci_hcd

# modprobe -a dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common ehci_hcd


it is detected properly _always_.

?

-- 
Tomasz Chmielewski
http://wpkg.org

 


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
