Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m47Ix8l9007418
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 14:59:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m47IwuGu013428
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 14:58:56 -0400
Date: Wed, 7 May 2008 15:58:19 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Vicent =?UTF-8?B?Sm9yZMOg?= <vjorda@hotmail.com>
Message-ID: <20080507155819.2df442b5@gaivota>
In-Reply-To: <BAY109-W23742D6ECAA5EF9CDEF632CBDE0@phx.gbl>
References: <BAY109-W5337BE0CEB1701C6AC945ACBDE0@phx.gbl>
	<20080428114741.040ccfd6@gaivota>
	<BAY109-W23742D6ECAA5EF9CDEF632CBDE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Trying to set up a NPG Real DVB-T PCI Card
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

On Mon, 28 Apr 2008 20:26:43 +0000
Vicent Jordà <vjorda@hotmail.com> wrote:

> 
> Hi,
> 
> (2) tuner-callback is sending a wrong reset. Xc3028 needs to receive a reset, gia a GPIO pin, for firmware to load. If you don't send a reset, firmware won't load; The better is to use regspy.exe (provided together with DCALER) and see what gpio changes during firmware load.
> 
> But regspy.exe is a Windows program. I tried to run it from wine but doesn't work.

True. This software helps to identify what the windows proprietary driver is
doing at the device. I guess your device uses a different pin for XC3028 reset.



Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
