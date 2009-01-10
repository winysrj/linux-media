Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1LLhln-0002MT-Sd
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 18:37:13 +0100
Received: by fg-out-1718.google.com with SMTP id e21so3772788fga.25
	for <linux-dvb@linuxtv.org>; Sat, 10 Jan 2009 09:37:08 -0800 (PST)
Message-ID: <4968DCC0.4060500@gmail.com>
Date: Sat, 10 Jan 2009 18:37:04 +0100
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
References: <4963A330.3090903@wpkg.org>	<4963B4AF.3040301@gmail.com>	<4965D821.4090304@wpkg.org>	<496881DD.2080405@wpkg.org>
	<49688623.7030901@gmail.com> <49688743.70605@wpkg.org>
	<49688C25.8060601@gmail.com>
In-Reply-To: <49688C25.8060601@gmail.com>
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

thomas schorpp schrieb:
> Tomasz Chmielewski schrieb:
>> thomas schorpp schrieb:
>>
>>>>> Did it work for you properly with earlier kernels?
>>>> I noticed that after I do (without device unplugging/replugging):
>>>>
>>>> # rmmod dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc 
>>>> dibx000_common ehci_hcd
>>>>
>>>> # modprobe -a dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc 
>>>> dibx000_common ehci_hcd
>>>>
>>>>
>>>> it is detected properly _always_.
>>>>
>>>> ?
>>>>
>>>
>>> no.
>>
>> With what earlier kernels does it for you?
> 
> irrelevant.
> 

> tom1:~# tom1:~# tom1:~#
> thanks for pointing the right direction.
> try this if it works for cold and warm boot (machine/device), too:
> 
> tom1:~# grep hcd /etc/modprobe.d/dvb
> install ehci-hcd /sbin/modprobe dvb_usb_dibusb_mc; /sbin/modprobe 

no.
needed this to get it work after linux cold boot:

tom1:~# cat /etc/modprobe.d/usb
install uhci-hcd /sbin/modprobe ehci-hcd; /sbin/modprobe --ignore-install uhci-hcd

tom1:~# cat /etc/modprobe.d/dvb
...
install dvb_usb_dibusb_mc /sbin/modprobe --ignore-install dvb_usb_dibusb_mc; \
/sbin/modprobe -r dvb_usb_dibusb_mc ehci_hcd; \
/sbin/modprobe -a --ignore-install dvb_usb_dibusb_mc ehci_hcd
# runvdr

but second is ignored by udev and/or modprobe at bootup for some reason, 

tom1:~# dmesg |grep frontend
DVB: registering adapter 0 frontend 0 (Philips TDA10021 DVB-C)...
DVB: registering adapter 1 frontend 0 (VLSI VES1820 DVB-C)...
dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'
dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...

so I need 

tom1:~# diff -U3 /usr/sbin/runvdr.dist /usr/sbin/runvdr
--- /usr/sbin/runvdr.dist	2008-10-02 00:22:53.000000000 +0200
+++ /usr/sbin/runvdr	2009-01-10 17:52:28.000000000 +0100
@@ -73,6 +73,9 @@
 
 [ -z "$MODULES" ] && load_dvb_modules
 
+/sbin/modprobe -r dvb_usb_dibusb_mc mt2060
+/sbin/modprobe dvb_usb_dibusb_mc
+
 while (true) do
 
     set_permissions


Can You pls confirm this, I won't touch the driver code before, maybe usb-h/w dependant.

y
tom

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
