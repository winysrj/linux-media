Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2J4QPt9023195
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 00:26:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2J4PsJA017216
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 00:25:55 -0400
Date: Wed, 19 Mar 2008 00:25:53 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <47E060EB.5040207@t-online.de>
Message-ID: <Pine.LNX.4.64.0803190017330.24094@bombadil.infradead.org>
References: <47E060EB.5040207@t-online.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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

On Wed, 19 Mar 2008, Hartmut Hackmann wrote:

> Mauro, what's your opinion on this? As far as i know, the broken code is in the upcoming
> kernel release. The patch is big, is there a chance to commit it to the kernel?

While some fixes are cosmetic (like __func__ change), and others are just 
function reordering, I suspect that the real changes are still too big for 
-rc6. It will probably be nacked.

Yet, it may be worthy to try.

I still need to send a patchset to Linus, after testing compilation 
(unfortunately, I had to postpone, since I need first to free some 
hundreds of Mb on my HD on my /home, to allow kernel compilation). 
Hopefully, I'll have some time tomorrow for doing a "housekeeping".

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
