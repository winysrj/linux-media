Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA81LAH0026760
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 20:21:10 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA81KxTv017140
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 20:21:00 -0500
Received: by wf-out-1314.google.com with SMTP id 25so1479808wfc.6
	for <video4linux-list@redhat.com>; Fri, 07 Nov 2008 17:20:59 -0800 (PST)
Message-ID: <208cbae30811071720h3ea4c07di7b94c82f0a0098a7@mail.gmail.com>
Date: Sat, 8 Nov 2008 04:20:59 +0300
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: [Q] does dsbr100 should be renamed to radio-dsbr100?
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

Hello all.

If you take a look under drivers/media/radio/  you can see that all
radio-drivers called "radio-something" beside one driver - dsbr100.
Is it good idea to rename it in radio-dsbr100 ? Will it be useful ?
Or (this driver supports two usb-radio models - dsbr and gemtek) in
something more appropriate to chip-model on which this two devices
based ?

-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
