Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1ENYnAs023544
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 18:34:49 -0500
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.239])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1ENYRaq021240
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 18:34:27 -0500
Received: by wr-out-0506.google.com with SMTP id 70so952919wra.7
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 15:34:23 -0800 (PST)
Message-ID: <1e5fdab70802141534o194c79efu1ed974734878c052@mail.gmail.com>
Date: Thu, 14 Feb 2008 15:34:22 -0800
From: "Guillaume Quintard" <guillaume.quintard@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <20080211104821.00756b8e@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1e5fdab70802061744u4b053ab3o43fcfbb86fe248a@mail.gmail.com>
	<20080207174703.5e79d19a@gaivota>
	<1e5fdab70802071203ndbce13an1fa226d5ec3e4ca1@mail.gmail.com>
	<20080207181136.5c8c53fc@gaivota>
	<1e5fdab70802081827x4b656625h3b20332d0ee030ab@mail.gmail.com>
	<20080211104821.00756b8e@gaivota>
Cc: video4linux-list@redhat.com
Subject: Re: Question about saa7115
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

Hello again,
baby step after baby step, I managed to get the saa7115 driver working
on my platform \o/ thank you for the help

but I have a question : is the driver complete ? because it doesn't
respond to half the V4L2 commands described in the API, and for some,
the structure isn't fully updated, is that normal ?
(I'm not blaming anybody, as I am new to all this stuff I still trying
to understand the V4L2 world :-), but it seems to me, after reading
the datasheet of the chip that the driver could offer more
possibility, am I right ?)

regards

-- 
Guillaume

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
