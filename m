Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bitumen.surfer@gmail.com>) id 1JfluE-0003W2-9B
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 03:00:19 +0200
Received: by rv-out-0910.google.com with SMTP id b22so639803rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 29 Mar 2008 18:00:13 -0700 (PDT)
From: J <bitumen.surfer@gmail.com>
To: Antti Palosaari <crope@iki.fi>,
	Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <47EEBED2.4080605@iki.fi>
References: <e44ae5e0712172128p4e1428aao493d0a1725b6fcd3@mail.gmail.com>
	<47EC3BD4.3070307@iki.fi>
	<Pine.LNX.4.64.0803292248590.26653@pub6.ifh.de>
	<47EEBED2.4080605@iki.fi>
Date: Sun, 30 Mar 2008 12:00:06 +1100
Message-Id: <1206838806.20909.2.camel@localhost.localdomain>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] new USB-ID for Leadtek Winfast DTV was:	Re:
	New Leadtek Winfast DTV Dongle working - with mods but no RC
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

Hi,

The proposed patch appears to do the job for me. 

At least when I plug in the dongle I get this in my messages:

Mar 30 11:54:47 localhost kernel: usb 1-4: new high speed USB device
using ehci_hcd and address 8
Mar 30 11:54:47 localhost kernel: usb 1-4: configuration #1 chosen from
1 choice
Mar 30 11:54:47 localhost kernel: dib0700: loaded with support for 5
different device-types
Mar 30 11:54:47 localhost kernel: dvb-usb: found a 'Leadtek Winfast DTV
Dongle (STK7700P based)' in cold state, will try to load a firmware
Mar 30 11:54:47 localhost kernel: dvb-usb: downloading firmware from
file 'dvb-usb-dib0700-1.10.fw'
Mar 30 11:54:48 localhost kernel: dib0700: firmware started
successfully.
Mar 30 11:54:48 localhost kernel: dvb-usb: found a 'Leadtek Winfast DTV
Dongle (STK7700P based)' in warm state.
Mar 30 11:54:48 localhost kernel: dvb-usb: will pass the complete MPEG2
transport stream to the software demuxer.
Mar 30 11:54:48 localhost kernel: DVB: registering new adapter (Leadtek
Winfast DTV Dongle (STK7700P based))
Mar 30 11:54:48 localhost kernel: DVB: registering frontend 0 (DiBcom
7000PC)...
Mar 30 11:54:48 localhost kernel: MT2060: successfully identified (IF1 =
1220)
Mar 30 11:54:49 localhost kernel: input: IR-receiver inside an USB DVB
receiver as /class/input/input11
Mar 30 11:54:49 localhost kernel: dvb-usb: schedule remote query
interval to 150 msecs.
Mar 30 11:54:49 localhost kernel: dvb-usb: Leadtek Winfast DTV Dongle
(STK7700P based) successfully initialized and connected.
Mar 30 11:54:49 localhost kernel: usbcore: registered new interface
driver dvb_usb_dib0700


Thanks
J




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
