Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34050 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab0GEIjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jul 2010 04:39:37 -0400
Received: by vws5 with SMTP id 5so5782739vws.19
        for <linux-media@vger.kernel.org>; Mon, 05 Jul 2010 01:39:36 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 5 Jul 2010 10:39:36 +0200
Message-ID: <AANLkTil3JUgSE43P12RWUkErU1Uj5uQrTJQTzkq9eZQB@mail.gmail.com>
Subject: 2.6.35-rc4 doesn't play well with TerraTec cinergyT2
From: Jan Willies <jan@willies.info>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm running 2.6.35-rc4 and get this with a TerraTec cinergyT2:

Jul  5 10:03:03 htpc kernel: dvb-usb: found a 'TerraTec/qanu USB2.0
Highspeed DVB-T Receiver' in warm state.
Jul  5 10:03:05 htpc kernel: dvb-usb: bulk message failed: -110 (2/0)
Jul  5 10:03:05 htpc kernel: dvb-usb: will pass the complete MPEG2
transport stream to the software demuxer.
Jul  5 10:03:05 htpc kernel: dvb-usb: will pass the complete MPEG2
transport stream to the software demuxer.
Jul  5 10:03:05 htpc kernel: DVB: registering new adapter
(TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)
Jul  5 10:03:07 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
Jul  5 10:03:07 htpc kernel: DVB: registering adapter 0 frontend 0
(TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)...
Jul  5 10:03:07 htpc kernel: input: IR-receiver inside an USB DVB
receiver as /devices/pci0000:00/0000:00:04.1/usb1/1-2/input/input4
Jul  5 10:03:07 htpc kernel: dvb-usb: schedule remote query interval
to 50 msecs.
Jul  5 10:03:09 htpc kernel: dvb-usb: bulk message failed: -110 (2/0)
Jul  5 10:03:09 htpc kernel: dvb-usb: TerraTec/qanu USB2.0 Highspeed
DVB-T Receiver successfully initialized and connected.
Jul  5 10:03:09 htpc kernel: dvb-usb: TerraTec/qanu USB2.0 Highspeed
DVB-T Receiver successfully initialized and connected.
Jul  5 10:03:09 htpc kernel: usbcore: registered new interface driver cinergyT2
Jul  5 10:03:11 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
Jul  5 10:03:13 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
Jul  5 10:03:15 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
Jul  5 10:03:17 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
Jul  5 10:03:19 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
Jul  5 10:03:22 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
Jul  5 10:03:22 htpc kernel: usbcore: deregistering interface driver cinergyT2
Jul  5 10:03:22 htpc kernel: dvb-usb: TerraTec/qanu USB2.0 Highspeed
DVB-T Receiver successfully deinitialized and disconnected.

2.6.35-rc3 was ok. Is this a known regression or am I doing something wrong?


regards,

 - jan
