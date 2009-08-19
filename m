Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7JIrKJY005256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Wed, 19 Aug 2009 14:53:20 -0400
Received: from mail-yx0-f202.google.com (mail-yx0-f202.google.com
	[209.85.210.202])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7JIr6x5016960
	for <video4linux-list@redhat.com>; Wed, 19 Aug 2009 14:53:07 -0400
Received: by yxe40 with SMTP id 40so6062794yxe.23
	for <video4linux-list@redhat.com>; Wed, 19 Aug 2009 11:53:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A81E717.1040509@tmr.com>
References: <4A7B2BDB.5000906@tmr.com>
	<829197380908061221l54ba8f1pcbec404200ae6c93@mail.gmail.com>
	<4A7B37F9.8070905@tmr.com>
	<829197380908061318x5ee6ccfbn5d8890e98b6f6325@mail.gmail.com>
	<4A81AC59.5020306@tmr.com>
	<829197380908111051v3e446534k73ae23883c510e65@mail.gmail.com>
	<4A81E717.1040509@tmr.com>
Date: Wed, 19 Aug 2009 14:53:05 -0400
Message-ID: <829197380908191153w2dff4df7x16300553c733e0a8@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bill Davidsen <davidsen@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux M/L <video4linux-list@redhat.com>
Subject: Re: Is there any working video capture card which works and is
	still made?
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

On Tue, Aug 11, 2009 at 5:48 PM, Bill Davidsen<davidsen@tmr.com> wrote:
> Do you have some particular application with which you think it "works?" If
> by works you mean a /dv/video0 and /dev/dvb/* ar created and the kernel log
> shows no errors, then it works. By works I mean there is some application (I
> listed several) which actually has audio and video, and the number of such I
> can identify is still zero. When analog cards were being made virtually
> every application worked fine,

There's no need to be patronizing.  Since the 950q support required me
to add around 3000 lines to the codebase, I am quite capable of
distinguishing the difference between a /dev/video0 device file being
created and a product actually working.  That sort of attitude might
be appropriate when dealing with tech support for a company you just
gave money to, but probably isn't the best approach to get help from a
group of volunteer developers.

Regarding apps that are known to work:  tvtime.  mplayer.  I don't
"think" it works.  I *know* it works, at least in my environment as
well as several dozen other users who have done testing and provided
feedback.

Since you are comparing against older devices where you believed
"every application worked fine", I am sure you are aware that all the
applications have issues with audio on raw analog capture devices, and
that the way it is dealt with varies by application.  Tvtime doesn't
support it at all - you have to run tvtime in conjunction with
arecord/aplay in a separate window.  mplayer allows you to specify the
location of the ALSA record device as a command line argument.  None
of this is specific to newer devices as the apps have the same
problems with older devices as well.

>> If you have a specific case that is causing you problems, please
>> provide details as to exactly which card you are trying to use, which
>> distro and application you are using, and what errors you are seeing
>> and we will see if we can help you debug your problem.  But saying
>> vague things like "nothing works" isn't really a constructive way to
>> improve your situation.
>>
>>
>
> I went out and got the HVR-950Q because you said it worked, as noted above
> the kernel like it but nothing I can find will use it usefully, I posted the
> lspci -vvvv for the ATI HDTV-Wonder, what exactly more do you need to
> identify a specific card? This is the problem I've had for years, that cards
> with the same part number aren't the same part. :-(

I'm making an active effort to understand what is unique about your
environment so we can figure out why it doesn't work for you while so
many others are reporting success.  I just double checked the thread
and don't see the lspci output for the ATI card as you suggested.  Did
you post it on some other thread of discussion?

It's probably also worth mentioning that the 950q analog support was
added recently (March), so if your distro is too old it will not be in
there yet (in which case you won't see the /dev/video0 device at all).

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
