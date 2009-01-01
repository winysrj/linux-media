Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.175])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mjenks1968@gmail.com>) id 1LIUcE-0006a1-KK
	for linux-dvb@linuxtv.org; Thu, 01 Jan 2009 21:58:03 +0100
Received: by wf-out-1314.google.com with SMTP id 27so7470633wfd.17
	for <linux-dvb@linuxtv.org>; Thu, 01 Jan 2009 12:57:57 -0800 (PST)
Message-ID: <e5df86c90901011257n69c71c7cg1b5fefc2d09841a2@mail.gmail.com>
Date: Thu, 1 Jan 2009 14:57:57 -0600
From: "Mark Jenks" <mjenks1968@gmail.com>
To: CityK <cityk@rogers.com>
In-Reply-To: <e5df86c90901011034o5d58113fx62897ba05ff2c7a3@mail.gmail.com>
MIME-Version: 1.0
References: <e5df86c90812270840w2fd6be64l40f9838aef23db4f@mail.gmail.com>
	<1230500176.3120.60.camel@palomino.walls.org>
	<e5df86c90812281451o111e3ebem77c7d9bb8469e149@mail.gmail.com>
	<49580FAB.2000003@rogers.com>
	<e5df86c90812281701x561691ej219ee83604bbb083@mail.gmail.com>
	<49583D09.5080507@rogers.com>
	<e5df86c90901011034o5d58113fx62897ba05ff2c7a3@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with kernel oops when installing HVR-1800.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2065358861=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2065358861==
Content-Type: multipart/alternative;
	boundary="----=_Part_167429_24939655.1230843477529"

------=_Part_167429_24939655.1230843477529
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Jan 1, 2009 at 12:34 PM, Mark Jenks <mjenks1968@gmail.com> wrote:

>
>
> On Sun, Dec 28, 2008 at 8:59 PM, CityK <cityk@rogers.com> wrote:
>
>> Mark Jenks wrote:
>> > On Sun, Dec 28, 2008 at 5:45 PM, CityK <cityk@rogers.com
>> > <mailto:cityk@rogers.com>> wrote:
>> >
>> >
>> >     The HVR-1250 device itself supports analogue, but such support is
>> not
>> >     yet realized within the cx23885 driver.
>> >
>> >
>> > Wow, actually it has an svideo in that I never paid attention to.
>> > Maybe someday I'll be able to use both of the analog in for both the
>> > 1250 and the 1800
>>
>> To be clear, just so everyone is on the same page, the device's analogue
>> input facilities include both that from its analog TV tuner and from its
>> (as mentioned above) A/V inputs
>
>
> Well, I patched it, make clean, make, make install, and a reboot.
>
> BUG: unable to handle kernel NULL pointer dereference at 00000168
> IP: [<f0e2571c>] :cx23885:mpeg_open+0x41/0xc0
> *pde = 00000000
> Oops: 0000 [#1] SMP
> Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave
> powernow_k8 xfs loop dm_mod cx25840 mt2131 s5h1409 cx23885
> v4l2_compat_ioctl32 nvidia(P) snd_mpu401 cx2341x videobuf_dma_sg
> videobuf_dvb dvb_core videobuf_core snd_usb_audio snd_usb_lib snd_cs4232
> snd_opl3_lib v4l2_common videodev agpgart snd_hwdep lirc_mceusb2
> snd_cs4231_lib snd_mpu401_uart snd_rawmidi snd_hda_intel snd_pcm parport_pc
> ohci1394 snd_timer k8temp osst v4l1_compat snd_seq_device hwmon snd button
> i2c_nforce2 lirc_dev parport ieee1394 st forcedeth sr_mod cdrom rtc_cmos
> rtc_core btcx_risc tveeprom i2c_core snd_page_alloc soundcore rtc_lib sg
> usbhid hid ff_memless ohci_hcd ehci_hcd usbcore sd_mod edd ext3 mbcache jbd
> fan aic7xxx scsi_transport_spi sata_nv pata_amd libata scsi_mod dock thermal
> processor thermal_sys
>
> Pid: 2876, comm: X Tainted: P          (2.6.27.10-default #3)
> EIP: 0060:[<f0e2571c>] EFLAGS: 00013287 CPU: 1
> EIP is at mpeg_open+0x41/0xc0 [cx23885]
> EAX: 00000000 EBX: ef1fd000 ECX: f0e308a8 EDX: ef3be000
> ESI: 00000001 EDI: ef189980 EBP: efba1790 ESP: efe93e84
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process X (pid: 2876, ti=efe92000 task=ef1e5070 task.ti=efe92000)
> Stack: efbf5a00 efbf5a04 ef189980 f0d775b8 00000000 ef3876c0 00000000
> efba1790
>        c016bee5 ef189980 00000000 ef189980 efba1790 00000000 c016bdd9
> c01683cd
>        ef81ebc0 ef504c6c efe93f14 ef189980 efe93f14 00000003 c01684d8
> ef189980
> Call Trace:
>  [<f0d775b8>] v4l2_open+0x62/0x76 [videodev]
>  [<c016bee5>] chrdev_open+0x10c/0x122
>  [<c016bdd9>] chrdev_open+0x0/0x122
>  [<c01683cd>] __dentry_open+0x10d/0x1fc
>  [<c01684d8>] nameidata_to_filp+0x1c/0x2c
>  [<c0172986>] do_filp_open+0x33d/0x63e
>  [<f1aad8ce>] _nv004117rm+0x9/0x12 [nvidia]
>  [<c01582f8>] handle_mm_fault+0x2b3/0x5dd
>  [<f0dcf391>] __videobuf_mmap_free+0x3e/0x7d [videobuf_core]
>  [<c017ab2d>] alloc_fd+0x57/0xd3
>  [<c01681e8>] do_sys_open+0x3f/0xb8
>  [<c01682a5>] sys_open+0x1e/0x23
>  [<c01037ad>] sysenter_do_call+0x12/0x21
>  =======================
> Code: 17 68 38 7a e2 f0 68 c8 0a 00 00 68 ee a2 e2 f0 e8 51 aa 2f cf 83 c4
> 0c e8 88 66 49 cf 8b 1d a0 fd e2 f0 eb 10 8b 83 c4 0e 00 00 <39> b0 68 01 00
> 00 74 1c 89 d3 8b 13 0f 18 02 90 81 fb a0 fd e2
> EIP: [<f0e2571c>] mpeg_open+0x41/0xc0 [cx23885] SS:ESP 0068:efe93e84
> ---[ end trace 1bdce38cbcdc8781 ]---
>
>
>
It's working!

I had to change cx23885-417.c to the same if statement in mpeg_open.

-Mark

------=_Part_167429_24939655.1230843477529
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">On Thu, Jan 1, 2009 at 12:34 PM, Mark Jenks <span dir="ltr">&lt;<a href="mailto:mjenks1968@gmail.com">mjenks1968@gmail.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br><br><div class="gmail_quote"><div><div></div><div class="Wj3C7c">On Sun, Dec 28, 2008 at 8:59 PM, CityK <span dir="ltr">&lt;<a href="mailto:cityk@rogers.com" target="_blank">cityk@rogers.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

<div>Mark Jenks wrote:<br>
&gt; On Sun, Dec 28, 2008 at 5:45 PM, CityK &lt;<a href="mailto:cityk@rogers.com" target="_blank">cityk@rogers.com</a><br>
</div><div>&gt; &lt;mailto:<a href="mailto:cityk@rogers.com" target="_blank">cityk@rogers.com</a>&gt;&gt; wrote:<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; The HVR-1250 device itself supports analogue, but such support is not<br>
&gt; &nbsp; &nbsp; yet realized within the cx23885 driver.<br>
&gt;<br>
&gt;<br>
&gt; Wow, actually it has an svideo in that I never paid attention to.<br>
&gt; Maybe someday I&#39;ll be able to use both of the analog in for both the<br>
&gt; 1250 and the 1800<br>
<br>
</div>To be clear, just so everyone is on the same page, the device&#39;s analogue<br>
input facilities include both that from its analog TV tuner and from its<br>
(as mentioned above) A/V inputs</blockquote></div></div><div><br>Well, I patched it, make clean, make, make install, and a reboot.<br><br>BUG: unable to handle kernel NULL pointer dereference at 00000168<br>IP: [&lt;f0e2571c&gt;] :cx23885:mpeg_open+0x41/0xc0<div class="Ih2E3d">
<br>
*pde = 00000000<br>Oops: 0000 [#1] SMP<br></div>Modules linked in: cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 xfs loop dm_mod cx25840 mt2131 s5h1409 cx23885 v4l2_compat_ioctl32 nvidia(P) snd_mpu401 cx2341x videobuf_dma_sg videobuf_dvb dvb_core videobuf_core snd_usb_audio snd_usb_lib snd_cs4232 snd_opl3_lib v4l2_common videodev agpgart snd_hwdep lirc_mceusb2 snd_cs4231_lib snd_mpu401_uart snd_rawmidi snd_hda_intel snd_pcm parport_pc ohci1394 snd_timer k8temp osst v4l1_compat snd_seq_device hwmon snd button i2c_nforce2 lirc_dev parport ieee1394 st forcedeth sr_mod cdrom rtc_cmos rtc_core btcx_risc tveeprom i2c_core snd_page_alloc soundcore rtc_lib sg usbhid hid ff_memless ohci_hcd ehci_hcd usbcore sd_mod edd ext3 mbcache jbd fan aic7xxx scsi_transport_spi sata_nv pata_amd libata scsi_mod dock thermal processor thermal_sys<br>

<br>Pid: 2876, comm: X Tainted: P&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (2.6.27.10-default #3)<br>EIP: 0060:[&lt;f0e2571c&gt;] EFLAGS: 00013287 CPU: 1<br>EIP is at mpeg_open+0x41/0xc0 [cx23885]<br>EAX: 00000000 EBX: ef1fd000 ECX: f0e308a8 EDX: ef3be000<br>

ESI: 00000001 EDI: ef189980 EBP: efba1790 ESP: efe93e84<div class="Ih2E3d"><br>&nbsp;DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068<br></div>Process X (pid: 2876, ti=efe92000 task=ef1e5070 task.ti=efe92000)<br>Stack: efbf5a00 efbf5a04 ef189980 f0d775b8 00000000 ef3876c0 00000000 efba1790<br>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; c016bee5 ef189980 00000000 ef189980 efba1790 00000000 c016bdd9 c01683cd<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ef81ebc0 ef504c6c efe93f14 ef189980 efe93f14 00000003 c01684d8 ef189980<br>Call Trace:<br>&nbsp;[&lt;f0d775b8&gt;] v4l2_open+0x62/0x76 [videodev]<div class="Ih2E3d">
<br>
&nbsp;[&lt;c016bee5&gt;] chrdev_open+0x10c/0x122<br>&nbsp;[&lt;c016bdd9&gt;] chrdev_open+0x0/0x122<br>&nbsp;[&lt;c01683cd&gt;] __dentry_open+0x10d/0x1fc<br>&nbsp;[&lt;c01684d8&gt;] nameidata_to_filp+0x1c/0x2c<br>&nbsp;[&lt;c0172986&gt;] do_filp_open+0x33d/0x63e<br>
</div>
&nbsp;[&lt;f1aad8ce&gt;] _nv004117rm+0x9/0x12 [nvidia]<div class="Ih2E3d"><br>&nbsp;[&lt;c01582f8&gt;] handle_mm_fault+0x2b3/0x5dd<br></div>&nbsp;[&lt;f0dcf391&gt;] __videobuf_mmap_free+0x3e/0x7d [videobuf_core]<div class="Ih2E3d"><br>
&nbsp;[&lt;c017ab2d&gt;] alloc_fd+0x57/0xd3<br>&nbsp;[&lt;c01681e8&gt;] do_sys_open+0x3f/0xb8<br>
&nbsp;[&lt;c01682a5&gt;] sys_open+0x1e/0x23<br>&nbsp;[&lt;c01037ad&gt;] sysenter_do_call+0x12/0x21<br>&nbsp;=======================<br></div>Code: 17 68 38 7a e2 f0 68 c8 0a 00 00 68 ee a2 e2 f0 e8 51 aa 2f cf 83 c4 0c e8 88 66 49 cf 8b 1d a0 fd e2 f0 eb 10 8b 83 c4 0e 00 00 &lt;39&gt; b0 68 01 00 00 74 1c 89 d3 8b 13 0f 18 02 90 81 fb a0 fd e2<br>

EIP: [&lt;f0e2571c&gt;] mpeg_open+0x41/0xc0 [cx23885] SS:ESP 0068:efe93e84<br>---[ end trace 1bdce38cbcdc8781 ]---<br>&nbsp;<br></div></div><br>
</blockquote></div><br>It&#39;s working!<br><br>I had to change cx23885-417.c to the same if statement in mpeg_open.<br><br>-Mark<br>

------=_Part_167429_24939655.1230843477529--


--===============2065358861==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2065358861==--
