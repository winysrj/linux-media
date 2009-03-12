Return-path: <linux-media-owner@vger.kernel.org>
Received: from n25.bullet.mail.ukl.yahoo.com ([87.248.110.142]:33918 "HELO
	n25.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751158AbZCLJaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 05:30:55 -0400
From: bloehei <bloehei@yahoo.de>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: EC168 support?!
Date: Thu, 12 Mar 2009 10:31:30 +0100
References: <200903111217.17846.bloehei@yahoo.de> <200903111424.02606.bloehei@yahoo.de> <49B7C5A9.1050906@iki.fi>
In-Reply-To: <49B7C5A9.1050906@iki.fi>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121031.31869.bloehei@yahoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> bloehei wrote:
> >> 40 00 00 00 40 08 c5 03 >>> 12 0c 93 80 06 12 0d 43 74 83 f0 e5 48 30 e3
> >> 78
>
> hmm, at least that last fw upload packet is wrong. It should look like
> 40 00 00 00 00 18 c5 03 >>> 49 9f f5
>
> I did yesterday many changes and fixed one bad bug that could be behind
> that. Please test with latest tree at:
> http://linuxtv.org/hg/~anttip/ec168/
>
> regards
> Antti

Hi,
GREAT! The firmware now gets uploaded and I can watch all channels in my 
region with the linux vdr. Thanks a lot! 
Here's my system log:

> ec168_module_init:
> usbcore: registered new interface driver dvb_usb_ec168
> usb 1-3: new high speed USB device using ehci_hcd and address 2
> usb 1-3: configuration #1 chosen from 1 choice
> ec168_probe: interface:0
> ec168_identify_state:
> c0 01 00 00 01 00 01 00 <<< 00
> ec168_identify_state: reply:00
> dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference design' in cold state,
> will try to load a firmware usb 1-3: firmware: requesting dvb-usb-ec168.fw
> dvb-usb: downloading firmware from file 'dvb-usb-ec168.fw'
> ec168_download_firmware:
> 40 00 00 00 00 00 00 08 >>> 02 13 e4 02 0e d3 00 00 00 00 00 02 14 f7 00 00
> 00 00 00 <---cut--->
> 40 00 00 00 00 08 00 08 >>> 4a 12 0c 5b 04 f0 02 08 4b 12 09 7f 12 0d 43 74
> 82 f0 12 <---cut--->
> 40 00 00 00 00 10 00 08 >>> 9d ec 98 40 05 fc ee 9d fe 0f d5 f0 e9 e4 ce fd
> 22 ed f8 <---cut--->
> 40 00 00 00 00 18 c5 03 >>> 49 9f f5 49 e5 48 94 00 f5 48 80 b3 e4 f5 24 f5
> 25 22 af <---cut--->
> 40 01 00 00 01 00 00 00 >>>
> 40 04 01 00 08 00 00 00 >>>
> ec168_rw_udev: usb_control_msg failed :-110
> 40 04 00 00 06 02 00 00 >>>
> dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference design' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer. DVB: registering new adapter (E3C EC168 DVB-T USB2.0 reference
> design) ec168_ec100_frontend_attach:
> DVB: registering adapter 0 frontend 0 (E3C EC100 DVB-T)...
> ec168_mxl5003s_tuner_attach:
> MXL5005S: Attached at address 0xc6
> dvb-usb: E3C EC168 DVB-T USB2.0 reference design successfully initialized
> and connected. ec168_probe: interface:1
> ec168_identify_state:
> c0 01 00 00 01 00 01 00 <<< 01
> ec168_identify_state: reply:01
> dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference design' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer. DVB: registering new adapter (E3C EC168 DVB-T USB2.0 reference
> design) ec168_ec100_frontend_attach:
> DVB: registering adapter 1 frontend 0 (E3C EC100 DVB-T)...
> ec168_mxl5003s_tuner_attach:
> MXL5005S: Attached at address 0xc6
> dvb-usb: E3C EC168 DVB-T USB2.0 reference design successfully initialized
> and connected.

USB-Id:  18b4:1689 
Card name: Sinovideo SV DVB-T 3420B

If I can help with testing, just let me know.

Regards,
Jo

