Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m149Nffg000859
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 04:23:41 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m149N9e0019579
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 04:23:09 -0500
Date: Mon, 4 Feb 2008 07:22:33 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Andy McMullan" <andy@andymcm.com>
Message-ID: <20080204072233.073d40da@gaivota>
In-Reply-To: <fea7c4860802030606v6614d884i1a5e71980709739f@mail.gmail.com>
References: <fea7c4860802030504k60ab0466ta03572a9083a69e@mail.gmail.com>
	<fea7c4860802030606v6614d884i1a5e71980709739f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: bt878 'interference' on fc6 but not fc1
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

On Sun, 3 Feb 2008 14:06:05 +0000
"Andy McMullan" <andy@andymcm.com> wrote:

> > I've been using a Hauppauge WinTv (bt878) card with fedora core 1 for
> > some time with no problems.  Yesterday I added a Fedora Core 6
> > installation to the same PC (dual-boot), but when running FC6 I see a
> > sort of wavey flickery interference pattern.   Switch back to FC1 and
> > there's no interference.
> 
> Well, I've discovered that if my TV is off, the interference goes
> away, so obviously it's electrical interference from the TV.   I
> really don't understand how that would show up in FC6 and not FC1,
> though.

Maybe it have something to do with some power saving cycle at the processor.
You may try to change powersave governor policy and see the results.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
