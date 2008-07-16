Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6GDhu9A005625
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 09:43:56 -0400
Received: from jem.yoyo.org (jem.yoyo.org [193.110.91.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6GDhCLZ010237
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 09:43:12 -0400
Date: Wed, 16 Jul 2008 14:43:07 +0100
From: Anthony Edwards <anthony@yoyo.org>
To: Michael Krufky <mike@krufky.com>
Message-ID: <20080716134307.GC9609@yoyo.org>
References: <20080716125556.GA9609@yoyo.org> <487DF0C6.6080209@krufky.com>
	<20080716132833.GB9609@yoyo.org> <487DF81C.5010908@krufky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487DF81C.5010908@krufky.com>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: smscoreapi.c:689: error: 'uintptr_t' undeclared
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

On Wed, Jul 16, 2008 at 09:31:08AM -0400, Michael Krufky wrote:
> Anthony Edwards wrote:
> > On Wed, Jul 16, 2008 at 08:59:50AM -0400, Michael Krufky wrote:
> >> Anthony Edwards wrote:
> >>> This appears to be an issue affecting a number of users, for example:
> >>>
> >>> http://forum.linuxmce.org/index.php?action=profile;u=41878;sa=showPosts
> >>>
> >>> I have experienced it too today after attempting to recompile drivers
> >>> for my Hauppauge Nova-T USB TV tuner following an Ubuntu kernel update.
> >>>
> >>> After obtaining the latest source code using hg clone, I have found
> >>> that it will not successfully compile.  I am seeing the same make
> >>> errors as the poster in the posting referenced above.
> >>>
> >>> Unfortunately, I lack the necessary programming knowledge to hack the
> >>> source code in order to make it work.
> >>>
> >>> Is a fix in the pipeline?
> >>>
> >> The fix is here -- please feel free to test it:
> >>
> >> http://linuxtv.org/hg/~mkrufky/sms1xxx
> >>
> >> I sent a pull request to Mauro a few days ago -- I don't know why it has not been merged yet.
> > 
> > Unfortunately I lack programming knowledge or experience so am not
> > entirely certain of my understanding of what is meant by the above,
> > however I have edited:
> > 
> > linux/drivers/media/dvb/siano/smscoreapi.h
> > 
> > So that instead of reading, lines 25 - 30:
> > 
> > #include <linux/version.h>
> > #include <linux/device.h>
> > #include <linux/list.h>
> > #include <linux/mm.h>
> > #include <linux/scatterlist.h>
> > #include <asm/page.h>
> > 
> > It now reads, lines 25 - 31:
> > 
> > #include <linux/version.h>
> > #include <linux/device.h>
> > #include <linux/list.h>
> > #include <linux/mm.h>
> > #include <linux/scatterlist.h>
> > #include <linux/types.h>
> > #include <asm/page.h>
> > 
> > That hasn't had the desired effect though, since compilation attempts
> > are still failing as follows:
> > 
> > /home/anthony/Software/v4l-dvb/v4l/smscoreapi.c: In function 'smscore_detect_mode':
> > /home/anthony/Software/v4l-dvb/v4l/smscoreapi.c:689: error: 'uintptr_t' undeclared (first use in this function)
> > /home/anthony/Software/v4l-dvb/v4l/smscoreapi.c:689: error: (Each undeclared identifier is reported only once
> > /home/anthony/Software/v4l-dvb/v4l/smscoreapi.c:689: error: for each function it appears in.)
> > /home/anthony/Software/v4l-dvb/v4l/smscoreapi.c: In function 'smscore_set_device_mode':
> > /home/anthony/Software/v4l-dvb/v4l/smscoreapi.c:820: error: 'uintptr_t' undeclared (first use in this function)
> > make[3]: *** [/home/anthony/Software/v4l-dvb/v4l/smscoreapi.o] Error 1
> > make[2]: *** [_module_/home/anthony/Software/v4l-dvb/v4l] Error 2
> > make[2]: Leaving directory `/usr/src/linux-headers-2.6.22-15-generic'
> > make[1]: *** [default] Error 2
> > make[1]: Leaving directory `/home/anthony/Software/v4l-dvb/v4l'
> > make: *** [all] Error 2
> > 
> > Presumably, if I have understood your instructions and followed them
> > correctly, something more is additionally needed?
> > 
> 
> 
> Yes.  The fix is in the tree that I pointed to in my previous email.
> 
> -Mike

Can you provide more detail please?

When I visit the URL that you referenced:

http://linuxtv.org/hg/~mkrufky/sms1xxx

I see a web page with multiple, different changes listed.

The only one that appears relevant to the issue that is the subject of
this thread is:

http://linuxtv.org/hg/~mkrufky/sms1xxx/rev/d49b1e522b37

I have, to the best of my knowledge, followed the instructions in
that link, and they do not appear to have worked.

What do you recommend that I do next?

-- 
Anthony Edwards
anthony@yoyo.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
