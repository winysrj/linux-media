Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1QIYZqX031029
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 13:34:35 -0500
Received: from smtpout1.ngs.ru (smtpout1.ngs.ru [195.93.186.195])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1QIY4Ou015593
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 13:34:04 -0500
Received: from [192.168.3.4] (unknown [192.168.3.4])
	(Authenticated sender: aptem@ngs.ru)
	by smtp.ngs.ru (smtp) with ESMTP id 5A8B94F1E96AB
	for <video4linux-list@redhat.com>;
	Wed, 27 Feb 2008 00:34:03 +0600 (NOVT)
Message-ID: <47C45B9D.5010400@ngs.ru>
Date: Wed, 27 Feb 2008 00:34:05 +0600
From: Bokhan Artem <APTEM@ngs.ru>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: saa7134 and "jumping" volume on nicam stereo channel
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

Hi.

I have several saa7134 (Beholder 6x series, M6 and 60x). On nicam stereo 
channel (R2) volume of sound accidentally "jumps".
The problem is repeated on all card, but only on nicam stereo channel. 
The card may be in stereo or mono(!) mode - no matter.
Alsa is used as audio subsystem, january'2008 trunk of v4l2 and 2.6.22 
kernel.
I don't have any ability to confirm the problem on Windows or any other 
saa7134 card.

Can it be the problem of drivers? Any saa7134 driver developer on the 
list? :)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
