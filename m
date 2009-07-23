Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6NJxvQI014156
	for <video4linux-list@redhat.com>; Thu, 23 Jul 2009 15:59:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n6NJxeju011586
	for <video4linux-list@redhat.com>; Thu, 23 Jul 2009 15:59:40 -0400
Date: Thu, 23 Jul 2009 16:59:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Folkert van Heusden <folkert@vanheusden.com>
Message-ID: <20090723165929.64cf3933@pedra.chehab.org>
In-Reply-To: <20090717174101.GB15611@vanheusden.com>
References: <20090717174101.GB15611@vanheusden.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: video4linux loopback device
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

Em Fri, 17 Jul 2009 19:41:01 +0200
Folkert van Heusden <folkert@vanheusden.com> escreveu:

> Hi,
> 
> Any chance that the video4linux loopback device will be integrated in
> the main video4linux distribution and included in the kernel?
> http://www.lavrsen.dk/foswiki/bin/view/Motion/VideoFourLinuxLoopbackDevice
> or
> http://sourceforge.net/projects/v4l2vd/
> or
> http://code.google.com/p/v4l2loopback/
> This enables userspace postprocessors to feed the altered stream to
> applications like amsn and skype for videochats.

If the postprocessor application is LGPL, the better is to add it at libv4l.



Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
