Return-path: <video4linux-list-bounces@redhat.com>
Date: Mon, 26 May 2008 18:14:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20080526181406.40f9e082@gaivota>
In-Reply-To: <200805261846.35758.hverkuil@xs4all.nl>
References: <20080522223700.2f103a14@core>
	<20080523090919.GA31575@devserv.devel.redhat.com>
	<20080526133457.6f892af9@gaivota>
	<200805261846.35758.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
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


> > Could you send this patch to the ML for people to review and for Andy
> > to port it to cx18?
> 
> Unless there is an objection, I would prefer to take Douglas' patch and 
> merge it into the v4l-dvb ivtv driver myself. There were several things 
> in the patch I didn't like, but I need to 'work' with it a bit to see 
> how/if it can be done better.

I didn't analyze his patch in detail. However, it is a starting point
for you to work with. I'm sure you can improve it if needed.

> I can work on it tonight and tomorrow. Hopefully it is finished by then. 
> I can move the BKL down at the same time for ivtv. It is unlikely that 
> I will have time to do cx18 as well as I'm abroad from Wednesday until 
> Monday, but I think Andy can do that easily based on the ivtv changes.

This strategy seems OK to me.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
