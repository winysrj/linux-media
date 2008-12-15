Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBF11Uw8031655
	for <video4linux-list@redhat.com>; Sun, 14 Dec 2008 20:01:30 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBF11Eb2008754
	for <video4linux-list@redhat.com>; Sun, 14 Dec 2008 20:01:15 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1088846fga.7
	for <video4linux-list@redhat.com>; Sun, 14 Dec 2008 17:01:14 -0800 (PST)
Message-ID: <412bdbff0812141701j3ee744daq49f47da9150124f4@mail.gmail.com>
Date: Sun, 14 Dec 2008 20:01:14 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: V4L <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Template for a new driver
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

I am writing a new driver for a video decoder, and wanted to ask if
there was any particular driver people would suggest as a model to
look at for new drivers.  For example, I am not completely familiar
with which interfaces are deprecated, and want to make sure I use a
driver as a template that reflects the latest standards/conventions.

Suggestions welcome.

Thanks in advance,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
