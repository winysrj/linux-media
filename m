Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id o98NQqj1017157
	for <video4linux-list@redhat.com>; Fri, 8 Oct 2010 19:26:52 -0400
Received: from mail-vw0-f46.google.com (mail-vw0-f46.google.com
	[209.85.212.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o98NQbD2006188
	for <video4linux-list@redhat.com>; Fri, 8 Oct 2010 19:26:38 -0400
Received: by vws3 with SMTP id 3so679995vws.33
	for <video4linux-list@redhat.com>; Fri, 08 Oct 2010 16:26:37 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 8 Oct 2010 20:26:37 -0300
Message-ID: <AANLkTi=_-+Rk1Tq3R3SzLMxaPLSy70chRET1rsvc=EoB@mail.gmail.com>
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

Hello folks,

I'm trying to add support to a card that is sold in Brazil as TopWay TW800x.
It has four Conexant 878A chips to provide 16 channels of video.
It don't has radio tuner and can't capture tv.
The only card id that partly works is card=131.
It partly works because I can see only one camera on all channels.
I already turned multi buffer off but it just can not capture other
channels.
I used both BtSpy and RegSpy to look for gpio_out_en, gpio_out_data and
other values but i don't really know the next step.
If anyone can help me I'll be glad.

If anyone has some sort of guide please send me.

Thank you all.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
