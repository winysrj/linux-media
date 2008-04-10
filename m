Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3AFEm0x013134
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 11:14:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3AFEWZG026601
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 11:14:32 -0400
Date: Thu, 10 Apr 2008 12:12:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Message-ID: <20080410121249.137daa5b@areia>
In-Reply-To: <alpine.LFD.1.00.0804091800370.4120@localhost.localdomain>
References: <alpine.LFD.1.00.0804091559470.27560@localhost.localdomain>
	<20080409185526.0feffa8a@areia>
	<alpine.LFD.1.00.0804091800370.4120@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video for linux list <video4linux-list@redhat.com>
Subject: Re: [newbie alert] setting up hauppauge hvr 950 to watch OTA analog?
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

On Wed, 9 Apr 2008 18:01:55 -0400 (EDT)
"Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

> already downloaded, built and installed modules.  as i read it, for
> this particular tv tuner, i want the em28xx module, yes?

Yes. This will load tuner-xc2028 driver. For xc3028 to work, you'll need to
have the proper firmware at /lib/firmware.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
