Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1IH8IIv003757
	for <video4linux-list@redhat.com>; Mon, 18 Feb 2008 12:08:18 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1IH7uj0015194
	for <video4linux-list@redhat.com>; Mon, 18 Feb 2008 12:07:56 -0500
Date: Mon, 18 Feb 2008 14:07:40 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Message-ID: <20080218140740.38746867@gaivota>
In-Reply-To: <200802181736.03492.rjw@sisk.pl>
References: <200802171121.13119.toralf.foerster@gmx.de>
	<20080218131300.529b9862@gaivota> <200802181736.03492.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: build #355 issue for v2.6.25-rc2-15-g1309d4e in function
 v4l2_i2c_attach
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

Hi Rafael,

> > > drivers/built-in.o: In function `v4l2_i2c_attach':
> > > (.text+0x26c67): undefined reference to `i2c_attach_client'
> > > make: *** [.tmp_vmlinux1] Error 1
> > 
> > This bug were already fixed. I'm waiting for Linus to pull. The patches fixing
> > it are available at:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git
> 
> Specific commits or just everything?

There are three commits for this broken dependency, covered by bug #9823:
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=a9254475bbfbed5f0596d952c6a3c9806e19dd0b
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=1a4e30c3eaffb83218977477bb83d54316844acb
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=057596eea8402aa8f7a670bf3195665aa8267204

The above commits move some code from v4l2-common into videodev and fixes
Kconfig. After the three patches, videodev is not dependent anymore of
v4l2-common.

You should notice also that bug #9965 (marked as duplicate) pointed to the
above bug, and also to another one:
	ERROR: "release_firmware" [drivers/media/video/tuner-xc2028.ko] undefined! 
	ERROR: "request_firmware" [drivers/media/video/tuner-xc2028.ko] undefined!

The second bug is fixed by a separate commit:
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commit;h=ea35e3a754b2ba5f712c3f4df55e426ae2e4d60a

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
