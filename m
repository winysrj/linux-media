Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab0ELXPL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 19:15:11 -0400
Message-ID: <4BEB3666.7070806@redhat.com>
Date: Wed, 12 May 2010 20:14:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Daniel Borkmann <danborkmann@googlemail.com>
CC: linux-media@vger.kernel.org, daniel@netyack.org
Subject: Re: Bug in AMDs V4L2 driver lxv4l2?
References: <4BEB29B2.9080501@gmail.com>
In-Reply-To: <4BEB29B2.9080501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel Borkmann wrote:
> Hi everyone,
> 
> I am using an AMD Geode webcam with a V4L driver (lxv4l2). For the userspace I've implemented a V4L
> binding with memory mapping of the frames. After sucessfull receiving frames it lasts about two or
> three minutes and then either the timestamp of the frame is not changing anymore or a kernel oops
> happens. I am not quite sure whether this is caused by my userspace test program ("fw_singapore")
> or whether this is a bug within AMDs driver code ...

If you're getting an OOPS, for sure there's a bug at the driver. That's said, unfortunately, we
can't help you on it, since AMD has never submitted this driver for our review.
> 
> Thanks for help.
> Cheers,
>                 Daniel
> 
> Here the causing driver function within AMDs lx.c (and below the dmesg output):
> 
> Nevertheless, I noticed that this function is also a potential deadlock candidate since
> "spin_lock_irqsave(&io->lock, flags);" is called an the "else return 0;" does not release the lock.
> 
> 
> /** lx_capt_resume2 - queue capture buffers to vip */
> int
> lx_capt_resume2(VidDevice *dp,io_queue *io)
> {
>    io_buf *op, *ep;
>    int eidx, oidx, vip_buffers;
>    int task = dp->capt_vip_task;
>    int task_buffers = vip_task_data[task].task_buffers;
>    VIPINPUTBUFFER *vip_inpbfr = &dp->vip_inpbfr;
> 
>    unsigned long flags;
>    struct list_head *lp;
>    io_buf *bp1;
> 
>    dp->capt_stalled = 1;
>    task = dp->capt_vip_task;
>    task_buffers = vip_task_data[task].task_buffers;
> 
>    if( dp->capt_addr_is_set == 0 ) {
>       op = dp->capt_toggle == capt_toggle_odd ? dp->capt_elch : dp->capt_onxt;
>       if( op == NULL ) {
>          if( list_empty(&io->rd_qbuf) != 0 )
>          {
>            // there are no more buffers into the input list for grabbing images,
>            // so requeue first output buffer into input list
> 
> 	   spin_lock_irqsave(&io->lock, flags);
> 
>            lp = &io->rd_dqbuf;
> 	   if( ! list_empty(lp) ) {
> 	      bp1 = list_entry(lp->next,io_buf,bfrq);	// get the struct for this entry / list_entry ( ptr, type, member) &struct list_head pointer/ type of the struct this is embedded in/
> name of the list_struct within the struct.
> 	      list_del_init(&bp1->bfrq);		//deletes entry from list and reinitialize it
> 	   }
>            else return 0;
> 
>            lp = &io->rd_qbuf;
> 	   list_move_tail(&bp1->bfrq,lp);
> 
> 	   bp1->sequence = io->sequence++;
> 	   bp1->flags &= ~V4L2_BUF_FLAG_DONE;
> 	   bp1->flags |= V4L2_BUF_FLAG_QUEUED;
> 
> 	   if( dp->capt_stalled != 0 )
> 	   {
> 	      DMSG(3,"------------ v4l_qbfr : capt != 0 && dp->capt_stalled != 0\n");
> 	      //v4l_capt_unstall(dp);
> 	   }
> 
> 	   spin_unlock_irqrestore(&io->lock,flags);
>            //return 0;
>          }
> 
>          op = list_entry(io->rd_qbuf.next,io_buf,bfrq);
>          list_del_init(&op->bfrq);
>       }
>       if( dp->capt_toggle == capt_toggle_both ||
>           dp->capt_toggle == capt_toggle_odd ) {
>          if( (ep=dp->capt_enxt) == NULL ) {
>             if( list_empty(&io->rd_qbuf) != 0 ) {
>                list_add(&op->bfrq,&io->rd_qbuf);
>                return 0;
>             }
>             ep = list_entry(io->rd_qbuf.next,io_buf,bfrq);
>             list_del_init(&ep->bfrq);
>          }
>       }
>       else
>       {
>          ep = op;
>       }
>       dp->capt_onxt = op;  oidx = op->index;
>       dp->capt_enxt = ep;  eidx = ep->index;
>    }
>    else
>    {
>       oidx = eidx = 0;
>    }
> 
>    if( oidx != eidx ) {
>       vip_inpbfr->current_buffer = eidx;
>       vip_buffers = vip_task_data[task].vip_even_buffers;
>       vip_toggle_video_offsets(vip_buffers,vip_inpbfr);
>       vip_inpbfr->current_buffer = oidx;
>       vip_buffers = vip_task_data[task].vip_odd_buffers;
>       vip_toggle_video_offsets(vip_buffers,vip_inpbfr);
>    }
>    else {
>       vip_inpbfr->current_buffer = oidx;
>       vip_buffers = vip_task_data[task].vip_buffers;
>       vip_toggle_video_offsets(vip_buffers,vip_inpbfr);
>    }
>    dp->capt_stalled = 0;
> 
>    ++dp->capt_sequence;
>    ++dp->capt_jiffy_sequence;
> 
>    return 1;
> }
> 
> 
> dmesg and uname:
> 
> 
> nao@purzel [1] [~]$ uname -a
> Linux purzel 2.6.29.6-rt24-aldebaran-rt #1 PREEMPT RT Fri Feb 12 17:51:46 CET 2010 i586 GNU/Linux
> 
> [   17.877211] AMD Linux LX video2linux/2 driver 3.2.0100
> [   17.893218] Found Geode LX VIP at IRQ 11
> [   17.910414] OmniVision ov7670 sensor driver, at your service (v 2.00)
> [   17.939093] ov7670/1: driver attached: adapter id: 10002
> [   17.955545] Trying to detect OmniVision 7670/7672 I2C adapters
> [   19.847126] ov7670_init returned 0
> [   19.847139] Phase 1
> [   19.849429] Phase 2
> [   19.849440] Phase 3
> [   19.851728] Phase 4
> [   19.851739] Phase 5
> [   19.854054] Phase 6
> [   19.854064] Phase 7
> [   19.856357] Phase 8
> [   19.856367] Phase 9
> [   19.856377] OmniVision 7670/7671 I2C Found
> [   19.868799] ov7670/1: driver attached: adapter id: 0
> [   20.324975] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
> [   22.963201] spurious 8259A interrupt: IRQ7.
> [   74.863542] warning: `vsftpd' uses 32-bit capabilities (legacy support in use)
> [  565.626822] BUG: unable to handle kernel paging request at 0519e544
> [  565.627024] IP: [<cf4bc988>] vip_toggle_video_offsets+0x29/0x106 [cimarron]
> [  565.627024] *pde = 00000000
> [  565.627024] Oops: 0000 [#1] PREEMPT
> [  565.627024] last sysfs file: /sys/class/i2c-adapter/i2c-1/1-004c/temp1_input
> [  565.627024] Modules linked in: lxv4l2 cimarron zd1211rw ftdi_sio usbserial lm90 scx200_acb i2c_serial
> [  565.627024]
> [  565.627024] Pid: 1557, comm: IRQ-11 Not tainted (2.6.29.6-rt24-aldebaran-rt #1) AMD "CM-iGLX" Geode LX/CS5536
> [  565.627024] EIP: 0060:[<cf4bc988>] EFLAGS: 00010246 CPU: 0
> [  565.627024] EIP is at vip_toggle_video_offsets+0x29/0x106 [cimarron]
> [  565.627024] EAX: 00000000 EBX: cdb86e24 ECX: cf428000 EDX: ce382c88
> [  565.627024] ESI: cdb86e2c EDI: cdb86e24 EBP: ce382c88 ESP: ce359f28
> [  565.627024]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 preempt:00000001
> [  565.627024] Process IRQ-11 (pid: 1557, ti=ce359000 task=ce0617f0 task.ti=ce359000)
> [  565.627024] Stack:
> [  565.627024]  cdb86e1c ce38281c cf43d926 cdb86e04 00000000 00000000 ce382800 00000001
> [  565.627024]  00000000 cf43ebe0 00075a8d 00040d9a 00000001 00000000 00000000 00000001
> [  565.627024]  ce38281c cdb86e00 00dc9c86 c0393f64 cda15b20 0000000b 00000000 c013e758
> [  565.627024] Call Trace:
> [  565.627024]  [<cf43d926>] ? lx_capt_resume2+0x199/0x1bd [lxv4l2]
> [  565.627024]  [<cf43ebe0>] ? lx_interrupt+0x67d/0x785 [lxv4l2]
> [  565.627024]  [<c013e758>] ? handle_IRQ_event+0x83/0x13f
> [  565.627024]  [<c013e9e8>] ? thread_simple_irq+0x3a/0x72
> [  565.627024]  [<c013eac2>] ? do_irqd+0xa2/0x24d
> [  565.627024]  [<c013ea20>] ? do_irqd+0x0/0x24d
> [  565.627024]  [<c012c5b9>] ? kthread+0x36/0x5a
> [  565.627024]  [<c012c583>] ? kthread+0x0/0x5a
> [  565.627024]  [<c0102fb3>] ? kernel_thread_helper+0x7/0x10
> [  565.627024] Code: 5f c3 56 53 89 c1 8b 9a e4 00 00 00 85 c0 75 33 f6 02 02 8b 0d 60 13 4d cf 8d 73 08 74 0d 8b 44 9a 04 89 41 1c 8b 54 b2 0c eb 0b <8b> 44 b2 0c 89 41 1c 8b 54
> 9a 04 a1 60 13 4d cf 89 50 18 e9 c0
> [  565.627024] EIP: [<cf4bc988>] vip_toggle_video_offsets+0x29/0x106 [cimarron] SS:ESP 0068:ce359f28
> [  565.627024] CR2: 000000000519e544
> [  566.207813] ---[ end trace d33f57cfaa8188ac ]---
> [  566.230208] BUG: unable to handle kernel paging request at 0519e544
> [  566.231021] IP: [<cf4bc988>] vip_toggle_video_offsets+0x29/0x106 [cimarron]
> [  566.231021] *pde = 00000000
> [  566.231021] Oops: 0000 [#2] PREEMPT
> [  566.231021] last sysfs file: /sys/class/i2c-adapter/i2c-1/1-004c/temp1_input
> [  566.231021] Modules linked in: lxv4l2 cimarron zd1211rw ftdi_sio usbserial lm90 scx200_acb i2c_serial
> [  566.231021]
> [  566.231021] Pid: 1751, comm: fw_singapore Tainted: G      D    (2.6.29.6-rt24-aldebaran-rt #1) AMD "CM-iGLX" Geode LX/CS5536
> [  566.231021] EIP: 0060:[<cf4bc988>] EFLAGS: 00010246 CPU: 0
> [  566.231021] EIP is at vip_toggle_video_offsets+0x29/0x106 [cimarron]
> [  566.231021] EAX: 00000000 EBX: cdb86e24 ECX: cf428000 EDX: ce382c88
> [  566.231021] ESI: cdb86e2c EDI: cdb86e24 EBP: ce382c88 ESP: ce2dee44
> [  566.231021]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068 preempt:00000001
> [  566.231021] Process fw_singapore (pid: 1751, ti=ce2de000 task=cd8aa030 task.ti=ce2de000)
> [  566.231021] Stack:
> [  566.231021]  cdb86e1c ce38281c cf43d76a 00000000 cdb86e58 cdb86e00 cdb86e1c ce38281c
> [  566.231021]  cf4375be 00000001 cdb86e04 cdb86e00 00000001 bfeae7b0 c044560f cf43c393
> [  566.231021]  00000001 ce2def50 ce2def4c 00000000 cddef740 ce2deea8 0000000d c0275b89
> [  566.231021] Call Trace:
> [  566.231021]  [<cf43d76a>] ? lx_capt_resume+0x108/0x12b [lxv4l2]
> [  566.231021]  [<cf4375be>] ? v4l_qbfr+0x72/0x88 [lxv4l2]
> [  566.231021]  [<cf43c393>] ? vid_ioctl+0x35c4/0x3d65 [lxv4l2]
> [  566.231021]  [<c0275b89>] ? sys_recvfrom+0xb1/0x113
> [  566.231021]  [<c0275bd9>] ? sys_recvfrom+0x101/0x113
> [  566.231021]  [<c014b731>] ? perf_swcounter_event+0xc4/0xeb
> [  566.231021]  [<cf438dcf>] ? vid_ioctl+0x0/0x3d65 [lxv4l2]
> [  566.231021]  [<c021cedb>] ? v4l2_ioctl+0x31/0x34
> [  566.231021]  [<c01709d8>] ? vfs_ioctl+0x47/0x5d
> [  566.231021]  [<c0170f01>] ? do_vfs_ioctl+0x43f/0x47f
> [  566.231021]  [<c0275c04>] ? sys_recv+0x19/0x1d
> [  566.231021]  [<c0276003>] ? sys_socketcall+0xf2/0x18c
> [  566.231021]  [<c0170f6d>] ? sys_ioctl+0x2c/0x42
> [  566.231021]  [<c0102851>] ? syscall_call+0x7/0xb
> [  566.231021] Code: 5f c3 56 53 89 c1 8b 9a e4 00 00 00 85 c0 75 33 f6 02 02 8b 0d 60 13 4d cf 8d 73 08 74 0d 8b 44 9a 04 89 41 1c 8b 54 b2 0c eb 0b <8b> 44 b2 0c 89 41 1c 8b 54
> 9a 04 a1 60 13 4d cf 89 50 18 e9 c0
> [  566.231021] EIP: [<cf4bc988>] vip_toggle_video_offsets+0x29/0x106 [cimarron] SS:ESP 0068:ce2dee44
> [  566.231021] CR2: 000000000519e544
> [  566.894334] ---[ end trace d33f57cfaa8188ad ]---
> 
> 


-- 

Cheers,
Mauro
