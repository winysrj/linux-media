Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB5LqWhA026747
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 16:52:32 -0500
Received: from smtp.seznam.cz (smtp.seznam.cz [77.75.72.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB5LovkU028410
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 16:50:58 -0500
To: video4linux-list@redhat.com
Content-Disposition: inline
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
Date: Fri, 5 Dec 2008 22:49:49 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200812052249.49816.oldium.pro@seznam.cz>
Subject: AverMedia CardBus E501R/E506R remote control
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

Hi all,

Had anybody tried to figure out how the remote control interacts with the 
card? My old E501R has remote control with chip RT1221 that generates 0.56ms 
long pulses with variable length space (1.12ms for "0", 2.24ms for "1"). I 
guess E506R has the same chip, but I do not want to open it (that breaks 
warranty).

If anybody had success getting those pulses on some GPIO bit, please let me 
know. The protocol decoding is rather easy, but I was not able to get the raw 
bits.

(Note: Also sent to linux-dvb mailing list)

Regards,
Oldrich.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
