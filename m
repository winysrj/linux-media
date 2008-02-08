Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m18IW4S0029205
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 13:32:04 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m18IVhLm010830
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 13:31:43 -0500
Date: Fri, 8 Feb 2008 16:31:02 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Adrian Pardini" <pardo.bsso@gmail.com>
Message-ID: <20080208163102.459d0efd@gaivota>
In-Reply-To: <9c4b1d600802080937h3dbbb388s9abb760feb084f4@mail.gmail.com>
References: <9c4b1d600802071009q7fc69d4cj88c3ec2586e484a0@mail.gmail.com>
	<20080207173926.53b9e0ce@gaivota>
	<1202421849.20032.25.camel@pc08.localdom.local>
	<9c4b1d600802071528p70de4e55ud582ef66d9ebb3d7@mail.gmail.com>
	<1202429587.20032.75.camel@pc08.localdom.local>
	<9c4b1d600802080937h3dbbb388s9abb760feb084f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [PATCH] New card entry (saa7134) and FM support for TNF9835
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

On Fri, 8 Feb 2008 15:37:28 -0200
"Adrian Pardini" <pardo.bsso@gmail.com> wrote:

> Hello,
> As hermann suggested I removed the tuner stuff and switched to the TNF5335
> (tuner=69), and left only the TV(mono) input. Also I made some cosmetic
> changes to comply with the CodingStyle rules.
> 
> Hope everything is ok.
> Cheers,
> Adrian.
> 
> ---
> diff -uprN -X dontdiff
> v4l-dvb/linux/Documentation/video4linux/CARDLIST.saa7134
> v4l-dvb-modified/linux/Documentation/video4linux/CARDLIST.saa7134
> --- v4l-dvb/linux/Documentation/video4linux/CARDLIST.saa7134    2008-02-06
> 22:54:07.000000000 -0200
> +++ v4l-dvb-modified/linux/Documentation/video4linux/CARDLIST.saa7134

Still the patch is line-wrapped. Although this is not a good practice, you may
send it as an annex, if you can't convince your emailer to not break the lines.
This way, patch command won't accept it.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
