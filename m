Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6CJtIDp013275
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 15:55:18 -0400
Received: from mail-in-05.arcor-online.net (mail-in-05.arcor-online.net
	[151.189.21.45])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6CJsfL1020750
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 15:54:41 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Peter Schlaf <peter.schlaf@web.de>,
	Mauro Carvalho Chehab <mchehab@infrafead.org.redhat.com>
In-Reply-To: <4878D1D9.8020500@web.de>
References: <4878D1D9.8020500@web.de>
Content-Type: text/plain
Date: Sat, 12 Jul 2008 21:50:47 +0200
Message-Id: <1215892247.2987.11.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: saa7134-cards.c:6081: error: 'SAA7134_BOARD_ASUSTeK_TVFM35'
	undeclared
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

Hi,

Am Samstag, den 12.07.2008, 17:46 +0200 schrieb Peter Schlaf:
> imho it should be SAA7134_BOARD_ASUSTeK_TVFM7135
> 
> cu
> 

yes, thanks.

There was a later patch which had that corrected here.

http://www.spinics.net/lists/vfl/msg37290.html

Mauro, we need to fix the compilation.
I'll prepare a patchlet or you just fix the board name based on the
later patch.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
