Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5AIU76b024267
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 14:30:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5AITuw6021338
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 14:29:56 -0400
Date: Tue, 10 Jun 2008 15:29:47 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Robert Herb <proletheus@freenet.de>
Message-ID: <20080610152947.73db9e01@gaivota>
In-Reply-To: <484E3DFD.2080304@freenet.de>
References: <484E3DFD.2080304@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: v4l-dvb compiling errors with kernel 2.6.25
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

On Tue, 10 Jun 2008 10:40:29 +0200
Robert Herb <proletheus@freenet.de> wrote:

> Hi,
> 
> since i've updated my kernel to 2.6.25, I always get the following 
> errors, when i try to compile. Is this caused by my system or by the 
> source-code? Can you help me?
> 
> With my last kernel 2.6.23.xx it was always compiled without errors.

Thanks for reporting. I've just fixed it at the repo. Tested with mainstream kernel 2.6.25.6.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
