Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3FHbOVY015466
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 13:37:24 -0400
Received: from web57903.mail.re3.yahoo.com (web57903.mail.re3.yahoo.com
	[68.142.236.96])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n3FHb5od012440
	for <video4linux-list@redhat.com>; Wed, 15 Apr 2009 13:37:06 -0400
Message-ID: <548493.31113.qm@web57903.mail.re3.yahoo.com>
Date: Wed, 15 Apr 2009 10:37:05 -0700 (PDT)
From: Harol Hunter <hawk_eyes80@yahoo.com.mx>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: ATI TV Wonder PCI
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


Hi there people:

I have an ATI TV Wonder 550 PCI card and I can't make linux recognize it properly. I've been googling a lot with no result. Here I let you my lscpi results:

01:0b.0 Multimedia controller [0480]: ATI Technologies Inc Theater 550 PRO PCI [ATI TV Wonder 550] [1002:4d52]
    Subsystem: ATI Technologies Inc Unknown device [1002:a346]
    Flags: bus master, medium devsel, latency 64, IRQ 5
    Memory at bff00000 (32-bit, non-prefetchable) [size=1M]
    Memory at de000000 (32-bit, prefetchable) [size=32M]
    Capabilities: [50] Power Management version 2

I read that I have to load the right modules for it and this is what I've done 'till now

$ sudo modprobe bttv card=63 tuner=44 radio=1

and with no parameters also. Bttv loads properly but still won't recognize the cards. Am I doing anything wrong or it's just my card. I must say I can watch TV on Windows with this very same card

Thanks in advance
Harol


      ¡Obtén la mejor experiencia en la web! Descarga gratis el nuevo Internet Explorer 8. http://downloads.yahoo.com/ieak8/?l=mx

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
