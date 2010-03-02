Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o229fxFr005218
	for <video4linux-list@redhat.com>; Tue, 2 Mar 2010 04:41:59 -0500
Received: from mail-fx0-f216.google.com (mail-fx0-f216.google.com
	[209.85.220.216])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o229fgP3031182
	for <video4linux-list@redhat.com>; Tue, 2 Mar 2010 04:41:43 -0500
Received: by fxm8 with SMTP id 8so49864fxm.11
	for <video4linux-list@redhat.com>; Tue, 02 Mar 2010 01:41:42 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 2 Mar 2010 10:41:42 +0100
Message-ID: <1098293f1003020141q530a1cadk52810baaf8bca1a4@mail.gmail.com>
Subject: Webcam. Brightness & Gamma Control
From: =?ISO-8859-1?Q?=C1lvaro_Canivell?= <oooh.oooh@gmail.com>
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
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello

I am using a Ricoh Webcam with the driver r5u870.

The problem is that the image quality is poor, it is too dark, thus I
would like to brighten it.

I have tried to do it using v4l-conf, v4lctl, but I get a message like this:

"v4l brightness control not supported"

I am not sure I am asking in the right place, but I have been
"interneting" for a while on r5u870 and v4l and found nothing that
helps me.

How could I determine where the problem is? Where can I check the
logfile for v4l start up. That would help me check wether the problem
is from the webcam driver or from v4l.

Cheers

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
