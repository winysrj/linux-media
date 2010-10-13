Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o9DMEjI4011439
	for <video4linux-list@redhat.com>; Wed, 13 Oct 2010 18:14:45 -0400
Received: from mail-yx0-f174.google.com (mail-yx0-f174.google.com
	[209.85.213.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9DMEXHd023185
	for <video4linux-list@redhat.com>; Wed, 13 Oct 2010 18:14:33 -0400
Received: by yxm8 with SMTP id 8so1699982yxm.33
	for <video4linux-list@redhat.com>; Wed, 13 Oct 2010 15:14:33 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 13 Oct 2010 19:14:32 -0300
Message-ID: <AANLkTikF2wTZesbRo+EP9r8oC7m_R6orkWJuh-6BiYAM@mail.gmail.com>
Subject: Add support to TW800X Capture Card
From: Raul Almeida <rcaj.dev@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

I'll post some more info.
The chipsets are 4 conexant fusion 878A.
As far as I research I need to figure out a way to switch channels by
defining a custom xxx_muxsel function.
I collected some data from regspy..

Note that I have 2 boards connected to my system.

GPIO_DATA
CARD0
00335FF8|00335FF9|00335FFA|00335FFB
CARD1
00738FFC|00738FFD|00738FFE|00738FFF
CARD2
008F8FF8|008F8FF9|008F8FFA|008F8FFB
CARD3
00CF0FFC|00CF0FFD|00CF0FFE|00CF0FFF
CARD4
000F8FF8|000F8FF9|000F8FFA|000F8FFB
CARD5
004F0FFC|004F0FFD|004F0FFE|004F0FFF
CARD6
00B30FFC|00B30FFD|00B30FFE|00B30FFF
CARD7
00F30FF8|00F30FF9|00F30FFA|00F30FFB

INT_MASK
00000800

GPIO_DMA_CTL
C003

GPIO_OUT_EN
003C7007

I also found a card sold in Russia that I think mind have same components of
mine.
It is ORIENT SDVR-1604.

This guy is looking for the same solution I am.
http://www.zoneminder.com/forums/viewtopic.php?p=39287&sid=e5dde89bd0d99637e9f202b7ea0eee72

Thank you all.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
