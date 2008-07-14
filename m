Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6EFj419025735
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 11:45:04 -0400
Received: from mta1.srv.hcvlny.cv.net (mta1.srv.hcvlny.cv.net [167.206.4.196])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6EFir62028468
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 11:44:53 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K40005IZ6ENMG01@mta1.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Mon, 14 Jul 2008 11:44:47 -0400 (EDT)
Date: Mon, 14 Jul 2008 11:44:46 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <E1KIPmW-000DK0-00.kr4v4-mail-ru@f116.mail.ru>
To: kr4v4 <kr4v4@mail.ru>
Message-id: <487B746E.5080100@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1251; format=flowed
Content-transfer-encoding: 7BIT
References: <E1KIPmW-000DK0-00.kr4v4-mail-ru@f116.mail.ru>
Cc: video4linux-list@redhat.com
Subject: Re: AVerMedia HC81R PCI-e Hybrid DVB-T
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

kr4v4 wrote:
> I am try add support for AVerMedia HC81R PCI-e Hybrid DVB-T, but i am stuck. What i do wrong?
>  
> Additional information in attachments.

The A/V core for your board may/may-not have some non-standard crystal 
frequencies - as yet not understood by the cx25840 driver. This impacts 
the A/V core timing and is currently unsupported for anything other than 
NTSC on some specific Hauppauge boards.

That probably explain example the risc timeouts.

This is the reason I haven't focused on PAL support with the cx23885 
with any Hauppauge boards. (Amongst other things).

Try DVB-T, you may have better luck.

Regards,

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
