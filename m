Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1RAYmJH013784
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 05:34:48 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1RAYBHp023648
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 05:34:11 -0500
Date: Wed, 27 Feb 2008 07:33:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Message-ID: <20080227073307.2ed6dc3d@areia>
In-Reply-To: <20080227102309.GA6698@joi>
References: <20080225205055.GA27455@joi>
	<20080226133222.7af260b2@hyperion.delvare>
	<20080226210307.GA6085@joi>
	<20080226232320.2df756d6@hyperion.delvare>
	<20080227102309.GA6698@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jean Delvare <khali@linux-fr.org>, video4linux-list@redhat.com,
	LKML <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
Subject: Re: [PATCH] video: limit stack usage of ir-kbd-i2c.c
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

On Wed, 27 Feb 2008 11:23:26 +0100
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> On Tue, Feb 26, 2008 at 11:23:20PM +0100, Jean Delvare wrote:
> > Hi Marcin,
> Hi
>  
> > On Tue, 26 Feb 2008 22:03:16 +0100, Marcin Slusarz wrote:
> > > Do you have an idea (or patch :D) how to solve this:
> > > 0x00000234 v4l_compat_translate_ioctl [v4l1-compat]:    1376
> > > ? That's on top of my make checkstack output
> > 
> > Random ideas (but I am in no way a specialist of this exercise):
> > 
> > * You could try moving the structures to the blocks where they are used,
> > in the case a given structure is used for only one ioctl. I'm not too
> > sure how gcc handles local variables declared inside blocks with
> > regards to stack reservation though. I thought it would work but my
> > experiments today seem to suggest it doesn't.
> That won't work. Variables at beginning of function take only ~600 bytes,
> so the rest must be from inner blocks and inlines (probably).
> 
> > * You can move the handling of some ioctls to dedicated functions, just
> > like I did in i2c-dev:
> > http://lists.lm-sensors.org/pipermail/i2c/2008-February/003010.html
> > However there is a risk that gcc will inline these functions (that's
> > what happened to me...) Not sure how to prevent gcc from inlining.
> There's "noinline" attribute in linux/compiler.h (compiler-gcc.h actually)
> for these situations.
>  
> > * You can allocate the structures dynamically, as you originally wanted
> > to do for ir-kbd-i2c. However this has a performance penalty and will
> > fragment the memory, so it's not ideal.
> > 
> > * If each ioctl uses only one of the structures, you may define a union
> > of all the structures. The size of the union will be the size of the
> > biggest structure, so you save a lot of space on the stack.
> Nice idea.
> 
> I'll try 2nd and 4th approaches.

The union will probably solve. This function is very complex, since it needs to
deal with almost all v4l1 v4l2 ioctls (about 80-90). Splitting into small
functions might help, but probably, gcc will create the functions as inline.


> 
> Marcin Slusarz



Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
