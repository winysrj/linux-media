Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3SBAV5Z027560
	for <video4linux-list@redhat.com>; Tue, 28 Apr 2009 07:10:31 -0400
Received: from mail-gx0-f158.google.com (mail-gx0-f158.google.com
	[209.85.217.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3SB9cNj016147
	for <video4linux-list@redhat.com>; Tue, 28 Apr 2009 07:10:11 -0400
Received: by mail-gx0-f158.google.com with SMTP id 2so928685gxk.3
	for <video4linux-list@redhat.com>; Tue, 28 Apr 2009 04:10:11 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 28 Apr 2009 08:10:10 -0300
Message-ID: <f695d6b80904280410v6ad4ba0cr77ba0a2af9370829@mail.gmail.com>
From: Isamar Maia <isamar@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Subject: Adding new Remote Control - Sabrent SBT-TVFM(SAA7130) - IR Remote
	control HH-338
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

I wish to add a new IR remote control support as described at
http://www.spinics.net/lists/vfl/msg15095.html

I am importing this patch manually into v4l tree for kernel 2.6.26.5(fedora 9),
working on drivers/media/common/ir-keymaps.c,
drivers/media/video/saa7134/saa7134-cards.c and
drivers/media/video/saa7134/saa7134-input.c

Is there any guideline or howto to proceed to achieve that ?

-- 
Isamar Maia
Brazil: 55-71-9146-8575
            55-71-4062-8688
日本: +81-(0)3-4550-1212
"In a world without walls. Who needs windows and gates?"

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
