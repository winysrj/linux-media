Return-path: <linux-media-owner@vger.kernel.org>
Received: from charon.podzimek.org ([83.240.118.45]:41808 "EHLO podzimek.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab1KXVqy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 16:46:54 -0500
Message-ID: <4ECEBA1F.7000404@podzimek.org>
Date: Thu, 24 Nov 2011 22:41:51 +0100
From: Andrej Podzimek <andrej@podzimek.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="=_charon-11078-1322170911-0001-2"
To: linux-media@vger.kernel.org
Subject: AverTV Volar HD Pro scanning problems
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_charon-11078-1322170911-0001-2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hello,

I use this device

	07ca:a835 AVerMedia Technologies, Inc.

with a 3.1.2 kernel (x86_64). TV can be played just fine in Kaffeine, but=
 scanning does not work (tried with kaffeine, scan). One has to obtain th=
e channel information from elsewhere, since scanning ends with the follow=
ing errors in dmesg:

	af9035: recv bulk message failed:-110
	af9033: I2C read failed reg:0047
	af9035: recv bulk message failed:-110
	af9033: I2C read failed reg:0045

	* Attempts to disable USB autosuspend (using the usbcore parameter and/o=
r laptop-mode-tools) don't change anything.
	* Failures are less likely (occur later during the scan) if the device i=
s plugged into a USB 3.0 port.

How can I make scanning work? Is there a Git branch I could try?

Thank you in advance for your hints. :-)

Andrej


P. S. The dmesg output after plugging in the device:

usb 4-1.2: new high speed USB device number 6 using ehci_hcd
dvb-usb: found a 'Avermedia AverTV Volar HD & HD PRO (A835)' in cold stat=
e, will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-af9035-01.fw'
dvb-usb: found a 'Avermedia AverTV Volar HD & HD PRO (A835)' in warm stat=
e.
dvb-usb: will pass the complete MPEG2 transport stream to the software de=
muxer.
DVB: registering new adapter (Avermedia AverTV Volar HD & HD PRO (A835))
af9033: firmware version: LINK:11.15.10.0 OFDM:5.48.10.0
DVB: registering adapter 0 frontend 0 (Afatech AF9033 DVB-T)...
tda18218: NXP TDA18218HN successfully identified.
IR keymap rc-avermedia-rm-ks not found
Registered IR keymap rc-empty
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000=
:00:1d.0/usb4/4-1/4-1.2/rc/rc3/input19
rc3: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:0=
0:1d.0/usb4/4-1/4-1.2/rc/rc3
dvb-usb: schedule remote query interval to 400 msecs.
dvb-usb: Avermedia AverTV Volar HD & HD PRO (A835) successfully initializ=
ed and connected.


--=_charon-11078-1322170911-0001-2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: Elektronický podpis S/MIME

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
--=_charon-11078-1322170911-0001-2--
