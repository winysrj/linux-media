Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm20.bullet.mail.sp2.yahoo.com ([98.139.91.90]:44104 "HELO
	nm20.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755761Ab1K0QhG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 11:37:06 -0500
Message-ID: <4ED26719.7000406@yahoo.com>
Date: Sun, 27 Nov 2011 17:36:41 +0100
From: Norret Thierry <tnorret@yahoo.com>
MIME-Version: 1.0
To: Esteban Tarroni <esuutar@gmail.com>
CC: Linux Media <linux-media@vger.kernel.org>
Subject: Re: Hauppauge HVR900H don't work with kernel 3.*
References: <1320872939.57808.YahooMailNeo@web132418.mail.ird.yahoo.com> <loom.20111117T192634-277@post.gmane.org>
In-Reply-To: <loom.20111117T192634-277@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Try with 2.6.39 and it work but I've some freezes.
I've try copying tm6000 directory from 2.6.39 to 3.0 and it as work
sometimes.
This is not an issue because this produce kernels panics.

So for me there are 2 problems:
- 2.6.38 dvb-t work good
- 2.6.39, dvb-t work but sometime freeze the computer
- 3.* dvb-t don't work

I'm trying to apply all the patchs from a 2.6.38 to obtain the same
files as a 3.0 to find what patch causes the problem
but I've a lot of errors.

Thanks

On 17 November 2011 19:35, Esteban Tarroni a écrit :

> Norret Thierry <tnorret <at yahoo.com writes:
>
>  
>  Hello,
>  I have this card http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-900H
> and use gentoo id 2040:6600
>  Since I upgrade my kernel from 2.6.38 to 3.* scan for channel doesn't work and
> channels can't be lock
>  
>  The modules (tm6000) are load, the firmware (xc3028L-v36.fw) is copied to
> /lib/firmware, the signal is
>  good but no channels found with w_scan/vlc/mplayer/kaffeineI don't see any
> error in dmesg.
>  
>  I've try last distros (ubuntu 11.10, fedora 16) with kernel 3.* and same results.
>  The last git sources from v4l/dvb don't resolve the problem.
>  
>  Thanks
>  
>  # dmesg
>  [   81.132653] IR NEC protocol handler initialized
>  [   81.158229] tm6000: module is from the staging directory, the quality is
>  unknown, you have been warned.
>  [   81.158801] tm6000 v4l2 driver version 0.0.2 loaded
>  [   81.160885] tm6000: alt 0, interface 0, class 255
>  [   81.160890] tm6000: alt 0, interface 0, class 255
>  [   81.160895] tm6000: Bulk IN endpoint: 0x82 (max size=512 bytes)
>  [   81.160899] tm6000: alt 0, interface 0, class 255
>  [   81.160903] tm6000: alt 1, interface 0, class 255
>  [   81.160907] tm6000: ISOC IN endpoint: 0x81 (max size=3072 bytes)
>  [   81.160911] tm6000: alt 1, interface 0, class 255
>  [   81.160914] tm6000: alt 1, interface 0, class 255
>  [   81.160918] tm6000: INT IN endpoint: 0x83 (max size=4 bytes)
>  [   81.160922] tm6000: alt 2, interface 0, class 255
>  [   81.160925] tm6000: alt 2, interface 0, class 255
>  [   81.160929] tm6000: alt 2, interface 0, class 255
>  [   81.160932] tm6000: alt 3, interface 0, class 255
>  [   81.160936] tm6000: alt 3, interface 0, class 255
>  [   81.160939] tm6000: alt 3, interface 0, class 255
>  [   81.160943] tm6000: New video device @ 480 Mbps (2040:6600, ifnum 0)
>  [   81.160947] tm6000: Found Hauppauge WinTV HVR-900H / WinTV USB2-Stick
>  [   81.167856] Found tm6010
>  [   81.176973] IR RC5(x) protocol handler initialized
>  [   81.183409] IR RC6 protocol handler initialized
>  [   81.185159] IR JVC protocol handler initialized
>  [   81.187524] IR Sony protocol handler initialized
>  [   81.201304] lirc_dev: IR Remote Control driver registered, major 250 
>  [   81.206121] IR LIRC bridge handler initialized
>  [   81.964984] tm6000 #0: i2c eeprom 00: 01 59 54 45 12 01 00 02 00 00 00 40 40
>  20 00 66  .YTE.......@@ .f
>  [   82.076933] tm6000 #0: i2c eeprom 10: 69 00 10 20 40 01 02 03 48 00 79 00 62
>  00 72 00  i.. @...H.y.b.r.
>  [   82.188834] tm6000 #0: i2c eeprom 20: ff 00 64 ff ff ff ff ff ff ff ff ff ff
>  ff ff ff  ..d.............
>  [   82.300725] tm6000 #0: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ff ff ff  ................
>  [   82.412622] tm6000 #0: i2c eeprom 40: 10 03 48 00 56 00 52 00 39 00 30 00 30
>  00 48 00  ..H.V.R.9.0.0.H.
>  [   82.524561] tm6000 #0: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ff ff ff  ................
>  [   82.636402] tm6000 #0: i2c eeprom 60: 30 ff ff ff 0f ff ff ff ff ff 0a 03 32
>  00 2e 00  0...........2...
>  [   82.748303] tm6000 #0: i2c eeprom 70: 3f 00 ff ff ff ff ff ff ff ff ff ff ff
>  ff ff ff  ?...............
>  [   82.860197] tm6000 #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ff ff ff  ................
>  [   82.972092] tm6000 #0: i2c eeprom 90: 32 ff ff ff 16 03 34 00 30 00 33 00 32
>  00 31 00  2.....4.0.3.2.1.
>  [   83.083977] tm6000 #0: i2c eeprom a0: 33 00 34 00 39 00 30 00 32 00 00 00 00
>  00 ff ff  3.4.9.0.2.......
>  [   83.195871] tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ff ff ff  ................
>  [   83.307773] tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ff ff ff  ................
>  [   83.419666] tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ff ff ff  ................
>  [   83.531535] tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ff ff ff  ................
>  [   83.643448] tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ff ff ff  ................
>  [   83.801012] i2c-core: driver [tuner] using legacy suspend method
>  [   83.801017] i2c-core: driver [tuner] using legacy resume method
>  [   83.801303] tuner 1-0061: Tuner -1 found with type(s) Radio TV.
>  [   83.801309] xc2028 1-0061: creating new instance
>  [   83.801311] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
>  [   83.801313] Setting firmware parameters for xc2028
>  [   83.804849] xc2028 1-0061: Loading 81 firmware images from xc3028L-v36.fw,
>  type: xc2028 firmware, ver 3.6
>  [   84.021087] xc2028 1-0061: Loading firmware for type=BASE (1), id
>  0000000000000000.
>  [  109.684698] xc2028 1-0061: Loading firmware for type=(0), id
>  000000000000b700.
>  [  110.118322] SCODE (20000000), id 000000000000b700:
>  [  110.118331] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
>  (60008000), id 0000000000008000.
>  [  110.733824] tm6000 #0: registered device video1
>  [  110.733831] Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status:
>  0)
>  [  110.733865] usbcore: registered new interface driver tm6000
>  [  110.735587] tm6000: open called (dev=video1)
>  [  110.812501] tm6000_dvb: module is from the staging directory, the quality is
>  unknown, you have been warned.
>  [  110.876588] DVB: registering new adapter (Trident TVMaster 6000 DVB-T)
>  [  110.876597] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
>  [  110.876695] xc2028 1-0061: attaching existing instance
>  [  110.876701] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
>  [  110.876705] tm6000: XC2028/3028 asked to be attached to frontend!
>  [  110.876846] tm6000 #0: Initialized (TM6000 dvb Extension) extension 
> # vlc log when trying to open
>  channel.conf in kernel 3.0.6
>  [0xb64eb0] dvb access warning: no lock, tuning again
>  [0xb64eb0] dvb access debug: using inversion=2
>  [0xb64eb0] dvb access debug: using bandwidth=8
>  [0xb64eb0] dvb access debug: using fec=9
>  [0xb64eb0] dvb access debug: using fec=9
>  [0xb64eb0] dvb access debug: using transmission=0
>  [0xb64eb0] dvb access debug: using guard=0
>  [0xb64eb0] dvb access debug: using hierarchy=0
>  [0xb64eb0] dvb access debug: frontend has acquired carrier
>  [0xb64eb0] dvb access debug: frontend has acquired stable FEC
>  [0xb64eb0] dvb access debug: frontend has acquired sync
>  [0xb64eb0] dvb access debug: frontend has acquired lock
>  [0xb64eb0] dvb access debug: - Bit error rate: 0
>  [0xb64eb0] dvb access debug: - Signal strength: 40044
>  [0xb64eb0] dvb access debug: - SNR: 58596 
> # mplayer log when trying to open dvb in kernel 3.0.6
>  MPlayer SVN-r33094-4.5.3 (C) 2000-2011 MPlayer Team
>  Lecture de dvb://
>  dvb_tune Freq: 554000000
>  dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 bytes
>  dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 bytes
>  dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048 bytes
>  dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 2048 bytes
>  dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 2048 bytes
>  dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 2048 bytes
>  dvb_streaming_read, return 0 bytes
>  dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 bytes
>  dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 bytes
>  dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048 bytes
>  dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 2048 bytes
>  dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 2048 bytes
>  dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 2048 bytes
>  dvb_streaming_read, return 0 bytes
>  
>  # w_scan
>  # w_scan kernel 3.0.6
>  w_scan version 20110702 (compiled for DVB API 5.2)
>  using settings for FRANCE
>  DVB aerial
>  DVB-T FR
>  frontend_type DVB-T, channellist 5
>  output format czap/tzap/szap/xine
>  output charset 'UTF-8', use -C <charset to override
>  Info: using DVB adapter auto detection.
>      /dev/dvb/adapter0/frontend0 - DVB-T "Zarlink ZL10353 DVB-T": good 
>  Using DVB-T frontend (adapter /dev/dvb/adapter0/frontend0)
>  -_-_-_-_ Getting frontend capabilities-_-_-_-_ 
>  Using DVB API 5.3
>  frontend 'Zarlink ZL10353 DVB-T' supports
>  INVERSION_AUTO
>  QAM_AUTO
>  TRANSMISSION_MODE_AUTO
>  GUARD_INTERVAL_AUTO
>  HIERARCHY_AUTO
>  FEC_AUTO
>  FREQ (174.00MHz ... 862.00MHz)
>  -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_ 
>  Scanning 7MHz frequencies...
>  177500: (time: 00:00) 
>  184500: (time: 00:29)
>  .
>  .
>  857833: (time: 09:39) 
>  tune to: QAM_AUTO f = 474000 kHz I999B8C999D999T999G999Y999 
>  (time: 09:42) Info: PAT filter timeout
>  Info: SDT(actual) filter timeout
>  Info: NIT(actual) filter timeout
>  tune to: QAM_AUTO f = 554000 kHz I999B8C999D999T999G999Y999 
>  (time: 09:57) Info: PAT filter timeout
>  Info: SDT(actual) filter timeout
>  Info: NIT(actual) filter timeout
>  tune to: QAM_AUTO f = 578000 kHz I999B8C999D999T999G999Y999 
>  (time: 10:11) Info: PAT filter timeout
>  Info: SDT(actual) filter timeout
>  Info: NIT(actual) filter timeout
>  tune to: QAM_AUTO f = 602000 kHz I999B8C999D999T999G999Y999 
>  (time: 10:26) Info: PAT filter timeout
>  Info: SDT(actual) filter timeout
>  Info: NIT(actual) filter timeout
>  tune to: QAM_AUTO f = 658000 kHz I999B8C999D999T999G999Y999 
>  (time: 10:41) Info: PAT filter timeout
>  Info: SDT(actual) filter timeout
>  Info: NIT(actual) filter timeout
>  tune to: QAM_AUTO f = 714000 kHz I999B8C999D999T999G999Y999 
>  (time: 10:55) Info: PAT filter timeout
>  Info: SDT(actual) filter timeout
>  Info: NIT(actual) filter timeout
>  dumping lists (0 services)
>  Done.
>  
Hello, any news?
