Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CF7Q3X021145
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 11:07:26 -0400
Received: from smtp-vbr2.xs4all.nl (smtp-vbr2.xs4all.nl [194.109.24.22])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4CF6gPW022518
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 11:06:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Date: Mon, 12 May 2008 17:05:58 +0200
References: <481B1027.1040002@linuxtv.org>
	<1209782607.27140.14.camel@palomino.walls.org>
In-Reply-To: <1209782607.27140.14.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805121705.58552.hverkuil@xs4all.nl>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>, ivtv-devel@ivtvdriver.org
Subject: Re: [PATCH] Fix potential cx18_cards[] entry leaks
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

On Saturday 03 May 2008 04:43:27 Andy Walls wrote:
> Hans,
>
> When investigating Mike Krufky's report of module reload problems, I
> ran across problems with the management of the cx18_cards[] array. 
> They're corner cases and not likely to be the cause of Mike problems
> though.
>
> Upon error conditions in cx18_probe(), the code at the 'err:' label
> could leak cx18_cards[] entries.  Not a big problem since there are
> 32 of them, but they could have caused a NULL pointer de-reference in
> cx18_v4l2_open().
>
> The attached patch fixes these and reworks the management of the
> cx18_cards[] entries.  The cx18_active_cards variable is replaced
> with cx18_highest_cards_index (because that's essentially what
> cx18_active_cards_was doing +1), and cleanup of entries happens a
> little more pedantically (obtaining the lock, and removing each entry
> on a pci remove, instead of waiting until module unload).
>
> The attached patch was made against the latest v4l-dvb hg repository.
>
> Comments welcome.
>
> Regards,
> Andy

Hi Andy,

Thanks for looking into this. I've copied the open() fix into the cx18 
and ivtv drivers, but not the additional changes: in my opinion they do 
not actually add anything useful. The potential NULL pointer 
dereference is however an important fix and definitely should go into 
2.6.26.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
