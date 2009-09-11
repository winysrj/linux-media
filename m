Return-path: <linux-media-owner@vger.kernel.org>
Received: from iptv.by ([91.149.162.254]:60657 "EHLO mail.iptv.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbZIKGcq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 02:32:46 -0400
Received: from localhost (mail.iptv.by) [127.0.0.1]
	 by mail.iptv.by with esmtp  id=1MlzPY-000EEL-AU
	for linux-media@vger.kernel.org; Fri, 11 Sep 2009 09:15:08 +0300
Message-ID: <64009.10.2.1.45.1252649708.squirrel@mail.iptv.by>
Date: Fri, 11 Sep 2009 09:15:08 +0300 (EEST)
Subject: How to capture the whole TS
From: olvin@iptv.by
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

I have a DVB-C PCI card (Technotrend Premium C-2300). Now I am trying to
write an application that will capture TS and write it to disk for future
analysis. The problem is that Linux DVB API demands the usage of PID
filter (DMX_SET_FILTER or DMX_SET_PES_FILTER in ioctl call), and I need to
capture the whole TS, packet by packet, exactly in the order they come.

I tried to use PID 0x2000 as a PID to be filtered, but have an EINVAL. I
saw some posts in the Internet where people were complaining about some
DVB cards that cannot give the ability to capture TS without filtering
explicitly specified PIDs, and I want to know: am I able to use
Technotrend Premium C-2300 card to capture the whole TS, and if yes then
how to do this.

Maybe I have to load dvb_ttpci module with some specific parameter set to
enable the feature that I need? Just in case, here is the parameter list
of this driver module:

parm:           ir_protocol:Infrared protocol: 0 RC5, 1 RCMM (default)
(array of int)
parm:           ir_inversion:Inversion of infrared signal: 0 not inverted
(default), 1 inverted (array of int)
parm:           ir_device_mask:Bitmask of infrared devices: bit 0..31 =
device 0..31 (default: all) (array of uint)
parm:           debug:debug level (bitmask, default 0) (int)
parm:           vidmode:analog video out: 0 off, 1 CVBS+RGB (default), 2
CVBS+YC, 3 YC (int)
parm:           pids_off:clear video/audio/PCR PID filters when demux is
closed (int)
parm:           adac:audio DAC type: 0 TI, 1 CRYSTAL, 2 MSP (use if
autodetection fails) (int)
parm:           hw_sections:0 use software section filter, 1 use hardware
(int)
parm:           rgb_on:For Siemens DVB-C cards only: Enable RGB control
signal on SCART pin 16 to switch SCART video mode from CVBS to RGB (int)
parm:           volume:initial volume: default 255 (range 0-255) (int)
parm:           budgetpatch:use budget-patch hardware modification:
default 0 (0 no, 1 autodetect, 2 always) (int)
parm:           full_ts:enable code for full-ts hardware modification: 0
disable (default), 1 enable (int)
parm:           wss_cfg_4_3:WSS 4:3 - default 0x4008 - bit 15: disable,
14: burst mode, 13..0: wss data (int)
parm:           wss_cfg_16_9:WSS 16:9 - default 0x0007 - bit 15: disable,
14: burst mode, 13..0: wss data (int)
parm:           tv_standard:TV standard: 0 PAL (default), 1 NTSC (int)
parm:           adapter_nr:DVB adapter numbers (array of short)

I have already used these parameters (in combination and apart) but have
no result: full_ts=1, budgetpatch=2, hw_sections=0. I am not sure what
exactly they mean.

$ uname -r
2.6.27-std-def-alt16
(ALT Linux, if it does matter)

Thanks in advance.
Sergey Kudriavtsev.


