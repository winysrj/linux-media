Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QD4N5N027754
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 09:04:23 -0400
Received: from bar.sig21.net (bar.sig21.net [88.198.146.85])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4QD4ASp031601
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 09:04:11 -0400
Message-ID: <483AB549.9070603@linuxtv.org>
Date: Mon, 26 May 2008 15:04:09 +0200
From: Michael Hunold <hunold@linuxtv.org>
MIME-Version: 1.0
To: Aimar Marco <marco.aimar@gmail.com>
References: <6cdc87030805201326k42740666h1266beb035aba684@mail.gmail.com>
In-Reply-To: <6cdc87030805201326k42740666h1266beb035aba684@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: saa7146 card
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

Hello Aimar,

on 20.05.2008 22:26 Aimar Marco said the following:
> 02:0c.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
> 	Subsystem: Unknown device 4342:4343

A quick search on the net did not bring up any vendor that matches this
id. What kind of card is this?

> and with this card I don't have a /dev/videoX.....

Besides the generic saa7146 driver you need a so-called extension driver
for your specific hardware. There is no extension driver for your
hardware yet, so no /dev/videoX.

> With another card (with chip bt878) my linux work (it created
> /dev/video0)...any idea?

As said above, there is no extension driver for your hardware.

> thank you

CU
Michael.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
