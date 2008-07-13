Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6D0h0q9019347
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 20:43:00 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6D0gdC0015148
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 20:42:40 -0400
Received: by ug-out-1314.google.com with SMTP id s2so98857uge.6
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 17:42:39 -0700 (PDT)
Date: Sun, 13 Jul 2008 02:42:48 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080713004248.GA12648@ska.dandreoli.com>
References: <200807101914.10174.mb@bu3sch.de> <20080710160258.4ddb5c61@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710160258.4ddb5c61@gaivota>
Cc: David Brownell <david-b@pacbell.net>, video4linux-list@redhat.com,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
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

Hi,

On Thu, Jul 10, 2008 at 04:02:58PM -0300, Mauro Carvalho Chehab wrote:
> 
> However, a much better alternative would be if you can rework on it to be a
> module that adds this functionality to the original driver, allowing to have
> both video control and gpio control, since, on a few cases like surveillance
> systems, the gpio's may be used for other things, like controlling security
> sensors, or switching a video commutter.

I need this. Is anybody working on it? If nobody is, I step forward.

What about a tiny bttv sub-driver in its own tiny module?

The sub-driver would be configurable card-by-card, so that those using
gpio ports for their remote controls would keep them hidden to gpiolib.

How instead could all these gpios communicate to user-space?

cheers,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
