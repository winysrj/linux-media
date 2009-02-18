Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1IAnmsX030250
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 05:49:48 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1IAnJBl009379
	for <video4linux-list@redhat.com>; Wed, 18 Feb 2009 05:49:19 -0500
Date: Wed, 18 Feb 2009 07:48:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Roel Kluin <roel.kluin@gmail.com>
Message-ID: <20090218074849.70209e5d@pedra.chehab.org>
In-Reply-To: <499BD0AE.8000603@gmail.com>
References: <499BD0AE.8000603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH] V4L: missing parentheses?
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

On Wed, 18 Feb 2009 10:11:10 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:

> From: Roel Kluin <roel.kluin@gmail.com>
> To: Michael Krufky <mkrufky@linuxtv.org>
> CC: Mauro Carvalho Chehab <mchehab@infradead.org>,  video4linux-list@redhat.com, Andrew Morton <akpm@linux-foundation.org>
> Subject: [PATCH] V4L: missing parentheses?
> Date: Wed, 18 Feb 2009 10:11:10 +0100
> User-Agent: Thunderbird 2.0.0.18 (X11/20081105)

Hi Roel,

Please use linux-media@vger.kernel.org, instead of v4l-list, for all patches
for drivers/media, otherwise your patch will likely be lost.

We are currently using patchwork.kernel.org as our patch repository. It only
handles patches sent to the new ML.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
