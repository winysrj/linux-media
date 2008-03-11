Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2BKrgeG025225
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 16:53:42 -0400
Received: from ex.volia.net (ex.volia.net [82.144.192.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2BKr8px006724
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 16:53:09 -0400
Message-ID: <47D6F12C.7040102@fm.com.ua>
Date: Tue, 11 Mar 2008 22:53:00 +0200
From: itman <itman@fm.com.ua>
MIME-Version: 1.0
To: hermann-pitton@arcor.de, simon@kalmarkaglan.se,
	video4linux-list@redhat.com, midimaker@yandex.ru, xyzzy@speakeasy.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: Re: 2.6.24 kernel and MSI TV @nywheremaster MS-8606 status
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

Hi Herman, Mauro.

Status with 2.6.24 is OK, BUT with the following changes:

1) mkdir /usr/src/linux/tmpmsi
2) cd tmpmsi
3) hg init
4) hg pull http://linuxtv.org/hg/v4l-dvb
5) make
6) make install

and changes for 2.6.24.3 :

Adding to /etc/modprobe.conf  this line:

options tda9887 port1=0 port2=0 qss=1

After reboot it works fine!

In 2.6.23 was used tuner instead tda9887
so it was
options tuner port1=0 port2=0 qss=1


Rgs,
    Serge.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
