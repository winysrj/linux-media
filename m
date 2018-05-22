Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:37728 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751192AbeEVIQH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 04:16:07 -0400
Subject: Re: [PATCHv2 0/4] gspca: convert to vb2gspca: convert to vb2
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: linux-media <linux-media@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
References: <20180513094741.25096-1-hverkuil@xs4all.nl>
 <CAAEAJfCBMsJ6FWb1qSC8ZHGz2peajG2ptQj6FB3082sMApjs8w@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e52ce589-d05a-6c1f-6e60-9d1d9ed15fad@xs4all.nl>
Date: Tue, 22 May 2018 10:16:03 +0200
MIME-Version: 1.0
In-Reply-To: <CAAEAJfCBMsJ6FWb1qSC8ZHGz2peajG2ptQj6FB3082sMApjs8w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/05/18 19:51, Ezequiel Garcia wrote:
> On 13 May 2018 at 06:47, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The first patch converts the gspca driver to the vb2 framework.
>> It was much easier to do than I expected and it saved almost 600
>> lines of gspca driver code.
>>
>> The second patch fixes v4l2-compliance warnings for g/s_parm.
>>
>> The third patch clears relevant fields in v4l2_streamparm in
>> v4l_s_parm(). This was never done before since v4l2-compliance
>> didn't check this.
>>
>> The final patch deletes the now unused v4l2_disable_ioctl_locking()
>> function.
>>
>> Tested with three different gspca webcams, and tested suspend/resume
>> as well.
>>
>> I'll test with a few more webcams next week and if those tests all
>> succeed then I'll post a pull request.
>>
>> Regards,
>>
>>         Hans
>>
>> Changes since v1:
>>
>> - Re-added 'if (gspca_dev->present)' before the dq_callback call.
>> - Added Reviewed-by tags from Hans de Goede.
>>
>> Hans Verkuil (4):
>>   gspca: convert to vb2
>>   gspca: fix g/s_parm handling
>>   v4l2-ioctl: clear fields in s_parm
>>   v4l2-ioctl: delete unused v4l2_disable_ioctl_locking
>>
>>  drivers/media/usb/gspca/Kconfig            |   1 +
>>  drivers/media/usb/gspca/gspca.c            | 925 ++++-----------------
>>  drivers/media/usb/gspca/gspca.h            |  38 +-
>>  drivers/media/usb/gspca/m5602/m5602_core.c |   4 +-
>>  drivers/media/usb/gspca/ov534.c            |   1 -
>>  drivers/media/usb/gspca/topro.c            |   1 -
>>  drivers/media/usb/gspca/vc032x.c           |   2 +-
>>  drivers/media/v4l2-core/v4l2-ioctl.c       |  19 +-
>>  include/media/v4l2-dev.h                   |  15 -
>>  9 files changed, 210 insertions(+), 796 deletions(-)
>>
> 
> Got a NULL pointer testing this series. However, I don't think
> the problem is with this series per-se, but more of a long-standing
> race.
> 
> [ 1133.771530] BUG: unable to handle kernel NULL pointer dereference
> at 00000000000000c4
> [ 1133.779354] PGD 0 P4D 0
> [ 1133.781885] Oops: 0000 [#1] PREEMPT SMP PTI
> [ 1133.786065] CPU: 1 PID: 0 Comm: swapper/1 Not tainted
> 4.17.0-rc3-next-20180503-ARCH-00029-gb14b92b054cc-dirty #11
> [ 1133.796306] Hardware name: ASUS All Series/H81M-D R2.0, BIOS 0504 05/14/2015
> [ 1133.803346] RIP: 0010:sd_pkt_scan+0x246/0x350 [gspca_sonixj]
> [ 1133.808994] Code: 00 89 d9 4c 89 e2 be 03 00 00 00 4c 89 ef e8 f1
> 06 c9 ff 49 8b 95 30 05 00 00 41 6b 85 d0 08 00 00 64 41 0f b7 8d d4
> 08 00 00 <0f> af 8a c4 00 00 00 31 d2 f7 f1 83 f8 54 0f 8f a6 00 00 00
> 83 f8
> [ 1133.827845] RSP: 0018:ffff88011fa83c78 EFLAGS: 00010002
> [ 1133.833061] RAX: 0000000000282d8c RBX: 00000000000002ee RCX: 0000000000000027
> [ 1133.840204] RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff8800c10b97e0
> [ 1133.847343] RBP: ffff88011fa83ca0 R08: 00000000000241a0 R09: ffffffffa021d45e
> [ 1133.854469] R10: 000000000000032c R11: ffff880115938700 R12: ffff8800c765b840
> [ 1133.861591] R13: ffff8800c10b9000 R14: 000000000000032c R15: 000000000000032c
> [ 1133.868726] FS:  0000000000000000(0000) GS:ffff88011fa80000(0000)
> knlGS:0000000000000000
> [ 1133.876802] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1133.882540] CR2: 00000000000000c4 CR3: 000000000200a004 CR4: 00000000001606e0
> [ 1133.889663] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1133.896788] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1133.903920] Call Trace:
> [ 1133.906365]  <IRQ>
> [ 1133.908376]  ? sd_stop0+0x40/0x40 [gspca_sonixj]
> [ 1133.912988]  isoc_irq+0xb8/0x130 [gspca_main]
> [ 1133.917340]  __usb_hcd_giveback_urb+0x64/0xe0 [usbcore]
> [ 1133.922565]  usb_hcd_giveback_urb+0x11f/0x130 [usbcore]
> [ 1133.927782]  xhci_giveback_urb_in_irq.isra.20+0x84/0x100 [xhci_hcd]
> [ 1133.934038]  ? handle_cmd_completion+0x2cd/0x1100 [xhci_hcd]
> [ 1133.939689]  xhci_td_cleanup+0xfb/0x170 [xhci_hcd]
> [ 1133.944490]  finish_td+0xb3/0xf0 [xhci_hcd]
> [ 1133.948669]  xhci_irq+0x1532/0x2130 [xhci_hcd]
> [ 1133.953106]  ? handle_irq_event+0x47/0x5b
> [ 1133.957110]  xhci_msi_irq+0x11/0x20 [xhci_hcd]
> [ 1133.961546]  __handle_irq_event_percpu+0x42/0x1b0
> [ 1133.966243]  handle_irq_event_percpu+0x32/0x80
> [ 1133.970681]  handle_irq_event+0x3c/0x5b
> [ 1133.974511]  handle_edge_irq+0x7f/0x1b0
> [ 1133.978342]  handle_irq+0x1a/0x30
> [ 1133.981654]  do_IRQ+0x46/0xd0
> [ 1133.984617]  common_interrupt+0xf/0xf
> [ 1133.988274]  </IRQ>
> 
> Common sense tells me that the gspca_dev->urb[0] is
> set to NULL in destroy_urbs() and then accessed:
> 
> static void sd_pkt_scan(struct gspca_dev *gspca_dev,
>                         u8 *data,                       /* isoc packet */
>                         int len)                        /* iso packet length */
> {
> [..]
>                 r = (sd->pktsz * 100) /
>                         (sd->npkt *
>                                 gspca_dev->urb[0]->iso_frame_desc[0].length);
> 
> As nothing protects the gspca_dev->urb array.
> 
> This is confirmed by disassembly, if I did the math right.
> sd_pkt_scan+0x246 is 0xC56:
> 
>      c3a:       e8 00 00 00 00          callq  c3f <sd_pkt_scan+0x22f>
>                                 gspca_dev->urb[0]->iso_frame_desc[0].length);
>      c3f:       49 8b 95 30 05 00 00    mov    0x530(%r13),%rdx
>                 r = (sd->pktsz * 100) /
>      c46:       41 6b 85 d0 08 00 00    imul   $0x64,0x8d0(%r13),%eax
>      c4d:       64
>                         (sd->npkt *
>      c4e:       41 0f b7 8d d4 08 00    movzwl 0x8d4(%r13),%ecx
>      c55:       00
>      c56:       0f af 8a c4 00 00 00    imul   0xc4(%rdx),%ecx
>                 r = (sd->pktsz * 100) /
> 
> Where %rdx seems to be gspca_dev->urb[0].
> 
> I think we should fix these gspca-state-urbs in all the gspca sub-drivers:
> 
> $ git grep "urb\[.*->" -- drivers/media/usb/gspca/
> drivers/media/usb/gspca/benq.c: if (urb == gspca_dev->urb[0] || urb ==
> gspca_dev->urb[2])
> drivers/media/usb/gspca/finepix.c:                      gspca_dev->urb[0]->pipe,
> drivers/media/usb/gspca/finepix.c:
> gspca_dev->urb[0]->transfer_buffer,
> drivers/media/usb/gspca/finepix.c:      usb_clear_halt(gspca_dev->dev,
> gspca_dev->urb[0]->pipe);
> drivers/media/usb/gspca/gspca.c:
>  gspca_dev->urb[0]->pipe);
> drivers/media/usb/gspca/jeilinj.c:
> gspca_dev->urb[0]->pipe,
> drivers/media/usb/gspca/jeilinj.c:
> gspca_dev->urb[0]->transfer_buffer,
> drivers/media/usb/gspca/jeilinj.c:              buf =
> gspca_dev->urb[0]->transfer_buffer;
> drivers/media/usb/gspca/sn9c20x.c:
> gspca_dev->urb[0]->iso_frame_desc[0].length);
> drivers/media/usb/gspca/sonixj.c:
> gspca_dev->urb[0]->iso_frame_desc[0].length);
> drivers/media/usb/gspca/xirlink_cit.c:
> usb_clear_halt(gspca_dev->dev, gspca_dev->urb[0]->pipe);
> drivers/media/usb/gspca/xirlink_cit.c:
> usb_clear_halt(gspca_dev->dev, gspca_dev->urb[0]->pipe);
> 
> Thoughts?
> 

Should be fixed in v3. The main problem was that the URBs were destroyed
too soon. By moving that to gspca_release this should no longer happen.

Regards,

	Hans
