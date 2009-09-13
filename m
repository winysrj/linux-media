Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8DIuLK9012750
	for <video4linux-list@redhat.com>; Sun, 13 Sep 2009 14:56:21 -0400
Received: from corona.kreucher.net (corona.kreucher.net [72.44.84.246])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8DIu8Tr002325
	for <video4linux-list@redhat.com>; Sun, 13 Sep 2009 14:56:08 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by corona.kreucher.net (Postfix) with ESMTP id E7CBE3D60F23
	for <video4linux-list@redhat.com>; Sun, 13 Sep 2009 11:55:47 -0700 (PDT)
Received: from corona.kreucher.net ([127.0.0.1])
	by localhost (mail.kreucher.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id l1EayBwyqvUR for <video4linux-list@redhat.com>;
	Sun, 13 Sep 2009 11:55:45 -0700 (PDT)
Received: from [192.168.3.50] (c-98-246-163-229.hsd1.or.comcast.net
	[98.246.163.229])
	by corona.kreucher.net (Postfix) with ESMTPSA id 51E3E3D60055
	for <video4linux-list@redhat.com>; Sun, 13 Sep 2009 11:55:45 -0700 (PDT)
From: Nicholas J Kreucher <nick@kreucher.net>
To: video4linux-list@redhat.com
Date: Sun, 13 Sep 2009 11:56:03 -0700
Message-Id: <1252868163.21699.150.camel@bluetote>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Subject: help adding card to saa7134
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

Hello,

I have a generic (read: cheap) card that has one SA7130HL chip and no
eeprom. It has 4 inputs and one video out. I'm only interested in
getting the 4 inputs working. As-is (card=0), one input works
beautifully, so the first thing I tried was forcing cards 18 and then
20, two cards that also have 4 inputs according to the definition in
saa7134-cards.c. However, when I plug in video feeds into more then one
input, they "overlap". The image is essentially the same for comp1
through comp4.

Sample images here... 1ch is using one channel at a time (to show actual
images) and 2ch is using 2 inputs at the same time, showing overlap
effect:
http://nick.kreucher.net/tmp/saa7134/

So I simply tried adding a simple/newb card definition to
saa7134-cards.c (below), but similar results:


        [SAA7134_BOARD_SVDVR] = {
                /* Nicholas J Kreucher <nick@kreucher.net> */
                .name           = "SVDVR / Photec",
                .tuner_type     = TUNER_ABSENT,
                .radio_type     = UNSET,
                .tuner_addr     = ADDR_UNSET,
                .radio_addr     = ADDR_UNSET,
                .inputs         = {{
                        .name = name_comp1,
                        .vmux = 0,
                }, {
                        .name = name_comp2,
                        .vmux = 1,
                }, {
                        .name = name_comp3,
                        .vmux = 2,
                }, {
                        .name = name_comp4,
                        .vmux = 3,
                }},


I see other definitions using things like gpio etc, perhaps that is what
is needed here? I am unfamiliar with gpio, so I wouldn't know where to
begin.

Any help or advice is appreciated! I'll also try and hang out in #v4l as
"njk".
    - nick

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
