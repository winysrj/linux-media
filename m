Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB6ABJ5v012722
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 05:11:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB6AB57b031947
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 05:11:05 -0500
Date: Sat, 6 Dec 2008 08:10:40 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Message-ID: <20081206081040.79b8dd44@pedra.chehab.org>
In-Reply-To: <4936F718.2000101@oracle.com>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
	<4936F718.2000101@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, v4l-dvb-maintainer@linuxtv.org,
	linux-next@vger.kernel.org, video4linux-list@redhat.com,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 3 (media/video/cx88)
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

Hi Randy,

On Wed, 03 Dec 2008 13:16:08 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> CONFIG_VIDEO_CX88=y
> CONFIG_VIDEO_CX88_DVB=m

That's the issue: cx18-dvb shouldn't be a module, since it depends on cx88.
I'll take a look at the kconfig stuff to solve this issue.

Thanks for reporting!

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
