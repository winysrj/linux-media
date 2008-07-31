Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oobe.trouble@gmail.com>) id 1KOPZG-0005Ki-Oi
	for linux-dvb@linuxtv.org; Thu, 31 Jul 2008 06:15:12 +0200
Received: by yw-out-2324.google.com with SMTP id 3so174772ywj.41
	for <linux-dvb@linuxtv.org>; Wed, 30 Jul 2008 21:15:06 -0700 (PDT)
Message-ID: <21aab41d0807302115g8b48997x3522e07c9911dc25@mail.gmail.com>
Date: Thu, 31 Jul 2008 14:15:06 +1000
From: "oobe trouble" <oobe.trouble@gmail.com>
To: "Robert Lowery" <rglowery@exemail.com.au>
In-Reply-To: <21aab41d0807302026q3db5730fp278d4bf8f970c749@mail.gmail.com>
MIME-Version: 1.0
References: <16121.64.213.30.2.1216781835.squirrel@webmail.exetel.com.au>
	<21aab41d0807302026q3db5730fp278d4bf8f970c749@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVICO firmware compatibility between v4l-dvb and
	in-tree kernel drivers
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1182696646=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1182696646==
Content-Type: multipart/alternative;
	boundary="----=_Part_63933_25851174.1217477706554"

------=_Part_63933_25851174.1217477706554
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

update i just tested this on 2.6.26 and ubuntu's 2.6.24-19-generic both work
ok

On Thu, Jul 31, 2008 at 1:26 PM, oobe trouble <oobe.trouble@gmail.com>wrote:

> hi i just tested http://linuxtv.org/hg/~mkrufky/cxusb/<http://linuxtv.org/hg/%7Emkrufky/cxusb/>on
> 2.6.25.10 havent had a chance to test 2.6.26 but im sure it works thanks
> for letting me know about this
>
> and thanks mkrufky
>
> On Wed, Jul 23, 2008 at 12:57 PM, Robert Lowery <rglowery@exemail.com.au>wrote:
>
>> Hi Folks,
>>
>> I've been successfully using the experimental v4l-dvb tree DVICO Dual
>> Digital 4 drivers for a number of months.  Today I decided to try an use
>> the official 2.6.26 kernel drivers, but they are triggering an OOPS at
>> firmware load time (see below).  Can someone please confirm if the
>> xc3028-dvico-au-01.fw  firmware is still compatible with 2.6.26? or are
>> there any other known issues in this space?
>>
>> Thanks
>>
>> -Rob
>>
>> [  103.974543] xc2028 1-0061: Loading 3 firmware images from
>> xc3028-dvico-au-01.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7
>> [  103.984657] BUG: unable to handle kernel NULL pointer dereference at
>> 00000000
>>
>> [  103.984690] IP: [<c0361a85>]
>> __mutex_lock_interruptible_slowpath+0x35/0xe0
>> [  103.984716] *pde = 00000000
>> [  103.984731] Oops: 0002 [#1] SMP
>> [  103.984742] Modules linked in: nfsd auth_rpcgss exportfs speedstep_lib
>> cpufre
>> q_conservative cpufreq_powersave cpufreq_userspace cpufreq_ondemand
>> cpufreq_stat
>> s freq_table container video output sbs sbshc battery nfs lockd nfs_acl
>> sunrpc i
>> ptable_filter ip_tables x_tables xfs ac lp tuner_xc2028 zl10353
>> dvb_usb_cxusb dv
>> b_usb snd_maestro3 dvb_core snd_ac97_codec serio_raw ac97_bus
>> snd_seq_dummy psmo
>> use snd_seq_oss snd_seq_midi snd_pcsp snd_rawmidi snd_pcm_oss
>> snd_mixer_oss snd_
>> pcm snd_seq_midi_event snd_seq snd_page_alloc snd_timer snd_seq_device snd
>> butto
>> n i2c_viapro soundcore i2c_core shpchp pci_hotplug via686a via_agp
>> parport_pc pa
>> rport agpgart ipv6 evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod pata_acpi
>> flopp
>> y pata_sil680 sym53c8xx ehci_hcd e100 uhci_hcd pata_via ata_generic mii
>> usbcore
>> scsi_transport_spi libata scsi_mod dock thermal processor fan fbcon
>> tileblit fon
>> t bitblit softcursor uvesafb cn fuse
>> [  103.984962]
>> [  103.984971] Pid: 6492, comm: kdvb-fe-0 Not tainted (2.6.26-4-generic
>> #1)
>> [  103.984981] EIP: 0060:[<c0361a85>] EFLAGS: 00010246 CPU: 1
>> [  103.984998] EIP is at __mutex_lock_interruptible_slowpath+0x35/0xe0
>> [  103.985009] EAX: f6783d30 EBX: f7aa0c5c ECX: f7aa0c64 EDX: 00000000
>> [  103.985020] ESI: f670d400 EDI: f7aa0c60 EBP: f6783d90 ESP: f6783d2c
>> [  103.985031]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> [  103.985040] Process kdvb-fe-0 (pid: 6492, ti=f6782000 task=f670d400
>> task.ti=f
>> 6782000)
>> [  103.985050] Stack: f7aa0c64 f7aa0c64 00000000 c029e80f f6783d90
>> 00000003 f7aa
>> 0720 f6783d90
>> [  103.985074]        f8b43b79 f6755d55 00000030 f8cbbaa5 f8cbdb14
>> 0001d729 f7aa
>> 0c5c 00000061
>> [  103.985094]        f6783d90 f6783dcf f6783d93 f6783db8 f8b84251
>> f6783dcf 0000
>> 0001 00000000
>> [  103.985114] Call Trace:
>> [  103.985129]  [<c029e80f>] release_firmware+0xf/0x20
>> [  103.985165]  [<f8b43b79>] dvb_usb_generic_rw+0x69/0x190 [dvb_usb]
>> [  103.985202]  [<f8cbbaa5>] load_all_firmwares+0x415/0x740 [tuner_xc2028]
>> [  103.985244]  [<f8b84251>] cxusb_ctrl_msg+0xa1/0xd0 [dvb_usb_cxusb]
>> [  103.985296]  [<f8b84737>] cxusb_bluebird_gpio_rw+0x37/0x50
>> [dvb_usb_cxusb]
>> [  103.985321]  [<f8b852a6>] cxusb_bluebird_gpio_pulse+0x56/0x70
>> [dvb_usb_cxusb]
>>
>> [  103.985347]  [<f8b85443>] dvico_bluebird_xc2028_callback+0x13/0x30
>> [dvb_usb_c
>> xusb]
>> [  103.985363]  [<f8cbc058>] check_firmware+0x288/0x880 [tuner_xc2028]
>> [  103.985389]  [<f8b84251>] cxusb_ctrl_msg+0xa1/0xd0 [dvb_usb_cxusb]
>> [  103.985440]  [<f8b8449f>] cxusb_i2c_xfer+0x21f/0x3c0 [dvb_usb_cxusb]
>> [  103.985463]  [<f8cbc6b6>] generic_set_freq+0x66/0x500 [tuner_xc2028]
>> [  103.985495]  [<c01049c7>] common_interrupt+0x23/0x28
>> [  103.985526]  [<f89f439f>] i2c_transfer+0x6f/0xa0 [i2c_core]
>> [  103.985572]  [<f8cbce64>] xc2028_set_params+0xf4/0x230 [tuner_xc2028]
>> [  103.985604]  [<f8b06c95>] zl10353_set_parameters+0x505/0x660 [zl10353]
>> [  103.985634]  [<c03610c4>] schedule+0x284/0x520
>> [  103.985698]  [<f8b745b1>] dvb_frontend_swzigzag_autotune+0xc1/0x240
>> [dvb_core
>> ]
>> [  103.985769]  [<c01353b0>] process_timeout+0x0/0x10
>> [  103.985806]  [<f8b74cd9>] dvb_frontend_swzigzag+0x179/0x270 [dvb_core]
>> [  103.985837]  [<f8b755af>] dvb_frontend_thread+0x38f/0x430 [dvb_core]
>> [  103.985862]  [<c011d783>] __wake_up_common+0x43/0x70
>> [  103.985894]  [<c013fe00>] autoremove_wake_function+0x0/0x50
>> [  103.985925]  [<f8b75220>] dvb_frontend_thread+0x0/0x430 [dvb_core]
>> [  103.985941]  [<c013faf9>] kthread+0x39/0x70
>> [  103.985941]  [<c013fac0>] kthread+0x0/0x70
>> [  103.985941]  [<c0104bd3>] kernel_thread_helper+0x7/0x14
>> [  103.985941]  =======================
>> [  103.985941] Code: ec 10 89 f8 64 8b 35 00 80 4d c0 e8 16 0e 00 00 8d 43
>> 08 89
>>  04 24 8d 44 24 04 8b 53 0c 89 43 0c 8b 0c 24 89 54 24 08 89 4c 24 04 <89>
>> 02 ba
>>  ff ff ff ff 89 74 24 0c 89 d0 87 03 83 e8 01 74 5f 87
>> [  103.985941] EIP:
>> [<c0361a85>]__mutex_lock_interruptible_slowpath+0x35/0xe0 SS:ESP
>> 0068:f6783d2c
>> [  103.985941] ---[ end trace 9e886fbc373acdcc ]---
>>
>>
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>
>

------=_Part_63933_25851174.1217477706554
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">update i just tested this on 2.6.26 and ubuntu&#39;s 2.6.24-19-generic both work ok <br><br><div class="gmail_quote">On Thu, Jul 31, 2008 at 1:26 PM, oobe trouble <span dir="ltr">&lt;<a href="mailto:oobe.trouble@gmail.com">oobe.trouble@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div dir="ltr">hi i just tested <a href="http://linuxtv.org/hg/%7Emkrufky/cxusb/" target="_blank">http://linuxtv.org/hg/~mkrufky/cxusb/</a> on <a href="http://2.6.25.10" target="_blank">2.6.25.10</a> havent had a chance to test 2.6.26 but im sure it works thanks for letting me know about this <br>

<br>and thanks mkrufky <br><div><div></div><div class="Wj3C7c"><br><div class="gmail_quote">On Wed, Jul 23, 2008 at 12:57 PM, Robert Lowery <span dir="ltr">&lt;<a href="mailto:rglowery@exemail.com.au" target="_blank">rglowery@exemail.com.au</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi Folks,<br>
<br>
I&#39;ve been successfully using the experimental v4l-dvb tree DVICO Dual<br>
Digital 4 drivers for a number of months. &nbsp;Today I decided to try an use<br>
the official 2.6.26 kernel drivers, but they are triggering an OOPS at<br>
firmware load time (see below). &nbsp;Can someone please confirm if the<br>
xc3028-dvico-au-01.fw &nbsp;firmware is still compatible with 2.6.26? or are<br>
there any other known issues in this space?<br>
<br>
Thanks<br>
<br>
-Rob<br>
<br>
[ &nbsp;103.974543] xc2028 1-0061: Loading 3 firmware images from<br>
xc3028-dvico-au-01.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7<br>
[ &nbsp;103.984657] BUG: unable to handle kernel NULL pointer dereference at<br>
00000000<br>
<br>
[ &nbsp;103.984690] IP: [&lt;c0361a85&gt;] __mutex_lock_interruptible_slowpath+0x35/0xe0<br>
[ &nbsp;103.984716] *pde = 00000000<br>
[ &nbsp;103.984731] Oops: 0002 [#1] SMP<br>
[ &nbsp;103.984742] Modules linked in: nfsd auth_rpcgss exportfs speedstep_lib<br>
cpufre<br>
q_conservative cpufreq_powersave cpufreq_userspace cpufreq_ondemand<br>
cpufreq_stat<br>
s freq_table container video output sbs sbshc battery nfs lockd nfs_acl<br>
sunrpc i<br>
ptable_filter ip_tables x_tables xfs ac lp tuner_xc2028 zl10353<br>
dvb_usb_cxusb dv<br>
b_usb snd_maestro3 dvb_core snd_ac97_codec serio_raw ac97_bus<br>
snd_seq_dummy psmo<br>
use snd_seq_oss snd_seq_midi snd_pcsp snd_rawmidi snd_pcm_oss<br>
snd_mixer_oss snd_<br>
pcm snd_seq_midi_event snd_seq snd_page_alloc snd_timer snd_seq_device snd<br>
butto<br>
n i2c_viapro soundcore i2c_core shpchp pci_hotplug via686a via_agp<br>
parport_pc pa<br>
rport agpgart ipv6 evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod pata_acpi<br>
flopp<br>
y pata_sil680 sym53c8xx ehci_hcd e100 uhci_hcd pata_via ata_generic mii<br>
usbcore<br>
scsi_transport_spi libata scsi_mod dock thermal processor fan fbcon<br>
tileblit fon<br>
t bitblit softcursor uvesafb cn fuse<br>
[ &nbsp;103.984962]<br>
[ &nbsp;103.984971] Pid: 6492, comm: kdvb-fe-0 Not tainted (2.6.26-4-generic #1)<br>
[ &nbsp;103.984981] EIP: 0060:[&lt;c0361a85&gt;] EFLAGS: 00010246 CPU: 1<br>
[ &nbsp;103.984998] EIP is at __mutex_lock_interruptible_slowpath+0x35/0xe0<br>
[ &nbsp;103.985009] EAX: f6783d30 EBX: f7aa0c5c ECX: f7aa0c64 EDX: 00000000<br>
[ &nbsp;103.985020] ESI: f670d400 EDI: f7aa0c60 EBP: f6783d90 ESP: f6783d2c<br>
[ &nbsp;103.985031] &nbsp;DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068<br>
[ &nbsp;103.985040] Process kdvb-fe-0 (pid: 6492, ti=f6782000 task=f670d400<br>
task.ti=f<br>
6782000)<br>
[ &nbsp;103.985050] Stack: f7aa0c64 f7aa0c64 00000000 c029e80f f6783d90<br>
00000003 f7aa<br>
0720 f6783d90<br>
[ &nbsp;103.985074] &nbsp; &nbsp; &nbsp; &nbsp;f8b43b79 f6755d55 00000030 f8cbbaa5 f8cbdb14<br>
0001d729 f7aa<br>
0c5c 00000061<br>
[ &nbsp;103.985094] &nbsp; &nbsp; &nbsp; &nbsp;f6783d90 f6783dcf f6783d93 f6783db8 f8b84251<br>
f6783dcf 0000<br>
0001 00000000<br>
[ &nbsp;103.985114] Call Trace:<br>
[ &nbsp;103.985129] &nbsp;[&lt;c029e80f&gt;] release_firmware+0xf/0x20<br>
[ &nbsp;103.985165] &nbsp;[&lt;f8b43b79&gt;] dvb_usb_generic_rw+0x69/0x190 [dvb_usb]<br>
[ &nbsp;103.985202] &nbsp;[&lt;f8cbbaa5&gt;] load_all_firmwares+0x415/0x740 [tuner_xc2028]<br>
[ &nbsp;103.985244] &nbsp;[&lt;f8b84251&gt;] cxusb_ctrl_msg+0xa1/0xd0 [dvb_usb_cxusb]<br>
[ &nbsp;103.985296] &nbsp;[&lt;f8b84737&gt;] cxusb_bluebird_gpio_rw+0x37/0x50 [dvb_usb_cxusb]<br>
[ &nbsp;103.985321] &nbsp;[&lt;f8b852a6&gt;] cxusb_bluebird_gpio_pulse+0x56/0x70<br>
[dvb_usb_cxusb]<br>
<br>
[ &nbsp;103.985347] &nbsp;[&lt;f8b85443&gt;] dvico_bluebird_xc2028_callback+0x13/0x30<br>
[dvb_usb_c<br>
xusb]<br>
[ &nbsp;103.985363] &nbsp;[&lt;f8cbc058&gt;] check_firmware+0x288/0x880 [tuner_xc2028]<br>
[ &nbsp;103.985389] &nbsp;[&lt;f8b84251&gt;] cxusb_ctrl_msg+0xa1/0xd0 [dvb_usb_cxusb]<br>
[ &nbsp;103.985440] &nbsp;[&lt;f8b8449f&gt;] cxusb_i2c_xfer+0x21f/0x3c0 [dvb_usb_cxusb]<br>
[ &nbsp;103.985463] &nbsp;[&lt;f8cbc6b6&gt;] generic_set_freq+0x66/0x500 [tuner_xc2028]<br>
[ &nbsp;103.985495] &nbsp;[&lt;c01049c7&gt;] common_interrupt+0x23/0x28<br>
[ &nbsp;103.985526] &nbsp;[&lt;f89f439f&gt;] i2c_transfer+0x6f/0xa0 [i2c_core]<br>
[ &nbsp;103.985572] &nbsp;[&lt;f8cbce64&gt;] xc2028_set_params+0xf4/0x230 [tuner_xc2028]<br>
[ &nbsp;103.985604] &nbsp;[&lt;f8b06c95&gt;] zl10353_set_parameters+0x505/0x660 [zl10353]<br>
[ &nbsp;103.985634] &nbsp;[&lt;c03610c4&gt;] schedule+0x284/0x520<br>
[ &nbsp;103.985698] &nbsp;[&lt;f8b745b1&gt;] dvb_frontend_swzigzag_autotune+0xc1/0x240<br>
[dvb_core<br>
]<br>
[ &nbsp;103.985769] &nbsp;[&lt;c01353b0&gt;] process_timeout+0x0/0x10<br>
[ &nbsp;103.985806] &nbsp;[&lt;f8b74cd9&gt;] dvb_frontend_swzigzag+0x179/0x270 [dvb_core]<br>
[ &nbsp;103.985837] &nbsp;[&lt;f8b755af&gt;] dvb_frontend_thread+0x38f/0x430 [dvb_core]<br>
[ &nbsp;103.985862] &nbsp;[&lt;c011d783&gt;] __wake_up_common+0x43/0x70<br>
[ &nbsp;103.985894] &nbsp;[&lt;c013fe00&gt;] autoremove_wake_function+0x0/0x50<br>
[ &nbsp;103.985925] &nbsp;[&lt;f8b75220&gt;] dvb_frontend_thread+0x0/0x430 [dvb_core]<br>
[ &nbsp;103.985941] &nbsp;[&lt;c013faf9&gt;] kthread+0x39/0x70<br>
[ &nbsp;103.985941] &nbsp;[&lt;c013fac0&gt;] kthread+0x0/0x70<br>
[ &nbsp;103.985941] &nbsp;[&lt;c0104bd3&gt;] kernel_thread_helper+0x7/0x14<br>
[ &nbsp;103.985941] &nbsp;=======================<br>
[ &nbsp;103.985941] Code: ec 10 89 f8 64 8b 35 00 80 4d c0 e8 16 0e 00 00 8d 43<br>
08 89<br>
&nbsp;04 24 8d 44 24 04 8b 53 0c 89 43 0c 8b 0c 24 89 54 24 08 89 4c 24 04 &lt;89&gt;<br>
02 ba<br>
&nbsp;ff ff ff ff 89 74 24 0c 89 d0 87 03 83 e8 01 74 5f 87<br>
[ &nbsp;103.985941] EIP:<br>
[&lt;c0361a85&gt;]__mutex_lock_interruptible_slowpath+0x35/0xe0 SS:ESP<br>
0068:f6783d2c<br>
[ &nbsp;103.985941] ---[ end trace 9e886fbc373acdcc ]---<br>
<br>
<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org" target="_blank">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br></div></div></div>
</blockquote></div><br></div>

------=_Part_63933_25851174.1217477706554--


--===============1182696646==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1182696646==--
