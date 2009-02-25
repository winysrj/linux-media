Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1PF92Cr012164
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 10:09:02 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1PF86KV027347
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 10:08:08 -0500
Date: Wed, 25 Feb 2009 09:07:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Vitaly Wool <vital@embeddedalley.com>
Message-ID: <20090225090728.7f2b0673@caramujo.chehab.org>
In-Reply-To: <49A53CB9.1040109@embeddedalley.com>
References: <49A3A61F.30509@embeddedalley.com>
	<20090224234205.7a5ca4ca@pedra.chehab.org>
	<49A53CB9.1040109@embeddedalley.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, em28xx@mcentral.de
Subject: Re: em28xx: Compro VideoMate For You sound problems
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

On Wed, 25 Feb 2009 15:42:33 +0300
Vitaly Wool <vital@embeddedalley.com> wrote:

> Hello Mauro,
> 
> Mauro Carvalho Chehab wrote:
> 
> > On Tue, 24 Feb 2009 10:47:43 +0300
> > Vitaly Wool <vital@embeddedalley.com> wrote:
> >
> >> Hello,
> >>
> >> about half a year ago I posted the patch that basically enabled Compro 
> >> VideoMate For You USB TV box support.
> >> The main problem is I couldn't get the sound working. I was poking 
> >> around that for some time then but gave up soon. Now I spent some time 
> >> debugging the problem without any real success, tried the new 
> >> (alternative) version of the em28xx driver suite from Markus and had no 
> >> luck with it either.
> >>
> >> So I kind of decomposed the box and found out the audio decoder chip 
> >> used there was Philips TDA9874A. As far as I can see, it's not supported 
> >> within the em28xx suite although it is for other TV tuner drivers. Could 
> >> anyone please give me some guidance on how to add that to em28xx to 
> >> shorten my way to getting the sound working on that good ol' box?
> >
> > Could you please try to load tvaudio module and see what happens? Please probe
> > it with debug info and post here the results.
> here it is:
> 
> [78735.039693] tvaudio: TV audio decoder + audio/video mux driver
> 
> [78735.039693] tvaudio: known chips: tda9840, tda9873h, tda9874h/a, tda9850, tda9855, tea6300, tea6320, tea6420, tda8425, pic16c54 (PV951), ta8874z
> 
> [78735.039693] tvaudio' 1-0058: chip found @ 0xb0
> 
> [78735.049368] tvaudio' 1-0058: tvaudio': chip_read2: reg254=0x11
> 
> [78735.068049] tvaudio' 1-0058: tvaudio': chip_read2: reg255=0x2
> 
> [78735.068056] tvaudio' 1-0058: tda9874a_checkit(): DIC=0x11, SIC=0x2.
> 
> [78735.068059] tvaudio' 1-0058: found tda9874a.
> 
> [78735.068063] tvaudio' 1-0058: tda9874h/a found @ 0xb0 (em28xx #0)
> 
> [78735.068066] tvaudio' 1-0058: tda9874h/a: chip_write: reg0=0x0
> 
> [78735.079304] tvaudio' 1-0058: tda9874h/a: chip_write: reg1=0xc0
> 
> [78735.091299] tvaudio' 1-0058: tda9874h/a: chip_write: reg2=0x2
> 
> [78735.103300] tvaudio' 1-0058: tda9874h/a: chip_write: reg11=0x80
> 
> [78735.115291] tvaudio' 1-0058: tda9874h/a: chip_write: reg12=0x0
> 
> [78735.126706] tvaudio' 1-0058: tda9874h/a: chip_write: reg13=0x0
> 
> [78735.138668] tvaudio' 1-0058: tda9874h/a: chip_write: reg14=0x1
> 
> [78735.150665] tvaudio' 1-0058: tda9874h/a: chip_write: reg15=0x0
> 
> [78735.162661] tvaudio' 1-0058: tda9874h/a: chip_write: reg16=0x14
> 
> [78735.174656] tvaudio' 1-0058: tda9874h/a: chip_write: reg17=0x50
> 
> [78735.186651] tvaudio' 1-0058: tda9874h/a: chip_write: reg18=0xf9
> 
> [78735.198648] tvaudio' 1-0058: tda9874h/a: chip_write: reg19=0x80
> 
> [78735.208703] tvaudio' 1-0058: tda9874h/a: chip_write: reg20=0x80
> 
> [78735.220988] tvaudio' 1-0058: tda9874h/a: chip_write: reg24=0x80
> 
> [78735.232982] tvaudio' 1-0058: tda9874h/a: chip_write: reg255=0x0
> 
> [78735.244979] tvaudio' 1-0058: tda9874a_setup(): A2, B/G [0x00].
> 
> [78735.246530] tvaudio' 1-0058: tda9874h/a: thread started]

Ok, so if everything else is properly configured on em28xx, you should have
audio working. 

I've just committed a patch that should automatically load tvaudio for your
board. Could you please test it?

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
