Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174Ab0DZWUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 18:20:25 -0400
Date: Mon, 26 Apr 2010 15:19:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, linux-media@vger.kernel.org,
	bugzilla.kernel.org@boris64.net
Subject: Re: [Bugme-new] [Bug 15826] New: WARNING: at fs/proc/generic.c:317
 __xlate_proc_name+0xbd/0xe0()
Message-Id: <20100426151933.87e82353.akpm@linux-foundation.org>
In-Reply-To: <bug-15826-10286@https.bugzilla.kernel.org/>
References: <bug-15826-10286@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Wed, 21 Apr 2010 12:21:18 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=15826
> 
>            Summary: WARNING: at fs/proc/generic.c:317
>                     __xlate_proc_name+0xbd/0xe0()
>            Product: v4l-dvb
>            Version: unspecified
>     Kernel Version: 2.6.34-rc5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: dvb-core
>         AssignedTo: v4l-dvb_dvb-core@kernel-bugs.osdl.org
>         ReportedBy: bugzilla.kernel.org@boris64.net
>         Regression: No
> 
> 
> Created an attachment (id=26077)
>  --> (https://bugzilla.kernel.org/attachment.cgi?id=26077)
> full dmesg
> 
> I keep getting this warning on boot. It seems to
> happen when the dvb driver for my "technisat skystar2"
> card is loaded (correct me if i'm wrong).
> 
> If you need more infos or debug stuff inside 
> my kernel config, please tell me what i need to include.
> 
> Thank you in advance.
> 
> ----------------------------------------
> ...
> [    0.739420] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip
> loaded successfully
> [    0.739435] flexcop-pci: will use the HW PID filter.
> [    0.739438] flexcop-pci: card revision 2
> [    0.739442] b2c2_flexcop_pci 0000:04:01.0: PCI INT A -> GSI 17 (level, low)
> -> IRQ 17
> [    0.739459] ------------[ cut here ]------------
> [    0.739463] WARNING: at fs/proc/generic.c:317 __xlate_proc_name+0xbd/0xe0()

Alexey, this sucks.  A developer goes to the warning site:

static int __xlate_proc_name(const char *name, struct proc_dir_entry **ret,
			     const char **residual)
{
	const char     		*cp = name, *next;
	struct proc_dir_entry	*de;
	int			len;

	de = *ret;
	if (!de)
		de = &proc_root;

	while (1) {
		next = strchr(cp, '/');
		if (!next)
			break;

		len = next - cp;
		for (de = de->subdir; de ; de = de->next) {
			if (proc_match(len, cp, de))
				break;
		}
		if (!de) {
			WARN(1, "name '%s'\n", name);
			return -ENOENT;
		}
		cp += len + 1;
	}
	*residual = cp;
	*ret = de;
	return 0;
}

and there's no hint whatsoever to tell him what the warning means, nor
how to fix it.

Please send a patch adding a nice comment to __xlate_proc_name().  Then
perhaps the DVB guys have a chance of fixing this bug.

Thanks.


> [    0.739465] Hardware name: P5K
> [    0.739466] name 'Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver'
> [    0.739467] Modules linked in:
> [    0.739470] Pid: 1, comm: swapper Not tainted 2.6.34-rc5-v2k11+-dbg-dirty
> #118
> [    0.739471] Call Trace:
> [    0.739476]  [<ffffffff8103e386>] warn_slowpath_common+0x76/0xb0
> [    0.739478]  [<ffffffff8103e41c>] warn_slowpath_fmt+0x3c/0x40
> [    0.739481]  [<ffffffff8110b4ad>] __xlate_proc_name+0xbd/0xe0
> [    0.739483]  [<ffffffff8110b540>] __proc_create+0x70/0x140
> [    0.739486]  [<ffffffff8110bf49>] proc_mkdir_mode+0x29/0x60
> [    0.739488]  [<ffffffff8110bf91>] proc_mkdir+0x11/0x20
> [    0.739491]  [<ffffffff8107b39b>] register_handler_proc+0x11b/0x140
> [    0.739494]  [<ffffffff810791f9>] __setup_irq+0x1f9/0x390
> [    0.739497]  [<ffffffff813ca790>] ? flexcop_pci_isr+0x0/0x3e0
> [    0.739500]  [<ffffffff810794bc>] request_threaded_irq+0x12c/0x210
> [    0.739502]  [<ffffffff813cad20>] flexcop_pci_probe+0x1b0/0x350
> [    0.739505]  [<ffffffff811e4ee5>] pci_device_probe+0x75/0xa0
> [    0.739509]  [<ffffffff8130522a>] ? driver_sysfs_add+0x5a/0x90
> [    0.739511]  [<ffffffff813054f3>] driver_probe_device+0x93/0x1a0
> [    0.739514]  [<ffffffff8130569b>] __driver_attach+0x9b/0xa0
> [    0.739517]  [<ffffffff81305600>] ? __driver_attach+0x0/0xa0
> [    0.739519]  [<ffffffff8130460e>] bus_for_each_dev+0x5e/0x90
> [    0.739522]  [<ffffffff813051c9>] driver_attach+0x19/0x20
> [    0.739524]  [<ffffffff81304d62>] bus_add_driver+0xb2/0x260
> [    0.739527]  [<ffffffff8130590f>] driver_register+0x6f/0x130
> [    0.739529]  [<ffffffff811e5171>] __pci_register_driver+0x51/0xd0
> [    0.739533]  [<ffffffff818f49a9>] ? flexcop_pci_module_init+0x0/0x1b
> [    0.739535]  [<ffffffff818f49c2>] flexcop_pci_module_init+0x19/0x1b
> [    0.739538]  [<ffffffff810002d9>] do_one_initcall+0x39/0x1a0
> [    0.739540]  [<ffffffff818d1cc4>] kernel_init+0x14d/0x1d7
> [    0.739543]  [<ffffffff81003194>] kernel_thread_helper+0x4/0x10
> [    0.739546]  [<ffffffff818d1b77>] ? kernel_init+0x0/0x1d7
> [    0.739548]  [<ffffffff81003190>] ? kernel_thread_helper+0x0/0x10
> [    0.739553] ---[ end trace 4e6b2faee55cb1bf ]---
> [    0.744389] DVB: registering new adapter (FlexCop Digital TV device)
> [    0.746102] b2c2-flexcop: MAC address = 00:d0:d7:0f:30:58
> [    0.946350] b2c2-flexcop: found 'ST STV0299 DVB-S' .
> [    0.946353] DVB: registering adapter 0 frontend 0 (ST STV0299 DVB-S)...
> [    0.946422] b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 DVB-S rev 2.6'
> at the 'PCI' bus controlled by a 'FlexCopIIb' complete

