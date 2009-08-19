Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:53609 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbZHSQTH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 12:19:07 -0400
Message-ID: <4A8C2611.9050002@nildram.co.uk>
Date: Wed, 19 Aug 2009 17:19:29 +0100
From: Lou Otway <lotway@nildram.co.uk>
Reply-To: lotway@nildram.co.uk
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problem with Hauppauge Nova-500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

I have a Hauppauge Nova-T 500 that is displaying some odd behaviour.

Often the device fails to tune after rebooting the host machine, due to 
a failure to load firmware.

when the firmware fails to load, dmesg shows:

dib0700: loaded with support for 9 different device-types
dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold state, will 
try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
dib0700: firmware download failed at 7 with -22
usbcore: registered new interface driver dvb_usb_dib0700

When firmware loading is successful I see:

dib0700: loaded with support for 9 different device-types
dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
DVB: registering adapter 1 frontend 0 (DiBcom 3000MC/P)...
MT2060: successfully identified (IF1 = 1242)
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
MT2060: successfully identified (IF1 = 1233)
input: IR-receiver inside an USB DVB receiver as /class/input/input7
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and 
connected.
usbcore: registered new interface driver dvb_usb_dib0700

Powering down the host machine seems to help as, so far, I have 100% 
success when restarting this way, whereas after reboot the success is 
much lower, firmware failing to load maybe 50% of the time.

Has anyone seen this behaviour before, any advice on what the cause 
might be?

Many thanks,

Lou



