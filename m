Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJJl5vB023358
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 14:47:05 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJJkrSM023280
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 14:46:54 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
In-Reply-To: <20081119181018.bf483949.ospite@studenti.unina.it>
References: <20081119163009.25f0b377.ospite@studenti.unina.it>
	<62e5edd40811190750o2792293ei6e32fb25d3819218@mail.gmail.com>
	<20081119181018.bf483949.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 19 Nov 2008 20:37:13 +0100
Message-Id: <1227123433.1709.39.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] gspca: ov534 camera driver
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

On Wed, 2008-11-19 at 18:10 +0100, Antonio Ospite wrote:
> On Wed, 19 Nov 2008 16:50:20 +0100
> "Erik Andrén" <erik.andren@gmail.com> wrote:
	[snip]
> > I would collect all the data to be written in tables and loop over
> > them instead of having large sets of write calls.
> 
> I'd do that way too, normally.
> But I wanted to respect the original form of the reverse engineered
> code. If the driver really needs to be revolutionized, then it may be
> worth copying/sharing stuff with the (non-gspca) ov772x driver.
> 
> I know that the driver is in a suboptimal state, the bridge chip
> datasheet is not available, so I thought that as a first version it
> could be still accepted.

I think so. We have the original working driver. It may be optimized
later.

	[snip]
> > When would you not like to have the maximum frame rate?
> 
> I just thought that capturing at 25fps is a typical case, and using a
> default frame_rate near to that value would be sane, but please give
> advices here.

It seems fine to me.

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
