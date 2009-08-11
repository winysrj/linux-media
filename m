Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7BHpuFH005243
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 13:51:56 -0400
Received: from mail-yw0-f203.google.com (mail-yw0-f203.google.com
	[209.85.211.203])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n7BHpeFC016194
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 13:51:40 -0400
Received: by ywh41 with SMTP id 41so5566472ywh.23
	for <video4linux-list@redhat.com>; Tue, 11 Aug 2009 10:51:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A81AC59.5020306@tmr.com>
References: <4A7B2BDB.5000906@tmr.com>
	<829197380908061221l54ba8f1pcbec404200ae6c93@mail.gmail.com>
	<4A7B37F9.8070905@tmr.com>
	<829197380908061318x5ee6ccfbn5d8890e98b6f6325@mail.gmail.com>
	<4A81AC59.5020306@tmr.com>
Date: Tue, 11 Aug 2009 13:51:40 -0400
Message-ID: <829197380908111051v3e446534k73ae23883c510e65@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Bill Davidsen <davidsen@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

On Tue, Aug 11, 2009 at 1:37 PM, Bill Davidsen<davidsen@tmr.com> wrote:
> Since you quoted the HVR-950Q as working, I tried one of those. Someone else
> said the ATI HDTV-Wonder works. Neither do. I tried all of the programs
> people swore work with these cards: tvtime, xawtv, cheese, and vlc. Mythtv
> appears to need the whole system tuned to be a pvr, not the intent here,
> users want to monitor CNN, MSNBC, and similar news or financial channels in
> a window without needing to get a TV for each seat.

Well since I did the support for the HVR-950Q, I'm pretty sure it
works. :-)  With regards to the "ATI HDTV-Wonder" card you referred
to, there are many cards with that name, so you would need to be more
specific (providing a model number and bus type).  For example, I did
the work for the "ATI TV Wonder HD 600 USB".  For analog support, both
of the above cards work fine with tvtime.

If you have a specific case that is causing you problems, please
provide details as to exactly which card you are trying to use, which
distro and application you are using, and what errors you are seeing
and we will see if we can help you debug your problem.  But saying
vague things like "nothing works" isn't really a constructive way to
improve your situation.

> And after all that I am still at ground zero, not only nothing I would date
> try to give to an end user, but nothing I want to use myself, tuning by
> frequencies in MHz, good grief! The kernel loads drivers and makes entries
> in /dev/dvb and/or /dev/videoN, but none of the software people suggested
> does anything useful.

You only need to tune to something specifying MHz if you are using the
command line tools.  The GUI applications have built in mechanisms to
change channels.

I agree that there is plenty of room for improvement in the
application space.  Feel free to roll up your sleeves and help out
(that's how I got involved in the project, after all).  Given the
number of devices people are demanding support for, we are quite
understaffed and could use all the help we could get.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
