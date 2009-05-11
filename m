Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:48552 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZEKMTv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 08:19:51 -0400
Received: from wmproxy1-g27.free.fr (wmproxy1-g27.free.fr [212.27.42.91])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id B22AC77CF2E
	for <linux-media@vger.kernel.org>; Mon, 11 May 2009 14:19:48 +0200 (CEST)
Received: from wmproxy1-g27.free.fr (localhost [127.0.0.1])
	by wmproxy1-g27.free.fr (Postfix) with ESMTP id 58E96634D0
	for <linux-media@vger.kernel.org>; Mon, 11 May 2009 14:18:49 +0200 (CEST)
Received: from UNKNOWN (imp4-g19.priv.proxad.net [172.20.243.134])
	by wmproxy1-g27.free.fr (Postfix) with ESMTP id 3ABE963548
	for <linux-media@vger.kernel.org>; Mon, 11 May 2009 14:18:48 +0200 (CEST)
Message-ID: <1242044328.4a0817a834575@imp.free.fr>
Date: Mon, 11 May 2009 14:18:48 +0200
From: linuxconsole@free.fr
To: linux-media@vger.kernel.org
Subject: AverMedia AVerTV Volar Black HD (A850) support
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi and thanks for your work.

I have a AverMedia AVerTV Volar Black, I downloaded latest v4l-dvb (build with
2.6.29.2 kernel), load driver, all is fine :

***************************************************************************
 dvb-usb: found a 'AverMedia AVerTV Volar Black HD (A850)' in cold state, will
try to load a firmware
 usb 1-4: firmware: requesting dvb-usb-af9015.fw
 dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
 dvb-usb: found a 'AverMedia AVerTV Volar Black HD (A850)' in warm state.
 dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
 DVB: registering new adapter (AverMedia AVerTV Volar Black HD (A850))
 af9013: firmware version:4.95.0
 DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
 MXL5005S: Attached at address 0xc6
 dvb-usb: AverMedia AVerTV Volar Black HD (A850) successfully initialized and
connected.
 usbcore: registered new interface driver dvb_usb_af9015

***************************************************************************
but after starting dvbscan (that starts but never stops), I see those error
messages :

[60111.937222] af9015: command failed:1
[60111.937226] mxl5005s I2C reset failed

(dvbscan reports tuning status is 0x02, then 0x02, 0x01 and 0x1f

What can I do now ?

Yann.

