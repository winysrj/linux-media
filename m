Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:65090 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaFJMui (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jun 2014 08:50:38 -0400
Received: from wolfgang ([88.27.195.166]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0Ldbqw-1WTDyA2Hxa-00igaU for
 <linux-media@vger.kernel.org>; Tue, 10 Jun 2014 14:50:36 +0200
Date: Tue, 10 Jun 2014 14:50:59 +0200
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: linux-media@vger.kernel.org
Subject: AF9033 / IT913X: Avermedia A835B(1835) only works sporadically
Message-ID: <20140610125059.GA1930@wolfgang>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello list,

I have an "Avermedia A835B(1835)" USB DVB-T stick (07ca:1835) which
works only (very) sporadically. It's pure luck as far as I can see.
I can't reproduce how to get it working. There are no special steps that
I can take to guarantee that it'll work once I plug it in.

I'd rate my chances of having the device actually working between 5 and
10 percent.

In the log everything looks fine, apart from the messages at the bottom
about the device not being able to get a lock on a channel.

Reception here is really good, so there's no problem with signal
strength. When loading the device in Windows 7 64 bit it always finds a
lock.

Has anybody any idea? Thanks for any suggestions!

Jun 10 14:18:07 meiner kernel: usb 1-2: new high-speed USB device number 2 using xhci_hcd
Jun 10 14:18:07 meiner kernel: WARNING: You are using an experimental version of the media stack.
Jun 10 14:18:07 meiner kernel: 	As the driver is backported to an older kernel, it doesn't offer
Jun 10 14:18:07 meiner kernel: 	enough quality for its usage in production.
Jun 10 14:18:07 meiner kernel: 	Use it with care.
Jun 10 14:18:07 meiner kernel: Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
Jun 10 14:18:07 meiner kernel: 	bfd0306462fdbc5e0a8c6999aef9dde0f9745399 [media] v4l: Document timestamp buffer flag behaviour
Jun 10 14:18:07 meiner kernel: 	309f4d62eda0e864c2d4eef536cc82e41931c3c5 [media] v4l: Copy timestamp source flags to destination on m2m devices
Jun 10 14:18:07 meiner kernel: 	599b08929efe9b90e44b504454218a120bb062a0 [media] exynos-gsc, m2m-deinterlace, mx2_emmaprp: Copy v4l2_buffer data from src to dst
Jun 10 14:18:07 meiner kernel: 	experimental: a60b303c3e347297a25f0a203f0ff11a8efc818c experimental/ngene: Support DuoFlex C/C2/T/T2 (V3)
Jun 10 14:18:07 meiner kernel: 	v4l-dvb-saa716x: 052c468e33be00a3d4d9b93da3581ffa861bb288 saa716x: IO memory of upper PHI1 regions is mapped in saa716x_ff driver.
Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_af9035: prechip_version=83 chip_version=02 chip_type=9135
Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_v2: found a 'Avermedia A835B(1835)' in cold state
Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_v2: downloading firmware from file 'dvb-usb-it9135-02.fw'
Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_af9035: firmware version=3.42.3.3
Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_v2: found a 'Avermedia A835B(1835)' in warm state
Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
Jun 10 14:18:07 meiner kernel: DVB: registering new adapter (Avermedia A835B(1835))
Jun 10 14:18:07 meiner kernel: i2c i2c-0: af9033: firmware version: LINK=0.0.0.0 OFDM=3.29.3.3
Jun 10 14:18:07 meiner kernel: usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech AF9033 (DVB-T))...
Jun 10 14:18:07 meiner kernel: i2c i2c-0: tuner_it913x: ITE Tech IT913X successfully attached
Jun 10 14:18:07 meiner kernel: usb 1-2: dvb_usb_v2: 'Avermedia A835B(1835)' successfully initialized and connected
Jun 10 14:18:07 meiner kernel: usbcore: registered new interface driver dvb_usb_af9035
Jun 10 14:18:28 meiner vdr: [1653] VDR version 2.0.4 started
Jun 10 14:18:28 meiner vdr: [1653] switched to user 'vdr'
Jun 10 14:18:28 meiner vdr: [1653] codeset is 'UTF-8' - known
Jun 10 14:18:28 meiner vdr: [1653] loading plugin: /usr/lib64/vdr/plugins/libvdr-softhddevice.so.2.0.0
Jun 10 14:18:28 meiner vdr: New default svdrp port 6419!
Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/setup.conf
Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/sources.conf
Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/diseqc.conf
Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/scr.conf
Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/channels.conf
Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/timers.conf
Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/commands.conf
Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/reccmds.conf
Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/svdrphosts.conf
Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/remote.conf
Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/keymacros.conf
Jun 10 14:18:29 meiner vdr: [1653] DVB API version is 0x050A (VDR was built with 0x050A)
Jun 10 14:18:29 meiner vdr: [1653] frontend 0/0 provides DVB-T with QPSK,QAM16,QAM64 ("Afatech AF9033 (DVB-T)")
Jun 10 14:18:29 meiner vdr: [1653] found 1 DVB device
Jun 10 14:18:29 meiner vdr: [1653] initializing plugin: softhddevice (0.6.1rc1): Ein Software und GPU emulieres HD-Gerät
Jun 10 14:18:29 meiner vdr: [1653] setting primary device to 2
Jun 10 14:18:29 meiner vdr: [1653] SVDRP listening on port 6419
Jun 10 14:18:29 meiner vdr: [1653] setting current skin to "lcars"
Jun 10 14:18:29 meiner vdr: [1653] loading /etc/vdr/themes/lcars-default.theme
Jun 10 14:18:29 meiner vdr: [1653] starting plugin: softhddevice
Jun 10 14:18:30 meiner vdr: [1653] switching to channel 2
Jun 10 14:18:30 meiner lircd-0.9.0[1219]: accepted new client on /var/run/lirc/lircd
Jun 10 14:18:30 meiner lircd-0.9.0[1219]: zotac initializing '/dev/usb/hiddev0'
Jun 10 14:18:31 meiner kernel: nvidia 0000:02:00.0: irq 46 for MSI/MSI-X
Jun 10 14:18:31 meiner vdr: [1653] connect from 127.0.0.1, port 59159 - accepted
Jun 10 14:18:31 meiner vdr: [1653] closing SVDRP connection
Jun 10 14:18:31 meiner vdrwatchdog[1702]: Starting vdrwatchdog
Jun 10 14:18:39 meiner vdr: [1674] frontend 0/0 timed out while tuning to channel 2, tp 818
Jun 10 14:19:43 meiner vdr: [1674] frontend 0/0 timed out while tuning to channel 2, tp 818

Kind regards,
Sebatian
