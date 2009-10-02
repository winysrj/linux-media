Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n92IZ33I019719
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 14:35:03 -0400
Received: from mail-fx0-f205.google.com (mail-fx0-f205.google.com
	[209.85.220.205])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n92IYokj010704
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 14:34:50 -0400
Received: by fxm1 with SMTP id 1so1313040fxm.7
	for <video4linux-list@redhat.com>; Fri, 02 Oct 2009 11:34:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AC64358.3010200@tmr.com>
References: <4AC5FA6E.2000201@tmr.com>
	<829197380910020940o599f5678t60abb2b2da6f8d46@mail.gmail.com>
	<4AC64358.3010200@tmr.com>
Date: Fri, 2 Oct 2009 14:34:49 -0400
Message-ID: <829197380910021134t4df64ddq279ab817b792855@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bill Davidsen <davidsen@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Cc: video4linux M/L <video4linux-list@redhat.com>
Subject: Re: Upgrading from FC4 to current Linux
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

On Fri, Oct 2, 2009 at 2:15 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> I fear you are concentrating on the analog which is only a discussion of
> where things were when there was support. But since you didn't offer any
> suggestions for some user-friendly app I could give users, and I haven't
> found any, I have to assume that the tools which I did find, all requiring a
> significant user expertise to install, configure, and use, are all that's
> available any more.

Ah, well, we can talk about digital TV as well, although I had
excluded it since your references were to analog and this was sent to
the video4linux mailing list as opposed to linux-media.

Compared to digital television support for international standards
like DVB-T, the application support for ATSC/ClearQAM is much weaker.
I added ATSC support to Kaffeine last year, and ClearQAM *should* work
under Kaffeine but it is not heavily tested.  Me-TV supports ATSC as
well, although it has considerable playback problems at high bitrates
(channels such as CBS-HD).  I don't know of any applications that are
easy to use and have support for both digital and analog.  The "easy
to use" apps generally support one or the other, as they tend to have
been developed by different groups of people.

The reason for ATSC/ClearQAM support not being as good as DVB is
pretty simple:  I can count the number of developers who actively
contribute to it on one hand (three of which work for KernelLabs).

The driver support for both ATSC and ClearQAM is pretty mature, but
again most of the problems you will find are in the applications
space.  There also is an issue where because ClearQAM devices are much
newer, there tends to be fewer devices that support both ClearQAM
*and* analog.  There are plenty of devices that support ATSC and
analog but not ClearQAM, and there are plenty of devices that support
ATSC and ClearQAM but not analog.  There are fewer devices though that
support all three.

> Perhaps the days of the Linux desktop are over, at least
> for people who want to install and have it work.

Well, I'm not as extreme as some other developers as to say that
"analog is dead", but like most developers, I don't have any personal
interest in going out of my way to continue supporting it.

> I guess staying with FC4 or going Windows are the only options for users who
> want something easy to use, thanks for assuring me that I didn't miss
> something.

Yeah, short of some commercial entity being willing to support
maintenance of the apps and adding support for new devices, it seems
likely that this is where things are going.  People seem to think they
are somehow entitled for this stuff to "just work" when in reality it
takes an enormous amount of effort, and if developers don't have an
interest in doing it, and nobody is willing to pay for it, then
support will indeed continue to get smaller and smaller.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
