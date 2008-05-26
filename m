Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QDgBiK013030
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 09:42:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4QDfxxn020221
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 09:41:59 -0400
Date: Mon, 26 May 2008 10:41:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Message-ID: <20080526104146.7ef1bc91@gaivota>
In-Reply-To: <200805072253.23219.tobias.lorenz@gmx.net>
References: <200805072253.23219.tobias.lorenz@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH 2/2] v4l2: hardware frequency seek ioctl interface
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

Hi Tobias,

On Wed, 7 May 2008 22:53:22 +0200
Tobias Lorenz <tobias.lorenz@gmx.net> wrote:
> + *		- unplugging fixed
> + * 2008-05-07	Tobias Lorenz <tobias.lorenz@gmx.net>
> + *		Version 1.0.8
> + *		- hardware frequency seek support
> + *		- afc indication
> + *		- implementation of private video controls for
> + *		  seek options and band/space/de changes
> + *		- register definitions moved to separate header file
> + *		- more safety checks, let si470x_get_freq return errno

Please, don't send a patch with several different things on it. Instead, send me incremental patches. with just one change. So, you would send me:
	a patch for harware seek support;
	a patch for afc indication; 
	...

Also version numbers are generally incremented once by each kernel.

Please split this patch into smaller ones and submit me again.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
