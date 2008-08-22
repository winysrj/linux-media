Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1KWTZD-0004Uh-Pk
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 12:08:28 +0200
Received: by yx-out-2324.google.com with SMTP id 8so187786yxg.41
	for <linux-dvb@linuxtv.org>; Fri, 22 Aug 2008 03:08:23 -0700 (PDT)
Message-ID: <617be8890808220308g7d0769dfl60e621543f4db36f@mail.gmail.com>
Date: Fri, 22 Aug 2008 12:08:23 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] New firmware for dib0700 (Nova-T-500 and others)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1457231110=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1457231110==
Content-Type: multipart/alternative;
	boundary="----=_Part_47640_24235284.1219399703256"

------=_Part_47640_24235284.1219399703256
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>
> ---------- Missatge reenviat ----------
> From: thomas schorpp <thomas.schorpp@googlemail.com>
> To: linux-dvb <linux-dvb@linuxtv.org>
> Date: Fri, 22 Aug 2008 11:41:49 +0200
> Subject: Re: [linux-dvb] New firmware for dib0700 (Nova-T-500 and others)
> Nicolas Will wrote:
>
>> All,
>>
>> There is a new firmware file fixing the last cause for i2c errors and
>> disconnects and providing a new, more modular i2c request formatting.
>>
>>
> this is not firmware since it does not occur with the "other OS" and it's
> gone better upgrading 2.6.24->2.6.26.2 but the driver is still buggy:
>
> do lsusb and...
>
> INFO: task khubd:1966 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> khubd         D ffff81003dca9bc0     0  1966      2
> ffff81003dca9bb0 0000000000000046 ffff81003eeb6220 ffff81003f0ea7d0
> ffff81003eeb6478 ffff81003eeb6478 ffff81003dca9b90 ffffffff80245e8f
> ffff81003dca9bb0 ffff81003dd33800 ffff81003dca9bc0 0000000000000000
> Call Trace:
> [<ffffffff80245e8f>] ? kthread_stop+0x7f/0x90
> [<ffffffffa0099645>] :dvb_core:dvb_unregister_frontend+0xb5/0x100
> [<ffffffff80246150>] ? autoremove_wake_function+0x0/0x40
> [<ffffffffa021bf0d>] :dvb_usb:dvb_usb_adapter_frontend_exit+0x1d/0x40
> [<ffffffffa021b42c>] :dvb_usb:dvb_usb_exit+0x4c/0xe0
> [<ffffffffa021b505>] :dvb_usb:dvb_usb_device_exit+0x45/0x60
> [<ffffffffa00f3e47>] :usbcore:usb_unbind_interface+0x47/0x90
> [<ffffffff804cd57d>] __device_release_driver+0x9d/0xe0
> [<ffffffff804cd70b>] device_release_driver+0x2b/0x40
> [<ffffffff804cc9e5>] bus_remove_device+0xb5/0xf0
> [<ffffffff804cb133>] device_del+0x123/0x190
> [<ffffffffa00f1054>] :usbcore:usb_disable_device+0x94/0x120
> [<ffffffffa00ec233>] :usbcore:usb_disconnect+0xb3/0x140
> [<ffffffffa00ecf2e>] :usbcore:hub_thread+0x37e/0x1210
> [<ffffffff80209ccf>] ? __switch_to+0x1f/0x3b0
> [<ffffffff80246150>] ? autoremove_wake_function+0x0/0x40
> [<ffffffffa00ecbb0>] ? :usbcore:hub_thread+0x0/0x1210
> [<ffffffff80245bd9>] kthread+0x49/0x80
> [<ffffffff8020c1e8>] child_rip+0xa/0x12
> [<ffffffff80245b90>] ? kthread+0x0/0x80
> [<ffffffff8020c1de>] ? child_rip+0x0/0x12
>
> y
> tom
>


By the reports here it seems better to wait and keep using the old 1.10
file, which has been rock solid these last months.
By the way, could you confirm also the continuos reboots that Nicolas told
us about with this file?

Regards,
   Eduard Huguet

------=_Part_47640_24235284.1219399703256
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">---------- Missatge reenviat ----------<br>From:&nbsp;thomas schorpp &lt;<a href="mailto:thomas.schorpp@googlemail.com">thomas.schorpp@googlemail.com</a>&gt;<br>
To:&nbsp;linux-dvb &lt;<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>&gt;<br>Date:&nbsp;Fri, 22 Aug 2008 11:41:49 +0200<br>Subject:&nbsp;Re: [linux-dvb] New firmware for dib0700 (Nova-T-500 and others)<br>Nicolas Will wrote:<br>

<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
All,<br>
<br>
There is a new firmware file fixing the last cause for i2c errors and<br>
disconnects and providing a new, more modular i2c request formatting.<br>
<br>
</blockquote>
<br>
this is not firmware since it does not occur with the &quot;other OS&quot; and it&#39;s gone better upgrading 2.6.24-&gt;<a href="http://2.6.26.2" target="_blank">2.6.26.2</a> but the driver is still buggy:<br>
<br>
do lsusb and...<br>
<br>
INFO: task khubd:1966 blocked for more than 120 seconds.<br>
&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disables this message.<br>
khubd &nbsp; &nbsp; &nbsp; &nbsp; D ffff81003dca9bc0 &nbsp; &nbsp; 0 &nbsp;1966 &nbsp; &nbsp; &nbsp;2<br>
ffff81003dca9bb0 0000000000000046 ffff81003eeb6220 ffff81003f0ea7d0<br>
ffff81003eeb6478 ffff81003eeb6478 ffff81003dca9b90 ffffffff80245e8f<br>
ffff81003dca9bb0 ffff81003dd33800 ffff81003dca9bc0 0000000000000000<br>
Call Trace:<br>
[&lt;ffffffff80245e8f&gt;] ? kthread_stop+0x7f/0x90<br>
[&lt;ffffffffa0099645&gt;] :dvb_core:dvb_unregister_frontend+0xb5/0x100<br>
[&lt;ffffffff80246150&gt;] ? autoremove_wake_function+0x0/0x40<br>
[&lt;ffffffffa021bf0d&gt;] :dvb_usb:dvb_usb_adapter_frontend_exit+0x1d/0x40<br>
[&lt;ffffffffa021b42c&gt;] :dvb_usb:dvb_usb_exit+0x4c/0xe0<br>
[&lt;ffffffffa021b505&gt;] :dvb_usb:dvb_usb_device_exit+0x45/0x60<br>
[&lt;ffffffffa00f3e47&gt;] :usbcore:usb_unbind_interface+0x47/0x90<br>
[&lt;ffffffff804cd57d&gt;] __device_release_driver+0x9d/0xe0<br>
[&lt;ffffffff804cd70b&gt;] device_release_driver+0x2b/0x40<br>
[&lt;ffffffff804cc9e5&gt;] bus_remove_device+0xb5/0xf0<br>
[&lt;ffffffff804cb133&gt;] device_del+0x123/0x190<br>
[&lt;ffffffffa00f1054&gt;] :usbcore:usb_disable_device+0x94/0x120<br>
[&lt;ffffffffa00ec233&gt;] :usbcore:usb_disconnect+0xb3/0x140<br>
[&lt;ffffffffa00ecf2e&gt;] :usbcore:hub_thread+0x37e/0x1210<br>
[&lt;ffffffff80209ccf&gt;] ? __switch_to+0x1f/0x3b0<br>
[&lt;ffffffff80246150&gt;] ? autoremove_wake_function+0x0/0x40<br>
[&lt;ffffffffa00ecbb0&gt;] ? :usbcore:hub_thread+0x0/0x1210<br>
[&lt;ffffffff80245bd9&gt;] kthread+0x49/0x80<br>
[&lt;ffffffff8020c1e8&gt;] child_rip+0xa/0x12<br>
[&lt;ffffffff80245b90&gt;] ? kthread+0x0/0x80<br>
[&lt;ffffffff8020c1de&gt;] ? child_rip+0x0/0x12<br>
<br>
y<br>
tom<br>
</blockquote></div><br><br>By the reports here it seems better to wait and keep using the old 1.10 file, which has been rock solid these last months.<br>By the way, could you confirm also the continuos reboots that Nicolas told us about with this file?<br>
<br>Regards, <br>&nbsp;&nbsp; Eduard Huguet<br><br><br><br><br></div>

------=_Part_47640_24235284.1219399703256--


--===============1457231110==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1457231110==--
