Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2JMdMFK028738
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 18:39:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2JMcm0B014107
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 18:38:49 -0400
Date: Wed, 19 Mar 2008 19:38:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Message-ID: <20080319193832.643bf8a0@gaivota>
In-Reply-To: <47E190CF.9050904@t-online.de>
References: <47E060EB.5040207@t-online.de>
	<Pine.LNX.4.64.0803190017330.24094@bombadil.infradead.org>
	<47E190CF.9050904@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	LInux DVB <linux-dvb@linuxtv.org>
Subject: Re: [RFC] TDA8290 / TDA827X with LNA: testers wanted
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

On Wed, 19 Mar 2008 23:16:47 +0100
Hartmut Hackmann <hartmut.hackmann@t-online.de> wrote:

> Hi, Mauro
> 
> Mauro Carvalho Chehab schrieb:
> > On Wed, 19 Mar 2008, Hartmut Hackmann wrote:
> > 
> >> Mauro, what's your opinion on this? As far as i know, the broken code
> >> is in the upcoming
> >> kernel release. The patch is big, is there a chance to commit it to
> >> the kernel?
> > 
> > While some fixes are cosmetic (like __func__ change), and others are
> > just function reordering, I suspect that the real changes are still too
> > big for -rc6. It will probably be nacked.
> > 
> > Yet, it may be worthy to try.
> 
> This was my opinion as well.
> Did you notice Michaels reply on this issue? He pointed out that the problem
> was introduced by this changeset:
> http://linuxtv.org/hg/v4l-dvb/rev/ad6fb7fe6240 : Add support for xc3028-based boards
> 
> If this did not go to Linus yet, we don't have a problem. This also explains
> why we don't have bug reports on this.

It didn't reach mainstream yet. About the bug report, there's a related bug, on
a thread about Avermedia A16D. The issue is that "dev" is NULL but this
shouldn't happen (otherwise, all callbacks will fail).

On your patch, you're just returning, if dev=NULL, at saa7134 callback function. IMO, the correct would be to
print an error message and return. Also, we should discover why dev is being
null there (I'll try to identify here - the reason - yet, I can't really test,
since the saa7134 boards I have don't need any callback.
> 
> > 
> > I still need to send a patchset to Linus, after testing compilation
> > (unfortunately, I had to postpone, since I need first to free some
> > hundreds of Mb on my HD on my /home, to allow kernel compilation).
> > Hopefully, I'll have some time tomorrow for doing a "housekeeping".
> > 
> Unfortunately, i deleted you mails describing what went to linux and i don't
> have the RC source here :-(

You may take a look on master branch on my git tree. I'm about to forward him a
series of patches. Hopefully, 2GB free space will be enough for a full kernel
compilation. I'll discover soon...


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
