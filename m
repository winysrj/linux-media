Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9THmMdq029149
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 13:48:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9THmJI7023090
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 13:48:19 -0400
Date: Wed, 29 Oct 2008 15:48:21 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Message-ID: <20081029154821.30f72fa7@pedra.chehab.org>
In-Reply-To: <1225146457.2761.4.camel@nga.site>
References: <1225146457.2761.4.camel@nga.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list <video4linux-list@redhat.com>
Subject: Re: dvb: add DVB_DEVICE_NUM and DVB_ADAPTER_NUM to uevent
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

On Mon, 27 Oct 2008 23:27:37 +0100
Kay Sievers <kay.sievers@vrfy.org> wrote:

> Hey,
> I'm resending this, after the version I sent in May this year
> never got anywhere. :)
> 
> This allows udev to create proper device nodes without any
> hacky shell scripts/programs to call, which guess these numbers
> from the kernel device names.

Hi Kay,

I'm applying the patch at the tree. Please, review it with the current
development tree, since there were some changes on dvb to allow dynamic minor
allocation. Not sure if this could affect your patch.

Ah, I had to modify your patch while applying into the development tree, due to
some compat stuff with kernels before 2.6.28. If I didn't make any mistake, the
upstream patch will be exactly the same as yours ;)

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
