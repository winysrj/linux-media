Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3GMDjPf031114
	for <video4linux-list@redhat.com>; Thu, 16 Apr 2009 18:13:45 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n3GMDUxc013922
	for <video4linux-list@redhat.com>; Thu, 16 Apr 2009 18:13:30 -0400
Content-Type: text/plain; charset="iso-8859-1"
Date: Fri, 17 Apr 2009 00:13:28 +0200
From: Chatty@gmx.de
Message-ID: <20090416221328.140410@gmx.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Transfer-Encoding: 8bit
Subject: Extend go7007 driver with Lifeview TV Walker Ultra support
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

Hi there,

I am eager to extend the current go7007 driver in order to make use of my USB TV tuner. It is fully compatible to the Lifeview TV Walker Ultra. It even works under Windows 7 but I want to use it as a streaming source on a linux box.

The windows driver hints at a SAA7113 I2C chip in it, thus I added this to go7007 driver and tried all possible addresses (0x00 to 0x7f), but all failed during probing. Then I tried the Lifeview firmware (go7007fw.bin, used the kernel included at first), but still the same result.

Now I recorded all USB traffic under Windows and would need some expert to take a look at it (it has everything: EZ-USB fw loading, go7007 fw loading and channel tuning).

It is a real nice device. So please, can anyone help?

Regards, Jens.
-- 
 

Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger01

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
