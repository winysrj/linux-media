Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-blr1.sasken.com ([203.200.200.72]:2964 "EHLO
	mta-blr1.sasken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3GXI7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 04:59:47 -0400
From: Krishna Kishore <krishna.kishore@sasken.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: Prof DVB-S2 USB device
Date: Wed, 24 Jul 2013 08:59:38 +0000
Message-ID: <7CC27E99F1636344B0AC7B73D5BB86DE1485F535@exgmbxfz01.sasken.com>
References: <bd6fa917-9510-49e2-b4ff-b280fedb320a@exgedgfz01.sasken.com>,<51EEEFCA.9040107@schinagl.nl>
 <7CC27E99F1636344B0AC7B73D5BB86DE1485F3C0@exgmbxfz01.sasken.com>
 <51EF853E.2040108@schinagl.nl>
In-Reply-To: <51EF853E.2040108@schinagl.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Oliver,

       Thanks for your response. I tried with 3.10.1. As you rightly pointed out, it does not seem to work on my board (pandaboard). It gets stuck at "Starting kernel...".

        Now, I am trying with 3.4.47 version now. Let me see if it works. The delay of creating /dev/dvb/adapter0/frontend0 and /dev/dvb/adapter0/demux0 seems to exists. I am waiting for it to get created.

      I am downloading 3.4.54 and 3.10.2 now.

Regards,
Kishore.

-----Original Message-----
From: Oliver Schinagl [mailto:oliver+list@schinagl.nl] 
Sent: Wednesday, July 24, 2013 1:12 PM
To: Krishna Kishore
Cc: linux-media@vger.kernel.org
Subject: Re: Prof DVB-S2 USB device

On 24-07-13 08:56, Krishna Kishore wrote:
> Dear Oliver,
>
>     Thanks for your response. Here are more details. Please help me in making this work.
>
>     Linux version:
>
> -sh-4.1# uname -a
> Linux (none) 3.4.0 #28 SMP PREEMPT Tue Jul 23 16:24:14 IST 2013 armv7l 
> GNU/Linux
Your kernel is ancient. The latest kernel with the latest media fluff is 3.10.2; Since you are on arm, chances are your platform isn't that well supported with later kernels, but even in the 3.4 world your kernel is ancient. Latest stable is 3.4.54.

So you are asking for help, with something that could have been fixed 3 times over (or not, I don't know). So my first suggestion is to upgrade your kernel. If that's not possible on your arm platform, contact the supplier of your kernel.

Meanwhile, since this is an USB device, you could try it on a desktop. 
Get a recent Ubuntu live CD and see if it works there. At least then you can quickly and easily see if your problem hasn't been fixed in the last year.
>
> [dotconfig is attached to this email]
>
> lsusb -t:
> /:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci-omap/3p, 480M
>      |__ Port 1: Dev 2, If 0, Class=, Driver=hub/5p, 480M
>          |__ Port 1: Dev 3, If 0, Class=, Driver=smsc95xx, 480M
>          |__ Port 2: Dev 5, If 0, Class=, Driver=dw2102, 480M
>
> dmesg:
> [  126.824951] usb 1-1.2: new high-speed USB device number 5 using 
> ehci-omap [  126.950347] usb 1-1.2: New USB device found, 
> idVendor=3034, idProduct=7500 [  126.957794] usb 1-1.2: New USB device 
> strings: Mfr=0, Product=0, SerialNumber=0 [  126.983184] dvb-usb: 
> found a 'Prof 7500 USB DVB-S2' in cold state, will try to load a firmware [  127.033477] dvb-usb: downloading firmware from file 'dvb-usb-p7500.fw'
> [  127.051177] dw2102: start downloading DW210X firmware [  
> 127.238739] dvb-usb: found a 'Prof 7500 USB DVB-S2' in warm state.
> [  127.255828] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> [  127.271270] DVB: registering new adapter (Prof 7500 USB DVB-S2) [ 
> 1159.277740] dvb-usb: MAC address: 40:40:40:40:40:40 [ 1159.325531] 
> dw2102: Kishore: prof_7500_frontend_attach [ 1159.325561] [ 
> 1159.340332] Kishore stv0900_attach:
> [ 1159.340362] stv0900_init_internal
> [ 1159.340393] stv0900_init_internal: Create New Internal Structure!
> [ 1159.340423] stv0900_read_reg
> [ 1179.527770] stv0900_read_reg
> [ 1550.418365] stv0900_read_reg
> [ 1637.090240] stv0900_st_dvbs2_single [ 1637.090270] 
> stv0900_stop_all_s2_modcod [ 1669.340270] 
> stv0900_activate_s2_modcod_single [ 1703.605865] stv0900_read_reg [ 
> 1709.652740] stv0900_read_reg [ 1715.699584] stv0900_read_reg [ 
> 1721.746490] stv0900_read_reg [ 1727.793365] stv0900_read_reg [ 
> 1733.840209] stv0900_read_reg [ 1739.887115] stv0900_read_reg [ 
> 1743.918395] stv0900_read_reg [ 1749.965240] stv0900_read_reg [ 
> 1756.012115] stv0900_set_ts_parallel_serial path1 3 path2 0 [ 
> 1758.027740] stv0900_read_reg [ 1764.074615] stv0900_read_reg [ 
> 1770.121490] stv0900_read_reg [ 1776.168334] stv0900_read_reg [ 
> 1782.215209] stv0900_read_reg [ 1788.262115] stv0900_read_reg [ 
> 1810.433990] stv0900_read_reg [ 1816.480865] stv0900_read_reg [ 
> 1824.543365] stv0900_read_reg [ 1830.590240] stv0900_read_reg [ 
> 1838.652740] stv0900_read_reg [ 1844.699615] stv0900_read_reg [ 
> 1850.746490] stv0900_set_mclk: Mclk set to 135000000, Quartz = 
> 27000000 [ 1850.746520] stv0900_read_reg [ 1854.777740] 
> stv0900_read_reg [ 1860.824615] stv0900_read_reg [ 1864.855865] 
> stv0900_read_reg [ 1868.887115] stv0900_get_mclk_freq: Calculated Mclk 
> = 152672117 [ 1876.965209] stv0900_read_reg [ 1883.027709] 
> stv0900_read_reg [ 1887.058990] stv0900_read_reg [ 1891.090240] 
> stv0900_get_mclk_freq: Calculated Mclk = 152672117 [ 1891.090270] 
> Kishore stv0900_attach: Attaching STV0900 demodulator(0) [ 
> 1891.090301] dw2102: Kishore: dvb_attach stb6100_attach [ 1891.090332] 
> [ 1891.097442] Kishore stb6100_attach:
> [ 1891.101409] Kishore stb6100_attach: Attaching STB6100 [ 
> 1893.105957] dw2102: Attached STV0900+STB6100A!
> [ 1893.105957]
> [ 1893.112335] DVB: registering adapter 0 frontend 0 (STV0900 frontend)...
> [ 1893.137878] input: IR-receiver inside an USB DVB receiver as 
> /devices/platform/usbhs_omap/ehci-omap.0/usb1/1-1/1-1.2/input/input2
> [ 1893.177368] dvb-usb: schedule remote query interval to 150 msecs.
> [ 1893.184143] dvb-usb: Prof 7500 USB DVB-S2 successfully initialized and connected.
>
>
>
> Linux (none) 3.4.0 #28 SMP PREEMPT Tue Jul 23 16:24:14 IST 2013 armv7l 
> GNU/Linux -sh-4.1# /stbref/w_scan-20120112/w_scan -fs -s S93E5 -c IN 
> -G >> ch.conf w_scan version 20120112 (compiled for DVB API 5.4) using 
> settings for 93.5 east Insat 3A/4B scan type SATELLITE, channellist 42 
> output format gstreamer
> WARNING: could not guess your codepage. Falling back to 'UTF-8'
> output charset 'UTF-8', use -C <charset> to override
> Info: using DVB adapter auto detection.
>
>          /dev/dvb/adapter0/frontend0 -> SATELLITE "STV0900 frontend": 
> very good :-))
>
> Using SATELLITE frontend (adapter /dev/dvb/adapter0/frontend0) 
> -_-_-_-_ Getting frontend capabilities-_-_-_-_ Using DVB API 5.5 
> frontend 'STV0900 frontend' supports INVERSION_AUTO DVB-S
> DVB-S2
> FREQ (0.95GHz ... 2.15GHz)
> SRATE (1.000MBd ... 45.000MBd)
> using LNB "UNIVERSAL"
> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> (time: 00:40)
>
> dmesg logs:
>
> [1716261.743961] stv0900_init
> [1716287.004365] stv0900_set_tone: Off [1716307.004132] 
> stv0900_read_status:
> [1716321.004217] stv0900_status: locked = 0 [1716337.004246] 
> stv0900_get_mclk_freq: Calculated Mclk = 553008176 [1716337.004251] TS 
> bitrate = 2081 Mbit/sec [1716339.004299] DEMOD LOCK FAIL 
> [1716345.004236] stv0900_search:
> [1716345.004242] stv0900_read_status:
> [1716363.004324] stv0900_status: locked = 1 [1716379.004255] 
> stv0900_get_mclk_freq: Calculated Mclk = 607008176 [1716379.004260] TS 
> bitrate = 2361 Mbit/sec [1716379.004263] DEMOD LOCK OK 
> [1716261.743961] stv0900_init [1716287.004365] stv0900_set_tone: Off 
> [1716307.004132] stv0900_read_status:
> [1716321.004217] stv0900_status: locked = 0 [1716337.004246] 
> stv0900_get_mclk_freq: Calculated Mclk = 553008176 [1716337.004251] TS 
> bitrate = 2081 Mbit/sec [1716339.004299] DEMOD LOCK FAIL 
> [1716345.004236] stv0900_search:
> [1716345.004242] stv0900_read_status:
> [1716363.004324] stv0900_status: locked = 1 [1716379.004255] 
> stv0900_get_mclk_freq: Calculated Mclk = 607008176 [1716379.004260] TS 
> bitrate = 2361 Mbit/sec [1716379.004263] DEMOD LOCK OK 
> [1716455.004184] stv0900_search:
> [1716455.004190] stv0900_read_status:
> [1716461.004239] stv0900_status: locked = 0 [1716477.004310] 
> stv0900_get_mclk_freq: Calculated Mclk = 175008176 [1716477.004315] TS 
> bitrate = 503 Mbit/sec [1716479.004220] DEMOD LOCK FAIL
>
> Regards,
> Kishore.
> ________________________________________
> From: Oliver Schinagl [oliver+list@schinagl.nl]
> Sent: Wednesday, July 24, 2013 2:34 AM
> To: Krishna Kishore
> Cc: linux-media@vger.kernel.org
> Subject: Re: Prof DVB-S2 USB device
>
> On 23-07-13 18:52, Krishna Kishore wrote:
>> #Sorry for sending to individual email ids
>>
>> Hi,
>>
>>        I am trying to use Prof DVB-S2 USB device with Linux host. Device gets detected. But, I am facing the following problems.
> You will need to provide much more information then that. What does 
> dmesg say? lsusb? what driver are you using, what kernel version? Are 
> you using it as a module? Have you enabled debugging in your kernel?
>
> Those questions come to my mind.
>
>>
>> 1.      It takes approximately 21 minutes to get /dev/dvb/adapter0/frontend0 and /dev/dvb/adapter0/demux0 to get created. This happens every time
>> 2.      After /dev/dvb/adapter0/frontend0 gets created, when I use w_scan utility to scan for channels, it does not list the channels.
>> a.      In dmesg logs, I see DEMOD LOCK FAIL error continuously.
> Paste your logs (or if its too much, only copy/paste the relevant parts.
> You ask for a limb, yet offer nothing.
>
> oliver
>>
>>         Can you please help me?
>>
>>
>> Regards,
>> Kishore.
>>
>>
>>
>
>
>
> ________________________________
>
> SASKEN BUSINESS DISCLAIMER: This message may contain confidential, proprietary or legally privileged information. In case you are not the original intended Recipient of the message, you must not, directly or indirectly, use, disclose, distribute, print, or copy any part of this message and you are requested to delete it and inform the sender. Any views expressed in this message are those of the individual sender unless otherwise stated. Nothing contained in this message shall be construed as an offer or acceptance of any offer by Sasken Communication Technologies Limited ("Sasken") unless sent with that express intent and with due authority of Sasken. Sasken has taken enough precautions to prevent the spread of viruses. However the company accepts no liability for any damage caused by any virus transmitted by this email.
> Read Disclaimer at http://www.sasken.com/extras/mail_disclaimer.html
>

