Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m58AXEZF030337
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 06:33:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m58AX3e5016202
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 06:33:03 -0400
Date: Sun, 8 Jun 2008 07:32:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Message-ID: <20080608073255.67b8233c@gaivota>
In-Reply-To: <20080608063104.GA5608@joi>
References: <20080607224835.GA25025@joi>
	<20080608063104.GA5608@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] v4l: saa7134: fix multiple clients access (and oops)
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

On Sun, 8 Jun 2008 08:31:07 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> On Sun, Jun 08, 2008 at 12:48:35AM +0200, Marcin Slusarz wrote:
> > (...)
> 
> This patch is stupid. Please ignore.

Patch ignored. Yet, it seemed ok to my eyes. We shouldn't stop/deallocate
resources if there is still someone using the module.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
