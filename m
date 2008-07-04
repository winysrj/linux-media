Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail4.riotinto.com ([210.8.150.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Tom.George@riotinto.com>) id 1KEcjZ-0001pF-0p
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 06:17:23 +0200
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Fri, 4 Jul 2008 12:16:39 +0800
Message-ID: <C74607610AB6D64794BA3820A9567DA705A6C8AA@sbscpex06.corp.riotinto.org>
In-Reply-To: <486D9AE8.1030205@internode.on.net>
References: <C74607610AB6D64794BA3820A9567DA705A6C81A@sbscpex06.corp.riotinto.org>
	<486D9AE8.1030205@internode.on.net>
From: "George, Tom \(RTIO\)" <Tom.George@riotinto.com>
To: "Ian W Roberts" <ianwroberts@internode.on.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvb_usb_dib0700 tuning problems?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Thanks Ian,

Always good to have an upbeat reply!

The bit that concerns me is this (from scan):

tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 
> 22 Invalid argument

Cheers,

Tom


-----Original Message-----
From: Ian W Roberts [mailto:ianwroberts@internode.on.net] 
Sent: Friday, 4 July 2008 11:37 AM
To: George, Tom (RTIO)
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvb_usb_dib0700 tuning problems?

Dear George,

Do not despair (yet)! :-)

I had similar problems with a Gigabyte U7000 -being able to tune all 
channals except Channel Seven (here in Adelaide).

Now, it's not that there's much on 7 that interests me but
nevertheless...

I needed to change the initial tuning details for Adelaide 
(au-Adelaide). In my case just the Channel 7 details were incorrect.

Perhaps you need to find up-to-date information for au-Perth station 
tuning information and update 
/usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth -Try google

Just maybe you'll need to re-compile drivers (although maybe not given 
it's working for one channel). I had to on gutsy and heron. These 
instructions (http://waterwave.ch/weblog/detail.php?id=324130) worked 
fine for me.

good luck

bye

ian

George, Tom (RTIO) wrote:
>
> Hi,
>
> Hoping someone can shed some light on this!
>
> I have an Asus U3000 mini usb dvb-t tuner and I'm struggling to get it

> working properly. I have tested the card in windows xp with the same 
> antenna and it works flawlessly, receiving all channels.
>
> I am using ubuntu hardy heron with the 2.6.24-19-generic kernel which 
> (should) work out of the box. Device is recognised and the correct 
> dvb_usb_dib0700 module is loaded, with the correct devices created etc

> etc. Correct firmware is in /lib/firmware/2.6.24-19-generic.
>
> Scanning using kaffeine gets me some channels (I'm based in Perth, 
> Western Australia) - I get SBS & SBS HD but no other channels.
>
> It appears to me that there is an issue with the tuner changing 
> frequency (check the output of scan...), I'm new to dvb and a little 
> stuck, any help would be massively appreciated!!!
>
> Here's some technical output:
>
> root@jaws:/home/tom# cat /var/log/dmesg | grep dvb
> [ 57.721601] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner' 
> in cold state, will try to load a firmware
> [ 57.773379] dvb-usb: downloading firmware from file 
> 'dvb-usb-dib0700-1.10.fw'
> [ 58.465269] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner' 
> in warm state.
> [ 58.465328] dvb-usb: will pass the complete MPEG2 transport stream to

> the software demuxer.
> [ 58.871555] dvb-usb: ASUS My Cinema U3000 Mini DVBT Tuner 
> successfully initialized and connected.
> [ 58.871833] usbcore: registered new interface driver dvb_usb_dib0700
>
> root@jaws:/home/tom# lsmod | grep dvb
> dvb_usb_dib0700 26376 0
> dib7000p 17672 2 dvb_usb_dib0700
> dib7000m 16516 1 dvb_usb_dib0700
> dvb_usb 19852 1 dvb_usb_dib0700
> dvb_core 81404 1 dvb_usb
> dib3000mc 13960 1 dvb_usb_dib0700
> dib0070 9092 1 dvb_usb_dib0700
> i2c_core 24832 8 mt2266,dib7000p,dib7000m,dvb_usb,nvidia,dib3000mc, 
> dibx000_common,dib0070
> usbcore 146028 9 dvb_usb_dib0700,dvb_usb,hci_usb,usb_storage,usbhid 
> ,libusual,ohci_hcd,ehci_hcd
>
>
> root@jaws:/home/tom# ls -la /dev/dvb/adapter1
> total 0
> drwxr-xr-x 2 root root 120 2008-07-04 08:01 .
> drwxr-xr-x 3 root root 60 2008-07-04 08:01 ..
> crw-rw----+ 1 root video 212, 68 2008-07-04 08:01 demux0
> crw-rw----+ 1 root video 212, 69 2008-07-04 08:01 dvr0
> crw-rw----+ 1 root video 212, 67 2008-07-04 08:01 frontend0
> crw-rw----+ 1 root video 212, 71 2008-07-04 08:01 net0
>
> root@jaws:/home/tom# scan -a 1 
> /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth
> scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth
> using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
> initial transponder 226500000 1 3 9 3 1 1 0
> initial transponder 177500000 1 2 9 3 1 1 0
> initial transponder 191625000 1 3 9 3 1 1 0
> initial transponder 219500000 1 3 9 3 1 1 0
> initial transponder 536500000 1 2 9 3 1 2 0
> >>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F 
> EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL
_1_16:HIERARCHY_NONE
> __tune_to_transponder:1483: ERROR: Setting frontend parameters failed:

> 22 Invalid argument
> >>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F 
> EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL
_1_16:HIERARCHY_NONE
> __tune_to_transponder:1483: ERROR: Setting frontend parameters failed:

> 22 Invalid argument
> >>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F 
> EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL
_1_16:HIERARCHY_NONE
> __tune_to_transponder:1483: ERROR: Setting frontend parameters failed:

> 22 Invalid argument
> >>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F 
> EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL
_1_16:HIERARCHY_NONE
> __tune_to_transponder:1483: ERROR: Setting frontend parameters failed:

> 22 Invalid argument
> >>> tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F 
> EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL
_1_16:HIERARCHY_NONE
> __tune_to_transponder:1483: ERROR: Setting frontend parameters failed:

> 22 Invalid argument
> >>> tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F 
> EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL
_1_16:HIERARCHY_NONE
> __tune_to_transponder:1483: ERROR: Setting frontend parameters failed:

> 22 Invalid argument
> >>> tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F 
> EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL
_1_16:HIERARCHY_NONE
> __tune_to_transponder:1483: ERROR: Setting frontend parameters failed:

> 22 Invalid argument
> >>> tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:F 
> EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL
_1_16:HIERARCHY_NONE
> __tune_to_transponder:1483: ERROR: Setting frontend parameters failed:

> 22 Invalid argument
> >>> tune to: 536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F 
> EC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL _1_8:HIERARCHY_NONE
> 0x0000 0x0320: pmt_pid 0x0400 SBS -- SBS HD (running)
> 0x0000 0x0321: pmt_pid 0x0401 SBS -- SBS (running)
> 0x0000 0x0322: pmt_pid 0x0402 SBS -- SBS NEWS (running)
> 0x0000 0x0323: pmt_pid 0x0408 SBS -- SBS 2 (running)
> 0x0000 0x032e: pmt_pid 0x0403 SBS -- SBS RADIO 1 (running)
> 0x0000 0x032f: pmt_pid 0x0404 SBS -- SBS RADIO 2 (running)
> Network Name 'SBS NETWORK'
> >>> tune to: 571500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F 
> EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 571500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F 
> EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE 
> (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F 
> EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
> 0x0320 0x0320: pmt_pid 0x0400 SBS -- SBS HD (running)
> 0x0320 0x0321: pmt_pid 0x0401 SBS -- SBS (running)
> 0x0320 0x0322: pmt_pid 0x0402 SBS -- SBS NEWS (running)
> 0x0320 0x0323: pmt_pid 0x0408 SBS -- SBS 2 (running)
> 0x0320 0x032e: pmt_pid 0x0403 SBS -- SBS RADIO 1 (running)
> 0x0320 0x032f: pmt_pid 0x0404 SBS -- SBS RADIO 2 (running)
> Network Name 'SBS NETWORK'
> >>> tune to: 585625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F 
> EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 585625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F 
> EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE 
> (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 564500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F 
> EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 564500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F 
> EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE 
> (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 543500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F 
> EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 543500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:F 
> EC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_ 1_8:HIERARCHY_NONE 
> (tuning failed)
> WARNING: >>> tuning failed!!!
> dumping lists (12 services)
> SBS HD:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_ 
> 3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERV 
> AL_1_8:HIERARCHY_NONE:102:103:800
> SBS:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2 
> _3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTER 
> VAL_1_8:HIERARCHY_NONE:161:81:801
> SBS NEWS:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_ 
> 2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTE 
> RVAL_1_8:HIERARCHY_NONE:162:83:802
> SBS 2:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
> :FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA 
> L_1_8:HIERARCHY_NONE:161:81:803
> SBS RADIO 1:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
> :FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA 
> L_1_8:HIERARCHY_NONE:0:201:814
> SBS RADIO 2:536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
> :FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA 
> L_1_8:HIERARCHY_NONE:0:202:815
> SBS HD:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_ 
> 3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERV 
> AL_1_8:HIERARCHY_NONE:102:103:800
> SBS:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2 
> _3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTER 
> VAL_1_8:HIERARCHY_NONE:161:81:801
> SBS NEWS:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_ 
> 2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTE 
> RVAL_1_8:HIERARCHY_NONE:162:83:802
> SBS 2:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
> :FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA 
> L_1_8:HIERARCHY_NONE:161:81:803
> SBS RADIO 1:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
> :FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA 
> L_1_8:HIERARCHY_NONE:0:201:814
> SBS RADIO 2:536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
> :FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVA 
> L_1_8:HIERARCHY_NONE:0:202:815
> Done.
>
> Anyone got an idea what is going on here???????
>
> CHeers,
>
> Tom
>
> Tom George
>
> RTIO WA Demand Coordinator - Office of the CIO
>
> Rio Tinto
>
> Central Park, 152 - 158 St Georges Terrace, Perth, 6000, Western
Australia
>
> T: +61 (9) 8 94247251 M: +61 (0) 417940173 F: +61 (0) 8 9327 2456
>
> Tom.george@riotinto.com http://www.riotinto.com
>
> This email (including all attachments) is the sole property of Rio 
> Tinto Limited and may be confidential. If you are not the intended 
> recipient, you must not use or forward the information contained in 
> it. This message may not be reproduced or otherwise republished 
> without the written consent of the sender. If you have received this 
> message in error, please delete the e-mail and notify the sender.
>
------------------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
Ian W Roberts
157 Sixth Avenue
ROYSTON PARK 5070

t:    +61 8 8362 1318
m:    0423 147 044
e:    ianwroberts@internode.on.net

This email message is intended only for the addressee(s) and contains
information that may be confidential and/or copyright. If you are not
the intended recipient please notify the sender by reply email and
immediately delete this email. Use, disclosure or reproduction of this
email by anyone other than the intended recipient(s) is strictly
prohibited. No representation is made that this email or any attachments
are free of viruses. Virus scanning is recommended and is the
responsibility of the recipient. 
 
This email (including all attachments) is the sole property of Rio Tinto Limited and may be confidential.  If you are not the intended recipient, you must not use or forward the information contained in it.  This message may not be reproduced or otherwise republished without the written consent of the sender.  If you have received this message in error, please delete the e-mail and notify the sender.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
