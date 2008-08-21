Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1KWJ6v-00050m-RO
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 00:58:35 +0200
From: Nicolas Will <nico@youplala.net>
To: Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <1219359165.6770.27.camel@youkaida>
References: <1219357399.6770.12.camel@youkaida>
	<1219359165.6770.27.camel@youkaida>
Date: Thu, 21 Aug 2008 23:57:34 +0100
Message-Id: <1219359454.6770.30.camel@youkaida>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] New firmware for dib0700 (Nova-T-500 and others)
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

On Thu, 2008-08-21 at 23:52 +0100, Nicolas Will wrote:
> On Thu, 2008-08-21 at 23:23 +0100, Nicolas Will wrote:
> > All,
> > 
> > There is a new firmware file fixing the last cause for i2c errors and
> > disconnects and providing a new, more modular i2c request formatting.
> > 
> 
> Ahem....
> 
> I may have jumped the gun.
> 
> My system keeps rebooting when using the new firmware.
> 
> I have used a soft link with the 1.10 name pointed at the 1.20 firmware.
> 
> And I get no DVB-T card at all, adapter of FE.



Aug 21 23:43:39 favia kernel: [   34.062388] dib0700: loaded with
support for 7 different device-types
Aug 21 23:43:39 favia kernel: [   34.062569] dvb-usb: found a 'Hauppauge
Nova-T 500 Dual DVB-T' in cold state, will try to load a firmware
Aug 21 23:43:39 favia kernel: [   34.168630] dvb-usb: downloading
firmware from file 'dvb-usb-dib0700-1.10.fw'
Aug 21 23:43:39 favia kernel: [   34.385198] usbcore: registered new
interface driver dvb_usb_dib0700


Then nothing about the device... Nothing in syslog about the reboot...

Nico







> 
> Nico
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
