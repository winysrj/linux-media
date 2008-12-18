Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <davideshay@gmail.com>) id 1LDCLK-0004rT-VF
	for linux-dvb@linuxtv.org; Thu, 18 Dec 2008 07:27:10 +0100
Received: by rn-out-0910.google.com with SMTP id j43so216008rne.2
	for <linux-dvb@linuxtv.org>; Wed, 17 Dec 2008 22:26:38 -0800 (PST)
Message-ID: <9b7b1af0812172226w7e677fcat5808a97fd5554e41@mail.gmail.com>
Date: Thu, 18 Dec 2008 00:26:38 -0600
From: "David Shay" <davideshay@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] DVICO FusionHDTV5 USB unable to find symbol
	lgdt330x_attach
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1383668995=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1383668995==
Content-Type: multipart/alternative;
	boundary="----=_Part_38534_7072146.1229581598102"

------=_Part_38534_7072146.1229581598102
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I'm having a problem with the device listed above.
Relevant facts:

DVICO FusionHDTV5 USB device (USB device ID 0fe9:d501)
Gentoo 2.6.26, running kernel gentoo-sources 2.6.26-r4 (dvb drivers
initially from kernel only)

The following is the dmesg log at bootup:

dvb-usb: found a 'DViCO FusionHDTV5 USB Gold' in warm state.
i2c-adapter i2c-1: adapter [DViCO FusionHDTV5 USB Gold] registered
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (DViCO FusionHDTV5 USB Gold)
DVB: Unable to find symbol lgdt330x_attach()
dvb-usb: no frontend was attached by 'DViCO FusionHDTV5 USB Gold'
input: IR-receiver inside an USB DVB receiver as /class/input/input5
dvb-usb: schedule remote query interval to 100 msecs.
dvb-usb: DViCO FusionHDTV5 USB Gold successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_cxusb

Main error here is the unable to find symbol lgdt330x_attach() line. Not
sure what is happening here. Was on #linuxtv last night and on a hunch, we
disconnected the device, manually modprobe'd lgdt330x and reconnected, and
all was fine.  Recommendation was to install from the latest drivers from
mercurial, which I have done.  I still get the same symptoms as indicated
above.  If I then disconnect and reconnect (even without the modprobe), I
get the rest of the log, as indicated below, which makes everything
successful:


usb 1-4: USB disconnect, address 3
i2c-adapter i2c-1: adapter [DViCO FusionHDTV5 USB Gold] unregistered
dvb-usb: DViCO FusionHDTV5 USB Gold successfully deinitialized and
disconnected

usb 1-4: new high speed USB device using ehci_hcd and address 4
usb 1-4: configuration #1 chosen from 1 choice
dvb-usb: found a 'DViCO FusionHDTV5 USB Gold' in cold state, will try to
load a
firmware
firmware: requesting dvb-usb-bluebird-01.fw
dvb-usb: downloading firmware from file 'dvb-usb-bluebird-01.fw'
usb 1-4: USB disconnect, address 4
dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
usb 1-4: new high speed USB device using ehci_hcd and address 5
usb 1-4: configuration #1 chosen from 1 choice
dvb-usb: found a 'DViCO FusionHDTV5 USB Gold' in warm state.
i2c-adapter i2c-1: adapter [DViCO FusionHDTV5 USB Gold] registered
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (DViCO FusionHDTV5 USB Gold)
DVB: Unable to find symbol lgdt330x_attach()
dvb-usb: no frontend was attached by 'DViCO FusionHDTV5 USB Gold'
input: IR-receiver inside an USB DVB receiver as /class/input/input6
dvb-usb: schedule remote query interval to 100 msecs.
dvb-usb: DViCO FusionHDTV5 USB Gold successfully initialized and connected.

Any ideas here?

------=_Part_38534_7072146.1229581598102
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I&#39;m having a problem with the device listed above.<div><br></div><div>Relevant facts:</div><div><br></div><div>DVICO FusionHDTV5 USB device (USB device ID 0fe9:d501)</div><div>Gentoo 2.6.26, running kernel gentoo-sources 2.6.26-r4 (dvb drivers initially from kernel only)</div>
<div><br></div><div>The following is the dmesg log at bootup:</div><div><br></div><div><div><div>dvb-usb: found a &#39;DViCO FusionHDTV5 USB Gold&#39; in warm state.</div><div>i2c-adapter i2c-1: adapter [DViCO FusionHDTV5 USB Gold] registered</div>
<div>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.</div><div>DVB: registering new adapter (DViCO FusionHDTV5 USB Gold)</div><div>DVB: Unable to find symbol lgdt330x_attach()</div><div>dvb-usb: no frontend was attached by &#39;DViCO FusionHDTV5 USB Gold&#39;</div>
<div>input: IR-receiver inside an USB DVB receiver as /class/input/input5</div><div>dvb-usb: schedule remote query interval to 100 msecs.</div><div>dvb-usb: DViCO FusionHDTV5 USB Gold successfully initialized and connected.</div>
<div>usbcore: registered new interface driver dvb_usb_cxusb</div><div><br></div><div>Main error here is the unable to find symbol lgdt330x_attach() line. Not sure what is happening here. Was on #linuxtv last night and on a hunch, we disconnected the device, manually modprobe&#39;d lgdt330x and reconnected, and all was fine. &nbsp;Recommendation was to install from the latest drivers from mercurial, which I have done. &nbsp;I still get the same symptoms as indicated above. &nbsp;If I then disconnect and reconnect (even without the modprobe), I get the rest of the log, as indicated below, which makes everything successful:</div>
<div><br></div><div><br></div><div>usb 1-4: USB disconnect, address 3<br></div><div>i2c-adapter i2c-1: adapter [DViCO FusionHDTV5 USB Gold] unregistered</div><div>dvb-usb: DViCO FusionHDTV5 USB Gold successfully deinitialized and disconnected</div>
<div><br></div><div>usb 1-4: new high speed USB device using ehci_hcd and address 4</div><div>usb 1-4: configuration #1 chosen from 1 choice</div><div>dvb-usb: found a &#39;DViCO FusionHDTV5 USB Gold&#39; in cold state, will try to load a</div>
<div>firmware</div><div>firmware: requesting dvb-usb-bluebird-01.fw</div><div>dvb-usb: downloading firmware from file &#39;dvb-usb-bluebird-01.fw&#39;</div><div>usb 1-4: USB disconnect, address 4</div><div>dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.</div>
<div>usb 1-4: new high speed USB device using ehci_hcd and address 5</div><div>usb 1-4: configuration #1 chosen from 1 choice</div><div>dvb-usb: found a &#39;DViCO FusionHDTV5 USB Gold&#39; in warm state.</div><div>i2c-adapter i2c-1: adapter [DViCO FusionHDTV5 USB Gold] registered</div>
<div>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.</div><div>DVB: registering new adapter (DViCO FusionHDTV5 USB Gold)</div><div>DVB: Unable to find symbol lgdt330x_attach()</div><div>dvb-usb: no frontend was attached by &#39;DViCO FusionHDTV5 USB Gold&#39;</div>
<div>input: IR-receiver inside an USB DVB receiver as /class/input/input6</div><div>dvb-usb: schedule remote query interval to 100 msecs.</div><div>dvb-usb: DViCO FusionHDTV5 USB Gold successfully initialized and connected.</div>
<div><br></div><div>Any ideas here?</div></div></div>

------=_Part_38534_7072146.1229581598102--


--===============1383668995==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1383668995==--
