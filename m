Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx38.mail.ru ([94.100.176.52]:64981 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760135AbZCOThQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 15:37:16 -0400
Received: from [78.36.179.73] (port=51890 helo=localhost.localdomain)
	by mx38.mail.ru with asmtp
	id 1Liw93-000LqX-00
	for linux-media@vger.kernel.org; Sun, 15 Mar 2009 22:37:13 +0300
Date: Sun, 15 Mar 2009 22:50:37 +0300
From: Goga777 <goga777@bk.ru>
To: linux-media@vger.kernel.org
Subject: BUG: cx88 can't find device struct. Can't proceed with open
Message-ID: <20090315225037.0196a446@bk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I have that errors during of system loading . How is it fix it ?

in syslog I can see

Mar 15 21:50:26 localhost pulseaudio[3572]: main.c: setrlimit(RLIMIT_NICE, (31, 31)) failed: Operation not permitted
Mar 15 21:50:26 localhost pulseaudio[3572]: main.c: setrlimit(RLIMIT_RTPRIO, (9, 9)) failed: Operation not permitted
Mar 15 21:50:26 localhost pulseaudio[3572]: shm.c: shm_open() failed: Permission denied
Mar 15 21:50:26 localhost pulseaudio[3572]: core.c: failed to allocate shared memory pool. Falling back to a normal memory pool.
Mar 15 21:50:26 localhost kernel: [   47.341579] BUG: cx88 can't find device struct. Can't proceed with open
Mar 15 21:50:26 localhost pulseaudio[3572]: alsa-util.c: Error opening PCM device hw:1: No such device
Mar 15 21:50:26 localhost pulseaudio[3572]: module.c: Failed to load  module "module-alsa-source" (argument: "device_id=1 source_name=alsa_input.pci_14f1_8
811_alsa_capture_0"): initialization failed.
Mar 15 21:50:26 localhost pulseaudio[3572]: alsa-util.c: Device front:0 doesn't support 44100 Hz, changed to 48000 Hz.
Mar 15 21:50:26 localhost pulseaudio[3572]: alsa-util.c: Device front:0 doesn't support 44100 Hz, changed to 48000 Hz.

here's my dmesg
http://paste.org.ru/?pdmods

I'm using liplanin-dvb with current dvb-v4l 
kernel 2.6.27


Goga
