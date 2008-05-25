Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from firefly.xen.no ([193.71.199.6])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tlan@firefly.xen.no>) id 1K0GNH-0000u4-UN
	for linux-dvb@linuxtv.org; Sun, 25 May 2008 15:35:00 +0200
Date: Sun, 25 May 2008 15:34:56 +0200
From: Thomas =?iso-8859-1?Q?Lang=E5s?= <thomas@langaas.org>
To: linux-dvb@linuxtv.org
Message-ID: <20080525133454.GA30316@firefly.xen.no>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Drivers for Technotrend CT-3650 CI (USB 2.0-device)
Reply-To: thomas@langaas.org
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

Hi!

I just got this device, and I see there's a driver called ttusb2 that
seems to be what I need (with some modifications, I suspect).  I've got
a few logs from when I've been playing with the device in Windows, and I
see that there's a few more commands sent to the device (than is listen
in the ttusb2-driver).  Is there a good util in Windows to send single
commands to a device?  Like "adjust frequency", "adjust QAM-setting"
etc?  I thoought that logging such settings might be the easiest way to
decode the various messages sent to the device.  

In advance, thanks!

-- 
Thomas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
