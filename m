Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv2.rent-a-guru.de ([212.86.204.162]:54911 "EHLO
	mx02.rent-a-guru.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZESR5K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 13:57:10 -0400
Received: from mx01 (dslb-088-067-117-079.pools.arcor-ip.net [88.67.117.79])
	(authenticated bits=128)
	by mx02.rent-a-guru.de (8.13.6/8.13.6) with ESMTP id n4JHmMAR210994095
	for <linux-media@vger.kernel.org>; Tue, 19 May 2009 19:48:30 +0200 (CEST)
Date: Tue, 19 May 2009 19:48:22 +0200
From: Michael Stapelberg <michael+lm@stapelberg.de>
To: linux-media@vger.kernel.org
Subject: Problems with tuning (only after a while) and Nexus-S
Message-ID: <20090519174822.GA1165@mx01>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

since some days I have problems with my Nexus-S v2.3 and tuning. dmesg says
this about the adapter:

DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-S rev2.3)
adapter has MAC addr = 00:d0:5c:04:f4:2f
dvb-ttpci: info @ card 0: firm f0240009, rtsl b0250018, vid 0f12623
dvb-ttpci: firmware @ card 0 supports CI link layer interface
dvb-ttpci: Crystal audio DAC @ card 0 detected
saa7146_vv: saa7146 (0): registered device video0 [v4l2]
saa7146_vv: saa7146 (0): registered device vbi0 [v4l2]
DVB: registering adapter 0 frontend 0 (ST STV0299 DVB-S)...
input: DVB on-card IR receiver as /class/input/input12
dvb-ttpci: found av7110-0.

Kernel version is 2.6.29, though this happened in my old machine with 2.6.22
aswell. Firmware is dvb-ttpci-01.fw-2622

After some hours of tuning (delay 5 seconds to stress-test the machine), it
will not get further than FE_HAS_SIGNAL and FE_HAS_CARRIER. Only on the
ProSiebenSat.1-transponder i still get a lock, which i find quite odd.

Could it be the cable being badly shielded? Or may it be the LNB failing?
We had some issues with an analog receiver (on the same LNB) displaying
interferences.

I already tried disconnecting the analog receiver to make sure it doesn’t
interfere with the DVB card, but that wasn’t the problem.

Any other ideas what I could try?

Enabling the debug options of the driver led to the following output:
DVB: initialising adapter 0 frontend 0 (ST STV0299 DVB-S)...
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_get_event
dvb_frontend_ioctl
dvb_frontend_add_event
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0 auto_sub_step:0 started_auto_step:0
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_add_event
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:0 auto_sub_step:1 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:1718 inversion:1 auto_step:1 auto_sub_step:0 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:1718 inversion:0 auto_step:1 auto_sub_step:1 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-1718 inversion:0 auto_step:1 auto_sub_step:2 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-1718 inversion:1 auto_step:1 auto_sub_step:3 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:3436 inversion:1 auto_step:2 auto_sub_step:0 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:3436 inversion:0 auto_step:2 auto_sub_step:1 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-3436 inversion:0 auto_step:2 auto_sub_step:2 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-3436 inversion:1 auto_step:2 auto_sub_step:3 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:5154 inversion:1 auto_step:3 auto_sub_step:0 started_auto_step:0
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_swzigzag_autotune: drift:5154 inversion:0 auto_step:3 auto_sub_step:1 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-5154 inversion:0 auto_step:3 auto_sub_step:2 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-5154 inversion:1 auto_step:3 auto_sub_step:3 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:6872 inversion:1 auto_step:4 auto_sub_step:0 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:6872 inversion:0 auto_step:4 auto_sub_step:1 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-6872 inversion:0 auto_step:4 auto_sub_step:2 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-6872 inversion:1 auto_step:4 auto_sub_step:3 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:8590 inversion:1 auto_step:5 auto_sub_step:0 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:8590 inversion:0 auto_step:5 auto_sub_step:1 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-8590 inversion:0 auto_step:5 auto_sub_step:2 started_auto_step:0
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_swzigzag_autotune: drift:-8590 inversion:1 auto_step:5 auto_sub_step:3 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:10308 inversion:1 auto_step:6 auto_sub_step:0 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:10308 inversion:0 auto_step:6 auto_sub_step:1 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-10308 inversion:0 auto_step:6 auto_sub_step:2 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-10308 inversion:1 auto_step:6 auto_sub_step:3 started_auto_step:0
dvb_frontend_add_event
dvb_frontend_swzigzag_autotune: drift:12026 inversion:1 auto_step:7 auto_sub_step:0 started_auto_step:0
dvb_frontend_add_event
dvb_frontend_swzigzag_autotune: drift:12026 inversion:0 auto_step:7 auto_sub_step:1 started_auto_step:0
dvb_frontend_add_event
dvb_frontend_swzigzag_autotune: drift:-12026 inversion:0 auto_step:7 auto_sub_step:2 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-12026 inversion:1 auto_step:7 auto_sub_step:3 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:13744 inversion:1 auto_step:8 auto_sub_step:0 started_auto_step:0
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_swzigzag_autotune: drift:13744 inversion:0 auto_step:8 auto_sub_step:1 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-13744 inversion:0 auto_step:8 auto_sub_step:2 started_auto_step:0
dvb_frontend_swzigzag_autotune: drift:-13744 inversion:1 auto_step:8 auto_sub_step:3 started_auto_step:0
dvb_frontend_swzigzag_update_delay
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:0 auto_sub_step:0 started_auto_step:0
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_add_event
dvb_frontend_swzigzag_update_delay
vb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0 auto_sub_step:1 started_auto_step:0
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_add_event
dvb_frontend_swzigzag_update_delay
dvb_frontend_swzigzag_autotune: drift:1718 inversion:0 auto_step:1 auto_sub_step:0 started_auto_step:0
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_swzigzag_update_delay
dvb_frontend_swzigzag_autotune: drift:1718 inversion:1 auto_step:1 auto_sub_step:1 started_auto_step:0
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_ioctl
dvb_frontend_swzigzag_update_delay
dvb_frontend_swzigzag_autotune: drift:-1718 inversion:1 auto_step:1 auto_sub_step:2 started_auto_step:0
dvb_frontend_release

Best regards,
Michael
