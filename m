Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m34DNuq4020717
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 09:23:56 -0400
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m34DNhcr018129
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 09:23:43 -0400
Received: by gv-out-0910.google.com with SMTP id l14so14998gvf.13
	for <video4linux-list@redhat.com>; Fri, 04 Apr 2008 06:23:41 -0700 (PDT)
Message-ID: <37219a840804040623i274d7292ledbe91ac7a531171@mail.gmail.com>
Date: Fri, 4 Apr 2008 09:23:33 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <47F6258B.7020207@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1115343012.20080318233620@a-j.ru>
	<1207269838.3365.4.camel@pc08.localdom.local>
	<20080403222937.3b234a40@gaivota>
	<200804040456.57561@orion.escape-edv.de>
	<47F5AB2A.3020908@linuxtv.org>
	<Pine.LNX.4.64.0804040726540.6240@bombadil.infradead.org>
	<47F6258B.7020207@linuxtv.org>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
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

On Fri, Apr 4, 2008 at 8:56 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>
> Mauro Carvalho Chehab wrote:
>  >>> Imho 7186 _must_ be applied to 2.6.24, no matter how large the patch is.
>  >>>
>  >> Are you saying that THIS is the patch that needs to be applied to 2.6.24.y ?
>  >>
>  >> http://linuxtv.org/hg/v4l-dvb/rev/eb6bc7f18024
>  >>
>  >> If so, this patch seems fine for -stable.  We just have to make sure it
>  >> applies correctly, etc.
>  >
>  > Agreed.
>  >
>  > I don't see why the patch would be rejected for -stable. It is a fix,
>  > proofed to work, and simple enough for everybody to understand what it is
>  > doing.
>  >
>  > The kernel documents are guidances, not absolute rules. In the end, good
>  > sense is the main rule for a patch to be applied or not.
>  >
>  > ---
>  >
>  > Next time, please ask first for us to submit a patch to mainstream or
>  > -stable before complaining why it weren't submitted.
>  >
>  > Side note: after reviewing the entire thread, and finally understanding
>  > the hole picture, it seems that you've implicitly asked. The better is to
>  > send an objective email. Something like:
>  >       Subject: [PATCH -stable] Please send patch xxxx to -stable
>  >
>  > Requesting to add a patch in the middle of a thread generally means that
>  > the patch won't be handled as so. The better is to send a separate e-mail,
>  > with the word [PATCH] at the subject, copying the one who will be
>  > responsible for applying it at the tree (the driver maintainer or me), for
>  > this to be handled. In the case of patches for -stable, please c/c
>  > mkrufky.
>
>
>
>  Guys,
>
>  Please test this patch against 2.6.24.4 -stable.
>
>  I don't have this hardware, or any way to test this myself, so I will wait on your feedback before sending this to the -stable team.  (Please try to test it and get back to me quickly -- I'd like to send this over before the 2.6.24.5 review cycle begins)


I also uploaded the patch to linuxtv.org, in case of mailer whitespace-mangling:

http://linuxtv.org/~mkrufky/stable/2.6.24.y/0002-DVB-tda10086-make-the-22kHz-tone-for-DISEQC-a-conf.patch

Please test.

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
