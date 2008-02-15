Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FCoSr1011308
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 07:50:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1FCo6DT024457
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 07:50:06 -0500
Date: Fri, 15 Feb 2008 10:49:45 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Guillaume Quintard" <guillaume.quintard@gmail.com>
Message-ID: <20080215104945.4e6fe998@gaivota>
In-Reply-To: <1e5fdab70802141534o194c79efu1ed974734878c052@mail.gmail.com>
References: <1e5fdab70802061744u4b053ab3o43fcfbb86fe248a@mail.gmail.com>
	<20080207174703.5e79d19a@gaivota>
	<1e5fdab70802071203ndbce13an1fa226d5ec3e4ca1@mail.gmail.com>
	<20080207181136.5c8c53fc@gaivota>
	<1e5fdab70802081827x4b656625h3b20332d0ee030ab@mail.gmail.com>
	<20080211104821.00756b8e@gaivota>
	<1e5fdab70802141534o194c79efu1ed974734878c052@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

On Thu, 14 Feb 2008 15:34:22 -0800
"Guillaume Quintard" <guillaume.quintard@gmail.com> wrote:

> Hello again,
> baby step after baby step, I managed to get the saa7115 driver working
> on my platform \o/ thank you for the help
> 
> but I have a question : is the driver complete ? because it doesn't
> respond to half the V4L2 commands described in the API, and for some,
> the structure isn't fully updated, is that normal ?
> (I'm not blaming anybody, as I am new to all this stuff I still trying
> to understand the V4L2 world :-), but it seems to me, after reading
> the datasheet of the chip that the driver could offer more
> possibility, am I right ?)


At the current drivers, most of the API functions are handled by the bridge
driver. So, only a subset of saa7115 features is needed for those devices. As a
rule, we generally try not to add code on kernel drivers that aren't used by
other kernel drivers.

Yet, some functions shouldn't be on saa7115, like, for example:
	buffer handling - specific to the way it is connected;
	audio control and decoding - should be associated to an audio chip;

I don't know the implementation details of your driver. If you intend to submit
your driver for its addition on kernel, feel free to propose the addition of
new features to saa7115, and post to the list. Maybe your job will help also
other users (for example, saa7115 driver doesn't work with Osprey 560
- I'm not sure where's the issue).

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
