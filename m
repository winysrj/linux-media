Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m51J63rJ002218
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 15:06:03 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m51J5lqj015923
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 15:05:48 -0400
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200806011215.11489.hverkuil@xs4all.nl>
References: <20080522223700.2f103a14@core>
	<200805261846.35758.hverkuil@xs4all.nl>
	<1212287646.20064.21.camel@palomino.walls.org>
	<200806011215.11489.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sun, 01 Jun 2008 15:01:59 -0400
Message-Id: <1212346919.3294.6.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, ivtv-devel@ivtvdriver.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] cx18: convert driver to video_ioctl2() (Re: [PATCH]
	video4linux: Push down the BKL)
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

On Sun, 2008-06-01 at 12:15 +0200, Hans Verkuil wrote:


> Thanks Andy!
> 
> I'll take a closer look on Tuesday or Wednesday, but I noticed one 
> thing: you set unused callbacks to NULL in cx18_set_funcs(), however 
> these can just be removed as they are NULL by default.

Yeah, they can go.  I left them in as an aid for double checking that I
didn't forget any callbacks that needed to be implemented.

Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
