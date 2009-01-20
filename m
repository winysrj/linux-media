Return-path: <linux-media-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:53018 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbZATQew (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 11:34:52 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1831030wah.21
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 08:34:51 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 20 Jan 2009 18:34:50 +0200
Message-ID: <f6e4f67d0901200834o1933d4d0n6687cfb9b3d87032@mail.gmail.com>
Subject: Hauppauge WinTV-Nova-T 500 - problem wit internal IR receiver
From: critter <critter1974@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
