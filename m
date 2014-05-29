Return-path: <linux-media-owner@vger.kernel.org>
Received: from alpha.mini.pw.edu.pl ([194.29.178.1]:57926 "EHLO
	alpha.mini.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbaE2Mvb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 08:51:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by alpha.mini.pw.edu.pl (Postfix) with ESMTP id 87C4A2A2077
	for <linux-media@vger.kernel.org>; Thu, 29 May 2014 14:51:29 +0200 (CEST)
Received: from alpha.mini.pw.edu.pl ([127.0.0.1])
	by localhost (alpha.mini.pw.edu.pl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N2Jq-17CoCZG for <linux-media@vger.kernel.org>;
	Thu, 29 May 2014 14:51:25 +0200 (CEST)
Received: from [192.168.1.100] (178235096052.warszawa.vectranet.pl [178.235.96.52])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by alpha.mini.pw.edu.pl (Postfix) with ESMTPSA id EA0E22A2199
	for <linux-media@vger.kernel.org>; Thu, 29 May 2014 14:37:50 +0200 (CEST)
Message-ID: <53872A62.7000700@mini.pw.edu.pl>
Date: Thu, 29 May 2014 14:38:58 +0200
From: Marek Kozlowski <kozlowsm@mini.pw.edu.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Pinnacle 320cx -- /dev/video ?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

:-)

According to:
http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_USB_RC

Pinnacle Expresscard 320cx 	✔ Yes, in kernel since 2.6.26 	2304:022e
USB2.0 		dvb-usb-dib0700-1.20.fw

I've just bought this card and it is correctly recognized and
initialized, however it doesn't work. Precisely: tvtime and similar
applications say: `no video device' and no /dev/video0 nor similar
device files are created. Does the _analog_ part work? Am I missing sth?

/m

May 29 14:06:32 localhost kernel: [   35.839778] dvb-usb: found a
'Pinnacle Expresscard 320cx' in cold state, will try to load a firmware
May 29 14:06:32 localhost kernel: [   35.857310] dvb-usb: downloading
firmware from file 'dvb-usb-dib0700-1.20.fw'
May 29 14:06:33 localhost kernel: [   36.058772] dib0700: firmware
started successfully.
May 29 14:06:33 localhost kernel: [   36.560345] dvb-usb: found a
'Pinnacle Expresscard 320cx' in warm state.
May 29 14:06:33 localhost kernel: [   36.560485] dvb-usb: will pass the
complete MPEG2 transport stream to the software demuxer.
May 29 14:06:33 localhost kernel: [   36.560671] DVB: registering new
adapter (Pinnacle Expresscard 320cx)
May 29 14:06:33 localhost kernel: [   36.803166] usb 2-2: DVB:
registering adapter 0 frontend 0 (DiBcom 7000PC)...
May 29 14:06:33 localhost kernel: [   36.865296] xc2028 9-0061: creating
new instance
May 29 14:06:33 localhost kernel: [   36.865300] xc2028 9-0061: type set
to XCeive xc2028/xc3028 tuner
May 29 14:06:33 localhost kernel: [   36.884811] xc2028 9-0061: Loading
80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
May 29 14:06:33 localhost kernel: [   36.906762] Registered IR keymap
rc-dib0700-rc5
May 29 14:06:33 localhost kernel: [   36.907126] input: IR-receiver
inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1a.7/usb2/2-2/rc/rc0/input15
May 29 14:06:33 localhost kernel: [   36.908238] rc0: IR-receiver inside
an USB DVB receiver as /devices/pci0000:00/0000:00:1a.7/usb2/2-2/rc/rc0
May 29 14:06:33 localhost kernel: [   36.908411] dvb-usb: schedule
remote query interval to 50 msecs.
May 29 14:06:33 localhost kernel: [   36.908419] dvb-usb: Pinnacle
Expresscard 320cx successfully initialized and connected.
May 29 14:06:33 localhost kernel: [   36.908603] usbcore: registered new
interface driver dvb_usb_dib0700
