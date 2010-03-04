Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o24BTGHW009231
	for <video4linux-list@redhat.com>; Thu, 4 Mar 2010 06:29:17 -0500
Received: from smtp.positive-internet.com (pop3.positive-internet.com
	[80.87.128.64])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o24BT2Tb028132
	for <video4linux-list@redhat.com>; Thu, 4 Mar 2010 06:29:03 -0500
Subject: Re: em28xx v4l-info returns gibberish on igepv2
From: John Banks <john.banks@noonanmedia.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
In-Reply-To: <829197381003030656q6b5cf73eybcf30b713ba9be37@mail.gmail.com>
References: <1267621938.3066.46.camel@chimpin>
	<829197381003030656q6b5cf73eybcf30b713ba9be37@mail.gmail.com>
Date: Thu, 04 Mar 2010 11:29:01 +0000
Message-ID: <1267702141.5175.15.camel@chimpin>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, 2010-03-03 at 09:56 -0500, Devin Heitmueller wrote:
> On Wed, Mar 3, 2010 at 8:12 AM, John Banks <john.banks@noonanmedia.com> wrote:
> > I have an usb capture card that accepts composite and svideo and outputs
> > raw video through v4l2.
> >
> > When running the card on my laptop (ubuntu karmic) I am able to use
> > gstreamer to dump the raw video to a file. It comes out as yuv and can
> > be easily played back.
> 
> Hi John
> 
> I saw your question on #linuxtv yesterday, and reached out to you but
> I guess you didn't see the message.
> 
> I did some ARM work for the em28xx last year, and assuming there has
> been no regression, it should be working fine.  The fact that even the
> enumstd ioctl is returning zero'd data suggests that you've got some
> sort of basic userland/kernel communications problem, since that
> command has no interaction with the hardware at all (the driver fills
> out the result with statically defined data).  It might also be some
> sort of bug in v4l2-info.
> 
> Have you tried writing a quick 50-line C program that performs the
> ioctl and dumps the result?  That might help you narrow down whether
> it's a v4l2-info problem.
> 
> Without a board though, I'm not quite sure how I could debug this.
> 
> Devin
> 

Hey Devin,

Sorry I must have missed your message on irc, I had hung around for most
of the day, must have just missed you at the end.

Having never used ioctl before I spent most of the day reading up.

I created a dump as you suggested and you are right, it seems to be a
v4l-info problem.

chimp@ll-1:~/source/ioctl$ ./ioctl 
index:
0
id:
34592
name:
NTSC
frameperiod-numerator:
1001
frameperiod-denominator:
30000
framelines:
525
reserved:

As you can see I get the correct output. I think it has to do with the
size of variables created in struct-v4l2.c as they don't match the
declaration in videodev2.h

Anyway this doesn't help to explain why I get the 0000's seen in the
hexdump of the file. I had been hoping that it was incorrectly reading
the variables it needed in order for it to create the output correctly.

I was originally using the gstreamer v4l2src module that was in the
repositories but I tried compiling the gstreamer provided by TI (it
contains extra plugins for use on the dsp) but the same problem
occurred.

If I want to further track down this problem, where should I look?

Cheers

-- 
John Banks - Head of Engineering
Noonan Media Ltd 

www.noonanmedia.com 

MB: +44 779 62 64 707 
E: john.banks@noonanmedia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
