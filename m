Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2DE1VfS007907
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 10:01:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2DE0jmO013385
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 10:00:45 -0400
Date: Thu, 13 Mar 2008 11:00:19 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: emhn@usb.ve
Message-ID: <20080313110019.0181297c@gaivota>
In-Reply-To: <1205409776.20876.34.camel@trillian.ius.cc>
References: <1205409776.20876.34.camel@trillian.ius.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Support for a 16-channel bt878 card
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

On Thu, 13 Mar 2008 07:32:56 -0430
Ernesto Hernández-Novich <emhn@usb.ve> wrote:

> Signed-off-by: Ernesto Hernández-Novich <emhn@usb.ve>
> 

Applied, thanks. There were just a small CodingStyle error that I fixed on the
applied patch. Please, run "make checkpatch" next time.

> I have made no efforts yet to get audio working, but would appreciate
> any pointers.

There are two possibilities:

1) if the board has an audio chip, you'll have to use it and configure;
2) otherwise, you just need to set the proper GPIO pins to enable audio. I suspect that this would be your case.
This page may help you to figure out the proper values for GPIO:
	http://www.linuxtv.org/v4lwiki/index.php/GPIO_pins

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
