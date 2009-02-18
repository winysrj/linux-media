Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1I6Lhmb008706
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 01:21:43 -0500
Received: from qb-out-0506.google.com (qb-out-0506.google.com [72.14.204.224])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1I6LXld012935
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 01:21:33 -0500
Received: by qb-out-0506.google.com with SMTP id o21so2781753qba.7
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 22:21:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c785bba30902172207ge34c267o996e9afadfd9094e@mail.gmail.com>
References: <83b2c1480902172112p6fb23235w53d9bb750e8bc8cb@mail.gmail.com>
	<c785bba30902172120v26c20484r233ff4bdf98b430b@mail.gmail.com>
	<83b2c1480902172158s51d8f2bbke3476a14bf9b5779@mail.gmail.com>
	<c785bba30902172207ge34c267o996e9afadfd9094e@mail.gmail.com>
Date: Wed, 18 Feb 2009 06:21:32 +0000
Message-ID: <83b2c1480902172221t39628473lda565f03b288a1a0@mail.gmail.com>
From: Sumanth V <sumanth.v@allaboutif.com>
To: Paul Thomas <pthomas8589@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: setting up dvb-s card
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

Thanks Paul, i am usind Debian. The kernel default version was
"2.6.18-6-686".  How do i build v4l-dvb tree ?? should i recomplie my
default kernel again??
When i do " dmesg | grep dvb " it displays
saa7146: register extension 'dvb'.

Thanks.

On Wed, Feb 18, 2009 at 6:07 AM, Paul Thomas <pthomas8589@gmail.com> wrote:

> On Tue, Feb 17, 2009 at 10:58 PM, Sumanth V <sumanth.v@allaboutif.com>
> wrote:
> > Thanks Paul, But i dont see any drivers associated to this card. But the
> > modules are present in
> >
> > /lib/modules/2.6.28/kernel/drivers/media/common/
> > saa7146.ko     saa7146_vv.ko
> >
> > but they dont show up when i do "lsmod", so i used "insmod" to inseret
> them
> > and i was able to insert saa7146.ko , but for saa7146_vv.ko it gave me
> > following error
> > insmod: error inserting 'saa7146_vv.ko': -1 Unknown symbol in module
> >
> > When i do "dmesg" it gives the following error for this module
> >
> > saa7146_vv: Unknown symbol videobuf_streamoff
> > saa7146_vv: Unknown symbol videobuf_poll_stream
> > saa7146_vv: Unknown symbol saa7146_devices_lock
> > saa7146_vv: Unknown symbol videobuf_dma_free
> > saa7146_vv: Unknown symbol videobuf_reqbufs
> > saa7146_vv: Unknown symbol videobuf_waiton
> > saa7146_vv: Unknown symbol videobuf_dqbuf
> > saa7146_vv: Unknown symbol saa7146_debug
> > saa7146_vv: Unknown symbol saa7146_devices
> > saa7146_vv: Unknown symbol videobuf_stop
> > saa7146_vv: Unknown symbol videobuf_queue_sg_init
> > saa7146_vv: Unknown symbol videobuf_dma_unmap
> > saa7146_vv: Unknown symbol videobuf_read_stream
> > saa7146_vv: Unknown symbol videobuf_querybuf
> > saa7146_vv: Unknown symbol saa7146_pgtable_build_single
> > saa7146_vv: Unknown symbol videobuf_qbuf
> > saa7146_vv: Unknown symbol videobuf_read_one
> > saa7146_vv: Unknown symbol saa7146_pgtable_alloc
> > saa7146_vv: Unknown symbol saa7146_pgtable_free
> > saa7146_vv: Unknown symbol videobuf_iolock
> > saa7146_vv: Unknown symbol videobuf_streamon
> > saa7146_vv: Unknown symbol videobuf_queue_cancel
> > saa7146_vv: Unknown symbol videobuf_mmap_setup
> > saa7146_vv: Unknown symbol videobuf_mmap_mapper
> > saa7146_vv: Unknown symbol videobuf_to_dma
> >
> > i am going wrong some where while compiling the kernel for this dvb
> card??
> > can some one guide me getting this card up??
> >
> >
> > Thanks.
> >
> >
> >
> >
> > On Wed, Feb 18, 2009 at 5:20 AM, Paul Thomas <pthomas8589@gmail.com>
> wrote:
> >>
> >> It might already be set up. You can see if there is a driver
> >> associated with it by doing "tree /sys/bus/pci".
> >>
> >> thanks,
> >> Paul
> >>
> >> On Tue, Feb 17, 2009 at 10:12 PM, Sumanth V <sumanth.v@allaboutif.com>
> >> wrote:
> >> > Hi All,
> >> >
> >> >      i am trying to set up a dvb-s card on my system. when i do lspci
> -v
> >> > i
> >> > get this.
> >> >
> >> >  00:0b.0 Multimedia controller: Philips Semiconductors SAA7146 (rev
> 01)
> >> >        Subsystem: KNC One Unknown device 0019
> >> >        Flags: bus master, medium devsel, latency 32, IRQ 5
> >> >        Memory at ea000000 (32-bit, non-prefetchable) [size=512]
> >> >
> >> > i am using the kernel version 2.6.28.
> >> >
> >> > How do i set up this card??
> >> >
> >> > Thanks
> >> > --
> >> > video4linux-list mailing list
> >> > Unsubscribe
> >> > mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> >> > https://www.redhat.com/mailman/listinfo/video4linux-list
> >> >
> >
> >
>
> What distro are you using? I would stick with the kernel that comes
> with your distro it probably has the right modules, but if not you can
> build the v4l-dvb tree against your distros kernel.
>
> thanks,
> Paul
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
