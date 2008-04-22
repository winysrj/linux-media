Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MJYb7V027919
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 15:34:38 -0400
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.180])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3MJXoiH011892
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 15:33:50 -0400
Received: by el-out-1112.google.com with SMTP id n30so804116elf.21
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 12:33:49 -0700 (PDT)
Date: Tue, 22 Apr 2008 12:33:42 -0700
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080422193342.GN7392@plankton.ifup.org>
References: <480D5AF9.4030808@linuxtv.org>
	<20080422034449.GC24855@plankton.ifup.org>
	<20080422122201.0a70b151@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422122201.0a70b151@gaivota>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: Hauppauge HVR1400 DVB-T support / XC3028L
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

On 12:22 Tue 22 Apr 2008, Mauro Carvalho Chehab wrote:
> On Mon, 21 Apr 2008 20:44:49 -0700
> Brandon Philips <brandon@ifup.org> wrote:
> > On 23:26 Mon 21 Apr 2008, Steven Toth wrote:
> > >  I've passed some patches to Mauro that add support for the Hauppauge
> > >  HVR1400 Expresscard in DVB-T mode. (cx23885 bridge, dib7000p
> > >  demodulator and the xceive xc3028L silicon tuner)
> > >
> > >  If you're interested in testing then wait for the patches to appear
> > >  in the http://linuxtv.org/hg/v4l-dvb tree.
> > >
> > >  You'll need to download firmware from
> > >  http://steventoth.net/linux/hvr1400
> > >
> > >  Post any questions or issues here.
> > 
> > Could you post the patches to the lists for review?  CC'ing both
> > linux-dvb@linuxtv.org and video4linux-list@redhat.com is appropriate.
> > 
> > It is really difficult staying on top of V4L with private trees and
> > private mails going around  :(
> 
> The better way for you to track about committed patches is what's described on
> item 5: "Knowing about newer patches committed at master hg repository", of
> http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches.
> 
> Basically, if you subscribe to linuxtv-commits ML[1], you'll receive an email for
> every newly committed changeset.

I think the list is broken.  The archives haven't received anything
since Feb.  2008... http://www.linuxtv.org/pipermail/linuxtv-commits/

I also signed up but haven't receive emails from anything you merged a
few hours ago.

> I think it is better to have a separate list for this, to avoid increasing the
> traffic at the main lists, since we have a large number of commits, especially
> during the merge window.
>
> For example, it is expected a 50 patch series with
> improvements to pvrusb2. Just flooding those emails to the main lists seems
> overkill to most users. Better to keep this in track on a separate ML.

Ok, we need some list that is open to everyone and gets a majority of
the patches.  If linuxtv-commits gets fixed up that might work.

> This is just my 2 cents. I'm open to discuss improvements on this
> process.

I am just concerned about the v4l-dvb-maintainers list being too private
and private trees not getting enough review before going into mainline.
linuxtv-commits may help.

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
