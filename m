Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:44730 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaJLUPo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Oct 2014 16:15:44 -0400
Received: by mail-oi0-f50.google.com with SMTP id i138so11594492oig.9
        for <linux-media@vger.kernel.org>; Sun, 12 Oct 2014 13:15:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALraBmDJrCUwX3=R4-7XuOKRMkzWChWPEuGciGFEzhHrzsHevg@mail.gmail.com>
References: <CALraBmDhAQgKy_G-rToUfZuv9XHoEy30S2mgnYXQc9xWiN=Zhw@mail.gmail.com>
	<1466502.QQO5pVr1dM@avalon>
	<CALraBmDJrCUwX3=R4-7XuOKRMkzWChWPEuGciGFEzhHrzsHevg@mail.gmail.com>
Date: Sun, 12 Oct 2014 13:15:44 -0700
Message-ID: <CALraBmCPhPnwMxs9ZkmWcOtv9h6Cg1GpJreeZuQoxAiqsOHqjg@mail.gmail.com>
Subject: Re: Kernel panic using a webcam
From: Andrew Klofas <aklofas@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 12, 2014 at 12:20 PM, Andrew Klofas <aklofas@gmail.com> wrote:
>
> On Sat, Oct 11, 2014 at 5:02 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>>
>> Hi Andrew,
>>
>> On Friday 10 October 2014 17:55:54 Andrew Klofas wrote:
>> > Greetings,
>> >
>> > I am new to the linux kernel community (first time contacting anyone),
>> > so I
>> > apologize if I am not doing this the proper way.
>>
>> No worries. You should have CC'ed the linux-media@vger.kernel.org mailing
>> list, which I've done on this reply.
>>
>> > I am trying to get to the bottom of a kernel panic that occurs under
>> > normal
>> > operation when using a webcam. I have a kernel dump (you can download it
>> > at
>> > http://static.novarianteng.net/dump.201410101406), and I can answer any
>> > questions you have.
>>
>> The first question would be, why do I get a 403 error when trying to
>> download
>> the file ? :-)
>
>
> Sorry, wrong file permissions (should have tested the link), it's fixed now.
>
>>
>>
>> > I am using the low-level ioctl for v4l2. I am mmap'ing the raw yuyv
>> > frames
>> > and can start streaming. However, when I stop streaming:
>> >
>> > // Call VIDIOC_STREAMOFF
>> > enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> > ioctl(fd, VIDIOC_STREAMOFF, &type);
>> >
>> > I get a kernel panic: BUG: unable to handle kernel NULL pointer
>> > dereference
>> > at (null)
>> >
>> > It took a while to follow the static inlining and indirect calls, but I
>> > think I found where the kernel panic is reported to have occured.
>> >
>> >
>> > crash command line
>> > - sys
>> >       KERNEL: /usr/lib/debug/boot/vmlinux-3.13.0-24-generic
>> >     DUMPFILE: /var/crash/201410101406/dump.201410101406  [PARTIAL DUMP]
>> >         CPUS: 4
>> >         DATE: Fri Oct 10 14:06:08 2014
>> >       UPTIME: 00:01:48
>> > LOAD AVERAGE: 0.71, 0.41, 0.16
>> >        TASKS: 341
>> >     NODENAME: workstation
>> >      RELEASE: 3.13.0-24-generic
>> >      VERSION: #47-Ubuntu SMP Fri May 2 23:30:00 UTC 2014
>> >      MACHINE: x86_64  (2693 Mhz)
>> >       MEMORY: 7.9 GB
>> >        PANIC: "Oops: 0002 [#1] SMP " (check log for details)
>> >
>> > - bt
>> > PID: 2461   TASK: ffff8802208edfc0  CPU: 0   COMMAND: "python"
>> >  #0 [ffff88022ec03988] machine_kexec at ffffffff8104a732
>> >  #1 [ffff88022ec039d8] crash_kexec at ffffffff810e6ab3
>> >  #2 [ffff88022ec03aa0] oops_end at ffffffff8171efe8
>> >  #3 [ffff88022ec03ac8] no_context at ffffffff8170e784
>> >  #4 [ffff88022ec03b10] __bad_area_nosemaphore at ffffffff8170e804
>> >  #5 [ffff88022ec03b58] bad_area_nosemaphore at ffffffff8170e96e
>> >  #6 [ffff88022ec03b68] __do_page_fault at ffffffff81721947
>> >  #7 [ffff88022ec03c68] do_page_fault at ffffffff81721e1a
>> >  #8 [ffff88022ec03c90] page_fault at ffffffff8171e288
>> >     [exception RIP: uvc_video_decode_start+658]
>> >     RIP: ffffffffa07bbc22  RSP: ffff88022ec03d40  RFLAGS: 00010002
>> >     RAX: 0000000000000000  RBX: ffff88003551c000  RCX: 000000000000045b
>> > <---------- RAX is NULL
>> >     RDX: 00000000e370dc50  RSI: 0000000000000046  RDI: 0000000000000060
>> >     RBP: ffff88022ec03de8   R8: ffff88003551c580   R9: 0000000000000000
>> >     R10: ffff8800af7ed000  R11: 0000000000000060  R12: ffff8800af020000
>> >     R13: ffff88021f659800  R14: 0000000000000bf4  R15: 0000000000000001
>> >     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0000
>> >  #9 [ffff88022ec03d50] ehci_urb_done at ffffffff8154e64d
>> > #10 [ffff88022ec03d78] ehci_work at ffffffff81556162
>> > #11 [ffff88022ec03e48] uvc_video_complete at ffffffffa07bb912 [uvcvideo]
>> > #12 [ffff88022ec03e78] __usb_hcd_giveback_urb at ffffffff8153a107
>> > #13 [ffff88022ec03ea8] usb_giveback_urb_bh at ffffffff8153aeb6
>> > #14 [ffff88022ec03ee8] tasklet_hi_action at ffffffff8106c5e3
>> > #15 [ffff88022ec03f08] __do_softirq at ffffffff8106caec
>> > #16 [ffff88022ec03f68] irq_exit at ffffffff8106d035
>> > #17 [ffff88022ec03f80] do_IRQ at ffffffff817287d6
>> > --- <IRQ stack> ---
>> > #18 [ffff880220e6df58] ret_from_intr at ffffffff8171df6d
>> >     RIP: 000000000053eacf  RSP: 00007fff8a062820  RFLAGS: 00000202
>> >     RAX: 0000000000913940  RBX: 0000000002090010  RCX: 000000000000003f
>> >     RDX: 00000000022f22e0  RSI: 0000000000000000  RDI: 00007f8a17b3a908
>> >     RBP: 00007f8a17b3a908   R8: 00000000022f27c0   R9: 0000000000000030
>> >     R10: 00000000022f2778  R11: 00000000022f2790  R12: 00007f8a2d088a01
>> >     R13: 00007fff8a0648f3  R14: 0000000000000001  R15: 0000000000000000
>> >     ORIG_RAX: ffffffffffffff3c  CS: 0033  SS: 002b
>> >
>> > > Looking at the code:
>> >
>> > http://lxr.free-electrons.com/source/drivers/media/usb/uvc/uvc_video.c?v=3.1
>> > 3#L454 - C
>> > 454         spin_lock_irqsave(&stream->clock.lock, flags);
>> > 455
>> > 456         sample = &stream->clock.samples[stream->clock.head];
>> >  <------------------------------ Somehow 'sample' becomes NULL
>>
>> That would be *really* weird. How have you determined the location of the
>> crash in the source code ? Have you used addr2line ?
>
> I downloaded the kernel debugging symbols. I could zip them up (~250MB IIRC)
> and upload them on monday when I'm back in the office.

Just uploaded the kernel w/ syms:
http://static.novarianteng.net/3.13.0-24-generic-debugsyms.tar.gz
(With all the modules gzipped, ~880MB be warned)

>
>
> My current (possibly crazy) theory is that it might be related to a race
> condition. If
> stream->clock.samples
> is set to NULL earlier when un-mmap, and
> stream->clock.head
> is '0', the evaluation of
> &stream->clock.samples[stream->clock.head];
> could be NULL:
> &stream->clock.samples[0]; == stream->clock.samples; == NULL?
>
>
>
>>
>>
>> > 457         sample->dev_stc = get_unaligned_le32(&data[header_size -
>> > 6]);
>> > <-------------------- CRASHES HERE (according to IP) when trying to
>> > deref
>> > sample->dev_stc
>> > 458         sample->dev_sof = dev_sof;
>> > 459         sample->host_sof = host_sof;
>> > 460         sample->host_ts = ts;
>> > 461
>> > 462         /* Update the sliding window head and count. */
>> > 463         stream->clock.head = (stream->clock.head + 1) %
>> > stream->clock.size;
>> > 464
>> > 465         if (stream->clock.count < stream->clock.size)
>> > 466                 stream->clock.count++;
>> > 467
>> > 468         spin_unlock_irqrestore(&stream->clock.lock, flags);
>> >
>> > - Asm (from crash dump)
>> > 0xffffffffa07bbbe3 <uvc_video_decode_start+595>:        callq
>> >  0xffffffff8171dab0 <_raw_spin_lock_irqsave>
>> > 0xffffffffa07bbbe8 <uvc_video_decode_start+600>:        mov    %rax,%rsi
>> > 0xffffffffa07bbbeb <uvc_video_decode_start+603>:        mov
>> >  0x570(%rbx),%eax
>> > 0xffffffffa07bbbf1 <uvc_video_decode_start+609>:        mov
>> >  0x54(%rsp),%edx
>> > 0xffffffffa07bbbf5 <uvc_video_decode_start+613>:        mov
>> >  0x50(%rsp),%ecx
>> > 0xffffffffa07bbbf9 <uvc_video_decode_start+617>:        mov
>> >  0x4c(%rsp),%r9d
>> > 0xffffffffa07bbbfe <uvc_video_decode_start+622>:        movzwl
>> > 0x60(%rsp),%edi
>> > 0xffffffffa07bbc03 <uvc_video_decode_start+627>:        mov
>> >  0x58(%rsp),%r8
>> > 0xffffffffa07bbc08 <uvc_video_decode_start+632>:        sub    $0x6,%edx
>> > 0xffffffffa07bbc0b <uvc_video_decode_start+635>:        shl    $0x5,%rax
>> > 0xffffffffa07bbc0f <uvc_video_decode_start+639>:        add
>> >  0x568(%rbx),%rax
>> > 0xffffffffa07bbc16 <uvc_video_decode_start+646>:        mov
>> >  (%r12,%rdx,1),%edx
>> > 0xffffffffa07bbc1a <uvc_video_decode_start+650>:        add    %r9d,%ecx
>> > 0xffffffffa07bbc1d <uvc_video_decode_start+653>:        and
>> > $0x7ff,%cx
>> > 0xffffffffa07bbc22 <uvc_video_decode_start+658>:        mov
>> > %edx,(%rax)
>> >  <--------------------- CRASHES HERE (according to IP) where RAX
>> > (address
>> > of sample) = NULL
>> > 0xffffffffa07bbc24 <uvc_video_decode_start+660>:        mov
>> > %cx,0x4(%rax)
>> > 0xffffffffa07bbc28 <uvc_video_decode_start+664>:        mov
>> >  %di,0x18(%rax)
>> > 0xffffffffa07bbc2c <uvc_video_decode_start+668>:        mov
>> >  0x70(%rsp),%rdx
>> > 0xffffffffa07bbc31 <uvc_video_decode_start+673>:        mov
>> >  0x78(%rsp),%rcx
>> > 0xffffffffa07bbc36 <uvc_video_decode_start+678>:        mov
>> >  %rdx,0x8(%rax)
>> > 0xffffffffa07bbc3a <uvc_video_decode_start+682>:        xor    %edx,%edx
>> > 0xffffffffa07bbc3c <uvc_video_decode_start+684>:        mov
>> >  %rcx,0x10(%rax)
>> > 0xffffffffa07bbc40 <uvc_video_decode_start+688>:        mov
>> >  0x570(%rbx),%eax
>> > 0xffffffffa07bbc46 <uvc_video_decode_start+694>:        mov
>> >  0x578(%rbx),%ecx
>> > 0xffffffffa07bbc4c <uvc_video_decode_start+700>:        add    $0x1,%eax
>> > 0xffffffffa07bbc4f <uvc_video_decode_start+703>:        div    %ecx
>> > 0xffffffffa07bbc51 <uvc_video_decode_start+705>:        mov
>> >  0x574(%rbx),%eax
>> > 0xffffffffa07bbc57 <uvc_video_decode_start+711>:        cmp    %eax,%ecx
>> > 0xffffffffa07bbc59 <uvc_video_decode_start+713>:        mov
>> >  %edx,0x570(%rbx)
>> > 0xffffffffa07bbc5f <uvc_video_decode_start+719>:        jbe
>> >  0xffffffffa07bbc6a <uvc_video_decode_start+730>
>> > 0xffffffffa07bbc61 <uvc_video_decode_start+721>:        add    $0x1,%eax
>> > 0xffffffffa07bbc64 <uvc_video_decode_start+724>:        mov
>> >  %eax,0x574(%rbx)
>> > 0xffffffffa07bbc6a <uvc_video_decode_start+730>:        mov    %r8,%rdi
>> > 0xffffffffa07bbc6d <uvc_video_decode_start+733>:        callq
>> >  0xffffffff8171d8c0 <_raw_spin_unlock_irqrestore>
>> >
>> > Please let me know any other information you think is needed.
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
>
