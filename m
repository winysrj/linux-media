Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2DF7ApE027283
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 11:07:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2DF6VsF004909
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 11:06:31 -0400
Date: Thu, 13 Mar 2008 12:06:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Roel Kluin <12o3l@tiscali.nl>
Message-ID: <20080313120602.6920a621@gaivota>
In-Reply-To: <47D47257.9090204@tiscali.nl>
References: <47D47257.9090204@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, pe1rxq@amsat.org, linux-usb@vger.kernel.org
Subject: Re: logical-bitwise & confusion in se401_init()?
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

On Mon, 10 Mar 2008 00:27:19 +0100
Roel Kluin <12o3l@tiscali.nl> wrote:

> drivers/media/video/se401.c:1282:
> 
> if (!cp[2] && SE401_FORMAT_BAYER) {
> 
> shouldn't this be 'if (!(cp[2] & SE401_FORMAT_BAYER)) {'
> drivers/media/video/se401.h:52:
> 
> #define SE401_FORMAT_BAYER       0x40

I don't have this driver, but this seems to be the proper fix.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
