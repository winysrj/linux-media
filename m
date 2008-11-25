Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAPIkuQE003725
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 13:46:56 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAPIk7uL026820
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 13:46:07 -0500
To: Mike Rapoport <mike@compulab.co.il>
References: <1227603594-16953-1-git-send-email-mike@compulab.co.il>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Tue, 25 Nov 2008 19:46:01 +0100
In-Reply-To: <1227603594-16953-1-git-send-email-mike@compulab.co.il> (Mike
	Rapoport's message of "Tue\, 25 Nov 2008 10\:59\:54 +0200")
Message-ID: <87y6z7fxue.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] mt9m111: add support for mt9m112 since sensors seem
	identical
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

Mike Rapoport <mike@compulab.co.il> writes:

> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> ---
>  drivers/media/video/mt9m111.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Yes, only sensor size and version seem different. I presume you have checked
that the I2C addresses are the same (0x5d or 0x48), and the datasheets match ?

Then, would be please make me a favor : modify the Kconfig and mt9m111 comments
to reflect that mt9m112 support is provided, please ?

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
