Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbZE1HFW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 03:05:22 -0400
Date: Thu, 28 May 2009 00:05:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, mrb74@gmx.at
Subject: Re: [Bugme-new] [Bug 13316] New: task khubd:281 blocked for more
 than 120 seconds
Message-Id: <20090528000516.6de719af.akpm@linux-foundation.org>
In-Reply-To: <bug-13316-10286@http.bugzilla.kernel.org/>
References: <bug-13316-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Fri, 15 May 2009 17:46:49 GMT bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13316
> 
>            Summary: task khubd:281 blocked for more than 120 seconds
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 2.6.30-rc5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: USB
>         AssignedTo: greg@kroah.com
>         ReportedBy: mrb74@gmx.at
>         Regression: No
> 
> 
> When unplugging the dvb-t device while using it (running me-tv) I got the
> following syslog output:
> 
> May 15 19:35:42 jupiter kernel: [ 6601.222871] INFO: task khubd:281 blocked for
> more than 120 seconds.
> May 15 19:35:42 jupiter kernel: [ 6601.222890] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> May 15 19:35:42 jupiter kernel: [ 6601.222906] khubd         D 000005e3     0  
> 281      2
> May 15 19:35:42 jupiter kernel: [ 6601.222932]  f71b3e30 00000046 bc40db98
> 000005e3 f0ce8000 f71b3dd0 c08e0510 c08a8dc0
> May 15 19:35:42 jupiter kernel: [ 6601.222982]  c08a8dc0 00000000 f256fab8
> f71994e0 f7199774 c2225dc0 00000000 c014046b
> May 15 19:35:42 jupiter kernel: [ 6601.223030]  bc414f32 000005e3 f256fab8
> ffffffff 00000000 00000046 f71b3e14 f256faa8
> May 15 19:35:42 jupiter kernel: [ 6601.223077] Call Trace:
> May 15 19:35:42 jupiter kernel: [ 6601.223112]  [<c014046b>] ?
> prepare_to_wait+0x14/0x48
> May 15 19:35:42 jupiter kernel: [ 6601.223136]  [<c014d665>] ?
> trace_hardirqs_on+0xb/0xd
> May 15 19:35:42 jupiter kernel: [ 6601.223160]  [<c04c9459>] ?
> _spin_unlock_irqrestore+0x5f/0x6c
> May 15 19:35:42 jupiter kernel: [ 6601.223181]  [<c04c7833>] schedule+0x12/0x33
> May 15 19:35:42 jupiter kernel: [ 6601.223235]  [<f8a989b2>]
> dvb_unregister_frontend+0x99/0xd3 [dvb_core]
> May 15 19:35:42 jupiter kernel: [ 6601.223258]  [<c01402db>] ?
> autoremove_wake_function+0x0/0x33
> May 15 19:35:42 jupiter kernel: [ 6601.223290]  [<f83f8b81>]
> dvb_usb_adapter_frontend_exit+0x15/0x25 [dvb_usb]
> May 15 19:35:42 jupiter kernel: [ 6601.223318]  [<f83f82f8>]
> dvb_usb_exit+0x2c/0x93 [dvb_usb]
> May 15 19:35:42 jupiter kernel: [ 6601.223345]  [<f83f8394>]
> dvb_usb_device_exit+0x35/0x47 [dvb_usb]
> May 15 19:35:42 jupiter kernel: [ 6601.223369]  [<c03a2cdc>]
> usb_unbind_interface+0x4d/0xc4
> May 15 19:35:42 jupiter kernel: [ 6601.223393]  [<c0348252>]
> __device_release_driver+0x5a/0x77
> May 15 19:35:42 jupiter kernel: [ 6601.223413]  [<c034830c>]
> device_release_driver+0x18/0x23
> May 15 19:35:42 jupiter kernel: [ 6601.223433]  [<c0347adc>]
> bus_remove_device+0x71/0x88
> May 15 19:35:42 jupiter kernel: [ 6601.223453]  [<c034679a>]
> device_del+0xf9/0x152
> May 15 19:35:42 jupiter kernel: [ 6601.223473]  [<c03a092f>]
> usb_disable_device+0x5c/0xba
> May 15 19:35:42 jupiter kernel: [ 6601.223493]  [<c039c9e9>]
> usb_disconnect+0x73/0xdc
> May 15 19:35:42 jupiter kernel: [ 6601.223564]  [<c039d7a8>]
> hub_thread+0x548/0xdf8
> May 15 19:35:42 jupiter kernel: [ 6601.223601]  [<c014d639>] ?
> trace_hardirqs_on_caller+0x103/0x124
> May 15 19:35:42 jupiter kernel: [ 6601.223632]  [<c01402db>] ?
> autoremove_wake_function+0x0/0x33
> May 15 19:35:42 jupiter kernel: [ 6601.223660]  [<c039d260>] ?
> hub_thread+0x0/0xdf8
> May 15 19:35:42 jupiter kernel: [ 6601.223685]  [<c039d260>] ?
> hub_thread+0x0/0xdf8
> May 15 19:35:42 jupiter kernel: [ 6601.223714]  [<c013ffb6>] kthread+0x45/0x6b
> May 15 19:35:42 jupiter kernel: [ 6601.223744]  [<c013ff71>] ? kthread+0x0/0x6b
> May 15 19:35:42 jupiter kernel: [ 6601.223777]  [<c01037e7>]
> kernel_thread_helper+0x7/0x10
> May 15 19:35:42 jupiter kernel: [ 6601.223796] INFO: lockdep is turned off.
> 

Oh my, that wordwrapping is painful :( You're better off using
attachments with bugzilla.

Could be a USB bug, could be a DVB bug.  I'd guess DVB.  Both lists
cc'ed for disposition, please.

