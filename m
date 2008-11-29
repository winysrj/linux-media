Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATCSgqj025038
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 07:28:42 -0500
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mATCS5GB002179
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 07:28:05 -0500
To: roel kluin <roel.kluin@gmail.com>
References: <49311628.7090308@gmail.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 29 Nov 2008 13:28:03 +0100
In-Reply-To: <49311628.7090308@gmail.com> (roel kluin's message of "Sat\,
	29 Nov 2008 05\:15\:04 -0500")
Message-ID: <87tz9qra24.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	mchehab@infradead.org
Subject: Re: [PATCH] mt9m111: mt9m111_get_global_gain() - unsigned <= 0 is
	always true
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

roel kluin <roel.kluin@gmail.com> writes:

> unsigned <= 0 is always true
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
You're right, your patch is good, but ... there is another mistake I made which
should be also fixed.

The real formula is :
  gain = (data & 0x2f) * (1 << ((data >> 10) & 1)) * (1 << ((data >> 9) & 1));

That is bits 9 and 10 give a 2x gain factor.

Would you please amend your patch to fix the formula please ?

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
