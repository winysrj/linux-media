Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5R06xF0013843
	for <video4linux-list@redhat.com>; Fri, 26 Jun 2009 20:06:59 -0400
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n5R06ffA029688
	for <video4linux-list@redhat.com>; Fri, 26 Jun 2009 20:06:42 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Vikraman Choudhury <vikraman.choudhury@gmail.com>
In-Reply-To: <1246055843.8505.20.camel@pc07.localdom.local>
References: <14b5ef430906251008j49859b24k93bcf2f122bf9590@mail.gmail.com>
	<1246053224.8505.12.camel@pc07.localdom.local>
	<1246055843.8505.20.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 02:05:36 +0200
Message-Id: <1246061136.8505.23.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: saa7134, help with integrated remote!
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


Am Samstag, den 27.06.2009, 00:37 +0200 schrieb hermann pitton:
> The device saa7134 IR is detected as /dev/input/event7, but
> > > cat /dev/input/event7 either doesn't show any output or spits out
> the same
> > > code repeatedly (without the remote pressed)

Means you already found that key down/up pin I forgot to mention.

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
