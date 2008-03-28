Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SHP1pa005420
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 13:25:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SHOn8f022528
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 13:24:49 -0400
Date: Fri, 28 Mar 2008 14:24:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Message-ID: <20080328142408.6c8dc198@gaivota>
In-Reply-To: <20080328133537.GS29105@one.firstfloor.org>
References: <47ECD0CF.1020003@gmail.com> <87y783jdjo.fsf@basil.nowhere.org>
	<47ECD715.90507@gmail.com>
	<20080328113803.GQ29105@one.firstfloor.org>
	<47ECE318.1030809@gmail.com>
	<20080328133537.GS29105@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v4l & compat_ioctl
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

On Fri, 28 Mar 2008 14:35:37 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> On Fri, Mar 28, 2008 at 01:22:48PM +0100, Jiri Slaby wrote:
> > On 03/28/2008 12:38 PM, Andi Kleen wrote:
> > >BTW i haven't audited them, but if there is u64 or similar in there 
> > >anywhere
> > >be careful about alignment.
> > 
> > Well, not good, some ioctls have different numbers on 32 and 64 bit:
> 
> Then you need compat handlers to translate the numbers.

V4L has its 32 bits compat module already, defined on
drivers/media/video/compat_ioctl32.c.

Also, the drivers should have this:

        .compat_ioctl = v4l_compat_ioctl32,

on their fops tables:

$ ls -C `grep -l compat_ioctl32 *.c|grep -v mod`

arv.c             meye.c              radio-rtrack2.c   stk-webcam.c
bttv-driver.c     miropcm20-radio.c   radio-sf16fmi.c   stradis.c
bw-qcam.c         ov511.c             radio-sf16fmr2.c  stv680.c
compat_ioctl32.c  pms.c               radio-si470x.c    usbvideo.c
cpia2_v4l.c       pwc-if.c            radio-terratec.c  usbvision-video.c
cpia.c            radio-aimslab.c     radio-trust.c     vicam.c
c-qcam.c          radio-aztech.c      radio-typhoon.c   w9966.c
cx23885-video.c   radio-cadet.c       radio-zoltrix.c   w9968cf.c
cx88-video.c      radio-gemtek.c      saa5249.c         zc0301_core.c
dsbr100.c         radio-gemtek-pci.c  saa7134-video.c   zoran_driver.c
em28xx-video.c    radio-maestro.c     se401.c
et61x251_core.c   radio-maxiradio.c   sn9c102_core.c

It seems that the problem you're suffering is specific to some driver.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
