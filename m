Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAKLJpFF007891
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 16:19:51 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAKLJnE4005889
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 16:19:49 -0500
Message-ID: <4925D46F.10701@gmx.net>
Date: Thu, 20 Nov 2008 22:19:43 +0100
From: Roman <muzungu@gmx.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Asus PC-39 IR Control: dead keys
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

Hi all

The keys defined with numbers bigger than 255 in the IR_KEYTAB_TYPE 
ir_codes_asus_pc39[IR_KEYTAB_SIZE] do not get recognized by X11 nor the 
console.

- showkey shows the keycode but no scancode
- xev does not react at all on those keys
- neither does the console
- lineak, as far as I can see, just reacts on keycodes below 256 too, or 
in other word on what xev does react.

How to solve this? How do I get the keys such as KEY_DVD or KEY_ZOOM 
(>255) get to work with an (X) app?

The only solution I can see by now, as long as X11 and the kernel 
(right?) do not react on key above 255 is
- to find me some unused keys below 256,
- fill IR_KEYTAB_TYPE ir_codes_asus_pc39[IR_KEYTAB_SIZE] wiht the best 
fitting,
- and recompile the driver module saa7134 with the new key definitions.

This is probably NOT the way to go.

Any suggestions?

Greets and thanks

Roman

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
