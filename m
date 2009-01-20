Return-path: <linux-media-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:34690 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZATTYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 14:24:05 -0500
From: "Luhrs, Arne F.E." <arne.luehrs@hp.com>
To: critter <critter1974@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 20 Jan 2009 19:23:46 +0000
Subject: RE: Hauppauge WinTV-Nova-T 500 - problem wit internal IR receiver
Message-ID: <1A5872E54ACA7C40BE798507A106BB203ADEC6B4E2@GVW1163EXB.americas.hpqcorp.net>
References: <f6e4f67d0901200834o1933d4d0n6687cfb9b3d87032@mail.gmail.com>
In-Reply-To: <f6e4f67d0901200834o1933d4d0n6687cfb9b3d87032@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In Ubuntu 8.10 you will also have to edit the HAL layer afterward if you want to use the IR control
For general purposes (e.g. MythTV)
You want to edit /usr/share/hal/fdi/preprobe/20thirdparty/lirc.fdi
And add the following in there  

<match key="info.product" contains_ncase="IR-receiver">
	<merge key="info.ignore" type="bool">true</merge>
</match>

This will route the IR events to lirc only and not to the keyboard controler.

Good luck
Arne

-----Original Message-----
From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of critter
Sent: 20 January 2009 17:35
To: linux-media@vger.kernel.org
Subject: Hauppauge WinTV-Nova-T 500 - problem wit internal IR receiver

Hello,

I don't have idea is this right way to get help with my problem, but
atleast I am trying. :)

I have this new version of Nova-T 500 which have two aerial inputs.

WinTV-NOVA-TD-500
DVB-T
84109 LF
Rev D1F4

PCI Interface: VIA VT6210L
Demodulator Interface: DiBcom DIB7000

Problem is that internal IR receiver is not recognised.

Here is the log:

[   11.155701] dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in
cold state, will try to load a firmware
[   11.155705] firmware: requesting dvb-usb-dib0700-1.20.fw
[   11.439514] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[   12.144029] dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in warm state.
[   12.144299] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   12.556520] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   12.888314] dvb-usb: Hauppauge Nova-TD-500 (84xxx) successfully
initialized and connected.
[   12.888599] usbcore: registered new interface driver dvb_usb_dib0700

Operating system is Mythbuntu 8.10.

BR
Pena
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
