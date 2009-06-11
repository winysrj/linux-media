Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta-out.inet.fi ([195.156.147.13] helo=jenni1.inet.fi)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lwgt@iki.fi>) id 1MEngh-0006LW-Tj
	for linux-dvb@linuxtv.org; Thu, 11 Jun 2009 19:03:40 +0200
Received: from [127.0.0.1] (88.192.35.233) by jenni1.inet.fi (8.5.014)
	id 49F5976601B86FC9 for linux-dvb@linuxtv.org;
	Thu, 11 Jun 2009 20:03:34 +0300
Message-ID: <4A3138DD.6010306@iki.fi>
Date: Thu, 11 Jun 2009 20:03:25 +0300
From: Lauri Tischler <lwgt@iki.fi>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] af9015 errors
Reply-To: linux-media@vger.kernel.org
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

Following appears in syslog when plugin in Fuji usb-stick

> [  227.744026] usb 1-1: new high speed USB device using ehci_hcd and address 6
> [  227.881303] usb 1-1: configuration #1 chosen from 1 choice
> [  228.008884] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state, will try to load a firmware
> [  228.008894] usb 1-1: firmware: requesting dvb-usb-af9015.fw
> [  228.030287] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> [  228.084183] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
> [  228.084262] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> [  228.084558] DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
> [  228.518386] af9013: firmware version:4.65.0
> [  228.521768] DVB: registering adapter 3 frontend 0 (Afatech AF9013 DVB-T)...
> [  228.567543] MT2060: successfully identified (IF1 = 1220)
> [  229.035652] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:02.2/usb1/1-1/input/input8
> [  229.040808] dvb-usb: schedule remote query interval to 150 msecs.
> [  229.040819] dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully initialized and connected.
> [  229.117384] usbcore: registered new interface driver dvb_usb_af9015
> [  229.193347] af9015: command failed:255
> [  229.193355] dvb-usb: error while querying for an remote control event.
> [  229.230577] usbcore: registered new interface driver hiddev
> [  229.230612] usbcore: registered new interface driver usbhid
> [  229.230617] usbhid: v2.6:USB HID core driver
> [  229.345301] af9015: command failed:255
> [  229.345309] dvb-usb: error while querying for an remote control event.
> [  229.496376] af9015: command failed:255
> [  229.496380] dvb-usb: error while querying for an remote control event.
> [  229.648452] af9015: command failed:255
> [  229.648456] dvb-usb: error while querying for an remote control event.
> [  229.800278] af9015: command failed:255
> [  229.800282] dvb-usb: error while querying for an remote control event.
> [  229.952353] af9015: command failed:255
> [  229.952357] dvb-usb: error while querying for an remote control event.
> [  230.104305] af9015: command failed:255
> [  230.104309] dvb-usb: error while querying for an remote control event.
> [  230.256383] af9015: command failed:255
> [  230.256389] dvb-usb: error while querying for an remote control event.
> [  230.408331] af9015: command failed:255

Errors fill up the log, until usb-stick is removed.
This is with 2.6.28-13-generic #44-Ubuntu SMP kernel,
another box with Debian SID and 2.6.29 runs ok.

Whats up Duck ??

-- 
lwgt@iki.fi  * Using HTML-mail is like breaking wind in a church *
60.2N 24.7E  *   it is not illegal, just extremely bad manners   *

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
