Return-path: <linux-media-owner@vger.kernel.org>
Received: from persephone.nexusuk.org ([217.172.134.9]:50963 "EHLO nexusuk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab2HFO0U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 10:26:20 -0400
Message-ID: <501C02C9.6010902@nexusuk.org>
Date: Fri, 03 Aug 2012 17:56:41 +0100
From: Steve Hill <steve@nexusuk.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: pctv452e
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi>
In-Reply-To: <4FF46DC4.4070204@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/07/12 17:22, Antti Palosaari wrote:

>>  > As the new DVB-USB fixes many bugs I ask you to test it. I converted
>>  > pctv452e driver for you:
>> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/pctv452e

I've had chance to give this kernel a go.  Unfortunately I'm getting an 
(unrelated) crash, which appears to be caused by IP forwarding.  The 
crash basically makes it unusable so I'm not actually able to test the 
PCTV driver. :(

I'll add the stack trace here for reference, although as mentioned, it 
doesn't appear to be related to the DVB drivers:

[  126.188809] ------------[ cut here ]------------
[  126.193455] kernel BUG at mm/slab.c:505!
[  126.197388] Internal error: Oops - BUG: 0 [#1] ARM
[  126.202191] Modules linked in: ctr twofish_generic twofish_common 
camellia_generic serpent_generic blowfish_generic blowfish_common cao
[  126.261699] CPU: 0    Not tainted  (3.5.0-rc5+ #1)
[  126.266510] PC is at kfree+0xa0/0xfc
[  126.270096] LR is at __kfree_skb+0x14/0xbc
[  126.274204] pc : [<c00c991c>]    lr : [<c0275a20>]    psr: 40000093
[  126.274204] sp : deadbb20  ip : 000000ff  fp : deadbba4
[  126.285729] r10: c045b0a4  r9 : 00000000  r8 : 00000001
[  126.290971] r7 : 00000000  r6 : a0000013  r5 : de2e7034  r4 : de2e7000
[  126.297519] r3 : c08bdce0  r2 : 00000000  r1 : 00000000  r0 : de2e7000
[  126.304069] Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM 
Segment user
[  126.311315] Control: 0005397f  Table: 1eac8000  DAC: 00000015
[  126.317078] Process tput (pid: 1411, stack limit = 0xdeada270)
[  126.322930] Stack: (0xdeadbb20 to 0xdeadc000)
[  126.327304] bb20: de11a5e0 de2e7034 00000003 c0275a20 de11a5e0 
c02aa448 ded95000 00012c9f
[  126.335518] bb40: 00000000 de11a5e0 de2e7034 de11a5e0 de2e7034 
deadbba4 00000008 00000000
[  126.343732] bb60: c048e8c0 c02a885c ded95000 00000001 00000002 
c045b084 df904000 deadbba4
[  126.351946] bb80: 00000008 c027d77c 00000000 00000000 00000000 
c04915f4 00000000 de11a5e0
[  126.360161] bba0: deada000 c045b0a4 c08bdce0 de11a5e0 2fcded46 
df9045dc df904000 00008000
[  126.368374] bbc0: 00000000 df904460 00000000 bf01c054 00000000 
00000005 00000000 df904460
[  126.376588] bbe0: 00000000 00000010 df90454c 00000080 df9059b0 
00000000 df904600 00000000
[  126.384802] bc00: def2be38 df90454c c0492360 00000001 c04b5bc0 
0000012c 00000000 00000080
[  126.393017] bc20: c0492368 c027db90 c04b5bcc ffffb3c1 c04b5bcc 
deada000 00000001 0000000c
[  126.401232] bc40: c04b5bc0 00000003 00000100 c0491bcc c0468944 
c0025f68 00000000 c046a7f0
[  126.409446] bc60: 00000000 0000000a deadbcdc 0000000b 00000000 
fed20200 deadbcdc c04915f4
[  126.417660] bc80: 00000000 c0491bcc 000200da c002618c 0000000b 
c000f850 c009c228 40000013
[  126.425874] bca0: fed20200 c000e574 c04915f4 00000000 00000385 
00000004 00000041 00000000
[  126.434089] bcc0: a18a4473 00000002 c04915f4 00000000 c0491bcc 
000200da 0001bc8c deadbcf4
[  126.442303] bce0: c009c28c c009c228 40000013 ffffffff 00000000 
00000000 deada000 c009c28c
[  126.450516] bd00: 00000041 0001bc8c 00000385 c009e830 00000041 
00000000 00000002 00000001
[  126.458732] bd20: 00000018 ffffffff c0491bd0 00000000 00000000 
deada000 c04915f4 00000002
[  126.466945] bd40: 00000000 00000000 deadbd8c c04915f4 00000122 
000200da deada000 00000000
[  126.475159] bd60: 00000002 def2be38 00000000 c0491bcc 00000001 
c009eebc 00000001 00000041
[  126.483374] bd80: c04915f4 00000002 dedb41c0 de0e50f8 00000100 
00000000 00000000 df48d868
[  126.491587] bda0: 00000002 0000002a de42ae04 dee49b78 c0491bd0 
00000200 00000000 000200da
[  126.499801] bdc0: 00000010 00000000 00000000 c00b5234 de87b69c 
00000000 00000028 0000002a
[  126.508016] bde0: c04915f4 c0527580 def2be38 def2be38 00000001 
bea81000 de9a3204 def2be38
[  126.516230] be00: 00000000 de42aca0 deacafa8 c00b6f94 0000002a 
00000028 00000000 00000000
[  126.524445] be20: 00000000 deada000 b6d7b000 00000000 00000000 
00000000 deadbe78 bea81000
[  126.532659] be40: deac8000 000005f5 de42aca0 def2be38 00000029 
deacafa8 00000000 c00b76ec
[  126.540874] be60: deacafa8 00000029 deadbfb0 bea81c34 def2be38 
def2eb60 de42aca0 00000029
[  126.549088] be80: 00000817 c0015548 deadbf08 b6efb000 deadbf08 
c00b8390 de42acd4 00000000
[  126.557302] bea0: deacadb8 de42aca0 b6efafff b6efb000 df59f1c8 
df59f1a4 b6eed000 00000000
[  126.565517] bec0: b6efb000 b6eed000 deadbf08 de0fa548 df9af70c 
b6eed000 00000000 c08cd1c0
[  126.573730] bee0: 00000000 c08cd1c0 00000000 00000817 c045e414 
bea81c34 deadbfb0 00000000
[  126.581944] bf00: 00000000 b6f20000 00000000 c0008404 ffffffff 
ffffffff 00000000 c00d5018
[  126.590158] bf20: 00000000 00000000 0000017d 00000000 de0fa548 
00000000 00000000 de0fa548
[  126.598373] bf40: 00000000 b6efb000 b6eed000 c00ba184 de42aca0 
de0fa548 00000000 c00bb3c4
[  126.606588] bf60: b6efb000 b6eed000 0000d71f de42acd4 00000000 
b6eed000 de42aca0 c000eae8
[  126.614802] bf80: deada000 00000000 bea83aec c00bb450 b6f20000 
000008b4 00000000 00008bd4
[  126.623016] bfa0: 60000010 ffffffff 00000000 c000e6dc bea83ef5 
bea83df4 bea83e04 000097cc
[  126.631230] bfc0: 00000000 bea83df4 00000003 00000000 00000000 
00000000 b6f20000 00000000
[  126.639445] bfe0: 00011f14 bea81c38 000097e8 00008bd4 60000010 
ffffffff 1fffe831 1fffec31
[  126.647667] [<c00c991c>] (kfree+0xa0/0xfc) from [<c0275a20>] 
(__kfree_skb+0x14/0xbc)
[  126.655448] [<c0275a20>] (__kfree_skb+0x14/0xbc) from [<c02aa448>] 
(ip_forward+0x378/0x3a8)
[  126.663835] [<c02aa448>] (ip_forward+0x378/0x3a8) from [<c02a885c>] 
(ip_rcv_finish+0x324/0x340)
[  126.672576] [<c02a885c>] (ip_rcv_finish+0x324/0x340) from 
[<c027d77c>] (__netif_receive_skb+0x540/0x5ac)
[  126.682131] [<c027d77c>] (__netif_receive_skb+0x540/0x5ac) from 
[<bf01c054>] (mv643xx_eth_poll+0x518/0x6b4 [mv643xx_eth])
[  126.693167] [<bf01c054>] (mv643xx_eth_poll+0x518/0x6b4 [mv643xx_eth]) 
from [<c027db90>] (net_rx_action+0x94/0x1f0)
[  126.703570] [<c027db90>] (net_rx_action+0x94/0x1f0) from [<c0025f68>] 
(__do_softirq+0xbc/0x1a4)
[  126.712313] [<c0025f68>] (__do_softirq+0xbc/0x1a4) from [<c002618c>] 
(irq_exit+0x40/0x8c)
[  126.720528] [<c002618c>] (irq_exit+0x40/0x8c) from [<c000f850>] 
(handle_IRQ+0x64/0x84)
[  126.728487] [<c000f850>] (handle_IRQ+0x64/0x84) from [<c000e574>] 
(__irq_svc+0x34/0x80)
[  126.736532] [<c000e574>] (__irq_svc+0x34/0x80) from [<c009c228>] 
(__zone_watermark_ok+0x44/0x90)
[  126.745362] [<c009c228>] (__zone_watermark_ok+0x44/0x90) from 
[<c009c28c>] (zone_watermark_ok+0x18/0x1c)
[  126.754892] [<c009c28c>] (zone_watermark_ok+0x18/0x1c) from 
[<c009e830>] (get_page_from_freelist+0x108/0x4c4)
[  126.764848] [<c009e830>] (get_page_from_freelist+0x108/0x4c4) from 
[<c009eebc>] (__alloc_pages_nodemask+0x124/0x708)
[  126.775421] [<c009eebc>] (__alloc_pages_nodemask+0x124/0x708) from 
[<c00b6f94>] (handle_pte_fault+0x130/0x7c4)
[  126.785472] [<c00b6f94>] (handle_pte_fault+0x130/0x7c4) from 
[<c00b76ec>] (handle_mm_fault+0xc4/0xd8)
[  126.794734] [<c00b76ec>] (handle_mm_fault+0xc4/0xd8) from 
[<c0015548>] (do_page_fault+0x118/0x350)
[  126.803731] [<c0015548>] (do_page_fault+0x118/0x350) from 
[<c0008404>] (do_DataAbort+0x34/0x94)
[  126.812468] [<c0008404>] (do_DataAbort+0x34/0x94) from [<c000e6dc>] 
(__dabt_usr+0x3c/0x40)
[  126.820762] Exception stack(0xdeadbfb0 to 0xdeadbff8)
[  126.825832] bfa0:                                     bea83ef5 
bea83df4 bea83e04 000097cc
[  126.834048] bfc0: 00000000 bea83df4 00000003 00000000 00000000 
00000000 b6f20000 00000000
[  126.842261] bfe0: 00011f14 bea81c38 000097e8 00008bd4 60000010 ffffffff
[  126.848906] Code: 1593301c e5932000 e3120080 1a000001 (e7f001f2)
[  126.855197] ---[ end trace d168049a4ee673fb ]---
[  126.859850] Kernel panic - not syncing: Fatal exception in interrupt



-- 

  - Steve
