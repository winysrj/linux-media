Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SIi0lh025450
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 14:44:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SIhbQF001316
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 14:43:37 -0400
Date: Fri, 28 Mar 2008 15:43:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Frej Drejhammar" <frej.drejhammar@gmail.com>
Message-ID: <20080328154302.2dc73781@gaivota>
In-Reply-To: <da854c7e2b4372794c04.1206312205@liva.fdsoft.se>
References: <patchbomb.1206312199@liva.fdsoft.se>
	<da854c7e2b4372794c04.1206312205@liva.fdsoft.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH 6 of 6] cx88: Enable color killer by default
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

Patches 1 to 5 applied, thanks.
 
> An enabled color killer will not degrade picture quality for color
> input signals, only suppress bogus color information on
> black-and-white input. Therefore enable it by default.

I don't think it is a good idea to enable the color killer by default. This may
lead to weird effects, if the stream uses some black and white images, with
just a few colors, to produce some sort of visual effect. Better to have this
disabled. If someone wants to see a black-and-white movie, or is on an area
where the color carrier is bogus, he can manually enable the filter.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
