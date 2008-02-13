Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1D5MJPK012078
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 00:22:19 -0500
Received: from mail1.sea5.speakeasy.net (mail1.sea5.speakeasy.net
	[69.17.117.3])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1D5LmBm018277
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 00:21:49 -0500
Date: Tue, 12 Feb 2008 21:21:43 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080212190235.4e86baf8@gaivota>
Message-ID: <Pine.LNX.4.58.0802122120530.7642@shell2.speakeasy.net>
References: <20080212190235.4e86baf8@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-dvb-maintainer@linuxtv.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes
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

On Tue, 12 Feb 2008, Mauro Carvalho Chehab wrote:
>    - cx88-mpeg: Allow concurrent access to cx88-mpeg devices;

So you decided to just commit this one with the race condition anyway?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
