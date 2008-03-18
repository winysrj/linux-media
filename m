Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2I8IUYo031415
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 04:18:30 -0400
Received: from mta-fe.casema.nl (cas-mta2-fe.casema.nl [83.80.1.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2I8HwIF007795
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 04:17:58 -0400
Received: from localhost (cas-filter6.mgmt.casema.nl [10.42.32.119])
	by mta-fe.casema.nl (Postfix) with ESMTP id DCB0341E2
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 09:17:52 +0100 (CET)
Received: from mta-fe.casema.nl ([10.42.32.24])
	by localhost (cas-filter6.mgmt.casema.nl [10.42.32.211]) (amavisd-new,
	port 20024)
	with ESMTP id UCBdtCoE2OUI for <video4linux-list@redhat.com>;
	Tue, 18 Mar 2008 09:17:52 +0100 (CET)
Received: from [192.168.0.12] (535692A8.cable.casema.nl [83.86.146.168])
	by mta-fe.casema.nl (Postfix) with ESMTP id ADBC838A9
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 09:17:52 +0100 (CET)
Message-ID: <47DF7AA5.9040109@casema.nl>
Date: Tue, 18 Mar 2008 09:17:41 +0100
From: bas <bvpoppel@casema.nl>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: saa7134 eeprom error
Reply-To: bas7@casema.nl
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

Hi,

I hope that someone can give me some directions to solve the problem I 
am encountering. I searched numerous forums and tried various options, 
but I am not going to get anywhere withuot some specialist help.

If this is not the right mailing list, can someone point me to the right 
one, please ?

Fedora 7, completely updated by yum
Pinnacle 50i TV card with a FM radio on the card
I connected the sound with a cable to my sound card, integrated on mobo.

The card and tuner are autodetected (card=77 and tuner = 54).

In dmesg in all cases I tried there is the message eeprom read error.

The image from tv is working, but never any sound.

So my first thought is that the eeprom error should be fixed.

Some forums say that this is related with i2c (I do not know waht i2c 
does) and with the auto dectection.

Any help appreciated,

Bas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
