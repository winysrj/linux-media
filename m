Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4L4mpST030431
	for <video4linux-list@redhat.com>; Wed, 21 May 2008 00:48:51 -0400
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4L4mMOd023280
	for <video4linux-list@redhat.com>; Wed, 21 May 2008 00:48:22 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Dan Taylor <dtaylor@startrac.com>
In-Reply-To: <A0E1B902C85838448AEA276170BCB5A5097886C8@NEVAEH.startrac.com>
References: <A0E1B902C85838448AEA276170BCB5A5097886C8@NEVAEH.startrac.com>
Content-Type: text/plain
Date: Wed, 21 May 2008 06:47:22 +0200
Message-Id: <1211345242.2517.12.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: where to send patch for SAA7134-cards.c?
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

Hi Dan,

Am Dienstag, den 20.05.2008, 20:06 -0700 schrieb Dan Taylor:
> I have fixed a problem with the S-Video input on the AverMedia A16D.
> It's a minor patch to add gpio mask and values to the entry in the
> saa7134_boards structure.  Should the patch be at the directory level of
> the file (.../drivers/media/video/saa7134) or higher in the tree?  Do I
> just post it to this list, or should I send it to a specific maintainer
> (and, if so, who?)?
> 

use "hg diff > my_patch.patch". (p1)

The current maintainer of the saa713x devices is Hartmut.
(Hartmut Hackmann <hartmut.hackmann@t-online.de)

However, due to specific scenarios that can happen, some more people are
involved since ever and do work together.

Last stamp should come from Hartmut.

Cheers,
Hermann







--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
