Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABEO9uV006720
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 09:24:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mABEMxXI002007
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 09:23:49 -0500
Date: Tue, 11 Nov 2008 12:23:06 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20081111122306.0bb05431@pedra.chehab.org>
In-Reply-To: <1226367478.2493.39.camel@pc10.localdom.local>
References: <1226357539.8035.20.camel@pete-desktop>
	<1226367478.2493.39.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] saa7134: Add new cards
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

On Tue, 11 Nov 2008 02:37:58 +0100
hermann pitton <hermann-pitton@arcor.de> wrote:

> I probably missed it and there is a plan, but if this should go to
> v4l-dvb now and SAA7134_MPEG_GO7007 support comes only with staging,
> should we not #if 0 it until all is merged?
> 
> Thanks for your work.

It is better to hold the patch until go7007 driver enters at v4l/dvb tree and
go outside staging.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
