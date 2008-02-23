Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web32702.mail.mud.yahoo.com ([68.142.207.246])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <vikinghat@yahoo.com>) id 1JSrbf-0000Ya-UW
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 11:27:48 +0100
Date: Sat, 23 Feb 2008 02:27:13 -0800 (PST)
From: Christopher Hammond <vikinghat@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <405415.21348.qm@web32702.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] af9005 problem with frontend?
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

<snip>
> I'm trying to use it in Mandriva 2008.0 (kernel 2.6.22.18-desktop-1mdv) so I've 
> followed the instructions referred to at http://ventoso.org/luca/af9005/ to 
> download the latest v4l-dvb code, make and install it.  
<snip>
> Output from dmesg:
> 
> usb 1-1: new full speed USB device using uhci_hcd and address 2
> usb 1-1: configuration #1 chosen from 1 choice
> dvb-usb: found a 'Afatech DVB-T USB1.1 stick' in cold state, will try to load a 
> firmware
> dvb-usb: downloading firmware from file 'af9005.fw'
> dvb-usb: found a 'Afatech DVB-T USB1.1 stick' in warm state.
> dvb-usb: will use the device's hardware PID filter (table count: 32).
> DVB: registering new adapter (Afatech DVB-T USB1.1 stick).
> dvb-usb: no frontend was attached by 'Afatech DVB-T USB1.1 stick'
> dvb-usb: Afatech DVB-T USB1.1 stick successfully initialized and connected.
> usbcore: registered new interface driver dvb_usb_af9005
<snip>

Sorry all, my error.  Turns out my kernel header files did not match the running kernel.
Mandriva do not provide header files for released kernels - you have to install the kernel source and build.  Until recently you could just run make on the default source and get compatible header files.... however as of Mandriva 2008.0 the mandriva installer installed kernel 2.6.22.18-desktop-1mdv, but the source I got was 2.6.22.18-1mdvcustom - so when editing the Makefile to remove the custom label I inserted desktop as well.  Big mistake!  

Solution, build a kernel (called 2.6.22.18-1testbuild1mdv) install it, reboot into new kernel, then build the v4l-dvb code, with make release VER=2.6.22.18-1testbuild1mdv and install.  Now a frontend is found when the af9005 is plugged in, and no kernel oops with dvbsnoop or when unplugging.  I now have it running in Kaffene.

Thank you to any that looked at the original report.
 



      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Inbox. http://uk.docs.yahoo.com/nowyoucan.html

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
