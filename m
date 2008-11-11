Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABILdXf005045
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 13:21:39 -0500
Received: from smtp-out114.alice.it (smtp-out114.alice.it [85.37.17.114])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mABILSYo003622
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 13:21:28 -0500
Date: Tue, 11 Nov 2008 19:15:16 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081111191516.20febe64.ospite@studenti.unina.it>
In-Reply-To: <20081111184200.cb9a2ba4.ospite@studenti.unina.it>
References: <20080816050023.GB30725@thumper>
	<20080816083613.51071257@mchehab.chehab.org>
	<7813ee860808160513g2f0e3602q9f3aed45d66ef165@mail.gmail.com>
	<20081105203114.213b599a@pedra.chehab.org>
	<20081111184200.cb9a2ba4.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

On Tue, 11 Nov 2008 18:42:00 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> 
> Actually I've started a port of this driver to gspca as an exercise.
> You can find a rough preview here:
> http://shell.studenti.unina.it/~ospite/tmp/gspca_ov534-20081111-1733.tar.bz2
>

And here's the direct link to the file, sorry for the tarball:
http://shell.studenti.unina.it/~ospite/tmp/gspca_ov534-20081111-1733/ov534.c

> I tried to (ab)use gpsca infrastructure for bulk transfers, the driver is
> quite essential but it works acceptably well, for now, even if I still
> loose fames because of some bug.
> 
> The driver needs the attached changes (or any better equivalent)
> to gspca bulk transfers code.

I forgot to say that the changes are against linux-2.6.28-rc4 from linus
git tree.

Regards,
   Antonio Ospite

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
