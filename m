Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1LLcPS-00056U-CF
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 12:53:47 +0100
Received: by bwz11 with SMTP id 11so1721325bwz.17
	for <linux-dvb@linuxtv.org>; Sat, 10 Jan 2009 03:53:12 -0800 (PST)
Message-ID: <49688C25.8060601@gmail.com>
Date: Sat, 10 Jan 2009 12:53:09 +0100
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
References: <4963A330.3090903@wpkg.org>	<4963B4AF.3040301@gmail.com>	<4965D821.4090304@wpkg.org>	<496881DD.2080405@wpkg.org>
	<49688623.7030901@gmail.com> <49688743.70605@wpkg.org>
In-Reply-To: <49688743.70605@wpkg.org>
From: thomas schorpp <thomas.schorpp@googlemail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] random "no frontend was attached"
Reply-To: thomas.schorpp@gmail.com
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
> thomas schorpp schrieb:
> 
>>>> Did it work for you properly with earlier kernels?
>>> I noticed that after I do (without device unplugging/replugging):
>>>
>>> # rmmod dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc 
>>> dibx000_common ehci_hcd
>>>
>>> # modprobe -a dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc 
>>> dibx000_common ehci_hcd
>>>
>>>
>>> it is detected properly _always_.
>>>
>>> ?
>>>
>>
>> no.
> 
> With what earlier kernels does it for you?

irrelevant.

yes for:

tom1:~# modprobe -r dvb_usb_dibusb_mc ehci_hcd
tom1:~# modprobe -r uhci_hcd
tom1:~# 
tom1:~# 
tom1:~# modprobe uhci_hcd
tom1:~# 
tom1:~# dmesg |grep frontend
DVB: registering adapter 0 frontend 0 (Philips TDA10021 DVB-C)...
DVB: registering adapter 1 frontend 0 (VLSI VES1820 DVB-C)...
dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'
dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'
dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
tom1:~# 
tom1:~# 
tom1:~# 

thanks for pointing the right direction.
try this if it works for cold and warm boot (machine/device), too:

tom1:~# grep hcd /etc/modprobe.d/dvb
install ehci-hcd /sbin/modprobe dvb_usb_dibusb_mc; /sbin/modprobe --ignore-install ehci-hcd
tom1:~# 

y
tom

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
