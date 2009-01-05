Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1LJncD-0006Bj-2Y
	for linux-dvb@linuxtv.org; Mon, 05 Jan 2009 12:27:25 +0100
Received: by yw-out-2324.google.com with SMTP id 3so2594203ywj.41
	for <linux-dvb@linuxtv.org>; Mon, 05 Jan 2009 03:27:20 -0800 (PST)
Message-ID: <ea4209750901050327nc21a830j75992a0f1de0fd75@mail.gmail.com>
Date: Mon, 5 Jan 2009 12:27:20 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Sid Gale" <sid@the-gales.com>
In-Reply-To: <4961D3E7.3070304@the-gales.com>
MIME-Version: 1.0
References: <495FA006.8020609@the-gales.com>
	<ea4209750901040646p492a91a2x9cd070b98e1dca9c@mail.gmail.com>
	<4961D3E7.3070304@the-gales.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Asus My Cinema U3000 Mini
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0272968310=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0272968310==
Content-Type: multipart/alternative;
	boundary="----=_Part_117325_13582313.1231154840289"

------=_Part_117325_13582313.1231154840289
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Just more questions... the v4l driver was already supplied on the kernel or
you downloaded it and compile?
It should not take so much time to get a channel... In other drivers there
was some GPIO problems, but I never got anything similar with this card (at
least nobody told me)...
You can try to load the dvb-core module with a specified timeout in
parameter: dvb_override_tune_delay:0: normal (default), >0 => delay in
milliseconds to wait for lock after a tune attempt (int)

Since you're a beginner in linux you should; first connect your card,
then as root unload the modules used by your card (order is important);
 sudo rmmod dvb_usb_dib0700 dib7000p dib7000m dib3000mc dib0070 dvb_usb
dvb_core
If you want you can get a list on the used modules and dependences between
them running; lsmod | grep dvb
Then you need to reload the modules in opposite order adding the parameter;
sudo modprobe dvb_core dvb_override_tune_delay=10000
You should see the new parameter on
/sys/module/dvb_core/parameters/dvb_override_tune_delay
And now you have to finish loadding the other modules one by one; sudo
modprobe dvb_usb... sudo modprobe dib0070...

Albert

2009/1/5 Sid Gale <sid@the-gales.com>

> Albert Comerma wrote:
>
>> Hi Sid, everything looks nice on the dmesg. The usb line numbers depend on
>> the hardware order, so it's not a problem, and the line registering the
>> interface must be there (it's when /dev/dvb is added, so if it's not there
>> you can't comunicate with the device). I think the other usb modules should
>> not give you any problem... If you modified in some way the source code it
>> would be nice to post it, just to have a look. You should also try latest
>> firmware (I think there was a 1.2 version which fixed som i2c problems).
>> And finally I just prefer to use kaffeine that v4l-apps... but that's just
>> a matter of taste.
>> Also try with the small antenna included with the device, I don't manage
>> to get signal from an amplified antenna in linux while the "small and
>> crappy" one works perfectly.
>>
>> 2009/1/3 Sid Gale <sid@the-gales.com <mailto:sid@the-gales.com>>
>>
>>
>>    I'm using the information in the V4L-DVB wiki to try to get an Asus My
>>    Cinema U300 mini usb dvb-t tuner working with eeebuntu (based on Ubuntu
>>    Intrepid) on an eeepc 900. I have these lines in kern.log:
>>
>>    -----------------------------------------------------
>>    Jan  2 13:24:22 sid-eee900 kernel: [   89.624051] usb 1-4: new high
>>    speed USB device using ehci_hcd and address 3
>>    Jan  2 13:24:22 sid-eee900 kernel: [   89.764082] usb 1-4:
>> configuration
>>    #1 chosen from 1 choice
>>    Jan  2 13:24:22 sid-eee900 kernel: [   90.033966] dib0700: loaded with
>>    support for 7 different device-types
>>    Jan  2 13:24:22 sid-eee900 kernel: [   90.035234] dvb-usb: found a
>> 'ASUS
>>    My Cinema U3000 Mini DVBT Tuner' in cold state, will try to load a
>>    firmware
>>    Jan  2 13:24:22 sid-eee900 kernel: [   90.035247] firmware: requesting
>>    dvb-usb-dib0700-1.10.fw
>>    Jan  2 13:24:22 sid-eee900 kernel: [   90.047706] dvb-usb: downloading
>>    firmware from file 'dvb-usb-dib0700-1.10.fw'
>>    Jan  2 13:24:22 sid-eee900 kernel: [   90.254492] dib0700: firmware
>>    started successfully.
>>    Jan  2 13:24:23 sid-eee900 kernel: [   90.756174] dvb-usb: found a
>> 'ASUS
>>    My Cinema U3000 Mini DVBT Tuner' in warm state.
>>    Jan  2 13:24:23 sid-eee900 kernel: [   90.756733] dvb-usb: will pass
>> the
>>    complete MPEG2 transport stream to the software demuxer.
>>    Jan  2 13:24:23 sid-eee900 kernel: [   90.757305] DVB: registering new
>>    adapter (ASUS My Cinema U3000 Mini DVBT Tuner)
>>    Jan  2 13:24:23 sid-eee900 kernel: [   91.080958] DVB: registering
>>    frontend 0 (DiBcom 7000PC)...
>>    Jan  2 13:24:23 sid-eee900 kernel: [   91.190399] MT2266: successfully
>>    identified
>>    Jan  2 13:24:23 sid-eee900 kernel: [   91.350822] dvb-usb: ASUS My
>>    Cinema U3000 Mini DVBT Tuner successfully initialized and connected.
>>    Jan  2 13:24:23 sid-eee900 kernel: [   91.353100] usbcore: registered
>>    new interface driver dvb_usb_dib0700
>>    ---------------------------------------------
>>
>>    These match the information given in the wiki for 'Successful
>>    initialization' except for the usb 'number' and address (1-4 and 3 for
>>    me, 5-7 and 8 in the wiki) and the very last line 'usbcore: registered
>>    new interface driver dvb_usb_dib0700'. This last line does not appear
>> in
>>    the wiki entry for 'Successful initialization' but does appear in the
>>    two of the 'failure' entries.
>>
>>    When I try to scan for channels, using the dvb_apps package as
>> described
>>    in the wiki, I get this:
>>
>>    ------------------------------------
>>    scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/uk-Oxford
>>    using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>    initial transponder 578000000 0 2 9 3 0 0 0
>>     >>> tune to:
>>
>>  578000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>    WARNING: filter timeout pid 0x0011
>>    WARNING: filter timeout pid 0x0000
>>    WARNING: filter timeout pid 0x0010
>>    dumping lists (0 services)
>>    Done.
>>    --------------------------------------
>>
>>    The tuner is connected to a roof-mounted aerial and when plugged in to
>> a
>>    Windows system pulls in 35 channels.
>>
>>    I'm very new to Linux and have no idea how to proceed, so I was hoping
>>    that someone here could give me some pointers. I have noticed that in
>>    the dmesg file there are lines saying:
>>
>>    -----------------------
>>    Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd,
>>    not after
>>    ------------------------
>>
>>    All the lines referring to ehci_hcd do, in fact, come after the
>> ohci_hcd
>>    lines so it would appear that I have the order wrong. Would this make a
>>    difference and, if so, how do I correct it?
>>
>>    I'd be very grateful for any help anyone can offer.
>>
>>
> Hi Albert
>
> Thanks for your reply. I've tried the new firmware and with the supplied
> aerial, but with no different results. I haven't changed any source code -
> at present I wouldn't know how, I'm still learning. I understand, though,
> that the eeebuntu kernel is a modified one called the array kernel, if that
> makes any difference. I tried Kaffine and Me TV first and found that neither
> could detect any channels, which is why I decided to try the dvb utilities
> from the wiki. Thanks for the suggestions, though.
>
> Can anyone give me some advice on how to find out why I get the 'filter
> timeout'? Is it because there is no filter to be found, or because there is
> no signal from the tuner, or because no channels are found within a given
> time...? If it's the last of these then it isn't trying for long enough, as
> it takes a minute of so for the first channel to be found on a Windows
> system and the filter timeout occurs after a few seconds.
>
> Regards
>
> Sid
>
>

------=_Part_117325_13582313.1231154840289
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Just more questions... the v4l driver was already supplied on the kernel or you downloaded it and compile? <br>It should not take so much time to get a channel... In other drivers there was some GPIO problems, but I never got anything similar with this card (at least nobody told me)...<br>
You can try to load the dvb-core module with a specified timeout in parameter: dvb_override_tune_delay:0: normal (default), &gt;0 =&gt; delay in milliseconds to wait for lock after a tune attempt (int)<br><br>Since you&#39;re a beginner in linux you should; first connect your card, <br>
then as root unload the modules used by your card (order is important); <br>&nbsp;sudo rmmod dvb_usb_dib0700 dib7000p dib7000m dib3000mc dib0070 dvb_usb dvb_core<br>If you want you can get a list on the used modules and dependences between them running; lsmod | grep dvb<br>
Then you need to reload the modules in opposite order adding the parameter;<br>sudo modprobe dvb_core dvb_override_tune_delay=10000<br>You should see the new parameter on /sys/module/dvb_core/parameters/dvb_override_tune_delay<br>
And now you have to finish loadding the other modules one by one; sudo modprobe dvb_usb... sudo modprobe dib0070...<br><br>Albert<br><br><div class="gmail_quote">2009/1/5 Sid Gale <span dir="ltr">&lt;<a href="mailto:sid@the-gales.com">sid@the-gales.com</a>&gt;</span><br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Albert Comerma wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class="Ih2E3d">
Hi Sid, everything looks nice on the dmesg. The usb line numbers depend on the hardware order, so it&#39;s not a problem, and the line registering the interface must be there (it&#39;s when /dev/dvb is added, so if it&#39;s not there you can&#39;t comunicate with the device). I think the other usb modules should not give you any problem... If you modified in some way the source code it would be nice to post it, just to have a look. You should also try latest firmware (I think there was a 1.2 version which fixed som i2c problems).<br>

And finally I just prefer to use kaffeine that v4l-apps... but that&#39;s just a matter of taste.<br>
Also try with the small antenna included with the device, I don&#39;t manage to get signal from an amplified antenna in linux while the &quot;small and crappy&quot; one works perfectly.<br>
<br></div>
2009/1/3 Sid Gale &lt;<a href="mailto:sid@the-gales.com" target="_blank">sid@the-gales.com</a> &lt;mailto:<a href="mailto:sid@the-gales.com" target="_blank">sid@the-gales.com</a>&gt;&gt;<div><div></div><div class="Wj3C7c">
<br>
<br>
 &nbsp; &nbsp;I&#39;m using the information in the V4L-DVB wiki to try to get an Asus My<br>
 &nbsp; &nbsp;Cinema U300 mini usb dvb-t tuner working with eeebuntu (based on Ubuntu<br>
 &nbsp; &nbsp;Intrepid) on an eeepc 900. I have these lines in kern.log:<br>
<br>
 &nbsp; &nbsp;-----------------------------------------------------<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 89.624051] usb 1-4: new high<br>
 &nbsp; &nbsp;speed USB device using ehci_hcd and address 3<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 89.764082] usb 1-4: configuration<br>
 &nbsp; &nbsp;#1 chosen from 1 choice<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 90.033966] dib0700: loaded with<br>
 &nbsp; &nbsp;support for 7 different device-types<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 90.035234] dvb-usb: found a &#39;ASUS<br>
 &nbsp; &nbsp;My Cinema U3000 Mini DVBT Tuner&#39; in cold state, will try to load a<br>
 &nbsp; &nbsp;firmware<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 90.035247] firmware: requesting<br>
 &nbsp; &nbsp;dvb-usb-dib0700-1.10.fw<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 90.047706] dvb-usb: downloading<br>
 &nbsp; &nbsp;firmware from file &#39;dvb-usb-dib0700-1.10.fw&#39;<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:22 sid-eee900 kernel: [ &nbsp; 90.254492] dib0700: firmware<br>
 &nbsp; &nbsp;started successfully.<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 90.756174] dvb-usb: found a &#39;ASUS<br>
 &nbsp; &nbsp;My Cinema U3000 Mini DVBT Tuner&#39; in warm state.<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 90.756733] dvb-usb: will pass the<br>
 &nbsp; &nbsp;complete MPEG2 transport stream to the software demuxer.<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 90.757305] DVB: registering new<br>
 &nbsp; &nbsp;adapter (ASUS My Cinema U3000 Mini DVBT Tuner)<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 91.080958] DVB: registering<br>
 &nbsp; &nbsp;frontend 0 (DiBcom 7000PC)...<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 91.190399] MT2266: successfully<br>
 &nbsp; &nbsp;identified<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 91.350822] dvb-usb: ASUS My<br>
 &nbsp; &nbsp;Cinema U3000 Mini DVBT Tuner successfully initialized and connected.<br>
 &nbsp; &nbsp;Jan &nbsp;2 13:24:23 sid-eee900 kernel: [ &nbsp; 91.353100] usbcore: registered<br>
 &nbsp; &nbsp;new interface driver dvb_usb_dib0700<br>
 &nbsp; &nbsp;---------------------------------------------<br>
<br>
 &nbsp; &nbsp;These match the information given in the wiki for &#39;Successful<br>
 &nbsp; &nbsp;initialization&#39; except for the usb &#39;number&#39; and address (1-4 and 3 for<br>
 &nbsp; &nbsp;me, 5-7 and 8 in the wiki) and the very last line &#39;usbcore: registered<br>
 &nbsp; &nbsp;new interface driver dvb_usb_dib0700&#39;. This last line does not appear in<br>
 &nbsp; &nbsp;the wiki entry for &#39;Successful initialization&#39; but does appear in the<br>
 &nbsp; &nbsp;two of the &#39;failure&#39; entries.<br>
<br>
 &nbsp; &nbsp;When I try to scan for channels, using the dvb_apps package as described<br>
 &nbsp; &nbsp;in the wiki, I get this:<br>
<br>
 &nbsp; &nbsp;------------------------------------<br>
 &nbsp; &nbsp;scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/uk-Oxford<br>
 &nbsp; &nbsp;using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br>
 &nbsp; &nbsp;initial transponder 578000000 0 2 9 3 0 0 0<br>
 &nbsp; &nbsp; &gt;&gt;&gt; tune to:<br>
 &nbsp; &nbsp;578000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE<br>
 &nbsp; &nbsp;WARNING: filter timeout pid 0x0011<br>
 &nbsp; &nbsp;WARNING: filter timeout pid 0x0000<br>
 &nbsp; &nbsp;WARNING: filter timeout pid 0x0010<br>
 &nbsp; &nbsp;dumping lists (0 services)<br>
 &nbsp; &nbsp;Done.<br>
 &nbsp; &nbsp;--------------------------------------<br>
<br>
 &nbsp; &nbsp;The tuner is connected to a roof-mounted aerial and when plugged in to a<br>
 &nbsp; &nbsp;Windows system pulls in 35 channels.<br>
<br>
 &nbsp; &nbsp;I&#39;m very new to Linux and have no idea how to proceed, so I was hoping<br>
 &nbsp; &nbsp;that someone here could give me some pointers. I have noticed that in<br>
 &nbsp; &nbsp;the dmesg file there are lines saying:<br>
<br>
 &nbsp; &nbsp;-----------------------<br>
 &nbsp; &nbsp;Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd,<br>
 &nbsp; &nbsp;not after<br>
 &nbsp; &nbsp;------------------------<br>
<br>
 &nbsp; &nbsp;All the lines referring to ehci_hcd do, in fact, come after the ohci_hcd<br>
 &nbsp; &nbsp;lines so it would appear that I have the order wrong. Would this make a<br>
 &nbsp; &nbsp;difference and, if so, how do I correct it?<br>
<br>
 &nbsp; &nbsp;I&#39;d be very grateful for any help anyone can offer.<br>
<br>
</div></div></blockquote>
<br>
Hi Albert<br>
<br>
Thanks for your reply. I&#39;ve tried the new firmware and with the supplied aerial, but with no different results. I haven&#39;t changed any source code - at present I wouldn&#39;t know how, I&#39;m still learning. I understand, though, that the eeebuntu kernel is a modified one called the array kernel, if that makes any difference. I tried Kaffine and Me TV first and found that neither could detect any channels, which is why I decided to try the dvb utilities from the wiki. Thanks for the suggestions, though.<br>

<br>
Can anyone give me some advice on how to find out why I get the &#39;filter timeout&#39;? Is it because there is no filter to be found, or because there is no signal from the tuner, or because no channels are found within a given time...? If it&#39;s the last of these then it isn&#39;t trying for long enough, as it takes a minute of so for the first channel to be found on a Windows system and the filter timeout occurs after a few seconds.<br>

<br>
Regards<br><font color="#888888">
<br>
Sid<br>
<br>
</font></blockquote></div><br>

------=_Part_117325_13582313.1231154840289--


--===============0272968310==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0272968310==--
