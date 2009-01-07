Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n07HSHO8002815
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 12:28:17 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n07HR5c3010985
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 12:27:05 -0500
Received: by wf-out-1314.google.com with SMTP id 25so8628223wfc.6
	for <video4linux-list@redhat.com>; Wed, 07 Jan 2009 09:27:05 -0800 (PST)
Message-ID: <c785bba30901070927x9be4bdcr84ceb792ccac7afb@mail.gmail.com>
Date: Wed, 7 Jan 2009 10:27:05 -0700
From: "Paul Thomas" <pthomas8589@gmail.com>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-Reply-To: <c785bba30901051633g7808197fl6d377420d799120c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>
	<c785bba30812311330w26ce5817l10db52d5be98d175@mail.gmail.com>
	<412bdbff0812311420n3f42e13ew899be73cd855ba5d@mail.gmail.com>
	<c785bba30812311424r87bd070v9a01828c77d6a2a6@mail.gmail.com>
	<412bdbff0812311435n429787ecmbcab8de00ba05b6b@mail.gmail.com>
	<c785bba30812311444l65b3825aq844b79dd6f420c09@mail.gmail.com>
	<412bdbff0812311452o64538cdav4b948f6a9214ccdd@mail.gmail.com>
	<c785bba30901020850y51c7b9d2i47fd418828cd150c@mail.gmail.com>
	<c785bba30901030922y17d67d0bm822304a650a0e812@mail.gmail.com>
	<c785bba30901051633g7808197fl6d377420d799120c@mail.gmail.com>
Cc: video4linux-list <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: em28xx issues
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Mon, Jan 5, 2009 at 5:33 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
> On Sat, Jan 3, 2009 at 10:22 AM, Paul Thomas <pthomas8589@gmail.com> wrote:
>> On Fri, Jan 2, 2009 at 9:50 AM, Paul Thomas <pthomas8589@gmail.com> wrote:
>>> On Wed, Dec 31, 2008 at 3:52 PM, Devin Heitmueller
>>> <devin.heitmueller@gmail.com> wrote:
>>>> On Wed, Dec 31, 2008 at 5:44 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
>>>>> How was it working with Skype? Can we hard code the settings for testing?
>>>>>
>>>>> thanks,
>>>>> Paul
>>>>
>>>> Well, regardless of the device profile issue, it's not clear why it is
>>>> segfaulting.  In theory, it should work but you should only get a
>>>> single input available instead of being able to pick between composite
>>>> and s-video.
>>>>
>>>> I think with this device you should be able to set a modprobe option
>>>> for "debug=1" which might provide a bit more insight.
>>>>
>>>> Try this.  Unplug the device, run "make unload", and then "modprobe
>>>> em28xx".  Then plug the device in.  You should start seeing more info
>>>> in the dmesg output.  Then start the app that segfaults and report the
>>>> dmesg contents.
>>>>
>>>> Devin
>>>>
>>>> --
>>>> Devin J. Heitmueller
>>>> http://www.devinheitmueller.com
>>>> AIM: devinheitmueller
>>>>
>>>
>>> Thanks CityK. I was able to enable core_debug=1. Here is what I have
>>> in dmesg after I camstream seg faults:
>>>
>>> Em28xx: Initialized (Em28xx Audio Extension) extension
>>> em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
>>> em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
>>> em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
>>> em28xx #0 em28xx_set_alternate :minimum isoc packet size: 2888 (alt=6)
>>> em28xx #0 em28xx_set_alternate :setting alternate 6 with wMaxPacketSize=2892
>>> em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
>>> em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
>>> em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
>>> em28xx #0 em28xx_set_alternate :minimum isoc packet size: 2888 (alt=6)
>>> em28xx #0 em28xx_set_alternate :setting alternate 6 with wMaxPacketSize=2892
>>> em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
>>> em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
>>> em28xx #0 em28xx_init_isoc :em28xx: called em28xx_prepare_isoc
>>> em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
>>> camstream[18436]: segfault at 0 ip 000000000043ea76 sp
>>> 00007fff1ca5d7a8 error 6 in camstream[400000+5a000]
>>> em28xx #0 em28xx_uninit_isoc :em28xx: called em28xx_uninit_isoc
>>> em28xx #0 em28xx_irq_callback :urb resubmit failed (error=-1)
>>> em28xx #0 em28xx_irq_callback :urb resubmit failed (error=-1)
>>> em28xx #0 em28xx_irq_callback :urb resubmit failed (error=-1)
>>> em28xx #0 em28xx_irq_callback :urb resubmit failed (error=-1)
>>> em28xx #0 em28xx_irq_callback :urb resubmit failed (error=-1)
>>>
>>> thanks,
>>> Paul
>>>
>>
>> Here is an update on the programs working with em28xx
>>
>> Working programs
>> Skype
>> UCview
>>
>> Here is the status of the other cam programs that aren't working yet:
>> camstream                 -> seg fault
>> gstreamer-properties  -> seg fault
>> cheese                      -> uses test input
>> fswebcam                  -> black screen with green stripe
>>
>> I hope this helps
>>
>> thanks,
>> Paul
>>
>
> OK, I was able to make some more progress. I can use fswebcam on my
> x86_64 box if I comment out the input selection section. Now I'm
> trying to get fswebcam to work on my embedded arm board
> (http://opencircuits.com/Linuxstamp), but when I run it I get a kernel
> oops. I've included the oops below. I'm now using this
> (git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git)
> git tree.
>
> Any ideas?
>
> thanks,
> Paul
>
> linuxstamp:/home/user/fswebcam-20070108# ./fswebcam -v test.jpeg
> --- Opening /dev/video0...
> Trying source module v4l2...
> /dev/video0 opened.
> src_v4l2_get_capability,81: /dev/video0 information:
> src_v4l2_get_capability,82: cap.driver: "em28xx"
> src_v4l2_get_capability,83: cap.card: "PointNix Intra-Oral Camera"
> src_v4l2_get_capability,84: cap.bus_info: "1-1.7"
> src_v4l2_get_capability,85: cap.capabilities=0x05020041
> src_v4l2_get_capability,86: - VIDEO_CAPTURE
> src_v4l2_get_capability,93: - AUDIO
> src_v4l2_get_capability,95: - READWRITE
> src_v4l2_get_capability,97: - STREAMING
> src_v4l2_set_pix_format,530: Device offers the following V4L2 pixel formats:
> src_v4l2_set_pix_format,542: 0: YUYV (16bpp YUY2, 4:2:2, packed)
> Using palette YUYV
> src_v4l2_set_mmap,648: mmap information:
> src_v4l2_set_mmap,649: frames=4
> src_v4l2_set_mmap,694: 0 length=221184
> src_v4l2_set_mmap,694: 1 length=221184
> src_v4l2_set_mmap,694: 2 length=221184
> src_v4l2_set_mmap,694: 3 length=221184
> kernel BUG at arch/arm/mm/dma-mapping.c:495!
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> pgd = c13c4000
> [00000000] *pgd=21311031, *pte=00000000, *ppte=00000000
> Internal error: Oops: 817 [#1] PREEMPT
> Modules linked in: saa7115 v4l2_common em28xx videodev v4l1_compat
> videobuf_vmalloc videobuf_core ir_common tveeprom
> CPU: 0    Not tainted  (2.6.28-15476-g7d3b56b #2)
> PC is at __bug+0x20/0x2c
> LR is at vprintk+0x2f0/0x34c
> pc : [<c00265c0>]    lr : [<c003b078>]    psr: 60000013
> sp : c1ff1ba4  ip : c03944fc  fp : c1ff1bb0
> r10: 00000028  r9 : c1d78628  r8 : c1d1f000
> r7 : 00000020  r6 : 00000000  r5 : c1d49800  r4 : ffc09000
> r3 : 00000000  r2 : c1ff0000  r1 : 00000002  r0 : 00000030
> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: c000717f  Table: 213c4000  DAC: 00000015
> Process fswebcam (pid: 2383, stack limit = 0xc1ff0260)
> Stack: (0xc1ff1ba4 to 0xc1ff2000)
> 1ba0:          c1ff1bc0 c1ff1bb4 c0027504 c00265b0 c1ff1c84 c1ff1bc4
> c01e2a40
> 1bc0: c0027470 c1ff1bf4 c1ff1bd4 c0053810 c003360c 00000000 c037001c
> c1c713c0
> 1be0: 00000017 c1ff0000 c1ff1c08 c1ff1c08 c1ff1bfc c02bd9b4 c0033704
> c1ff1c34
> 1c00: c1ff1c0c c02bb9a8 c003360c ffffdd0e c1ff0000 00000002 c1ff1c38
> c0376d64
> 1c20: ffffdd0e c1ff0000 c1ff1c70 c1ff1c38 c02bc0b4 c0043c5c 00000000
> 00200200
> 1c40: ffffdd0e c00443ec c1c713c0 c0398b80 00000001 00000001 c1d78000
> 00000001
> 1c60: c1dd9400 00000020 00000000 00008200 c1d78628 00000028 c1ff1cac
> c1ff1c88
> 1c80: c01e4380 c01e2904 c1ff1c94 bf036528 c004464c c1dbd3c0 c1e31400
> c1d78000
> 1ca0: c1ff1cd8 c1ff1cb0 bf036ed0 c01e40ec c1d78000 c1d7cbe0 00000000
> c1d379cc
> 1cc0: bf0150a0 bf038098 c1ff1e2c c1ff1cfc c1ff1cdc bf031904 bf036c68
> bf031000
> 1ce0: ffffffea c1d7cbe0 c1d379cc c1ff1e2c c1ff1d20 c1ff1d00 bf011ff8
> bf031850
> 1d00: c1d379c0 c1ff1e2c c044560f c044560f 00000000 c1ff1d38 c1ff1d24
> bf032b98
> 1d20: bf011d44 bf032b68 000223d0 c1ff1e18 c1ff1d3c bf0244c0 bf032b78 00000001
> 1d40: 00000000 60000013 c0398a4c c03989e0 60000013 c1d49000 00000000 c1d490d8
> 1d60: 00000001 00000001 00000000 c1d379c0 c1e0be00 c044560f c1e50ce0 c1ff1d88
> 1d80: c003624c c003360c 00000000 c1d49000 00000000 c0398a70 00000001 00000009
> 1da0: c1ff1dc4 c1ff1db0 c0191088 c0036204 c1ff0000 00000000 c1ff1dd4 c1ff1dc8
> 1dc0: c01a7720 c019103c c1ff1df0 c1ff1df0 c1ff1ddc c003f048 c003360c c1ff0000
> 1de0: 00000102 c1ff1e20 c1ff1df4 c003f150 00000000 000223d0 fffffff2 00000000
> 1e00: 00000000 c044560f 00000000 c1ff1ed4 c1ff1e1c bf026b68 bf023128 00000003
> 1e20: 00000000 c1ff1e2c c1e50ce0 00000000 00000001 00000000 00000000 00000000
> 1e40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000001
> 1e60: 00000000 00000000 00000000 00000000 c1ff1e7c c01a76b4 c01aac20 c1ff1ea0
> 1e80: c1ff1e8c c01a76f0 c003360c c1ff1eb0 c1ff1e9c c004f4ac c003360c 00000004
> 1ea0: c1d49000 c1ff1f10 c0385478 c044560f 000223d0 c1e50ce0 c044560f c0022fe4
> 1ec0: c1ff0000 00018d94 c1ff1ef0 c1ff1ed8 bf0222e4 bf0269c4 c1e50ce0 ffffffe7
> 1ee0: 000223d0 c1ff1f10 c1ff1ef4 c00993dc bf0222ac c1e50ce0 c1f235a0 00000003
> 1f00: 000223d0 c1ff1f84 c1ff1f14 c0099d18 c009936c 00000000 c1ff1f34 c1ff1f28
> 1f20: c01a7720 c019103c c1ff1f50 c1ff1f50 c1ff1f3c c003f048 c003360c c1ff0000
> 1f40: 00000102 c1ff1f80 c1ff1f54 c003f150 c003efc4 00000000 00000001 c1e50ce0
> 1f60: fffffff7 c044560f 00000036 c0022fe4 c1ff0000 00018d94 c1ff1fa4 c1ff1f88
> 1f80: c0099d80 c0099858 00000000 00000000 00000004 00022280 00000000 c1ff1fa8
> 1fa0: c0022e40 c0099d50 00000000 00000004 00000003 c044560f 000223d0 00022414
> 1fc0: 00000000 00000004 00022280 000223d0 00000001 0000000c 00018d94 000220a0
> 1fe0: 00021540 be81e728 00013e68 40129424 80000010 00000003 00000000 00000000
> Backtrace:
> [<c00265a0>] (__bug+0x0/0x2c) from [<c0027504>] (dma_cache_maint+0xa4/0xb8)
> [<c0027460>] (dma_cache_maint+0x0/0xb8) from [<c01e2a40>]
> (usb_hcd_submit_urb+0x14c/0x890)
> [<c01e28f4>] (usb_hcd_submit_urb+0x0/0x890) from [<c01e4380>]
> (usb_submit_urb+0x2a4/0x2ac)
> [<c01e40dc>] (usb_submit_urb+0x0/0x2ac) from [<bf036ed0>]
> (em28xx_init_isoc+0x278/0x2c4 [em28xx])
>  r6:c1d78000 r5:c1e31400 r4:c1dbd3c0
> [<bf036c58>] (em28xx_init_isoc+0x0/0x2c4 [em28xx]) from [<bf031904>]
> (buffer_prepare+0xc4/0xf4 [em28xx])
> [<bf031840>] (buffer_prepare+0x0/0xf4 [em28xx]) from [<bf011ff8>]
> (videobuf_qbuf+0x2c4/0x400 [videobuf_core])
>  r7:c1ff1e2c r6:c1d379cc r5:c1d7cbe0 r4:ffffffea
> [<bf011d34>] (videobuf_qbuf+0x0/0x400 [videobuf_core]) from
> [<bf032b98>] (vidioc_qbuf+0x30/0x3c [em28xx])
>  r8:00000000 r7:c044560f r6:c044560f r5:c1ff1e2c r4:c1d379c0
> [<bf032b68>] (vidioc_qbuf+0x0/0x3c [em28xx]) from [<bf0244c0>]
> (__video_do_ioctl+0x13a8/0x389c [videodev])
>  r5:000223d0 r4:bf032b68
> [<bf023118>] (__video_do_ioctl+0x0/0x389c [videodev]) from
> [<bf026b68>] (video_ioctl2+0x1b4/0x2a4 [videodev])
> [<bf0269b4>] (video_ioctl2+0x0/0x2a4 [videodev]) from [<bf0222e4>]
> (v4l2_ioctl+0x48/0x54 [videodev])
> [<bf02229c>] (v4l2_ioctl+0x0/0x54 [videodev]) from [<c00993dc>]
> (vfs_ioctl+0x80/0x94)
>  r6:000223d0 r5:ffffffe7 r4:c1e50ce0
> [<c009935c>] (vfs_ioctl+0x0/0x94) from [<c0099d18>] (do_vfs_ioctl+0x4d0/0x4f8)
>  r7:000223d0 r6:00000003 r5:c1f235a0 r4:c1e50ce0
> [<c0099848>] (do_vfs_ioctl+0x0/0x4f8) from [<c0099d80>] (sys_ioctl+0x40/0x5c)
> [<c0099d40>] (sys_ioctl+0x0/0x5c) from [<c0022e40>] (ret_fast_syscall+0x0/0x2c)
>  r6:00022280 r5:00000004 r4:00000000
> Code: e1a01000 e59f000c eb0052c5 e3a03000 (e5833000)
> ---[ end trace 68fb0b4324720f98 ]---
>

I thought a kernel oops was a big deal? Anyway, if the em28 device
isn't well supported. What would be a well supported device that has
an component input and preferably has been tested on ARM.

thanks,
Paul

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
