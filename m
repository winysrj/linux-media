Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:65190 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbZFAVvA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 17:51:00 -0400
Message-ID: <4A244D3F.8050809@retrodesignfan.eu>
Date: Mon, 01 Jun 2009 23:50:55 +0200
From: Marco Borm <linux-dvb@retrodesignfan.eu>
Reply-To: linux-media@vger.kernel.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: Terratec DT USB XS Diversity/DiB0070+vdr: "URB status: Value
 too large for defined data type"+USB reset
References: <4A232498.2080202@retrodesignfan.eu>
In-Reply-To: <4A232498.2080202@retrodesignfan.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks.

Sorry but I'm unable to reply to my previous message, because I just 
don't have this message. Now I'm registered to both lists...

I "played" a little bit with my problem and tried the latest source from 
the repository, but EOVERFLOW still occurs seconds after starting vdr.
I activated the debug options of all, I hope, relevant modules now and 
got a more detailed kern.log.
Maybe some expert can help me and take look at it.
Interesting section:

Jun  1 23:16:14 vdr kernel: function : dvb_dvr_poll
Jun  1 23:16:14 vdr kernel: function : dvb_dvr_poll
Jun  1 23:16:14 vdr kernel: function : dvb_dvr_poll
Jun  1 23:16:14 vdr kernel: dmxdev: section callback 4e f2 6c 40 0a e7
Jun  1 23:16:14 vdr kernel: dmxdev: section callback 50 f2 55 40 13 e1
Jun  1 23:16:14 vdr kernel: dmxdev: section callback 00 b0 1d 03 01 d1
Jun  1 23:16:14 vdr kernel: stop pid: 0x00a0, feedtype: 1
Jun  1 23:16:14 vdr kernel: setting pid (no):   160 00a0 at index 7 'off'
Jun  1 23:16:14 vdr kernel: function : dvb_dmxdev_filter_set
Jun  1 23:16:14 vdr kernel: start pid: 0x00e0, feedtype: 1
Jun  1 23:16:14 vdr kernel: setting pid (no):   224 00e0 at index 7 'on'
Jun  1 23:16:14 vdr kernel: function : dvb_dvr_poll
Jun  1 23:16:14 vdr kernel: function : dvb_dvr_poll
BOOM -> Jun  1 23:16:14 vdr kernel: urb completition error -75.

The whole logfile is available here:
http://www.retrodesignfan.eu/dvb/dib0700-usb-hangup.log


Greetings,
Marco Borm

Marco Borm wrote:
> Hi folks,
>
> yesterday I bought  a Terratec Cinergy DT USB XS Diversity and the 
> device works just plug&play and without problems under Windows AND 
> linux mplayer+ tzap but resets the whole USB bus very shortly after I 
> starting vdr. I don't think this has something to do with vdr itself, 
> so I posting here.
>
> My configuration is Debian on testing, kernel is 
> 2.6.29-4.slh.1-sidux-686, DVB drivers aren't self compiled, vdr is 
> "(1.6.0-2/1.6.0)", device info: ID 0ccd:0081 TerraTec Electronic GmbH.
> log entries:
> Jun  1 01:14:47 vdr kernel: dib0700: loaded with support for 8 
> different device-types
> Jun  1 01:14:47 vdr kernel: dvb-usb: found a 'Terratec Cinergy DT USB 
> XS Diversity' in warm state.
> Jun  1 01:14:47 vdr kernel: dvb-usb: will pass the complete MPEG2 
> transport stream to the software demuxer.
> Jun  1 01:14:47 vdr kernel: DVB: registering new adapter (Terratec 
> Cinergy DT USB XS Diversity)
> Jun  1 01:14:47 vdr kernel: DVB: registering adapter 1 frontend 0 
> (DiBcom 7000PC)...
> Jun  1 01:14:47 vdr kernel: DiB0070: successfully identified
> Jun  1 01:14:47 vdr kernel: dvb-usb: will pass the complete MPEG2 
> transport stream to the software demuxer.
> Jun  1 01:14:47 vdr kernel: DVB: registering new adapter (Terratec 
> Cinergy DT USB XS Diversity)
> Jun  1 01:14:47 vdr kernel: DVB: registering adapter 2 frontend 0 
> (DiBcom 7000PC)...
> Jun  1 01:14:47 vdr kernel: DiB0070: successfully identified
> Jun  1 01:14:47 vdr kernel: dvb-usb: Terratec Cinergy DT USB XS 
> Diversity successfully initialized and connected.
> Jun  1 01:14:47 vdr kernel: usbcore: registered new interface driver 
> dvb_usb_dib0700
> vdr start -> Jun  1 01:16:24 vdr logger: runvdr get_modulenames: 
> dvb_usb#012videobuf_dvb#012cx88_dvb dvb_core
> USB reset -> Jun  1 01:18:00 vdr kernel: usb 1-2: USB disconnect, [... 
> all devices reconnecting to the bus ....]
> Jun  1 01:18:28 vdr kernel: DiB0070 I2C write failed
> Jun  1 01:18:28 vdr kernel: DiB0070 I2C read failed
> Jun  1 01:18:28 vdr kernel: DiB0070 I2C write failed
> Jun  1 01:18:28 vdr kernel: DiB0070 I2C write failed
> Jun  1 01:18:28 vdr kernel: DiB0070 I2C write failed
> [...]
>
> This logs aren't very helpful, but I find something interesting with 
> Wireshark and usbmon:
> device -> host
> URB type: URB_COMPLETE ('C')
> URB transfer type: URB_BULK (3)
> Endpoint: 0x83
> Device: 13
> Data: present (0)
> URB status: Value too large for defined data type (-EOVERFLOW) (-75)
> URB length [bytes]: 39424
> Data length [bytes]: 39424
>
> after this URB I get a "URB transfer type: URB_INTERRUPT (1)" and all 
> goes to hell.
>
> Its also  interesting that the URB+data length in the failure package 
> is 39424 but "URB length [bytes]: 39480" in every package before that.
>
> As I know this device works without problems under linux for other 
> people, so I'm wondering why. I searched but found nothing about such 
> a problem.
>
> The wireshark capturefile is downloadable here: 
> http://rapidshare.com/files/239429647/terratec-xs-usb-overflow.html
>
>
> Thanks for hints,
> Marco Borm
>

