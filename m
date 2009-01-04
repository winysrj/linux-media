Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.250])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1LJUFV-0005bt-It
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 15:46:42 +0100
Received: by an-out-0708.google.com with SMTP id b38so1925488ana.41
	for <linux-dvb@linuxtv.org>; Sun, 04 Jan 2009 06:46:37 -0800 (PST)
Message-ID: <ea4209750901040646p492a91a2x9cd070b98e1dca9c@mail.gmail.com>
Date: Sun, 4 Jan 2009 15:46:36 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Sid Gale" <sid@the-gales.com>
In-Reply-To: <495FA006.8020609@the-gales.com>
MIME-Version: 1.0
References: <495FA006.8020609@the-gales.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Asus My Cinema U3000 Mini
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0317562878=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0317562878==
Content-Type: multipart/alternative;
	boundary="----=_Part_111850_20257360.1231080396986"

------=_Part_111850_20257360.1231080396986
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Sid, everything looks nice on the dmesg. The usb line numbers depend on
the hardware order, so it's not a problem, and the line registering the
interface must be there (it's when /dev/dvb is added, so if it's not there
you can't comunicate with the device). I think the other usb modules should
not give you any problem... If you modified in some way the source code it
would be nice to post it, just to have a look. You should also try latest
firmware (I think there was a 1.2 version which fixed som i2c problems).
And finally I just prefer to use kaffeine that v4l-apps... but that's just a
matter of taste.
Also try with the small antenna included with the device, I don't manage to
get signal from an amplified antenna in linux while the "small and crappy"
one works perfectly.

2009/1/3 Sid Gale <sid@the-gales.com>

> I'm using the information in the V4L-DVB wiki to try to get an Asus My
> Cinema U300 mini usb dvb-t tuner working with eeebuntu (based on Ubuntu
> Intrepid) on an eeepc 900. I have these lines in kern.log:
>
> -----------------------------------------------------
> Jan  2 13:24:22 sid-eee900 kernel: [   89.624051] usb 1-4: new high
> speed USB device using ehci_hcd and address 3
> Jan  2 13:24:22 sid-eee900 kernel: [   89.764082] usb 1-4: configuration
> #1 chosen from 1 choice
> Jan  2 13:24:22 sid-eee900 kernel: [   90.033966] dib0700: loaded with
> support for 7 different device-types
> Jan  2 13:24:22 sid-eee900 kernel: [   90.035234] dvb-usb: found a 'ASUS
> My Cinema U3000 Mini DVBT Tuner' in cold state, will try to load a firmware
> Jan  2 13:24:22 sid-eee900 kernel: [   90.035247] firmware: requesting
> dvb-usb-dib0700-1.10.fw
> Jan  2 13:24:22 sid-eee900 kernel: [   90.047706] dvb-usb: downloading
> firmware from file 'dvb-usb-dib0700-1.10.fw'
> Jan  2 13:24:22 sid-eee900 kernel: [   90.254492] dib0700: firmware
> started successfully.
> Jan  2 13:24:23 sid-eee900 kernel: [   90.756174] dvb-usb: found a 'ASUS
> My Cinema U3000 Mini DVBT Tuner' in warm state.
> Jan  2 13:24:23 sid-eee900 kernel: [   90.756733] dvb-usb: will pass the
> complete MPEG2 transport stream to the software demuxer.
> Jan  2 13:24:23 sid-eee900 kernel: [   90.757305] DVB: registering new
> adapter (ASUS My Cinema U3000 Mini DVBT Tuner)
> Jan  2 13:24:23 sid-eee900 kernel: [   91.080958] DVB: registering
> frontend 0 (DiBcom 7000PC)...
> Jan  2 13:24:23 sid-eee900 kernel: [   91.190399] MT2266: successfully
> identified
> Jan  2 13:24:23 sid-eee900 kernel: [   91.350822] dvb-usb: ASUS My
> Cinema U3000 Mini DVBT Tuner successfully initialized and connected.
> Jan  2 13:24:23 sid-eee900 kernel: [   91.353100] usbcore: registered
> new interface driver dvb_usb_dib0700
> ---------------------------------------------
>
> These match the information given in the wiki for 'Successful
> initialization' except for the usb 'number' and address (1-4 and 3 for
> me, 5-7 and 8 in the wiki) and the very last line 'usbcore: registered
> new interface driver dvb_usb_dib0700'. This last line does not appear in
> the wiki entry for 'Successful initialization' but does appear in the
> two of the 'failure' entries.
>
> When I try to scan for channels, using the dvb_apps package as described
> in the wiki, I get this:
>
> ------------------------------------
> scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/uk-Oxford
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 578000000 0 2 9 3 0 0 0
>  >>> tune to:
>
> 578000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: filter timeout pid 0x0011
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x0010
> dumping lists (0 services)
> Done.
> --------------------------------------
>
> The tuner is connected to a roof-mounted aerial and when plugged in to a
> Windows system pulls in 35 channels.
>
> I'm very new to Linux and have no idea how to proceed, so I was hoping
> that someone here could give me some pointers. I have noticed that in
> the dmesg file there are lines saying:
>
> -----------------------
> Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd,
> not after
> ------------------------
>
> All the lines referring to ehci_hcd do, in fact, come after the ohci_hcd
> lines so it would appear that I have the order wrong. Would this make a
> difference and, if so, how do I correct it?
>
> I'd be very grateful for any help anyone can offer.
>
> Regards
>
> Sid Gale
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_111850_20257360.1231080396986
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Sid, everything looks nice on the dmesg. The usb line numbers depend on the hardware order, so it&#39;s not a problem, and the line registering the interface must be there (it&#39;s when /dev/dvb is added, so if it&#39;s not there you can&#39;t comunicate with the device). I think the other usb modules should not give you any problem... If you modified in some way the source code it would be nice to post it, just to have a look. You should also try latest firmware (I think there was a 1.2 version which fixed som i2c problems). <br>
And finally I just prefer to use kaffeine that v4l-apps... but that&#39;s just a matter of taste.<br>Also try with the small antenna included with the device, I don&#39;t manage to get signal from an amplified antenna in linux while the &quot;small and crappy&quot; one works perfectly.<br>
<br><div class="gmail_quote">2009/1/3 Sid Gale <span dir="ltr">&lt;<a href="mailto:sid@the-gales.com">sid@the-gales.com</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
I&#39;m using the information in the V4L-DVB wiki to try to get an Asus My<br>
Cinema U300 mini usb dvb-t tuner working with eeebuntu (based on Ubuntu<br>
Intrepid) on an eeepc 900. I have these lines in kern.log:<br>
<br>
-----------------------------------------------------<br>
Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 89.624051] usb 1-4: new high<br>
speed USB device using ehci_hcd and address 3<br>
Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 89.764082] usb 1-4: configuration<br>
#1 chosen from 1 choice<br>
Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 90.033966] dib0700: loaded with<br>
support for 7 different device-types<br>
Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 90.035234] dvb-usb: found a &#39;ASUS<br>
My Cinema U3000 Mini DVBT Tuner&#39; in cold state, will try to load a firmware<br>
Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 90.035247] firmware: requesting<br>
dvb-usb-dib0700-1.10.fw<br>
Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 90.047706] dvb-usb: downloading<br>
firmware from file &#39;dvb-usb-dib0700-1.10.fw&#39;<br>
Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 90.254492] dib0700: firmware<br>
started successfully.<br>
Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 90.756174] dvb-usb: found a &#39;ASUS<br>
My Cinema U3000 Mini DVBT Tuner&#39; in warm state.<br>
Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 90.756733] dvb-usb: will pass the<br>
complete MPEG2 transport stream to the software demuxer.<br>
Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 90.757305] DVB: registering new<br>
adapter (ASUS My Cinema U3000 Mini DVBT Tuner)<br>
Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 91.080958] DVB: registering<br>
frontend 0 (DiBcom 7000PC)...<br>
Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 91.190399] MT2266: successfully<br>
identified<br>
Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 91.350822] dvb-usb: ASUS My<br>
Cinema U3000 Mini DVBT Tuner successfully initialized and connected.<br>
Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 91.353100] usbcore: registered<br>
new interface driver dvb_usb_dib0700<br>
---------------------------------------------<br>
<br>
These match the information given in the wiki for &#39;Successful<br>
initialization&#39; except for the usb &#39;number&#39; and address (1-4 and 3 for<br>
me, 5-7 and 8 in the wiki) and the very last line &#39;usbcore: registered<br>
new interface driver dvb_usb_dib0700&#39;. This last line does not appear in<br>
the wiki entry for &#39;Successful initialization&#39; but does appear in the<br>
two of the &#39;failure&#39; entries.<br>
<br>
When I try to scan for channels, using the dvb_apps package as described<br>
in the wiki, I get this:<br>
<br>
------------------------------------<br>
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/uk-Oxford<br>
using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br>
initial transponder 578000000 0 2 9 3 0 0 0<br>
&nbsp;&gt;&gt;&gt; tune to:<br>
578000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE<br>
WARNING: filter timeout pid 0x0011<br>
WARNING: filter timeout pid 0x0000<br>
WARNING: filter timeout pid 0x0010<br>
dumping lists (0 services)<br>
Done.<br>
--------------------------------------<br>
<br>
The tuner is connected to a roof-mounted aerial and when plugged in to a<br>
Windows system pulls in 35 channels.<br>
<br>
I&#39;m very new to Linux and have no idea how to proceed, so I was hoping<br>
that someone here could give me some pointers. I have noticed that in<br>
the dmesg file there are lines saying:<br>
<br>
-----------------------<br>
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd,<br>
not after<br>
------------------------<br>
<br>
All the lines referring to ehci_hcd do, in fact, come after the ohci_hcd<br>
lines so it would appear that I have the order wrong. Would this make a<br>
difference and, if so, how do I correct it?<br>
<br>
I&#39;d be very grateful for any help anyone can offer.<br>
<br>
Regards<br>
<br>
Sid Gale<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br>

------=_Part_111850_20257360.1231080396986--


--===============0317562878==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0317562878==--
