Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx03.syneticon.net ([78.111.66.105])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mangoo@wpkg.org>) id 1LMMZT-0005Mc-79
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 14:11:11 +0100
Message-ID: <496B4152.6050505@wpkg.org>
Date: Mon, 12 Jan 2009 14:10:42 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: thomas.schorpp@gmail.com
References: <4963A330.3090903@wpkg.org>	<4963B4AF.3040301@gmail.com>	<4965D821.4090304@wpkg.org>	<496881DD.2080405@wpkg.org>
	<49688623.7030901@gmail.com> <49688743.70605@wpkg.org>
	<49688C25.8060601@gmail.com> <4968DCC0.4060500@gmail.com>
In-Reply-To: <4968DCC0.4060500@gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
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

thomas schorpp schrieb:
> thomas schorpp schrieb:
>> Tomasz Chmielewski schrieb:
>>> thomas schorpp schrieb:
>>>
>>>>>> Did it work for you properly with earlier kernels?
>>>>> I noticed that after I do (without device unplugging/replugging):
>>>>>
>>>>> # rmmod dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc 
>>>>> dibx000_common ehci_hcd
>>>>>
>>>>> # modprobe -a dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc 
>>>>> dibx000_common ehci_hcd

> Can You pls confirm this, I won't touch the driver code before, maybe 
> usb-h/w dependant.

I noticed it is probably enough to remove ehci_hcd.
In that case, the device will be re-detected on uhci_hcd (which is USB 1.1).
And if you remove uhci_hcd and insert ehci_hcd again, it will be 
re-detected there.


-- 
Tomasz Chmielewski
http://wpkg.org


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
