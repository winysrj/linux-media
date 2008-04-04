Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m34BiWAQ001851
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 07:44:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m34BiJvZ010786
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 07:44:19 -0400
Date: Fri, 4 Apr 2008 07:44:11 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
In-Reply-To: <47F5AB2A.3020908@linuxtv.org>
Message-ID: <Pine.LNX.4.64.0804040726540.6240@bombadil.infradead.org>
References: <1115343012.20080318233620@a-j.ru>
	<1207269838.3365.4.camel@pc08.localdom.local>
	<20080403222937.3b234a40@gaivota>
	<200804040456.57561@orion.escape-edv.de>
	<47F5AB2A.3020908@linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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

>> Imho 7186 _must_ be applied to 2.6.24, no matter how large the patch is.
>>
> Are you saying that THIS is the patch that needs to be applied to 2.6.24.y ?
>
> http://linuxtv.org/hg/v4l-dvb/rev/eb6bc7f18024
>
> If so, this patch seems fine for -stable.  We just have to make sure it
> applies correctly, etc.

Agreed.

I don't see why the patch would be rejected for -stable. It is a fix, 
proofed to work, and simple enough for everybody to understand what it is 
doing.

The kernel documents are guidances, not absolute rules. In the end, good 
sense is the main rule for a patch to be applied or not.

---

Next time, please ask first for us to submit a patch to mainstream or 
-stable before complaining why it weren't submitted.

Side note: after reviewing the entire thread, and finally understanding 
the hole picture, it seems that you've implicitly asked. The better is to 
send an objective email. Something like:
 	Subject: [PATCH -stable] Please send patch xxxx to -stable

Requesting to add a patch in the middle of a thread generally means that 
the patch won't be handled as so. The better is to send a separate e-mail, 
with the word [PATCH] at the subject, copying the one who will be 
responsible for applying it at the tree (the driver maintainer or me), for 
this to be handled. In the case of patches for -stable, please c/c 
mkrufky.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
