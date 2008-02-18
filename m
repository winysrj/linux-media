Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1IHadam026348
	for <video4linux-list@redhat.com>; Mon, 18 Feb 2008 12:36:39 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1IHaIZb002148
	for <video4linux-list@redhat.com>; Mon, 18 Feb 2008 12:36:18 -0500
Date: Mon, 18 Feb 2008 14:36:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080218143602.338063e8@gaivota>
In-Reply-To: <20080218124351.4da5d6d2@gaivota>
References: <20080218124351.4da5d6d2@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL - resend] V4L/DVB fixes - first request on Feb, 12
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

On Mon, 18 Feb 2008 12:43:51 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> 	   - bug #9832: tuner-xc2028 depends on FW_LOADER;

In time: the but is bug is the second part of #9965 (and not 9832):
	ERROR: "release_firmware" [drivers/media/video/tuner-xc2028.ko] undefined! 
	ERROR: "request_firmware" [drivers/media/video/tuner-xc2028.ko] undefined!


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
