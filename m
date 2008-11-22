Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAMMto90004103
	for <video4linux-list@redhat.com>; Sat, 22 Nov 2008 17:55:50 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAMMtb85011089
	for <video4linux-list@redhat.com>; Sat, 22 Nov 2008 17:55:37 -0500
Date: Sat, 22 Nov 2008 20:55:27 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Message-ID: <20081122205527.459fcc74@pedra.chehab.org>
In-Reply-To: <1227384295.1828.8.camel@palomino.walls.org>
References: <1227384295.1828.8.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: v4l-dvb build doesn't work for 2.6.23.15-80.fc7
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

On Sat, 22 Nov 2008 15:04:55 -0500
Andy Walls <awalls@radix.net> wrote:

> Mauro,
> 
> v4l-dvb build fails on one of my setups:
> 
> $ uname -a
> Linux palomino.walls.org 2.6.23.15-80.fc7 #1 SMP Sun Feb 10 16:52:18 EST 2008 x86_64 x86_64 x86_64 GNU/Linu
> 
> $ make
> [snip]
>   CC [M]  /home/andy/cx18dev/v4l-dvb/v4l/ks0127.o
>   LD [M]  /home/andy/cx18dev/v4l-dvb/v4l/zr36067.o
>   CC [M]  /home/andy/cx18dev/v4l-dvb/v4l/videocodec.o
> /home/andy/cx18dev/v4l-dvb/v4l/videocodec.c: In function 'videocodec_init':
> /home/andy/cx18dev/v4l-dvb/v4l/videocodec.c:381: error: implicit declaration of function 'proc_create'
> /home/andy/cx18dev/v4l-dvb/v4l/videocodec.c:381: warning: assignment makes pointer from integer without a cast
> make[3]: *** [/home/andy/cx18dev/v4l-dvb/v4l/videocodec.o] Error 1
> make[2]: *** [_module_/home/andy/cx18dev/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/kernels/2.6.23.15-80.fc7-x86_64'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/andy/cx18dev/v4l-dvb/v4l'
> make: *** [all] Error 2
> 
> 
> By inspection, I think this may be the change that did it (I'm not
> sure):
> 
> http://linuxtv.org/hg/v4l-dvb/rev/90deb49c4730
> 
> 
> My workaround for myself is to just disable building all the zoran
> stuff.

Hmm... I did a small mistake at the compat thing. Please test if the new commit fixed it.
> 
> Regards,
> Andy
> 
> 




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
