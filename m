Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABAjBn0010096
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 05:45:11 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mABAirKg017262
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 05:44:53 -0500
Date: Tue, 11 Nov 2008 08:45:01 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Igor M. Liplianin" <liplianin@me.by>
Message-ID: <20081111084501.38f2917a@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Video <video4linux-list@redhat.com>
Subject: Section mismatch on dm1105 driver
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

Hi Igor,

Upstream compilation causes a section mismatch on dm1105. Please fix.

WARNING: drivers/media/built-in.o(.text+0x1bbd2d): Section mismatch in reference from the function dm1105dvb_start_feed() to the function .devinit.text:dm1105dvb_enable_irqs()
The function dm1105dvb_start_feed() references
the function __devinit dm1105dvb_enable_irqs().
This is often because dm1105dvb_start_feed lacks a __devinit 
annotation or the annotation of dm1105dvb_enable_irqs is wrong.




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
