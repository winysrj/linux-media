Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA7Kj1pc016132
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 15:45:01 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA7KinHY009441
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 15:44:49 -0500
Date: Fri, 7 Nov 2008 18:45:02 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Carl Karsten <carl@personnelware.com>
Message-ID: <20081107184502.0054ccdb@pedra.chehab.org>
In-Reply-To: <491339D9.2010504@personnelware.com>
References: <491339D9.2010504@personnelware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: weeding out v4l ver 1 stuff
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

On Thu, 06 Nov 2008 12:39:21 -0600
Carl Karsten <carl@personnelware.com> wrote:

> Given v4l version 1 is being dropped in December 08, we should remove stuff that
> targets that api, right?

Yes, but we should first convert the existing V4L1 drivers. We're currently
needing volunteers.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
