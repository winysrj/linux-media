Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45214 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005AbaDBKqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Apr 2014 06:46:39 -0400
Message-ID: <1396435596.3989.21.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: 3.15 & Bonding
From: Eric Dumazet <eric.dumazet@gmail.com>
To: poma <pomidorabelisima@gmail.com>
Cc: Thomas Davis <tadavis@lbl.gov>, Tom Gundersen <teg@jklm.no>,
	Dan Williams <dcbw@redhat.com>, netdev@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Date: Wed, 02 Apr 2014 03:46:36 -0700
In-Reply-To: <533BE2F8.5040903@gmail.com>
References: <533BE2F8.5040903@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2014-04-02 at 12:14 +0200, poma wrote:
> Are you all all right?
> New Tour de Bugs...
> 
> /sys/devices/virtual/net/bond0/bonding/mode:
> active-backup 1
> 
> - systemd-networkd
> dmesg:
> BUG: sleeping function called from invalid context at mm/slub.c:965
> in_atomic(): 1, irqs_disabled(): 0, pid: 593, name: systemd-network
> 2 locks held by systemd-network/593:
>  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff8169e57b>] rtnetlink_rcv+0x1b/0x40
>  #1:  (&bond->curr_slave_lock){+...+.}, at: [<ffffffffa0487291>]
> bond_enslave+0xf31/0xf50 [bonding]
> CPU: 2 PID: 593 Comm: systemd-network Not tainted
> 3.15.0-0.rc0.git2.1.fc21.x86_64 #1
> Call Trace:
> dump_stack+0x4d/0x66
> __might_sleep+0x17e/0x230
> kmem_cache_alloc_node+0x4a/0x390
>  [<ffffffff816779dd>] __alloc_skb+0x5d/0x2d0
>  [<ffffffff816a0bd8>] rtmsg_ifinfo+0x48/0x110
>  [<ffffffff810fa18d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff8109dd45>] ? __local_bh_enable_ip+0x75/0xe0
>  [<ffffffffa0485ca7>] bond_change_active_slave+0x197/0x670 [bonding]
>  [<ffffffffa0486264>] bond_select_active_slave+0xe4/0x1e0 [bonding]
>  [<ffffffffa048729a>] bond_enslave+0xf3a/0xf50 [bonding]
>  [<ffffffff8169fdf2>] do_setlink+0xa02/0xa70
>  [<ffffffff813f4fc6>] ? nla_parse+0x96/0xe0
>  [<ffffffff816a0da1>] rtnl_setlink+0xc1/0x130
>  [<ffffffff810a1739>] ? ns_capable+0x39/0x70
>  [<ffffffff8169e64b>] rtnetlink_rcv_msg+0xab/0x270
>  [<ffffffff8169e57b>] ? rtnetlink_rcv+0x1b/0x40
>  [<ffffffff8169e57b>] ? rtnetlink_rcv+0x1b/0x40
>  [<ffffffff8169e5a0>] ? rtnetlink_rcv+0x40/0x40
>  [<ffffffff816c3e29>] netlink_rcv_skb+0xa9/0xc0
>  [<ffffffff8169e58a>] rtnetlink_rcv+0x2a/0x40
>  [<ffffffff816c3420>] netlink_unicast+0x100/0x1e0
>  [<ffffffff816c3847>] netlink_sendmsg+0x347/0x770
>  [<ffffffff8166c78c>] sock_sendmsg+0x9c/0xe0
>  [<ffffffff811de22f>] ? might_fault+0x5f/0xb0
>  [<ffffffff811de278>] ? might_fault+0xa8/0xb0
>  [<ffffffff811de22f>] ? might_fault+0x5f/0xb0
>  [<ffffffff8166cd04>] SYSC_sendto+0x124/0x1d0
>  [<ffffffff81024879>] ? sched_clock+0x9/0x10
>  [<ffffffff810ddb75>] ? local_clock+0x25/0x30
>  [<ffffffff8111cfc9>] ? current_kernel_time+0x69/0xd0
>  [<ffffffff810fa0b5>] ? trace_hardirqs_on_caller+0x105/0x1d0
>  [<ffffffff810fa18d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff8166dede>] SyS_sendto+0xe/0x10
>  [<ffffffff817e79a9>] system_call_fastpath+0x16/0x1b

Should be fixed by

commit 072256d1f2b8ba0bbb265d590c703f3d57a39d6a
Author: Veaceslav Falico <vfalico@redhat.com>
Date:   Thu Mar 6 15:33:22 2014 +0100

    bonding: make slave status notifications GFP_ATOMIC
    


