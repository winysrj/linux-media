Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36569 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbbAMQHl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 11:07:41 -0500
Message-ID: <54B542CA.4050900@iki.fi>
Date: Tue, 13 Jan 2015 18:07:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Raimonds Cicans <ray@apollo.lv>, Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [REGRESSION] media: cx23885 broken by commit 453afdd "[media]
 cx23885: convert to vb2"
References: <54B24370.6010004@apollo.lv> <54B3A81F.5030601@xs4all.nl> <54B3E7E4.3050106@apollo.lv>
In-Reply-To: <54B3E7E4.3050106@apollo.lv>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I reported a bit similar looking bug few weeks ago. It could be coming 
from same issue.

cx23885 streaming lockdep error (VB2 related?)
http://www.spinics.net/lists/linux-media/msg84733.html

addition of that lockdep slash I saw many times random lockups and was 
forced to hard boot whole machine.

Antti


On 01/12/2015 05:27 PM, Raimonds Cicans wrote:
> On 12.01.2015 12:55, Hans Verkuil wrote:
>> On 01/11/2015 10:33 AM, Raimonds Cicans wrote:
>>> After upgrade from kernel 3.13.10 (do not have commit) to 3.17.7
>>> (have commit) I started receiving following IOMMU related messages:
>> This makes no sense. The cx23885 driver in 3.17.7 doesn't use vb2.
>>
>> Are you using the media_build repo perhaps to install the latest media
>> drivers on a 3.17 kernel?
>
> Sorry for misinforming you. IMHO I saw somewhere that 453afdd
> was included in 3.17.0-rc_something.
> In last two weeks I did too much tests.
>
> As far as I remember kernel / driver combinations was following
> 3.13.10 built in driver - not affected
> 3.17.7 + https://github.com/ljalves/linux_media (media tree + few new
> TBS open source drivers) - affected
> 3.18.1 + https://github.com/ljalves/linux_media (media tree + few new
> TBS open source drivers) - affected
> 3.19.0-rc3 built in driver (+ few new TBS open source drivers injected
> by https://github.com/bas-t/saa716x-intree) - affected
> Bisection I did on pure 3.13.10 + pure media tree
>
> As you can see bug(s) are kernel version agnostic
>>> 1)
>>> AMD-Vi: Event logged [IO_PAGE_FAULT device=0a:00.0 domain=0x001d
>>> address=0x000000000637c000 flags=0x0000]
>>>
>>> where device=0a:00.0 is TBS6981 card
>>>
>>> sometimes this message was followed by storm of following messages:
>>> cx23885[0]: mpeg risc op code error
>> This looks awfully like the bug that is fixed in commit
>> 7675fe99d280ea83388a4382c54573c80db37cda.
>>
>>> ...
>>>
>>> 2)
>>>    ------------[ cut here ]------------
>>>    WARNING: CPU: 1 PID: 6946 at drivers/iommu/amd_iommu.c:2637
>>> dma_ops_domain_unmap.part.12+0x55/0x72()
>>>    CPU: 1 PID: 6946 Comm: w_scan Tainted: G        W
>>> 3.19.0-rc3-myrc01 #1
>> Hmm, and this says 3.19-rc3.
>>
>> I really need to know what kernel and media drivers you are using!
>>
>
> Look above
>
>>>
>>> Yesterday I did git bisect on Linux media tree (v3.13 - HEAD)
>>> and found that your commit is guilty in the first message.
>> Try with commit 7675fe99d280ea83388a4382c54573c80db37cda.
>
> Did not help. Same errors.
>
>> I think the only relevant bug is #2. Just before Christmas I found some
>> issues with the vb2 threading code, although that was for video output
>> streams,
>> not video capture. But it may well be that similar problems exist for
>> capture.
>>
>> I'll look at that this week or early next week.
>>
>
> I did new checks on 3.18.2 + https://github.com/ljalves/linux_media
> (media tree + few new TBS open source drivers)
> and found strange coincidence:
> I did two tests in following way: started w_scan on first front-end and
> after 5-10 seconds on second
> and after some time received first bug in both tests.
> Than just for fun reversed order.
> I did two tests in following way: started w_scan on second front-end and
> after 5-10 seconds on first
> and after some time received second bug  followed after some time by
> first bug in both tests.
>
> Then I wanted to check following sequences:
> 1) init first front-end -> start scan on second -> start scan on first
> 2) init second front-end -> start scan on first -> start scan on second
>
> By init I mean: run dvb-fe-tool -sDVBS -a0 // or -a1
>
> But on first test of first sequence I received new bug:
> [  369.295899] BUG: unable to handle kernel NULL pointer dereference
> at            (nil)
> [  369.295945] IP: [<ffffffffc05173df>] cx23885_buf_prepare+0x8c/0xa9
> [cx23885]
> [  369.295989] PGD 0
> [  369.296002] Oops: 0000 [#1] SMP
> [  369.296020] Modules linked in: ip6table_filter ip6_tables act_police
> cls_basic cls_flow cls_fw cls_u32 sch_fq_codel sch_tbf sch_prio sch_htb
> sch_hfsc sch_ingress sch_sfq xt_CHECKSUM ipt_rpfilter xt_statistic xt_CT
> xt_realm xt_addrtype xt_nat ipt_MASQUERADE nf_nat_masquerade_ipv4
> ipt_ECN ipt_CLUSTERIP ipt_ah xt_set nf_nat_ftp xt_time xt_TCPMSS
> xt_tcpmss xt_policy xt_pkttype xt_physdev br_netfilter xt_NFQUEUE
> xt_NFLOG xt_mark xt_mac xt_length xt_helper xt_hashlimit xt_DSCP xt_dscp
> xt_CLASSIFY xt_AUDIT iptable_raw iptable_nat nf_nat_ipv4 nf_nat
> iptable_mangle hwmon_vid bridge stp llc ipv6 cx25840(O)
> snd_hda_codec_hdmi snd_usb_audio snd_hwdep uvcvideo(O) snd_usbmidi_lib
> videobuf2_vmalloc(O) snd_rawmidi ir_lirc_codec(O) ir_xmp_decoder(O)
> lirc_dev(O) ir_mce_kbd_decoder(O) ir_sharp_decoder(O) ir_sanyo_decoder(O)
> [  369.296375]  ir_sony_decoder(O) ir_jvc_decoder(O) ir_rc6_decoder(O)
> ir_rc5_decoder(O) ir_nec_decoder(O) rc_rc6_mce(O) mceusb(O) cx23885(O)
> tveeprom(O) cx2341x(O) tda18271(O) videobuf2_dvb(O) videobuf2_dma_sg(O)
> videobuf2_memops(O) videobuf2_core(O) v4l2_common(O) videodev(O) k10temp
> rc_core(O) microcode saa716x_core(O) dvb_core(O) cx24117(O) i2c_piix4
> snd_hda_intel snd_hda_controller snd_hda_codec r8169 mii nouveau ttm
> drm_kms_helper
> [  369.296547] CPU: 0 PID: 7016 Comm: vb2-cx23885[0] Tainted:
> G           O   3.18.1-hardened-r1-myrc06-NOSEC #1
> [  369.296574] Hardware name: To be filled by O.E.M. To be filled by
> O.E.M./M5A97 LE R2.0, BIOS 2501 04/09/2014
> [  369.296601] task: ffff88020c720830 ti: ffff88020c720db0 task.ti:
> ffff88020c720db0
> [  369.296622] RIP: 0010:[<ffffffffc05173df>] [<ffffffffc05173df>]
> cx23885_buf_prepare+0x8c/0xa9 [cx23885]
> [  369.296664] RSP: 0000:ffff88020adc3dc8  EFLAGS: 00010202
> [  369.296680] RAX: 0000000000005e00 RBX: ffff88009ce07400 RCX:
> 00000000000002f0
> [  369.296703] RDX: 0000000000000001 RSI: ffff88009ce07760 RDI:
> ffff880236af1000
> [  369.296722] RBP: ffff880234645568 R08: 0000000000000020 R09:
> 000000000000ba06
> [  369.296741] R10: 000000000000b800 R11: 000000000000b731 R12:
> 0000000000005e00
> [  369.296760] R13: ffff880234644000 R14: 0000000000000000 R15:
> 0000000000000000
> [  369.296780] FS:  00007fe5ff77a700(0000) GS:ffff88023fc00000(0000)
> knlGS:0000000000000000
> [  369.296801] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  369.296818] CR2: 0000000000000000 CR3: 0000000208ab2000 CR4:
> 00000000000007f0
> [  369.296836] Stack:
> [  369.296845]  ffff88009ce07400 ffff88009ce07400 0000000000000000
> ffff88009ce07058
> [  369.296875]  ffff8800b2c47d40 ffffffffc04caf21 ffff8802334c6d68
> ffff8802346454f0
> [  369.296903]  ffff8802334c6828 ffff88009ce07400 0000000000000000
> ffffffffc04cb3bb
> [  369.296932] Call Trace:
> [  369.296960]  [<ffffffffc04caf21>] ? __buf_prepare+0x1a6/0x25f
> [videobuf2_core]
> [  369.296994]  [<ffffffffc04cb3bb>] ? vb2_internal_qbuf+0x4c/0x1b7
> [videobuf2_core]
> [  369.297028]  [<ffffffffc04cb6b2>] ? vb2_thread+0x18c/0x1eb
> [videobuf2_core]
> [  369.297060]  [<ffffffffc04cb526>] ? vb2_internal_qbuf+0x1b7/0x1b7
> [videobuf2_core]
> [  369.297086]  [<ffffffff970d2fc4>] ? kthread+0xc5/0xcd
> [  369.297106]  [<ffffffff970d2eff>] ? kthread_create_on_node+0x155/0x155
> [  369.297129]  [<ffffffff97672d54>] ? ret_from_fork+0x74/0xa0
> [  369.297149]  [<ffffffff970d2eff>] ? kthread_create_on_node+0x155/0x155
> [  369.297166] Code: 49 63 c4 48 39 c1 72 32 85 d2 74 04 44 89 63 58 8b
> 8d f0 00 00 00 49 8b bd 18 01 00 00 48 8d b3 60 03 00 00 44 8b 85 f4 00
> 00 00 <49> 8b 16 45 31 c9 e8 a6 f2 ff ff 31 c0 eb 05 b8 ea ff ff ff 5b
> [  369.297397] RIP  [<ffffffffc05173df>] cx23885_buf_prepare+0x8c/0xa9
> [cx23885]
> [  369.297431]  RSP <ffff88020adc3dc8>
> [  369.297443] CR2: 0000000000000000
> [  369.302964] ---[ end trace a7bff82df7b103ca ]---
>
>
> I called "shutdown -r 0" but computer did not reappeared (I accessed it
> remotely).
> Even built in watchdog did not help.
>
> I will try to continue test last 2 sequences after somebody returns home
> and restarts computer.
>
>
> Thank you.
>
>
> Raimonds Cicans
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
http://palosaari.fi/
