Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBTMaS10025367
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 17:36:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBTMZNcE018285
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 17:35:23 -0500
Date: Mon, 29 Dec 2008 20:35:13 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Erik =?ISO-8859-1?B?QW5kculu?= <erik.andren@gmail.com>, Jean-Francois
	Moine <moinejf@free.fr>
Message-ID: <20081229203513.13b6b1ca@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Warning on stv06xx
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

Hi Erik,

Could you please take a look on this?

drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c: In function ‘hdcs_set_size’:
drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c:301: warning: ‘y’ may be used uninitialized in this function

By looking on that function, it seems that this condition can happen.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
