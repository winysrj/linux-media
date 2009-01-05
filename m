Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from core6.multiplay.co.uk ([85.236.96.23] helo=multiplay.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <prvs=1256c74c05=sid@the-gales.com>)
	id 1LJlqV-0004SC-Nf
	for linux-dvb@linuxtv.org; Mon, 05 Jan 2009 10:34:05 +0100
Received: from [192.168.1.10] ([85.236.104.54])
	by mail1.multiplay.co.uk (mail1.multiplay.co.uk [85.236.96.23])
	(Cipher TLSv1:RC4-MD5:128) (MDaemon PRO v9.6.6)
	with ESMTP id md50006785860.msg
	for <linux-dvb@linuxtv.org>; Mon, 05 Jan 2009 09:33:33 +0000
Message-ID: <4961D3E7.3070304@the-gales.com>
Date: Mon, 05 Jan 2009 09:33:27 +0000
From: Sid Gale <sid@the-gales.com>
MIME-Version: 1.0
To: Albert Comerma <albert.comerma@gmail.com>
References: <495FA006.8020609@the-gales.com>
	<ea4209750901040646p492a91a2x9cd070b98e1dca9c@mail.gmail.com>
In-Reply-To: <ea4209750901040646p492a91a2x9cd070b98e1dca9c@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Asus My Cinema U3000 Mini
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

Albert Comerma wrote:
> Hi Sid, everything looks nice on the dmesg. The usb line numbers depend 
> on the hardware order, so it's not a problem, and the line registering 
> the interface must be there (it's when /dev/dvb is added, so if it's not 
> there you can't comunicate with the device). I think the other usb 
> modules should not give you any problem... If you modified in some way 
> the source code it would be nice to post it, just to have a look. You 
> should also try latest firmware (I think there was a 1.2 version which 
> fixed som i2c problems).
> And finally I just prefer to use kaffeine that v4l-apps... but that's 
> just a matter of taste.
> Also try with the small antenna included with the device, I don't manage 
> to get signal from an amplified antenna in linux while the "small and 
> crappy" one works perfectly.
> 
> 2009/1/3 Sid Gale <sid@the-gales.com <mailto:sid@the-gales.com>>
> 
>     I'm using the information in the V4L-DVB wiki to try to get an Asus My
>     Cinema U300 mini usb dvb-t tuner working with eeebuntu (based on Ubuntu
>     Intrepid) on an eeepc 900. I have these lines in kern.log:
> 
>     -----------------------------------------------------
>     Jan  2 13:24:22 sid-eee900 kernel: [   89.624051] usb 1-4: new high
>     speed USB device using ehci_hcd and address 3
>     Jan  2 13:24:22 sid-eee900 kernel: [   89.764082] usb 1-4: configuration
>     #1 chosen from 1 choice
>     Jan  2 13:24:22 sid-eee900 kernel: [   90.033966] dib0700: loaded with
>     support for 7 different device-types
>     Jan  2 13:24:22 sid-eee900 kernel: [   90.035234] dvb-usb: found a 'ASUS
>     My Cinema U3000 Mini DVBT Tuner' in cold state, will try to load a
>     firmware
>     Jan  2 13:24:22 sid-eee900 kernel: [   90.035247] firmware: requesting
>     dvb-usb-dib0700-1.10.fw
>     Jan  2 13:24:22 sid-eee900 kernel: [   90.047706] dvb-usb: downloading
>     firmware from file 'dvb-usb-dib0700-1.10.fw'
>     Jan  2 13:24:22 sid-eee900 kernel: [   90.254492] dib0700: firmware
>     started successfully.
>     Jan  2 13:24:23 sid-eee900 kernel: [   90.756174] dvb-usb: found a 'ASUS
>     My Cinema U3000 Mini DVBT Tuner' in warm state.
>     Jan  2 13:24:23 sid-eee900 kernel: [   90.756733] dvb-usb: will pass the
>     complete MPEG2 transport stream to the software demuxer.
>     Jan  2 13:24:23 sid-eee900 kernel: [   90.757305] DVB: registering new
>     adapter (ASUS My Cinema U3000 Mini DVBT Tuner)
>     Jan  2 13:24:23 sid-eee900 kernel: [   91.080958] DVB: registering
>     frontend 0 (DiBcom 7000PC)...
>     Jan  2 13:24:23 sid-eee900 kernel: [   91.190399] MT2266: successfully
>     identified
>     Jan  2 13:24:23 sid-eee900 kernel: [   91.350822] dvb-usb: ASUS My
>     Cinema U3000 Mini DVBT Tuner successfully initialized and connected.
>     Jan  2 13:24:23 sid-eee900 kernel: [   91.353100] usbcore: registered
>     new interface driver dvb_usb_dib0700
>     ---------------------------------------------
> 
>     These match the information given in the wiki for 'Successful
>     initialization' except for the usb 'number' and address (1-4 and 3 for
>     me, 5-7 and 8 in the wiki) and the very last line 'usbcore: registered
>     new interface driver dvb_usb_dib0700'. This last line does not appear in
>     the wiki entry for 'Successful initialization' but does appear in the
>     two of the 'failure' entries.
> 
>     When I try to scan for channels, using the dvb_apps package as described
>     in the wiki, I get this:
> 
>     ------------------------------------
>     scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/uk-Oxford
>     using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>     initial transponder 578000000 0 2 9 3 0 0 0
>      >>> tune to:
>     578000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>     WARNING: filter timeout pid 0x0011
>     WARNING: filter timeout pid 0x0000
>     WARNING: filter timeout pid 0x0010
>     dumping lists (0 services)
>     Done.
>     --------------------------------------
> 
>     The tuner is connected to a roof-mounted aerial and when plugged in to a
>     Windows system pulls in 35 channels.
> 
>     I'm very new to Linux and have no idea how to proceed, so I was hoping
>     that someone here could give me some pointers. I have noticed that in
>     the dmesg file there are lines saying:
> 
>     -----------------------
>     Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd,
>     not after
>     ------------------------
> 
>     All the lines referring to ehci_hcd do, in fact, come after the ohci_hcd
>     lines so it would appear that I have the order wrong. Would this make a
>     difference and, if so, how do I correct it?
> 
>     I'd be very grateful for any help anyone can offer.
> 

Hi Albert

Thanks for your reply. I've tried the new firmware and with the supplied 
aerial, but with no different results. I haven't changed any source code 
- at present I wouldn't know how, I'm still learning. I understand, 
though, that the eeebuntu kernel is a modified one called the array 
kernel, if that makes any difference. I tried Kaffine and Me TV first 
and found that neither could detect any channels, which is why I decided 
to try the dvb utilities from the wiki. Thanks for the suggestions, though.

Can anyone give me some advice on how to find out why I get the 'filter 
timeout'? Is it because there is no filter to be found, or because there 
is no signal from the tuner, or because no channels are found within a 
given time...? If it's the last of these then it isn't trying for long 
enough, as it takes a minute of so for the first channel to be found on 
a Windows system and the filter timeout occurs after a few seconds.

Regards

Sid


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
