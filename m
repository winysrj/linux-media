Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.alice.nl ([217.149.195.8]:46449 "EHLO smtp.alice.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab0DRIV6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Apr 2010 04:21:58 -0400
Message-ID: <4BCAB275.5000902@cobradevil.org>
Date: Sun, 18 Apr 2010 09:19:17 +0200
From: william <kc@cobradevil.org>
MIME-Version: 1.0
To: Paul Shepherd <paul@whitelands.org.uk>
CC: Josu Lazkano <josu.lazkano@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Fwd: Tevii S660 USB card and dw2102 module generating RC messages
References: <4BC8219A.6060604@whitelands.org.uk> <s2k3907abe61004160234vd88652e6h2738162ba90d0279@mail.gmail.com> <4BC8A1AA.6020609@whitelands.org.uk>
In-Reply-To: <4BC8A1AA.6020609@whitelands.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Paul,

I know what is happening but i have no solution.

The message: dw2102: query RC enter

is a message from the ir receiver in the device.
I noticed by accident that when you push some buttons on the remote 
(which came with the tevii box) while tailing the log file you will see 
the buttons on the remote.

i'm not sure because my device did not work at all so i send it back to 
my supplier but i think the lib-s2planin drivers could fix it but i had 
no chance to test it myself.
If you are going to try the s2planin drivers please let me know how it 
works!

With kind regards

William


On 04/16/2010 07:43 PM, Paul Shepherd wrote:
>
> Josu,
>
> mythtv version 0.22-fixes [22594] however I don't think it's mythtv 
> problem but an interaction somewhere between the S660 h/w, firmware 
> and the kernel (vl4-dvb etc)
>
> paul
>
> On 16/04/2010 10:34, Josu Lazkano wrote:
>> Which version of mythtv are you using?
>>
>> Josu Lazkano
>>
>>> El 16/04/2010 10:58, "Paul Shepherd" <paul@whitelands.org.uk
>>> <mailto:paul@whitelands.org.uk>> escribió:
>>>
>>>
>>> I have a Tevii S660 (a usb dvb-s2 device) which is causing a problem.
>>>
>>> After the S660 is attached to a USB 2 socket, the firmware is d/l and
>>> everything looks fine but then there are continual RC (check/debug?)
>>> messages every 150 ms, then some time later everything goes pear 
>>> shaped:
>>>
>>>     Apr  9 22:15:49 antec300 kernel: [   16.801141] EXT3 FS on sdd1,
>>>     internal journal
>>>     Apr  9 22:15:49 antec300 kernel: [   16.801144] EXT3-fs: mounted
>>>     filesystem with writeback data mode.
>>>     Apr  9 22:15:49 antec300 kernel: [   17.490262] hda-intel: Codec
>>>     #3 probe error; disabling it...
>>>     Apr  9 22:15:50 antec300 kernel: [   17.568264] hda_codec: Unknown
>>>     model for ALC889, trying auto-probe from BIOS...
>>>     Apr  9 22:15:50 antec300 kernel: [   17.568513] input: HDA Digital
>>>     PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
>>>     Apr  9 22:15:55 antec300 kernel: [   22.697708] __ratelimit: 24
>>>     callbacks suppressed
>>>     Apr  9 22:15:55 antec300 kernel: [   22.697711] type=1503
>>>     audit(1270847755.406:33): operation="open" pid=2328 parent=1870
>>>     profile="/usr/sbin/mysqld" requested_mask="::r" denied_mask="::r"
>>>     fsuid=119 ouid=0 name="/sys/devices/system/cpu/"
>>>     .
>>>     # plug the S660 in ...
>>>     .
>>>     Apr  9 22:24:52 antec300 kernel: [  559.078860] usb 1-1: new high
>>>     speed USB device using ehci_hcd and address 7
>>>     Apr  9 22:24:52 antec300 kernel: [  559.211222] usb 1-1:
>>>     configuration #1 chosen from 1 choice
>>>     Apr  9 22:24:52 antec300 kernel: [  559.211390] dvb-usb: found a
>>>     'TeVii S660 USB' in cold state, will try to load a firmware
>>>     Apr  9 22:24:52 antec300 kernel: [  559.211396] usb 1-1: firmware:
>>>     requesting dvb-usb-teviis660.fw
>>>     Apr  9 22:24:52 antec300 kernel: [  559.224426] dvb-usb:
>>>     downloading firmware from file 'dvb-usb-teviis660.fw'
>>>     Apr  9 22:24:52 antec300 kernel: [  559.224431] dw2102: start
>>>     downloading DW210X firmware
>>>     Apr  9 22:24:52 antec300 kernel: [  559.342492] dvb-usb: found a
>>>     'TeVii S660 USB' in warm state.
>>>     Apr  9 22:24:52 antec300 kernel: [  559.342561] dvb-usb: will pass
>>>     the complete MPEG2 transport stream to the software demuxer.
>>>     Apr  9 22:24:52 antec300 kernel: [  559.346560] DVB: registering
>>>     new adapter (TeVii S660 USB)
>>>     Apr  9 22:24:58 antec300 kernel: [  565.369380] dvb-usb: MAC
>>>     address: d0:d0:d0:d0:d0:d0
>>>     Apr  9 22:24:58 antec300 kernel: [  565.394061] Only Zarlink
>>>     VP310/MT312/ZL10313 are supported chips.
>>>     Apr  9 22:24:59 antec300 kernel: [  565.665303] input: IR-receiver
>>>     inside an USB DVB receiver as
>>>     /devices/pci0000:00/0000:00:1a.7/usb1/1-1/input/input11
>>>     Apr  9 22:24:59 antec300 kernel: [  565.665361] dvb-usb: schedule
>>>     remote query interval to 150 msecs.
>>>     Apr  9 22:24:59 antec300 kernel: [  565.665366] dvb-usb: TeVii
>>>     S660 USB successfully initialized and connected.
>>>     Apr  9 22:24:59 antec300 kernel: [  565.665817] usb 1-1: USB
>>>     disconnect, address 7
>>>     Apr  9 22:24:59 antec300 kernel: [  565.693209] dvb-usb: TeVii
>>>     S660 USB successfully deinitialized and disconnected.
>>>     Apr  9 22:24:59 antec300 kernel: [  565.932522] usb 1-1: new high
>>>     speed USB device using ehci_hcd and address 8
>>>     Apr  9 22:24:59 antec300 kernel: [  566.064970] usb 1-1: config 1
>>>     interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 2
>>>     Apr  9 22:24:59 antec300 kernel: [  566.065590] usb 1-1:
>>>     configuration #1 chosen from 1 choice
>>>     Apr  9 22:24:59 antec300 kernel: [  566.066164] dvb-usb: found a
>>>     'TeVii S660 USB' in cold state, will try to load a firmware
>>>     Apr  9 22:24:59 antec300 kernel: [  566.066171] usb 1-1: firmware:
>>>     requesting dvb-usb-teviis660.fw
>>>     Apr  9 22:24:59 antec300 kernel: [  566.072788] dvb-usb:
>>>     downloading firmware from file 'dvb-usb-teviis660.fw'
>>>     Apr  9 22:24:59 antec300 kernel: [  566.072792] dw2102: start
>>>     downloading DW210X firmware
>>>     Apr  9 22:24:59 antec300 kernel: [  566.192150] dvb-usb: found a
>>>     'TeVii S660 USB' in warm state.
>>>     Apr  9 22:24:59 antec300 kernel: [  566.192213] dvb-usb: will pass
>>>     the complete MPEG2 transport stream to the software demuxer.
>>>     Apr  9 22:24:59 antec300 kernel: [  566.192644] DVB: registering
>>>     new adapter (TeVii S660 USB)
>>>     Apr  9 22:25:03 antec300 kernel: [  570.298170] dvb-usb: MAC
>>>     address: 00:18:bd:5c:60:b0
>>>     Apr  9 22:25:03 antec300 kernel: [  570.314148] Only Zarlink
>>>     VP310/MT312/ZL10313 are supported chips.
>>>     Apr  9 22:25:04 antec300 kernel: [  570.589497] DS3000 chip
>>>     version: 0.192 attached.
>>>     Apr  9 22:25:04 antec300 kernel: [  570.589501] dw2102: Attached
>>>     ds3000+ds2020!
>>>     Apr  9 22:25:04 antec300 kernel: [  570.589503]
>>>     Apr  9 22:25:04 antec300 kernel: [  570.589707] DVB: registering
>>>     adapter 1 frontend 0 (Montage Technology DS3000/TS2020)...
>>>     Apr  9 22:25:04 antec300 kernel: [  570.590909] input: IR-receiver
>>>     inside an USB DVB receiver as
>>>     /devices/pci0000:00/0000:00:1a.7/usb1/1-1/input/input12
>>>     Apr  9 22:25:04 antec300 kernel: [  570.590965] dvb-usb: schedule
>>>     remote query interval to 150 msecs.
>>>     Apr  9 22:25:04 antec300 kernel: [  570.590971] dvb-usb: TeVii
>>>     S660 USB successfully initialized and connected.
>>>     Apr  9 22:25:04 antec300 kernel: [  570.741992] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:04 antec300 kernel: [  570.741996] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:04 antec300 kernel: [  570.761941] dw2102: query RC 
>>> end
>>>     Apr  9 22:25:04 antec300 kernel: [  570.912988] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:04 antec300 kernel: [  570.912993] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:04 antec300 kernel: [  570.920950] dw2102: query RC 
>>> end
>>>     Apr  9 22:25:04 antec300 kernel: [  571.072756] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:04 antec300 kernel: [  571.072761] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:04 antec300 kernel: [  571.080742] dw2102: query RC 
>>> end
>>>     Apr  9 22:25:04 antec300 kernel: [  571.232512] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:04 antec300 kernel: [  571.232517] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:04 antec300 kernel: [  571.240503] dw2102: query RC 
>>> end
>>>     Apr  9 22:25:04 antec300 kernel: [  571.393004] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:04 antec300 kernel: [  571.393009] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:04 antec300 kernel: [  571.400998] dw2102: query RC 
>>> end
>>>     Apr  9 22:25:05 antec300 kernel: [  571.552774] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:05 antec300 kernel: [  571.552778] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:05 antec300 kernel: [  571.560764] dw2102: query RC 
>>> end
>>>     Apr  9 22:25:05 antec300 kernel: [  571.711791] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:05 antec300 kernel: [  571.711796] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:05 antec300 kernel: [  571.719776] dw2102: query RC 
>>> end
>>>     Apr  9 22:25:05 antec300 kernel: [  571.871529] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:05 antec300 kernel: [  571.871535] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:05 antec300 kernel: [  571.879506] dw2102: query RC 
>>> end
>>>     Apr  9 22:25:05 antec300 kernel: [  572.031296] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:05 antec300 kernel: [  572.031301] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:05 antec300 kernel: [  572.039283] dw2102: query RC 
>>> end
>>>     Apr  9 22:25:05 antec300 kernel: [  572.191370] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:05 antec300 kernel: [  572.191374] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:05 antec300 kernel: [  572.199064] dw2102: query RC 
>>> end
>>>     Apr  9 22:25:05 antec300 kernel: [  572.351564] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:05 antec300 kernel: [  572.351569] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:05 antec300 kernel: [  572.359550] dw2102: query RC 
>>> end
>>>     Apr  9 22:25:06 antec300 kernel: [  572.510583] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:06 antec300 kernel: [  572.510587] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:06 antec300 kernel: [  572.518557] dw2102: query RC 
>>> end
>>>     Apr  9 22:25:06 antec300 kernel: [  572.670334] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:06 antec300 kernel: [  572.670339] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:06 antec300 kernel: [  572.679070] dw2102: query RC 
>>> end
>>>     Apr  9 22:25:06 antec300 kernel: [  572.830080] dw2102: query RC 
>>> enter
>>>     Apr  9 22:25:06 antec300 kernel: [  572.830084] dw2102: query RC 
>>> start
>>>     Apr  9 22:25:06 antec300 kernel: [  572.838076] dw2102: query RC 
>>> end
>>>     .
>>>     # 15 hrs later ...
>>>     .
>>>     Apr 10 13:01:27 antec300 kernel: [53074.896764] dw2102: query RC 
>>> enter
>>>     Apr 10 13:01:27 antec300 kernel: [53074.896768] dw2102: query RC 
>>> start
>>>     Apr 10 13:01:27 antec300 kernel: [53074.904732] dw2102: query RC 
>>> end
>>>     Apr 10 13:01:27 antec300 kernel: [53075.055779] dw2102: query RC 
>>> enter
>>>     Apr 10 13:01:27 antec300 kernel: [53075.055784] dw2102: query RC 
>>> start
>>>     Apr 10 13:01:27 antec300 kernel: [53075.064511] dw2102: query RC 
>>> end
>>>     Apr 10 13:01:27 antec300 kernel: [53075.215544] dw2102: query RC 
>>> enter
>>>     Apr 10 13:01:27 antec300 kernel: [53075.215550] dw2102: query RC 
>>> start
>>>     Apr 10 13:01:27 antec300 kernel: [53075.224272] dw2102: query RC 
>>> end
>>>     Apr 10 13:01:27 antec300 kernel: [53075.375283] dw2102: query RC 
>>> enter
>>>     Apr 10 13:01:27 antec300 kernel: [53075.375288] dw2102: query RC 
>>> start
>>>     Apr 10 13:01:27 antec300 kernel: [53075.400123] usb 1-1: USB
>>>     disconnect, address 8
>>>     Apr 10 13:01:27 antec300 kernel: [53075.407986] dw2102:
>>>     dw2102_rc_query: unknown rc key: f7, ec
>>>     Apr 10 13:01:27 antec300 kernel: [53075.407988]
>>>     Apr 10 13:01:27 antec300 kernel: [53075.407990] dw2102: query RC 
>>> end
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638775] khubd         D
>>>     c08185c0     0    40      2 0x00000000
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638782]  f71a9da8 00000046
>>>     f7193ed0 c08185c0 f7194168 c08185c0 96b72f6a 00003045
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638792]  c08185c0 c08185c0
>>>     f7194168 c08185c0 96b724c4 00003045 c08185c0 f6b19880
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638800]  f7193ed0 f1ed7000
>>>     f71a9db8 f1f867f4 f71a9dd4 f822b50d f71a9dbc c03a4552
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638809] Call Trace:
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638836]  [<f822b50d>]
>>>     dvb_unregister_frontend+0x9d/0xe0 [dvb_core]
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638845]  [<c03a4552>] ?
>>>     device_unregister+0x12/0x20
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638852]  [<c015c180>] ?
>>>     autoremove_wake_function+0x0/0x40
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638862]  [<f8145095>]
>>>     dvb_usb_adapter_frontend_exit+0x15/0x30 [dvb_usb]
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638870]  [<f8144485>]
>>>     dvb_usb_exit+0x45/0xf0 [dvb_usb]
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638876]  [<c0572da4>] ?
>>>     mutex_lock+0x14/0x40
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638883]  [<f814455d>]
>>>     dvb_usb_device_exit+0x2d/0x50 [dvb_usb]
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638892]  [<c0418ab9>]
>>>     usb_unbind_interface+0xe9/0x120
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638897]  [<c03a691e>]
>>>     __device_release_driver+0x3e/0x90
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638902]  [<c03a6a30>]
>>>     device_release_driver+0x20/0x40
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638908]  [<c03a5d73>]
>>>     bus_remove_device+0x73/0x90
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638912]  [<c03a44df>]
>>>     device_del+0xef/0x150
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638917]  [<c041596d>]
>>>     usb_disable_device+0x7d/0xf0
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638922]  [<c04105be>]
>>>     usb_disconnect+0x9e/0x110
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638927]  [<c0410973>]
>>>     hub_port_connect_change+0x83/0x830
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638932]  [<c0416640>] ?
>>>     usb_control_msg+0xd0/0x120
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638937]  [<c040e7bb>] ?
>>>     clear_port_feature+0x4b/0x60
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638942]  [<c04121d5>]
>>>     hub_events+0x1f5/0x500
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638946]  [<c057209c>] ?
>>>     schedule+0x40c/0x730
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638952]  [<c015c2da>] ?
>>>     finish_wait+0x4a/0x70
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638956]  [<c04124e0>] ?
>>>     hub_thread+0x0/0x150
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638960]  [<c0412515>]
>>>     hub_thread+0x35/0x150
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638965]  [<c015c180>] ?
>>>     autoremove_wake_function+0x0/0x40
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638970]  [<c015be8c>]
>>>     kthread+0x7c/0x90
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638975]  [<c015be10>] ?
>>>     kthread+0x0/0x90
>>>     Apr 10 13:03:33 antec300 kernel: [53200.638981]  [<c0104047>]
>>>     kernel_thread_helper+0x7/0x10
>>>
>>>
>>> Tevii say the h/w is ok as it works with a Windows box with their
>>> myTevii application.  It does work while the RC messages are occurring,
>>> I can watch and record SD+HD content in mythtv until the crash.
>>>
>>> I have tried the latest tevii beta s/w (v4l and .fw files) and also the
>>> v4l-dvb drivers from linuxtv dated 6 april - the same result each time.
>>>  I can see in the dw2102.c where 150ms is defined and this seems the
>>> same as other devices in the code.
>>>
>>> Google indicates others have seen similar problems but it's not clear
>>> what the solution is.
>>>
>>> Three questions:
>>>
>>> 1) are the RC messages caused by a h/w or s/w issue?
>>>
>>> 2) if it's s/w what do I need to do?
>>>
>>> 3) is the subsequent khubd crash related and how do I fix that?
>>>
>>> I have a nova dvb-t usb box connected and that works fine - I assume
>>> there's no interaction.
>>>
>>> I am running Ubuntu 9.10 with the following kernel:
>>>
>>> Linux antec300.home.org <http://antec300.home.org> 2.6.31-20-generic
>>> #57-Ubuntu SMP Mon Feb 8
>>> 09:05:19 UTC 2010 i686 GNU/Linux
>>>
>>> thanks for any suggestions, paul
>>>
>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> <mailto:majordomo@vger.kernel.org>
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

