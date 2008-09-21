Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp126.rog.mail.re2.yahoo.com ([206.190.53.31])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <jcoles0727@rogers.com>) id 1KhPqT-0004xw-Iu
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 16:23:30 +0200
Message-ID: <48D658BF.7040807@rogers.com>
Date: Sun, 21 Sep 2008 10:22:55 -0400
From: Jonathan Coles <jcoles0727@rogers.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Still unclear how to use Hauppage HVR-950 and v4l-dvb
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

It would really help if there was a single set of instructions specific 
to the HVR-950 with tests at each stage. I'm really confused as to the 
status of my installation.

I compiled the firmware according to the instructions on 
http://linuxtv.org/repo/. The result:

$ lsusb
Bus 005 Device 002: ID 2040:7200 Hauppauge

On the other hand, dmesg reports:

[   17.247610] usb 5-2: new high speed USB device using ehci_hcd and 
address 2
[   17.380387] usb 5-2: unable to read config index 0 descriptor/all
[   17.380434] usb 5-2: can't read configurations, error -71

Is my firmware is properly installed or not?

I'm trying to follow the instructions on your 
*How_to_install_DVB_device_drivers* wiki, but some vital details are 
missing. Which modules do I look for in lsmod? The 
Hauppauge_Computer_Works Wiki doesn't provide this information for the 
HVR-950. The instructions at 
http://u32.net/MythTV/WinTV-HVR-950/index.html indicate that the 
required modules are either em28xx or au0828 and au8522. I have 
modprobe'd these, but still have nothing in /dev/dvb.

Any ideas as to what I am missing or how I can troubleshoot this?



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
